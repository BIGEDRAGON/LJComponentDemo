//
//  LJTabBarItem.h
//  LJTabBarController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

LJKit_EXTERN NSString * const LJNotificationTabBarItemChanged;

@interface LJTabBarItem : UIView

@property (nonatomic, strong) UIColor *itemTitleColor;

@property (nonatomic, strong) UIColor *selectedItemTitleColor;

@property (nonatomic, strong) UIFont *itemTitleFont;

@property (nonatomic, strong) UIFont *badgeTitleFont;

@property (nonatomic, assign) CGFloat itemImageRatio;

@property (nonatomic, strong) UITabBarItem *tabBarItem;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, assign) BOOL showPoint;

@property (nonatomic, strong) UIColor *pointColor;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio;

@end
