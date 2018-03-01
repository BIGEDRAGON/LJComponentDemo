//
//  UIViewController+LJTabBarController.m
//  LJComponentDemo
//
//  Created by long on 2018/2/23.
//  Copyright © 2018年 long. All rights reserved.
//

#import "UIViewController+LJTabBarController.h"
#import <objc/runtime.h>
#import "LJTabBarItem.h"

@implementation UIViewController (LJTabBarController)

- (LJTabBarDidClickAnimation)tabbarDidClickAnimation {
    return LJTabBarDidClickAnimationNone;
}

- (LJTabBar *)LJTabBar {
    LJTabBarController *tabBarController = (LJTabBarController *)self.tabBarController;
    return tabBarController.LJTabBar;
}

static int kShowPoint;
- (BOOL)showPoint {
    NSNumber *number = objc_getAssociatedObject(self, &kShowPoint);
    return number.boolValue;
}
- (void)setShowPoint:(BOOL)showPoint {
    NSNumber *number = [NSNumber numberWithBool:showPoint];
    objc_setAssociatedObject(self, &kShowPoint, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.currentTabBarItem.showPoint = showPoint;
}

static int kPointColor;
- (UIColor *)pointColor {
    UIColor *color = objc_getAssociatedObject(self, &kPointColor);
    return color;
}
- (void)setPointColor:(UIColor *)pointColor {
    objc_setAssociatedObject(self, &kPointColor, pointColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (pointColor) {
        self.currentTabBarItem.pointColor = pointColor;
    }
}

static int kCurrentTabBarItem;
- (LJTabBarItem *)currentTabBarItem {
    return objc_getAssociatedObject(self, &kCurrentTabBarItem);
}
- (void)setCurrentTabBarItem:(LJTabBarItem *)currentTabBarItem {
    objc_setAssociatedObject(self, &kCurrentTabBarItem, currentTabBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
