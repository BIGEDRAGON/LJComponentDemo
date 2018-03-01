//
//  UIViewController+UrlRouterPrivate.h
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlRouterDefines.h"

@interface UIViewController (UrlRouterPrivate)

/**
 当前页面名称，必选，由UrlRouter统一赋值
 */
@property (nonatomic, copy) NSString *vcPageName;

/**
 额外参数，可选
 */
@property (nonatomic, strong) NSDictionary *urlParams;

/**
 上个页面名称，必选
 */
@property (nonatomic, copy) NSString *fromPage;

/**
 url链接地址，可选
 */
@property (nonatomic, copy) NSString *h5Url;

/**
 回调Block，可选
 */
@property (nonatomic, copy) UrlPopedCallback urlCallback;

/**
 填充 params
 */
- (void)parseInputParams;

/**
 获取当前屏幕最顶层的控制器
 */
+ (UIViewController *)topVC;

@end
