//
//  LJTabBarController.h
//  LJTabBarController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTabBar.h"
#import "UIViewController+LJTabBarController.h"

@interface LJTabBarController : UITabBarController

@property (nonatomic, strong) LJTabBar *LJTabBar;

@property (nonatomic, strong) UIColor *itemTitleColor;

@property (nonatomic, strong) UIColor *selectedItemTitleColor;

@property (nonatomic, strong) UIFont *itemTitleFont;

@property (nonatomic, strong) UIFont *badgeTitleFont;

@property (nonatomic, assign) CGFloat itemImageRatio;

- (void)removeOriginControls NS_DEPRECATED_IOS(2_0, 11_0, "Method deprecated. For iOS 11.0+, framework will process it automatically.");

@end
