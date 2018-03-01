//
//  UIFont+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/11.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIFont+LJAdd.h"
#import <YYCategories/YYCategories.h>
#import "UIScreen+LJAdd.h"

@implementation UIFont (LJAdd)

+ (UIFont *)veryThinFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Ultralight" size:size];
    
    if (!font) {
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    }
    
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    
    return font;
}

+ (UIFont *)thinFontWithSize:(CGFloat)size {
    
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Thin" size:size];
    
    if (!font) {
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
    }
    
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    
    return font;
}

+ (UIFont *)regularFontWithSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)boldFontWithSize:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:size];;
}

+ (CGFloat)fontResizeBasedOnScreenWidth:(CGFloat)originalSize {
    return LJ_PointScale_Width(originalSize);
}

@end
