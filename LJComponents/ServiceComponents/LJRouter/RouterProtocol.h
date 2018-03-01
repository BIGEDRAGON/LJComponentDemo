//
//  ServiceRouterDefines.h
//  LJRouter
//
//  Created by longlj on 2017/12/11.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ServiceRouterProtocol <NSObject>

@optional

/**
 如果通过类方法构造页面，则需重写此方法返回类方法，否则就init创建
 */
+ (instancetype)initWithParams:(NSArray *)params;
/**
 可执行的方法名数组
 */
+ (NSArray *)SELNameArray;

@end

NS_ASSUME_NONNULL_END
