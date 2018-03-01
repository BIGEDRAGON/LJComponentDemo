//
//  UIColor+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/3.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Colours/Colours.h>

// 便捷方法和宏定义
#pragma mark - Convenient Methods & Defines

#define COLOR_RGBA(r,g,b,a)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define COLOR_RGB(r,g,b)        COLOR_RGBA(r,g,b,1.0f)
#define COLOR_Random            COLOR_RGB((arc4random()%255),(arc4random()%255),(arc4random()%255))
#define COLOR_DarkAlpha(a)      COLOR_RGBA(0,0,0,a)
#define COLOR_WhiteAlpha(a)     COLOR_RGBA(255,255,255,a)
#define COLOR_HexStr(hexStr)    ([UIColor colorFromHexString:hexStr])

// 预定义的颜色
#pragma mark - Predefined Colors

// 背景
#define COLOR_BG_White          (COLOR_HexStr(@"#ffffff"))
#define COLOR_BG_Dark           (COLOR_HexStr(@"#262626"))
#define COLOR_BG_Light          (COLOR_HexStr(@"#f1f1f1"))
#define COLOR_BG_Disabled       (COLOR_HexStr(@"#dadada"))

// 文本
#define COLOR_TEXT_Dark         (COLOR_DarkAlpha(0.87))
#define COLOR_TEXT_Light        (COLOR_DarkAlpha(0.54))
#define COLOR_TEXT_Light2       (COLOR_DarkAlpha(0.38))
#define COLOR_TEXT_Light3       (COLOR_DarkAlpha(0.25))
#define COLOR_TEXT_White        (COLOR_HexStr(@"#ffffff"))
#define COLOR_TEXT_Red          (COLOR_HexStr(@"#e03335"))
#define COLOR_TEXT_Yellow       (COLOR_HexStr(@"#f7aa23"))
#define COLOR_TEXT_Empty        (COLOR_HexStr(@"#d6d6d6"))

// 分割线
#define COLOR_LINE_Dash         (COLOR_HexStr(@"#cccccc"))
#define COLOR_LINE_Cell         (COLOR_HexStr(@"#f1f1f1"))
#define COLOR_LINE_Separator1   (COLOR_HexStr(@"#f1f1f1"))
#define COLOR_LINE_Separator2   (COLOR_HexStr(@"#e6e6e6"))

@interface UIColor (LJAdd)

@end
