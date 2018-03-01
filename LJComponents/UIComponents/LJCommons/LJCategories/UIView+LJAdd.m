//
//  UIView+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIView+LJAdd.h"
#import <objc/runtime.h>
#import <YYCategories/YYCategories.h>
#import "UIColor+LJAdd.h"
#import "LJMacros.h"
#import "UIDevice+LJAdd.h"

@interface GestureRecognizerDelegation : NSObject <UIGestureRecognizerDelegate>

@end

@implementation GestureRecognizerDelegation

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@implementation UIView (LJAdd)

@dynamic lj_badgeValue, lj_badgeBGColor, lj_badgeTextColor, lj_badgeFont;
@dynamic lj_badgePadding, lj_badgeOriginX, lj_badgeOriginY;
@dynamic lj_shouldHideBadgeAtZero, lj_shouldAnimateBadge;

@dynamic lj_point, lj_showPoint, lj_pointBGColor;
@dynamic lj_pointRadius ,lj_pointOriginX, lj_pointOriginY;
@dynamic lj_shouldAnimatePoint;

#pragma mark - Frame&Bounds

+ (CGRect)rect:(CGRect)originalRect withMargins:(UIEdgeInsets)margins {
    originalRect.origin = CGPointMake(originalRect.origin.x + margins.left, originalRect.origin.y + margins.top);
    originalRect.size = CGSizeMake(originalRect.size.width - margins.left - margins.right, originalRect.size.height - margins.top - margins.bottom);
    return originalRect;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setTop:(CGFloat)t {
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b {
    self.frame = CGRectMake(self.left, b - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l {
    self.frame = CGRectMake(l, self.top, self.width, self.height);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r {
    self.frame = CGRectMake(r - self.width, self.top, self.width, self.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setBoundsWidth:(CGFloat)width {
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth {
    return self.bounds.size.width;
}

- (void)setBoundsHeight:(CGFloat)height {
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight {
    return self.bounds.size.height;
}

- (CGFloat)boundsCenterX {
    return self.boundsLeft + self.boundsWidth / 2;
}

- (CGFloat)boundsCenterY {
    return self.boundsTop + self.boundsHeight / 2;
}

- (void)setBoundsTop:(CGFloat)t {
    self.bounds = CGRectMake(self.boundsLeft, t, self.boundsWidth, self.boundsHeight);
}

- (CGFloat)boundsTop {
    return self.bounds.origin.y;
}

- (void)setBoundsBottom:(CGFloat)b {
    self.bounds = CGRectMake(self.boundsLeft, b - self.boundsHeight, self.boundsWidth, self.boundsHeight);
}

- (CGFloat)boundsBottom {
    return self.bounds.origin.y + self.bounds.size.height;
}

- (void)setBoundsLeft:(CGFloat)l {
    self.bounds = CGRectMake(l, self.boundsTop, self.boundsWidth, self.boundsHeight);
}

- (CGFloat)boundsLeft {
    return self.bounds.origin.x;
}

- (void)setBoundsRight:(CGFloat)r {
    self.bounds = CGRectMake(r - self.boundsWidth, self.boundsTop, self.boundsWidth, self.boundsHeight);
}

- (CGFloat)boundsRight {
    return self.bounds.origin.x + self.bounds.size.width;
}

#pragma mark - badge

- (void)badgeInit {
    self.lj_badge.textAlignment     = NSTextAlignmentCenter;
    
    self.lj_badgeBGColor            = [UIColor redColor];
    self.lj_badgeTextColor          = [UIColor whiteColor];
    self.lj_badgeFont               = [UIFont systemFontOfSize:11];
    self.lj_badgePadding            = 0;
    self.lj_badgeOriginX            = self.frame.size.width - self.lj_badge.frame.size.width/2;
    self.lj_badgeOriginY            = -self.lj_badge.frame.size.height / 2;
    self.lj_shouldHideBadgeAtZero   = YES;
    self.lj_shouldAnimateBadge      = YES;
    
    self.clipsToBounds              = NO;
}

- (void)refreshBadge {
    self.lj_badge.textColor        = self.lj_badgeTextColor;
    self.lj_badge.backgroundColor  = self.lj_badgeBGColor;
    self.lj_badge.font             = self.lj_badgeFont;
}

- (void)updateBadgeFrame {
    CGSize expectedLabelSize = CGSizeMake(16, 16);
    
    CGFloat minWidth = expectedLabelSize.width;
    CGSize titleSize = [self.lj_badgeValue sizeWithAttributes:@{NSFontAttributeName : self.lj_badgeFont}];
    minWidth = MAX(minWidth, titleSize.width + 4);
    
    CGFloat minHeight = expectedLabelSize.height;
//    minHeight = (minHeight < self.lj_badgeMinSize) ? self.lj_badgeMinSize : expectedLabelSize.height;
    
    CGFloat padding = self.lj_badgePadding;
    
    self.lj_badge.frame = CGRectMake(self.lj_badgeOriginX, self.lj_badgeOriginY, minWidth + padding, minHeight + padding);
    self.lj_badge.layer.cornerRadius = (minHeight + padding) / 2;
    self.lj_badge.layer.masksToBounds = YES;
}

- (void)updateBadgeValueAnimated:(BOOL)animated {
    
    if (animated && self.lj_shouldAnimateBadge && ![self.lj_badge.text isEqualToString:self.lj_badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.lj_badge.layer addAnimation:animation forKey:@"badgeBounceAnimation"];
    }
    
    self.lj_badge.text = self.lj_badgeValue;
    
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updateBadgeFrame];
    }];
}

- (void)removeBadge {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lj_badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.lj_badge removeFromSuperview];
        self.lj_badge = nil;
    }];
}

static int kLj_badge;
- (UILabel *)lj_badge {
    return objc_getAssociatedObject(self, &kLj_badge);
}
- (void)setLj_badge:(UILabel *)lj_badgeLabel {
    objc_setAssociatedObject(self, &kLj_badge, lj_badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kLj_badgeValue;
- (NSString *)lj_badgeValue {
    return objc_getAssociatedObject(self, &kLj_badgeValue);
}
- (void)setLj_badgeValue:(NSString *)lj_badgeValue {
    objc_setAssociatedObject(self, &kLj_badgeValue, lj_badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!lj_badgeValue || [lj_badgeValue isEqualToString:@""]) {
        [self removeBadge];
        return;
    }
    
    if (self.lj_shouldHideBadgeAtZero && [lj_badgeValue isEqualToString:@"0"]) {
        [self removeBadge];
        return;
    }
    
    if (!self.lj_badge) {
        self.lj_badge                      = [[UILabel alloc] init];
        [self badgeInit];
        if (self.lj_badgeValue.length >= 3) {
            self.lj_badgeFont = [UIFont systemFontOfSize:10.0];
            self.lj_badge.font = self.lj_badgeFont;
        }
        [self addSubview:self.lj_badge];
    }
    
    [self updateBadgeValueAnimated:self.lj_shouldAnimateBadge];
}

static int kLj_badgeBGColor;
- (UIColor *)lj_badgeBGColor {
    return objc_getAssociatedObject(self, &kLj_badgeBGColor);
}
- (void)setLj_badgeBGColor:(UIColor *)lj_badgeBGColor {
    objc_setAssociatedObject(self, &kLj_badgeBGColor, lj_badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_badge) {
        [self refreshBadge];
    }
}

static int kLj_badgeTextColor;
- (UIColor *)lj_badgeTextColor {
    return objc_getAssociatedObject(self, &kLj_badgeTextColor);
}
- (void)setLj_badgeTextColor:(UIColor *)lj_badgeTextColor {
    objc_setAssociatedObject(self, &kLj_badgeTextColor, lj_badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_badge) {
        [self refreshBadge];
    }
}

static int kLj_badgeFont;
- (UIFont *)lj_badgeFont {
    return objc_getAssociatedObject(self, &kLj_badgeFont);
}
- (void)setLj_badgeFont:(UIFont *)lj_badgeFont {
    objc_setAssociatedObject(self, &kLj_badgeFont, lj_badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_badge) {
        [self refreshBadge];
    }
}

static int kLj_badgePadding;
- (CGFloat)lj_badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_badgePadding);
    return number.floatValue;
}
- (void)setLj_badgePadding:(CGFloat)lj_badgePadding {
    NSNumber *number = [NSNumber numberWithDouble:lj_badgePadding];
    objc_setAssociatedObject(self, &kLj_badgePadding, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_badge) {
        [self updateBadgeFrame];
    }
}

static int kLj_badgeOriginX;
- (CGFloat)lj_badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_badgeOriginX);
    return number.floatValue;
}
- (void)setLj_badgeOriginX:(CGFloat)lj_badgeOriginX {
    NSNumber *number = [NSNumber numberWithDouble:lj_badgeOriginX];
    objc_setAssociatedObject(self, &kLj_badgeOriginX, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_badge) {
        [self updateBadgeFrame];
    }
}

static int kLj_badgeOriginY;
- (CGFloat)lj_badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_badgeOriginY);
    return number.floatValue;
}
- (void)setLj_badgeOriginY:(CGFloat)lj_badgeOriginY {
    NSNumber *number = [NSNumber numberWithDouble:lj_badgeOriginY];
    objc_setAssociatedObject(self, &kLj_badgeOriginY, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_badge) {
        [self updateBadgeFrame];
    }
}

static int kLj_shouldHideBadgeAtZero;
- (BOOL)lj_shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_shouldHideBadgeAtZero);
    return number.boolValue;
}
- (void)setLj_shouldHideBadgeAtZero:(BOOL)lj_shouldHideBadgeAtZero {
    NSNumber *number = [NSNumber numberWithBool:lj_shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &kLj_shouldHideBadgeAtZero, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kLj_shouldAnimateBadge;
- (BOOL)lj_shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_shouldAnimateBadge);
    return number.boolValue;
}
- (void)setLj_shouldAnimateBadge:(BOOL)lj_shouldAnimateBadge {
    NSNumber *number = [NSNumber numberWithBool:lj_shouldAnimateBadge];
    objc_setAssociatedObject(self, &kLj_shouldAnimateBadge, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - point

- (void)pointInit {
    self.lj_pointBGColor = [UIColor redColor];
    
    self.lj_pointRadius     = 10;
    self.lj_pointOriginX    = self.frame.size.width - self.lj_point.frame.size.width/2;
    self.lj_pointOriginY    = -self.lj_point.frame.size.height / 2;
    
    self.clipsToBounds      = NO;
}

- (void)removePoint {
    [UIView animateWithDuration:0.2 animations:^{
        self.lj_point.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.lj_point removeFromSuperview];
        self.lj_point = nil;
    }];
}

- (void)updatePointFrame {
    self.lj_point.frame = CGRectMake(self.lj_pointOriginX, self.lj_pointOriginY, self.lj_pointRadius, self.lj_pointRadius);
    self.lj_point.layer.cornerRadius = self.lj_pointRadius / 2;
    self.lj_point.layer.masksToBounds = YES;
}

- (void)updatePointValueAnimated:(BOOL)animated {
    
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.lj_point.layer addAnimation:animation forKey:@"pointBounceAnimation"];
    }
    
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self updatePointFrame];
    }];
}

static int kLj_point;
- (UIView *)lj_point {
    return objc_getAssociatedObject(self, &kLj_point);
}
- (void)setLj_point:(UIView *)lj_point {
    objc_setAssociatedObject(self, &kLj_point, lj_point, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kLj_showPoint;
- (BOOL)lj_showPoint {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_showPoint);
    return number.boolValue;
}
- (void)setLj_showPoint:(BOOL)lj_showPoint {
    NSNumber *number = [NSNumber numberWithBool:lj_showPoint];
    objc_setAssociatedObject(self, &kLj_showPoint, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!lj_showPoint) {
        [self removePoint];
        return;
    }
    
    if (!self.lj_point) {
        self.lj_point = [[UIView alloc] init];
        [self pointInit];
        [self addSubview:self.lj_point];
    }
    
    [self updatePointValueAnimated:self.lj_shouldAnimatePoint];
}

static int kLj_pointBGColor;
- (UIColor *)lj_pointBGColor {
    UIColor *color = objc_getAssociatedObject(self, &kLj_pointBGColor);
    return color;
}
- (void)setLj_pointBGColor:(UIColor *)lj_pointBGColor {
    objc_setAssociatedObject(self, &kLj_pointBGColor, lj_pointBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_point) {
        self.lj_point.backgroundColor  = lj_pointBGColor;
    }
}

static int kLj_pointRadius;
- (CGFloat)lj_pointRadius {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_pointRadius);
    return number.floatValue;
}
- (void)setLj_pointRadius:(CGFloat)lj_pointRadius {
    NSNumber *number = [NSNumber numberWithDouble:lj_pointRadius];
    objc_setAssociatedObject(self, &kLj_pointRadius, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_point) {
        [self updatePointFrame];
    }
}

static int kLj_pointOriginX;
- (CGFloat)lj_pointOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_pointOriginX);
    return number.floatValue;
}
- (void)setLj_pointOriginX:(CGFloat)lj_pointOriginX {
    NSNumber *number = [NSNumber numberWithDouble:lj_pointOriginX];
    objc_setAssociatedObject(self, &kLj_pointOriginX, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_point) {
        [self updatePointFrame];
    }
}

static int kLj_pointOriginY;
- (CGFloat)lj_pointOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_pointOriginY);
    return number.floatValue;
}
- (void)setLj_pointOriginY:(CGFloat)lj_pointOriginY {
    NSNumber *number = [NSNumber numberWithDouble:lj_pointOriginY];
    objc_setAssociatedObject(self, &kLj_pointOriginY, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.lj_point) {
        [self updatePointFrame];
    }
}

static int kLj_shouldAnimatePoint;
- (BOOL)lj_shouldAnimatePoint {
    NSNumber *number = objc_getAssociatedObject(self, &kLj_shouldAnimatePoint);
    return number.boolValue;
}
- (void)setLj_shouldAnimatePoint:(BOOL)lj_shouldAnimatePoint {
    NSNumber *number = [NSNumber numberWithBool:lj_shouldAnimatePoint];
    objc_setAssociatedObject(self, &kLj_shouldAnimatePoint, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - other Custom Views

+ (UIView *)maskView {
    return [UIView viewWithColor:COLOR_DarkAlpha(0.4)];
}

+ (UIView *)maskViewWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    return [UIView viewWithColor:[color colorWithAlphaComponent:alpha]];
}

/**
 ** lineView:	   需要绘制成虚线的view
 ** lineLength:	 虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:	  虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

- (void)addTopSeparatorLineWithMargin:(CGFloat)margin {
    [self addSepLineWithOffset:CGPointMake(margin, 0) width:self.width - margin - margin height:1];
}

- (void)addTopSeparatorLine {
    [self addSepLineWithOffset:CGPointZero width:self.width height:1];
}

- (void)addBottomSeparatorLineWithMargin:(CGFloat)margin {
    [self addSepLineWithOffset:CGPointMake(margin, self.height - 1) width:self.width - margin - margin height:1];
}

- (void)addBottomSeparatorLine {
    [self addSepLineWithOffset:CGPointMake(0, self.height - 1) width:self.width height:1];

}

- (void)addSepLineWithOffset:(CGPoint)offset width:(CGFloat)width height:(CGFloat)height {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offset.x, offset.y, width, height)];
    line.backgroundColor = COLOR_LINE_Cell;
    [self addSubview:line];
}

- (void)addSeparatorLineWithColor:(UIColor *)color offset:(CGPoint)offset width:(CGFloat)width height:(CGFloat)height {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offset.x, offset.y, width, height)];
    line.backgroundColor = color;
    [self addSubview:line];
}

- (void)addTextFieldLineWithOffset:(CGPoint)offset width:(CGFloat)width {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offset.x, offset.y, width, 2)];
    line.backgroundColor = COLOR_LINE_Cell;
    [self addSubview:line];
}

+ (UIView *)viewWithColor:(UIColor *)color {
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = color;
    
    return v;
}

+ (UIView *)sepLine {
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = COLOR_LINE_Cell;
    
    return v;
}

+ (UIView *)roundRedViewWithRadius:(CGFloat)radius {
    UIView *v = [self viewWithColor:COLOR_HexStr(@"#e03335")];
    v.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    v.layer.cornerRadius = radius;
    v.clipsToBounds = YES;
    return v;
}

- (void)boardWithColor:(UIColor *)color {
    [self boardWithColor:color withWidth:1];
}

- (void)boardWithColor:(UIColor *)color withWidth:(CGFloat)width {
    self.clipsToBounds = YES;
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)boardWithHexString:(NSString *)hex withWidth:(CGFloat)width {
    UIColor *color = [UIColor colorFromHexString:hex];
    [self boardWithColor:color withWidth:width];
}

- (void)boardWithHexString:(NSString *)hex {
    [self boardWithHexString:hex withWidth:1];
}

- (void)addMask {
    UIView *v = [UIView maskView];
    [self addSubview:v];
    WeakSelf()
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.and.right.equalTo(weakSelf);
    }];
}

- (void)addBottomBorder {
    [self addSepLineWithOffset:CGPointMake(0, self.height - 1) width:self.width height:1];
}

#pragma mark - View Click

static int kViewClicked;
- (void(^)(void))viewClicked {
    return objc_getAssociatedObject(self, &kViewClicked);
}

- (void)setViewClicked:(void(^)(void))viewClicked {
    objc_setAssociatedObject(self, &kViewClicked, viewClicked, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (self.tapGesture) {
        [self removeGestureRecognizer:self.tapGesture];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (viewClicked) {
            viewClicked();
        }
    }];
    
//    self.tapDelegation = [GestureRecognizerDelegation new];
//    tap.delegate = self.tapDelegation;
    [self addGestureRecognizer:tap];
    self.tapGesture = tap;
    self.userInteractionEnabled = YES;
}

static int kTapGesture;
- (UITapGestureRecognizer *)tapGesture {
    return objc_getAssociatedObject(self, &kTapGesture);
}

- (void)setTapGesture:(UITapGestureRecognizer *)tapGesture {
    objc_setAssociatedObject(self, &kTapGesture, tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kTapDelegation;
- (GestureRecognizerDelegation *)tapDelegation {
    return objc_getAssociatedObject(self, &kTapDelegation);
}

- (void)setTapDelegation:(GestureRecognizerDelegation *)tapDelegation {
    objc_setAssociatedObject(self, &kTapDelegation, tapDelegation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Animations

+ (void)springAnimateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:0 animations:animations completion:completion];
}

+ (void)springAnimateWithDuration:(NSTimeInterval)duration withDamping:(CGFloat)dampingRatio animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:dampingRatio initialSpringVelocity:0 options:0 animations:animations completion:completion];
}

#pragma mark - Status

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen {
    // 若view 隐藏
    if (self.hidden) {
        return NO;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }

    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return NO;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isFullDisplayedInScreen {
    // 若view 隐藏
    if (self.hidden) {
        return NO;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return NO;
    }
    
    return CGRectContainsRect(screenRect, rect) ? YES : NO;
}

- (UIView *)screenShotView {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.width, self.height);
    imageView.userInteractionEnabled = YES;
    return imageView;
}

- (UIView *)firstResponderTest {
    if ([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *v in self.subviews) {
        UIView *firstResponderView = [v firstResponderTest];
        if (firstResponderView) {
            return firstResponderView;
        }
    }
    
    return nil;
}

+ (UIView *)viewWithSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor contentview:(UIView *)contentview andEdgeInsets:(UIEdgeInsets)insets {
    UIView *view = [UIView viewWithColor:backgroundColor];
    view.frame = CGRectMake(0, 0, size.width, size.height);
    if (contentview) {
        contentview.frame = CGRectMake(insets.left, insets.top, view.width - insets.left - insets.right, view.height - insets.top - insets.bottom);
        [view addSubview:contentview];
    }
    return view;
}

@end
