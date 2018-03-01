//
//  UIScreen+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIScreen+LJAdd.h"

@implementation UIScreen (LJAdd)

+ (CGFloat)mainWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)mainHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
