//
//  LJNavigationBarView.h
//  LJNavigationController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LJNavigationBarViewBottomLineStyle) {
    kLJNavigationBarViewBottomLineStyleNone = 0,        // 无分割线
    kLJNavigationBarViewBottomLineStyleLightContent,    // 灰色分割线，用于亮色调内容，default
    kLJNavigationBarViewBottomLineStyleDarkContent,      // 白色分割线，用于暗色调内容
    kLJNavigationBarViewBottomLineStyleHome
};

/**
 *  自定义导航栏视图
 */
@interface LJNavigationBarView : UIView

- (instancetype)init NS_DESIGNATED_INITIALIZER;

#pragma mark - Left View

@property (nonatomic, strong) UIButton *leftBtn;

- (void)displayDefaultBackBtnWithCallback:(void(^)(void))backBtnClicked;
- (void)displayCloseBackBtnWithCallback:(void(^)(void))backBtnClicked;

#pragma mark - Title View

@property (nonatomic, strong) UIView *titleView;

- (void)setBarTitle:(NSString *)title;
- (void)setBarTitleColor:(UIColor *)color;
- (void)setBarTitleFont:(UIFont *)font;

#pragma mark - Right View

@property (nonatomic, strong) UIButton *rightBtn;

- (void)setRightCloseBtnWithCallback:(void(^)(void))backBtnClicked;

#pragma mark - Others

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

/**
 *  导航栏的点击事件
 */
@property (nonatomic, copy) void(^barClicked)(void);

/**
 *  默认为nil，如果属性被调用则自动创建背景视图并放在所有视图后面。将self.backgroundColor = [UIColor clearColor], 配置barBackgroundView可以调整导航栏的透明度
 */
@property (nonatomic, strong, readonly) UIView *barBackgroundView;

/**
 *  分割线样式
 */
@property (nonatomic, assign) LJNavigationBarViewBottomLineStyle bottomLineStyle;
- (void)setBottomLineNone;
- (void)setBottomLineLightContentStyle;
- (void)setBottomLineDarkContentStyle;

@end
