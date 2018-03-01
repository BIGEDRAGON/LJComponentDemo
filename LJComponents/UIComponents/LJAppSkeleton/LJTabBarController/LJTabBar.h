//
//  LJNavigationBarView.m
//  LJTabBarController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTabBarItem.h"

@class LJTabBar;

@protocol LJTabBarDelegate <NSObject>

@optional

- (void)tabBar:(LJTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface LJTabBar : UIView

@property (nonatomic, strong) UIColor *itemTitleColor;

@property (nonatomic, strong) UIColor *selectedItemTitleColor;

@property (nonatomic, strong) UIFont *itemTitleFont;

@property (nonatomic, strong) UIFont *badgeTitleFont;

@property (nonatomic, assign) CGFloat itemImageRatio;

@property (nonatomic, strong) NSMutableArray *tabBarItems;

@property (nonatomic, strong) LJTabBarItem *selectedItem;

@property (nonatomic, assign) NSInteger tabBarItemCount;

@property (nonatomic, weak) id<LJTabBarDelegate> delegate;

- (void)addTabBarItem:(UITabBarItem *)item;

@end
