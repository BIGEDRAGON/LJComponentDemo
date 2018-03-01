//
//  UITextField+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/10/27.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UITextField+LJAdd.h"

@implementation UITextField (LJAdd)

+ (instancetype)textFieldWithPlaceholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType frameSize:(CGSize)frameSize {
    UITextField *t = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frameSize.width, frameSize.height)];
    t.placeholder = placeholder;
    t.keyboardType = keyboardType;
    return t;
}

@end
