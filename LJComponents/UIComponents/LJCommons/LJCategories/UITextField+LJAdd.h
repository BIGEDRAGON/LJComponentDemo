//
//  UITextField+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/10/27.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LJAdd)

+ (instancetype)textFieldWithPlaceholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType frameSize:(CGSize)frameSize;

@end
