//
//  UILabel+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/5.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMacros.h"

@interface UILabel (LJAdd)

/**
 *  根据字体大小，调整标签高度
 */
- (void)resizeHeightToFitFontLineHeightBasedOnCenterYForSingleLine;

#pragma mark - 便捷实例化方法

/*
 文本
 文本颜色、默认值为darkTextColor
 字体大小、默认值为14
 视图大小、默认为CGSizeZero
 对齐方式、默认为NSTextAlignmentLeft
 */

+ (UILabel *)labelWithTextColor:(UIColor *)textColor;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize alignment:(NSTextAlignment)alignment;

+ (UILabel *)labelWithText:(NSString *)text;

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor;

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize;

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize;

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize alignment:(NSTextAlignment)alignment;


/**
 设置富文本 & 获取文本高度
 */
- (void)setText:(NSString*)text wordsSpacing:(CGFloat)wordsSpacing;
- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;
+ (CGFloat)text:(NSString*)text heightWithFont:(UIFont*)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

@end
