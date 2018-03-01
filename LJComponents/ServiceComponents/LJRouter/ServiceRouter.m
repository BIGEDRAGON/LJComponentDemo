//
//  ServiceRouter.m
//  LJRouter
//
//  Created by longlj on 2017/12/8.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import "ServiceRouter.h"
#import "NSObject+RouterPrivate.h"
#import "RouterProtocol.h"

@interface ServiceRouter ()

@property (nonatomic, strong) NSMutableDictionary *services;

@end

@implementation ServiceRouter

+ (instancetype)sharedInstance {
    static ServiceRouter *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ServiceRouter alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.services = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - setup

- (void)registerService:(NSString *)serviceName
       forServieceClass:(Class)serviceClass {
    NSString *className = NSStringFromClass(serviceClass);
    if (className.length && serviceName.length) {
        self.services[serviceName] = className;
    }
}

- (void)unregisterService:(NSString *)serviceName {
    if (serviceName.length > 0) {
        [self.services removeObjectForKey:serviceName];
    }
}

#pragma mark - utils

- (Class)classForServiceName:(NSString *)serviceName {
    if (serviceName.length > 0) {
        NSString *className = self.services[serviceName];
        if (className.length > 0) {
            Class serviceCls = NSClassFromString(className);
            return serviceCls;
        }
    }
    return nil;
}

#pragma mark - Open services action by name

- (void)executeMethodWithService:(NSString *)serviceName
                     withSelName:(NSString *)selName {
    [self executeMethodWithService:serviceName withSelName:selName withParams:nil];
}

- (void)executeMethodWithService:(NSString *)serviceName
                     withSelName:(NSString *)selName
                      withParams:(NSArray *)params {
    [self executeMethodWithService:serviceName withSelName:selName withParams:params successed:nil failed:nil];
}

- (void)executeMethodWithService:(NSString *)serviceName
                     withSelName:(NSString *)selName
                      withParams:(NSArray *)params
                       successed:(void (^)(id returnValue))successed
                          failed:(void (^)(NSError *))failed {
    [self executeMethodWithService:serviceName initSelParams:nil withSelName:selName withParams:params successed:successed failed:failed];
}

- (void)executeMethodWithService:(NSString *)serviceName
                   initSelParams:(NSArray *)selParams
                     withSelName:(NSString *)selName
                      withParams:(NSArray *)params
                       successed:(void (^)(id returnValue))successed
                          failed:(void (^)(NSError *))failed {
    
    NSString *failMsg = [NSString stringWithFormat:@"[serviceName(%@);selName(%@)]", serviceName, selName];
    Class cls = [self classForServiceName:serviceName];
    if (!cls) {
        [self notifyRouterNotFoundFailed:failed
                           withFailedMsg:failMsg];
        return;
    }
    
    id<ServiceRouterProtocol> service = nil;
    if ([cls respondsToSelector:@selector(initWithParams:)]) {
        service = [cls initWithParams:selParams];
    }else {
        service = [[cls alloc] init];
    }
    
    if (!service) {
        [self notifyRouterNotFoundFailed:failed
                           withFailedMsg:failMsg];
        return;
    }
    
    if ([cls respondsToSelector:@selector(SELNameArray)]) {
        NSArray *selNames = [cls SELNameArray];
        
        if (selNames.count && [selNames containsObject:selName]) {
            SEL sel = NSSelectorFromString(selName);
            id returnValue = [cls performSelector:sel
                                       withParams:params
                                        designObj:service];
            [self notifyRouterSuccessed:successed
                              withValue:returnValue];
            return;
        }
        
    }
    
    [self notifyRouterSelectorNotFoundFailed:failed
                               withFailedMsg:failMsg];
}

#pragma mark - fail notify

//- (void)notifyServiceSuccessed:(void(^)(id))successed withValue:(id)value {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (successed) {
//            successed(value);
//        }
//    });
//}

//- (void)notifyServiceNotFoundFailed:(void(^)(NSError *error))failed
//                    withServiceName:(NSString *)serviceName
//                    withSelName:(NSString *)selName {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (failed) {
//            NSString *failMsg = [NSString stringWithFormat:@"[serviceName(%@);selName(%@)]", serviceName, selName];
//            failed([NSError errorWithDomain:ServiceNotFoundErrorDomain code:(-100) userInfo:@{NSLocalizedDescriptionKey: failMsg}]);
//        }
//    });
//}
//
//- (void)notifyServiceSelectorNotFoundFailed:(void(^)(NSError *error))failed
//                            withServiceName:(NSString *)serviceName
//                                withSelName:(NSString *)selName {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (failed) {
//            NSString *failMsg = [NSString stringWithFormat:@"[serviceName(%@);selName(%@)]", serviceName, selName];
//            failed([NSError errorWithDomain:ServiceSelectorNotFoundErrorDomain code:(-101) userInfo:@{NSLocalizedDescriptionKey: failMsg}]);
//        }
//    });
//}

@end
