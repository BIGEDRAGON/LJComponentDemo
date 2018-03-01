//
//  LJNavigationControllerDelegation.h
//  LJNavigationController
//
//  Created by longlj on 2016/8/8.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  视图控制器将要显示
 */
UIKIT_EXTERN NSString * const kLJNavWillShowViewController;

/**
 *  视图控制器完成显示
 */
UIKIT_EXTERN NSString * const kLJNavDidShowViewController;

/**
 *  Key of UIViewController, 视图控制器
 */
UIKIT_EXTERN NSString * const kLJNavNotifyViewControllerKey;

/**
 *  key of NSString, 上个页面名称
 */
UIKIT_EXTERN NSString * const kLJNavNotifyFromPageNameKey;

@interface LJNavigationControllerDelegation : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithController:(UINavigationController *)controller;

@end
