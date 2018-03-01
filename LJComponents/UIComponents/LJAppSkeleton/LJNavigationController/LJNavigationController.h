//
//  LJNavigationController.h
//  LJNavigationController
//
//  Created by longlj on 2016/4/19.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTransitionAnimator.h"
#import "LJNavigationBarView.h"
#import "UIViewController+LJNavigationController.h"
#import "LJNavigationControllerDelegation.h"

/**
 *  自定义导航控制器
 */
@interface LJNavigationController : UINavigationController

/**
 *  导航控制器是否正在做转场动画
 */
@property (nonatomic, assign, readonly) BOOL isNavTransitioning;

@end

