//
//  LJReachability.h
//  LJNetWork
//
//  Created by longlj on 2016/6/15.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

// 网络状态
typedef NS_ENUM(NSInteger, LJConnectionStatus) {
    kLJConnectionStatusUnReachable  = 0,
    kLJConnectionStatusWiFi         = 1,
    kLJConnectionStatus2G           = 2,
    kLJConnectionStatus3G           = 3,
    kLJConnectionStatus4G           = 4,
    kLJConnectionStatusUnknown      = 5
};

// 网络状态管理器
@interface LJReachability : NSObject

// 单例
+ (instancetype)sharedInstance;

// 初始化
- (void)startup;

// 监听网络断开回调
- (void)setUnreachableCallback:(void(^)(void))unReachableCallback withDelayInterval:(NSTimeInterval)delayInterval;

// 网络状态
@property (nonatomic, assign, readonly) LJConnectionStatus connectionStatus;

// 网络状态描述
@property (nonatomic, copy, readonly) NSString *connectionStatusDesc;

@property (nonatomic, assign, readonly) BOOL isReachable;

@end
