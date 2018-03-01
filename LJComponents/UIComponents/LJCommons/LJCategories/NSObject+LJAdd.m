//
//  NSObject+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/7/4.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "NSObject+LJAdd.h"
#import "LJMacros.h"

@implementation NSObject (LJAdd)

#define VERSION_SUB_ITEM_MAX_LENGTH (2)

+ (NSInteger)appVersionCode {
    NSInteger appVersionCode = 0;
    NSString *version = [self appVersion];
    
    NSArray *comps = [version componentsSeparatedByString:@"."];
    if (comps && comps.count >= 3) {
        NSString *major = comps[0];
        NSString *minor = comps[1];
        NSString *beta = comps[2];
        
        if (major.length > VERSION_SUB_ITEM_MAX_LENGTH) {
            major = [major substringToIndex:VERSION_SUB_ITEM_MAX_LENGTH];
        }
        
        if (minor.length > VERSION_SUB_ITEM_MAX_LENGTH) {
            minor = [major substringToIndex:VERSION_SUB_ITEM_MAX_LENGTH];
        }
        
        if (beta.length > VERSION_SUB_ITEM_MAX_LENGTH) {
            beta = [beta substringToIndex:VERSION_SUB_ITEM_MAX_LENGTH];
        }
        
        appVersionCode = [major integerValue] * 10000 + [minor integerValue] * 100 + [beta integerValue];
    }
    
    return appVersionCode;
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (NSString *)appBuild {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

+ (NSString *)appBundleId {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
}

+ (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

- (void)timerWithDuration:(NSTimeInterval)duration callback:(void(^)(void))callback {
    if (callback) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            callback();
        });
    }
}

- (void)timerRepeatedWithDuration:(NSTimeInterval)duration callback:(void(^)(BOOL *shouldStop))callback {
    if (callback) {
        WeakSelf()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf) {
                __block BOOL stop = NO;
                callback(&stop);
                if (!stop) {
                    [weakSelf timerRepeatedWithDuration:duration callback:callback];
                }
            }
        });
    }
}

@end
