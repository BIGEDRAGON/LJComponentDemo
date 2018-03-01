//
//  UIView+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface UIView (LJAdd)

#pragma mark - Frame&Bounds

+ (CGRect)rect:(CGRect)originalRect withMargins:(UIEdgeInsets)margins;

// frame
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

// bounds
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;
@property (nonatomic, assign, readonly) CGFloat boundsCenterX;
@property (nonatomic, assign, readonly) CGFloat boundsCenterY;
@property (nonatomic, assign) CGFloat boundsTop;
@property (nonatomic, assign) CGFloat boundsBottom;
@property (nonatomic, assign) CGFloat boundsLeft;
@property (nonatomic, assign) CGFloat boundsRight;

#pragma mark - badge

@property (nonatomic, strong, readonly) UILabel *lj_badge;
// 'lj_badgeValue' 可以用来启动或关闭
@property (nonatomic, copy) NSString *lj_badgeValue;
@property (nonatomic, strong) UIColor *lj_badgeBGColor;
@property (nonatomic, strong) UIColor *lj_badgeTextColor;
@property (nonatomic, strong) UIFont *lj_badgeFont;
@property (nonatomic, assign) CGFloat lj_badgePadding;
@property (nonatomic, assign) CGFloat lj_badgeOriginX;
@property (nonatomic, assign) CGFloat lj_badgeOriginY;
@property (nonatomic, assign) BOOL lj_shouldHideBadgeAtZero;
@property (nonatomic, assign) BOOL lj_shouldAnimateBadge;

#pragma mark - point

@property (nonatomic, strong, readonly) UIView *lj_point;
// 'lj_showPoint' 用来启动或关闭
@property (nonatomic, assign) BOOL lj_showPoint;
@property (nonatomic, strong) UIColor *lj_pointBGColor;
@property (nonatomic, assign) CGFloat lj_pointRadius;
@property (nonatomic, assign) CGFloat lj_pointOriginX;
@property (nonatomic, assign) CGFloat lj_pointOriginY;
@property (nonatomic, assign) BOOL lj_shouldAnimatePoint;

#pragma mark - other Custom Views

+ (UIView *)maskView;

+ (UIView *)maskViewWithColor:(UIColor *)color alpha:(CGFloat)alpha;

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

- (void)addTopSeparatorLineWithMargin:(CGFloat)margin;

- (void)addTopSeparatorLine;

- (void)addBottomSeparatorLineWithMargin:(CGFloat)margin;

- (void)addBottomSeparatorLine;

- (void)addSepLineWithOffset:(CGPoint)offset width:(CGFloat)width height:(CGFloat)height;

- (void)addSeparatorLineWithColor:(UIColor *)color offset:(CGPoint)offset width:(CGFloat)width height:(CGFloat)height;

- (void)addTextFieldLineWithOffset:(CGPoint)offset width:(CGFloat)width;

+ (UIView *)viewWithColor:(UIColor *)color;

+ (UIView *)sepLine;

+ (UIView *)roundRedViewWithRadius:(CGFloat)radius;

- (void)boardWithColor:(UIColor *)color;

- (void)boardWithColor:(UIColor *)color withWidth:(CGFloat)width;

- (void)boardWithHexString:(NSString *)hex;

- (void)boardWithHexString:(NSString *)hex withWidth:(CGFloat)width;

- (void)addMask;

- (void)addBottomBorder;

#pragma mark - View Click

@property (nonatomic, copy) void(^viewClicked)(void);

#pragma mark - Animations

// Default spring animation, with damping 1.0
+ (void)springAnimateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

// Spring animation
+ (void)springAnimateWithDuration:(NSTimeInterval)duration withDamping:(CGFloat)dampingRatio animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

#pragma mark - Status

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen;

// 判断View是否完全显示在屏幕上
- (BOOL)isFullDisplayedInScreen;

// 截图
- (UIView *)screenShotView;

// 遍历子视图，返回第一响应视图
- (UIView *)firstResponderTest;

+ (UIView *)viewWithSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor contentview:(UIView *)contentview andEdgeInsets:(UIEdgeInsets)insets;

@end
