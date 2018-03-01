//
//  UIViewController+LJNavigationController.h
//  LJNavigationController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJNavigationBarView.h"
#import "LJTransitionAnimator.h"

@class LJNavigationController;

@interface UIViewController (LJNavigationController)

@property (nonatomic, assign) BOOL isSetup;

@property (nonatomic, strong, readonly) LJNavigationController *LJNavigationController;
@property (nonatomic, strong) LJNavigationBarView *navigationBarView;

// Called when new view controller pushed, remove from navigation stack if return YES, default is NO.
- (BOOL)shouldDismissWhenOtherPushed;

#pragma mark - 导航栏的相关配置

// 是否使用导航栏，默认YES
- (BOOL)shouldUseNavigationBar;

// 是否显示默认返回按钮，默认YES，override point
- (BOOL)shouldDisplayDefaultBackBtn;

// 导航栏标题，默认nil
@property (nonatomic, copy) NSString *barTitle;
- (void)addNavigationTitle:(NSString*)title;

// 是否显示导航栏，默认NO
@property (nonatomic, assign) BOOL isBarViewHidden;

// 导航栏背景色，默认白色
@property (nonatomic, strong) UIColor *barViewBackgroundColor;

//导航栏的文字颜色，默认是#1f1f1f
@property (nonatomic, strong) UIColor *barTitleColor;

//导航栏的文字字体，默认是16
@property (nonatomic, strong) UIFont *barTitleFont;

#pragma mark - Push & Pop 动画

// 自定义的Push和Pop的转场动画
@property (nonatomic, strong) LJTransitionAnimator *pushAnimation;
@property (nonatomic, strong) LJTransitionAnimator *popAnimation;

/**
 *  是否允许手势交互Pop，默认为YES
 */
- (BOOL)shouldEnableNavigationInteractPop;

@end
