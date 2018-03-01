//
//  NSObject+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/7/4.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LJAdd)

/**
 *  应用版本编码，规则为数字abcdef代表版本"ab.cd.ef"
 *
 *  @return eg. 21503 代表版本"2.15.3"
 */
+ (NSInteger)appVersionCode;

/**
 *  应用版本号
 *
 *  @return eg. "2.15.3"
 */
+ (NSString *)appVersion;

/**
 *  应用Build号
 *
 *  @return eg. "16"
 */
+ (NSString *)appBuild;

/**
 *  应用BundleId
 *
 *  @return eg. "com.longljtech.longlj"
 */
+ (NSString *)appBundleId;

/**
 应用名称

 @return eg. "Xcode"
 */
+ (NSString *)appName;


/**
 *  定时器
 */
- (void)timerWithDuration:(NSTimeInterval)duration callback:(void(^)(void))callback;
- (void)timerRepeatedWithDuration:(NSTimeInterval)duration callback:(void(^)(BOOL *shouldStop))callback;

@end
