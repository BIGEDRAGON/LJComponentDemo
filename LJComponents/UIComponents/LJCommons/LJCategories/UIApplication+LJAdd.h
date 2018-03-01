//
//  UIApplication+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/9/9.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LJApplication [UIApplication sharedApplication]

@interface UIApplication (LJAdd)

+ (nullable UIViewController *)getRootViewController;

+ (nullable UIViewController *)getTopViewController;

/**
 跳转到应用权限设置页面
 */
+ (void)openSettings;

/**
 根据iOS版本选择最新的api跳转 options为nil，completionHandler为nil

 @param string 跳转的连接字符串
 */
- (void)openURLWithString:(NSString * __nonnull )string;

/**
 根据iOS版本选择最新的api跳转

 @param string     跳转的连接字符串
 @param options    UIApplicationOpenURLOptionUniversalLinksOnly，默认NO，http://one9398.com/2016/09/25/iOS10%E6%96%B0%E5%8F%98%E5%8C%96%E4%B9%8B%E5%BA%9F%E5%BC%83%E7%9A%84openURL/
 @param completion 完成跳转动作 success标记
 */
- (void)openURLWithString:(NSString * __nonnull )string options:(NSDictionary<NSString *,id> * __nullable)options completionHandler:(void (^__nullable)(BOOL success))completion;

@end
