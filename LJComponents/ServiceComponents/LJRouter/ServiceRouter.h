//
//  ServiceRouter.h
//  LJRouter
//
//  Created by longlj on 2017/12/8.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRouter : NSObject

+ (instancetype)sharedInstance;

#pragma mark - setup

- (void)registerService:(NSString *)serviceName
       forServieceClass:(Class)serviceClass;

- (void)unregisterService:(NSString *)serviceName;

#pragma mark - Open services action by name

- (void)executeMethodWithService:(NSString *)serviceName
                     withSelName:(NSString *)selName;
- (void)executeMethodWithService:(NSString *)serviceName
                     withSelName:(NSString *)selName
                      withParams:(NSArray *)params;
- (void)executeMethodWithService:(NSString *)serviceName
                     withSelName:(NSString *)selName
                      withParams:(NSArray *)params
                       successed:(void(^)(id returnValue))successed
                          failed:(void(^)(NSError *error))failed;
- (void)executeMethodWithService:(NSString *)serviceName
                   initSelParams:(NSArray *)selParams
                     withSelName:(NSString *)selName
                      withParams:(NSArray *)params
                       successed:(void (^)(id returnValue))successed
                          failed:(void (^)(NSError *))failed;

@end
