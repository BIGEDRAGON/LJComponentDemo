//
//  UIViewController+LJNavigationController.m
//  LJNavigationController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIViewController+LJNavigationController.h"
#import "objc/runtime.h"
#import "LJCategories.h"

@implementation UIViewController (LJNavigationController)

static int kIsSetup;
- (BOOL)isSetup {
    NSNumber *ret = objc_getAssociatedObject(self, &kIsSetup);
    return ret ? [ret boolValue] : NO;
}

- (void)setIsSetup:(BOOL)isSetup {
    objc_setAssociatedObject(self, &kIsSetup, @(isSetup), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LJNavigationController *)LJNavigationController {
    return (LJNavigationController *)self.navigationController;
}

static int kNavigationBarView;
- (LJNavigationBarView *)navigationBarView {
    return objc_getAssociatedObject(self, &kNavigationBarView);
}

- (void)setNavigationBarView:(LJNavigationBarView *)navigationBarView {
    objc_setAssociatedObject(self, &kNavigationBarView, navigationBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldDismissWhenOtherPushed {
    return NO;
}

#pragma mark - 导航栏的相关配置

- (BOOL)shouldUseNavigationBar {
    return YES;
}

- (BOOL)shouldDisplayDefaultBackBtn {
    return YES;
}

static int kBarTitle;
- (NSString *)barTitle {
    return objc_getAssociatedObject(self, &kBarTitle);
}

- (void)setBarTitle:(NSString *)barTitle {
    objc_setAssociatedObject(self, &kBarTitle, barTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.navigationBarView) {
        [self.navigationBarView setBarTitle:barTitle];
    }
}

- (void)addNavigationTitle:(NSString*)title {
    self.barTitle = title;
}

static int kIsBarViewHidden;
- (BOOL)isBarViewHidden {
    NSNumber *ret = objc_getAssociatedObject(self, &kIsBarViewHidden);
    return ret ? [ret boolValue] : NO;
}

- (void)setIsBarViewHidden:(BOOL)isBarViewHidden {
    objc_setAssociatedObject(self, &kIsBarViewHidden, @(isBarViewHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.navigationBarView) {
        self.navigationBarView.hidden = isBarViewHidden;
    }
}

static int kBarViewBackgroundColor;
- (UIColor *)barViewBackgroundColor {
    UIColor *ret = objc_getAssociatedObject(self, &kBarViewBackgroundColor);
    return ret ?: [UIColor whiteColor];
}

- (void)setBarViewBackgroundColor:(UIColor *)barViewBackgroundColor {
    objc_setAssociatedObject(self, &kBarViewBackgroundColor, barViewBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.navigationBarView) {
        self.navigationBarView.backgroundColor = barViewBackgroundColor;
    }
}

static int kBarTitleColor;
- (UIColor *)barTitleColor {
    UIColor *color = objc_getAssociatedObject(self, &kBarTitleColor);
    return color ?:COLOR_TEXT_Dark;
}

- (void)setBarTitleColor:(UIColor *)barTitleColor {
    objc_setAssociatedObject(self, &kBarTitleColor, barTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.navigationBarView) {
        [self.navigationBarView setBarTitleColor:barTitleColor];
    }
}

static int kBarTitleFont;
- (UIFont *)barTitleFont {
    UIFont *font = objc_getAssociatedObject(self, &kBarTitleFont);
    return font ?:[UIFont systemFontOfSize:16];
}

- (void)setBarTitleFont:(UIFont *)barTitleFont {
    objc_setAssociatedObject(self, &kBarTitleFont, barTitleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.navigationBarView) {
        [self.navigationBarView setBarTitleFont:barTitleFont];
    }
}

#pragma mark - Push & Pop 动画

static int kPushAnimation;
- (LJTransitionAnimator *)pushAnimation {
    return objc_getAssociatedObject(self, &kPushAnimation);
}

- (void)setPushAnimation:(LJTransitionAnimator *)pushAnimation {
    objc_setAssociatedObject(self, &kPushAnimation, pushAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kPopAnimation;
- (LJTransitionAnimator *)popAnimation {
    return objc_getAssociatedObject(self, &kPopAnimation);
}

- (void)setPopAnimation:(LJTransitionAnimator *)popAnimation {
    objc_setAssociatedObject(self, &kPopAnimation, popAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldEnableNavigationInteractPop {
    return YES;
}

@end
