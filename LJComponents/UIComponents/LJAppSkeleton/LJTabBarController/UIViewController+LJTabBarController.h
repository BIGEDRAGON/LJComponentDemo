//
//  UIViewController+LJTabBarController.h
//  LJComponentDemo
//
//  Created by long on 2018/2/23.
//  Copyright © 2018年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LJTabBarDidClickAnimation) {
    LJTabBarDidClickAnimationNone = 0,
    LJTabBarDidClickAnimationScale,
    LJTabBarDidClickAnimationRotate,
};

@interface UIViewController (LJTabBarController)

- (LJTabBarDidClickAnimation)tabbarDidClickAnimation;

@property (nonatomic, assign) BOOL showPoint;

@property (nonatomic, strong) UIColor *pointColor;

@property (nonatomic, weak, readonly) LJTabBar *LJTabBar;

@property (nonatomic, weak) LJTabBarItem *currentTabBarItem;

@end
