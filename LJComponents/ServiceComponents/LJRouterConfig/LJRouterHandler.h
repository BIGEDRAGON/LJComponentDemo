//
//  LJRouterHandler.h
//  LJRouter
//
//  Created by longlj on 2017/11/20.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJRouter.h"

LJKit_EXTERN NSString * const kUrlRouter_viewComponent;
LJKit_EXTERN NSString * const kUrlRouter_serviceComponent;
LJKit_EXTERN NSString * const kUrlRouter_study;

@interface LJRouterHandler : NSObject

+ (UIWindow *)setUpUrlRouterInAppDel;

@end
