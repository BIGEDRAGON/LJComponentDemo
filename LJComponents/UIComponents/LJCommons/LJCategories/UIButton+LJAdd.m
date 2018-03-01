//
//  UIButton+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/5.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIButton+LJAdd.h"
#import <objc/runtime.h>
#import <YYCategories/YYCategories.h>
#import "UIFont+LJAdd.h"
#import "UIColor+LJAdd.h"
#import "UIScreen+LJAdd.h"
#import "UIImage+LJAdd.h"

@implementation UIButton (LJAdd)

#pragma mark - 点击事件

static int kClickedCallback;
- (void(^)(void))clickedCallback {
    return objc_getAssociatedObject(self, &kClickedCallback);
}

- (void)setClickedCallback:(void(^)(void))clickedCallback {
    objc_setAssociatedObject(self, &kClickedCallback, clickedCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    
    [self addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClicked {
    if (self.clickedCallback) {
        self.clickedCallback();
    }
}

#pragma mark - 便捷构造方法

+ (UIButton *)buttonWithStyle:(LJButtonStyle)style title:(NSString *)title clicked:(void(^)(void))clicked {
    return [self buttonWithStyle:style size:CGSizeMake(64, 32) title:title clicked:clicked];
}

+ (UIButton *)buttonWithStyle:(LJButtonStyle)style size:(CGSize)size title:(NSString *)title clicked:(void(^)(void))clicked {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.titleLabel.font = FontOfSize(14);
    btn.backgroundColor = [UIColor whiteColor];
    btn.clickedCallback = clicked;
    
    switch (style) {
        case kLJButtonStyleTextDefault:
            btn.tintColor = COLOR_TEXT_Dark;
            break;
        case kLJButtonStyleTextCancel:
            btn.tintColor = [UIColor blueColor];
            break;
        case kLJButtonStyleTextDestructive:
            btn.tintColor = COLOR_TEXT_Red;
            break;
        case kLJButtonStyleActionDefault:
            btn.tintColor = COLOR_TEXT_Dark;
            btn.layer.borderColor = COLOR_BG_Dark.CGColor;
            btn.layer.borderWidth = 1.0;
            break;
        case kLJButtonStyleActionCancel:
            btn.tintColor = [UIColor blueColor];
            btn.layer.borderColor = COLOR_BG_Dark.CGColor;
            btn.layer.borderWidth = 1.0;
            break;
        case kLJButtonStyleActionDestructive:
            btn.tintColor = COLOR_TEXT_Red;
            btn.layer.borderColor = COLOR_BG_Dark.CGColor;
            btn.layer.borderWidth = 1.0;
            break;
        default:
            break;
    }
    
    return btn;
}

+ (UIButton *)buttonWithImgName:(NSString *)imgName
                        clicked:(void(^)(void))clicked
                           size:(CGSize)size
                    leftPadding:(CGFloat)leftPadding
                          color:(UIColor *)color {
    UIImage *image = IMG(imgName);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:image forState:UIControlStateNormal];
    CGSize imgSize = image ? image.size : CGSizeZero;
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, leftPadding, 0, size.width - imgSize.width - leftPadding);
    btn.clickedCallback = clicked;
    btn.tintColor = color;
    
    return btn;
}

+ (UIButton *)buttonWithImgName:(NSString *)imgName
                        clicked:(void(^)(void))clicked
                           size:(CGSize)size
                    rightPadding:(CGFloat)rightPadding
                          color:(UIColor *)color {
    UIImage *image = IMG(imgName);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:image forState:UIControlStateNormal];
    CGSize imgSize = image ? image.size : CGSizeZero;
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, size.width - imgSize.width - rightPadding, 0, rightPadding);
    btn.clickedCallback = clicked;
    btn.tintColor = color;
    
    return btn;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state leftPadding:(CGFloat)leftPadding {
    [self setImage:image forState:state];
    CGSize imgSize = image ? image.size : CGSizeZero;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, leftPadding, 0, CGRectGetWidth(self.frame) - imgSize.width - leftPadding);
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state rightPadding:(CGFloat)rightPadding; {
    [self setImage:image forState:state];
    CGSize imgSize = image ? image.size : CGSizeZero;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(self.frame) - imgSize.width - rightPadding, 0, rightPadding);
}

+ (UIButton *)customButtonWithImgName:(NSString *)imgName
                        clicked:(void(^)(void))clicked
                           size:(CGSize)size
                   rightPadding:(CGFloat)rightPadding {
    UIImage *image = IMG(imgName);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    CGSize imgSize = image ? image.size : CGSizeZero;
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, size.width - imgSize.width - rightPadding, 0, rightPadding);
    btn.clickedCallback = clicked;
    
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                      clicked:(void(^)(void))clicked
                         size:(CGSize)size
                     fontSize:(CGFloat)fontSize
                   titleColor:(UIColor *)titleColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.titleLabel.font = FontOfSize(fontSize);
    btn.tintColor = titleColor;
    btn.clickedCallback = clicked;
    
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                      clicked:(void(^)(void))clicked
                         size:(CGSize)size
                     fontSize:(CGFloat)fontSize
                   titleColor:(UIColor *)titleColor
                  borderColor:(UIColor *)borderColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.titleLabel.font = FontOfSize(fontSize);
    btn.tintColor = titleColor;
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = 1.0;
    btn.backgroundColor = COLOR_BG_White;
    btn.clickedCallback = clicked;
    
    return btn;
}

+ (UIButton *)buttonWithImgName:(NSString *)imgName
                        clicked:(void(^)(void))clicked
                           size:(CGSize)size
                          color:(UIColor *)color {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:IMG(imgName) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.tintColor = color;
    btn.clickedCallback = clicked;
    
    return btn;
}

+ (UIButton *)customBtnWithImgName:(NSString *)imgName
                          title:(NSString *)title
                       fontSize:(CGFloat)fontSize
                     titleColor:(UIColor *)titleColor
                        clicked:(void(^)(void))clicked {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:IMG(imgName) forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = FontOfSize(fontSize);
    btn.clickedCallback = clicked;
    
    return btn;
}

+ (UIButton *)buttonStyleSizeToFit:(NSString *)title clicked:(void(^)(void))clicked {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(8, 15, 8, 15)];
    btn.titleLabel.font = FontOfSize(14);
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn setTitleColor:COLOR_TEXT_Dark forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_TEXT_White forState:UIControlStateHighlighted];
    [btn setTitleColor:COLOR_TEXT_White forState:UIControlStateSelected];
    [btn setTitleColor:COLOR_TEXT_Light2 forState:UIControlStateDisabled];
    
    [btn setBackgroundImage:[UIImage imageFromColor:COLOR_BG_White] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageFromColor:COLOR_BG_Dark] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageFromColor:COLOR_BG_Dark] forState:UIControlStateSelected];
    
    btn.layer.borderColor = COLOR_TEXT_Dark.CGColor;
    btn.layer.borderWidth = 1;
    
    btn.clickedCallback = clicked;
    
    [btn sizeToFit];
    
    return btn;
}

+ (UIButton *)customBtnWithImgName:(NSString *)imgName size:(CGSize)size {
    return [UIButton customBtnWithImgName:imgName clicked:nil size:size];
}

+ (UIButton *)customBtnWithImgName:(NSString *)imgName clicked:(void(^)(void))clicked size:(CGSize)size {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:IMG(imgName) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    btn.clickedCallback = clicked;
    
    return btn;
}

+ (UIButton *)clearColorBtnWithClicked:(void(^)(void))clicked {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 48, 48);
    btn.backgroundColor = [UIColor clearColor];
    btn.tintColor = [UIColor clearColor];
    btn.clickedCallback = clicked;
    return btn;
}

+ (UIButton *)defaultDarkBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = COLOR_BG_Dark;
    btn.tintColor = [UIColor whiteColor];
    return btn;
}

+ (UIButton *)defaultCellBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor clearColor];
    btn.tintColor = COLOR_TEXT_Dark;
    btn.layer.borderColor = COLOR_TEXT_Dark.CGColor;
    btn.layer.borderWidth = 0.5;
    return btn;
}

// 返回右侧图标左侧文字的按钮
+ (UIButton *)rightImageStyleBtnWithTitle:(NSString *)title
                                imageName:(NSString *)imageName
                                  minSize:(CGSize)size {
    UIImage *image = IMG(imageName);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = FontOfSize(14);
    [btn setTitleColor:COLOR_TEXT_Dark forState:UIControlStateNormal];
    CGFloat textWidth = title ? [title widthForFont:FontOfSize(14)] : 0;
    CGSize imgSize = image ? image.size : CGSizeZero;
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, textWidth, 0, -textWidth);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imgSize.width, 0, imgSize.width);
    btn.frame = CGRectMake(0, 0, MAX(size.width, textWidth + imgSize.width), MAX(size.height, MAX(imgSize.height, FontOfSize(14).lineHeight)));
    CGFloat contentLeftMargin = (btn.width - textWidth - imgSize.width) / 2;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, contentLeftMargin, 0, btn.width - textWidth - imgSize.width - contentLeftMargin);
    
    return btn;
}

+ (UIButton *)topImageStyleBtnWithTitle:(NSString *)title
                              imageName:(NSString *)imageName
                               fontSize:(CGFloat)fontSize
                                   size:(CGSize)size {
    UIImage *image = IMG(imageName);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, size.width, size.height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = FontOfSize(fontSize);
    
    CGSize imgSize = image ? image.size : CGSizeZero;
    CGSize textSize = title ? [title sizeForFont:btn.titleLabel.font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping] : CGSizeZero;
    
    CGFloat margin = 1;
    CGFloat padding = (size.height - imgSize.height - textSize.height - margin) / 2.0;
    
    btn.imageEdgeInsets = UIEdgeInsetsMake(padding, 0, size.height - imgSize.height - padding, -textSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(size.height - textSize.height - padding, -imgSize.width, padding, 0);
    
    return btn;
}

+ (UIButton *)locationBtnWithTitle:(NSString *)title {
    UIButton *btn = [UIButton rightImageStyleBtnWithTitle:title imageName:@"icon_arrow_down" minSize:CGSizeMake(40 + 48, 40)];
    btn.tintColor = COLOR_TEXT_Dark;
    return btn;
}

@end
