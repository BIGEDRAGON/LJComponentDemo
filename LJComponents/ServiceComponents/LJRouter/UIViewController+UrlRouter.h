//
//  UIViewController+UrlRouter.h
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlRouterDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UrlRouter)

/**
 当前页面名称，不为空，由UrlRouter统一赋值
 */
@property (nonatomic, copy, readonly) NSString *vcPageName;

/**
 额外参数，可选
 */
@property (nonatomic, strong, readonly) NSDictionary *urlParams;

/**
 上个页面名称，必选
 */
@property (nonatomic, copy, readonly) NSString *fromPage;

/**
 url链接地址，可选
 */
@property (nonatomic, copy, readonly) NSString *h5Url;

/**
 回调Block，可选
 */
@property (nonatomic, copy, readonly) UrlPopedCallback urlCallback;

/**
 是否允许在导航栈中存在多个实例
 */
+ (BOOL)isSingletonPage;

/**
 如果通过类方法构造页面，则需重写此方法返回类方法
 */
+ (instancetype)initWithParams:(NSArray *)params;

/**
 该页面可执行的方法名
 ps: 如果是通过initSel构造的页面，则不能执行
 */
+ (NSArray *)SELNameArray;

@end

NS_ASSUME_NONNULL_END
