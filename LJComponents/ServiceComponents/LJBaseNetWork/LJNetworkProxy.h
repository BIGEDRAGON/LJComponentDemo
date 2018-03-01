//
//  LJNetworkProxy.h
//  LJNetWork
//
//  Created by longlj on 2016/7/4.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCommons.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface LJNetworkProxy : NSObject

SINGLETON_DECLARE()

@property (nonatomic, strong, readonly) AFHTTPSessionManager *httpResponseSession;

@property (nonatomic, strong, readonly) AFHTTPSessionManager *jsonResponseSession;

- (BOOL)hasRequest:(id)request;
- (void)addRequest:(id)request;
- (void)removeRequest:(id)request;

- (void)cleanAll;

@end
