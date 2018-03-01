//
//  UIFont+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/11.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FontOfSize(size)     ([UIFont regularFontWithSize:size])
#define ThinFontOfSize(size) ([UIFont thinFontWithSize:size])
#define BoldFontOfSize(size) ([UIFont boldFontWithSize:size])
#define DefaultFont          (FontOfSize(14))

@interface UIFont (LJAdd)

/**
 *  极细字体
 */
+ (UIFont *)veryThinFontWithSize:(CGFloat)size;

/**
 *  细字体
 */
+ (UIFont *)thinFontWithSize:(CGFloat)size;

/**
 *  常规字体
 */
+ (UIFont *)regularFontWithSize:(CGFloat)size;

/**
 *  加粗字体
 */
+ (UIFont *)boldFontWithSize:(CGFloat)size;

/**
 *  根据屏幕大小，调整字体大小
 *
 *  @param originalSize 原始字体大小
 *
 *  @return 调整后的字体大小
 */
+ (CGFloat)fontResizeBasedOnScreenWidth:(CGFloat)originalSize;

@end
