//
//  LJReachability.m
//  LJNetWork
//
//  Created by longlj on 2016/6/15.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "LJReachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "LJLocalConnection.h"

@interface LJReachability ()

@property (nonatomic, strong) NSArray *typeStrings4G;
@property (nonatomic, strong) NSArray *typeStrings3G;
@property (nonatomic, strong) NSArray *typeStrings2G;
@property (nonatomic, assign) LJConnectionStatus connectionStatus;
@property (nonatomic, strong) NSArray *statusDescriptions;
@property (nonatomic, assign) BOOL isWillNotifyUnReachable;
@property (nonatomic, copy) void(^unReachableCallback)(void);
@property (nonatomic, assign) NSTimeInterval unreachableCallbackDelayInterval;

@end

@implementation LJReachability

+ (instancetype)sharedInstance {
    static LJReachability *__sharedInstance;
    static dispatch_once_t __once;
    dispatch_once(&__once, ^{
        __sharedInstance = [[LJReachability alloc] init];
    });
    return __sharedInstance;
}

- (void)startup {
    // do nothing here
    
    
}

- (void)setUnreachableCallback:(void(^)(void))unReachableCallback withDelayInterval:(NSTimeInterval)delayInterval {
    self.unReachableCallback = unReachableCallback;
    self.unreachableCallbackDelayInterval = delayInterval;
}

- (instancetype)init {
    if (self = [super init]) {
        _typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        _typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        _typeStrings4G = @[CTRadioAccessTechnologyLTE];
        
        self.connectionStatus = kLJConnectionStatusUnknown;
        
        self.statusDescriptions = @[@"UnReachable", @"WiFi", @"2G", @"3G", @"4G", @"Unknown"];
        
        self.isWillNotifyUnReachable = NO;
        
        [GLocalConnection startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(localConnectionChanged:)
                                                     name:kLocalConnectionChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(localConnectionInitialized:)
                                                     name:kLocalConnectionInitializedNotification
                                                   object:nil];
    }
    
    return self;
}

- (NSString *)connectionStatusDesc {
    return self.statusDescriptions[self.connectionStatus];
}

- (BOOL)isReachable {
    return self.connectionStatus != kLJConnectionStatusUnReachable;
}

- (void)localConnectionChanged:(NSNotification *)notification {
    LJLocalConnection *lc = (LJLocalConnection *)notification.object;
    LocalConnectionStatus lcStatus = [lc currentLocalConnectionStatus];
    [self updateStatus:lcStatus];
}

- (void)localConnectionInitialized:(NSNotification *)notification {
    LJLocalConnection *lc = (LJLocalConnection *)notification.object;
    LocalConnectionStatus lcStatus = [lc currentLocalConnectionStatus];
    [self updateStatus:lcStatus];
}

- (void)updateStatus:(LocalConnectionStatus)lcStatus {
    if (LC_WWAN == lcStatus) {
        static CTTelephonyNetworkInfo *teleInfo;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            teleInfo = [[CTTelephonyNetworkInfo alloc] init];;
        });
        
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([accessString length] > 0) {
            if ([self.typeStrings3G containsObject:accessString]) {
                self.connectionStatus = kLJConnectionStatus3G;
            }
            else if ([self.typeStrings2G containsObject:accessString]) {
                self.connectionStatus = kLJConnectionStatus2G;
            }
            else {
                self.connectionStatus = kLJConnectionStatus4G;;
            }
        }
        else {
            self.connectionStatus = kLJConnectionStatus4G;
        }
        
        NSLog(@"[LJ.Reachability] Current radio access technology is %@", accessString);
    }
    else if (LC_WiFi == lcStatus) {
        self.connectionStatus = kLJConnectionStatusWiFi;
    }
    else {
        self.connectionStatus = kLJConnectionStatusUnReachable;
    }
    
    NSLog(@"[LJ.Reachability] Current access way is %@", self.statusDescriptions[self.connectionStatus]);
    
    [self handleStatusUpdated];
}

- (void)handleStatusUpdated {
    if (self.isWillNotifyUnReachable) {
        if (self.connectionStatus != kLJConnectionStatusUnReachable) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            self.isWillNotifyUnReachable = NO;
        }
    }
    else {
        if (self.connectionStatus == kLJConnectionStatusUnReachable) {
            self.isWillNotifyUnReachable = YES;
            if (self.unreachableCallbackDelayInterval <= 0) {
                [self doNotify];
            }
            else {
                [self performSelector:@selector(doNotify) withObject:nil afterDelay:self.unreachableCallbackDelayInterval];
            }
        }
    }
}

- (void)doNotify {
    /**
     *  kLocalConnectionChangedNotification is already notified in mainthread, so here run in main.
     */
    
    self.isWillNotifyUnReachable = NO;
    
    if (self.connectionStatus != kLJConnectionStatusUnReachable) {
        return;
    }
    
    if (self.unReachableCallback) {
        self.unReachableCallback();
    }
    
    NSLog(@"[LJ.Reachability] Notify network unreachable for a little time");
}

@end
