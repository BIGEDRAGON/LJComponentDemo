//
//  NSObject+routerPrivate.h
//  LJRouter
//
//  Created by longlj on 2017/12/8.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RouterPrivate)

- (void)notifyRouterSuccessed:(void(^)(id))successed withValue:(id)value;
- (void)notifyRouterNotFoundFailed:(void(^)(NSError *error))failed
                     withFailedMsg:(NSString *)failedMsg;
- (void)notifyRouterSelectorNotFoundFailed:(void(^)(NSError *error))failed
                             withFailedMsg:(NSString *)failedMsg;

+ (id)performSelector:(SEL)sel withParams:(NSArray *)params;

/**
 执行特定方法
 @param sel 方法SEL
 @param params 参数数组
 @param obj 指定的对象（不通过init来创建）
 @return 返回值
 */
+ (id)performSelector:(SEL)sel withParams:(NSArray *)params designObj:(id)obj;

@end
