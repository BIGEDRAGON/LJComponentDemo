//
//  UIScreen+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+LJAdd.h"

// 系统版本
#define iOS_VERSION     ([UIDevice getVersion])
#define IOS7_OR_LATER   ([UIDevice isVersionLargeOrEqualThan:7)
#define IOS8_OR_LATER   ([UIDevice isVersionLargeOrEqualThan:8)
#define IOS9_OR_LATER   ([UIDevice isVersionLargeOrEqualThan:9)
#define IOS10_OR_LATER  ([UIDevice isVersionLargeOrEqualThan:10)
#define IOS11_OR_LATER  ([UIDevice isVersionLargeOrEqualThan:11)

// 设备型号
#define IS_SCREEN_35_INCH	CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)
#define IS_SCREEN_40_INCH	CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)
#define IS_SCREEN_47_INCH	CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)
#define IS_SCREEN_55_INCH	CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)
#define IS_SCREEN_50_INCH	CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)

// 屏幕UI常量
#define LJ_SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
#define LJ_SCREEN_WIDTH  (CGRectGetWidth([UIScreen mainScreen].bounds))
#define LJ_SCREEN_HEIGHT (CGRectGetHeight([UIScreen mainScreen].bounds))
#define LJ_SCREEN_SIZE   ([UIScreen mainScreen].bounds.size)

#define LJ_SCREEN_HEIGHT_SCALE (LJ_SCREEN_HEIGHT/667.0f)
#define LJ_SCREEN_WIDTH_SCALE  (LJ_SCREEN_WIDTH/375.0f)

#define LJ_PointScale_Width(point)  (point * LJ_SCREEN_WIDTH_SCALE)
#define LJ_PointScale_Height(point) (point * LJ_SCREEN_HEIGHT_SCALE)

#define LJ_PointScale_CeilWidth(point)  (ceilf(LJ_PointScale_Width(point)))
#define LJ_PointScale_CeilHeight(point) (ceilf(LJ_PointScale_Height(point)))

#define LJ_WIDTH(Value)  (Value * LJ_SCREEN_WIDTH_SCALE)
#define LJ_HEIGHT(Value) (Value * LJ_SCREEN_HEIGHT_SCALE)

#define LJ_NAV_BAR_HEIGHT   (IS_SCREEN_50_INCH?83:64)
#define LJ_STAUS_HEIGHT     (IS_SCREEN_50_INCH?44:20)
#define LJ_TABBAR_HEIGHT    (48)
#define LJ_SEPARATOR_HEIGHT (0.5)

@interface UIScreen (LJAdd)

+ (CGFloat)mainWidth;

+ (CGFloat)mainHeight;

@end
