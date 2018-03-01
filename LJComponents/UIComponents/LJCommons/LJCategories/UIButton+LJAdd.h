//
//  UIButton+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/5.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAV_BAR_ITEM_LEFT_INSET (16)
#define NAV_BAR_ITEM_RIGHT_INSET (16)

typedef NS_ENUM(NSInteger, LJButtonStyle) {
    kLJButtonStyleTextDefault = 0,  // 文本按钮，默认
    kLJButtonStyleTextCancel,       // 文本按钮，取消样式
    kLJButtonStyleTextDestructive,  // 文本按钮，警告样式
    kLJButtonStyleActionDefault,    // 带边框文本按钮，默认
    kLJButtonStyleActionCancel,     // 带边框文本按钮，取消样式
    kLJButtonStyleActionDestructive // 带边框文本按钮，警告样式
};

@interface UIButton (LJAdd)

#pragma mark - 点击事件

// 按钮的点击事件回调，UIControlEventTouchUpInside
@property (nonatomic, copy) void(^clickedCallback)(void);

#pragma mark - 便捷构造方法

+ (UIButton *)buttonWithStyle:(LJButtonStyle)style title:(NSString *)title clicked:(void(^)(void))clicked;

+ (UIButton *)buttonWithStyle:(LJButtonStyle)style size:(CGSize)size title:(NSString *)title clicked:(void(^)(void))clicked;

/**
 * 图片按钮
 
 * layout:
 
 |<--leftPadding-->|Image.size.width|<---auto--->|
 |<------            size.width           ------>|
 */
+ (UIButton *)buttonWithImgName:(NSString *)imgName
                        clicked:(void(^)(void))clicked
                           size:(CGSize)size
                    leftPadding:(CGFloat)leftPadding
                          color:(UIColor *)color;

- (void)setImage:(UIImage *)image forState:(UIControlState)state leftPadding:(CGFloat)leftPadding;

/**
 * 图片按钮
 
 * layout:
 
 |<--auto-->|Image.size.width|<---rightPadding--->|
 |<------             size.width           ------>|
 */
+ (UIButton *)buttonWithImgName:(NSString *)imgName
                        clicked:(void(^)(void))clicked
                           size:(CGSize)size
                   rightPadding:(CGFloat)rightPadding
                          color:(UIColor *)color;

- (void)setImage:(UIImage *)image forState:(UIControlState)state rightPadding:(CGFloat)rightPadding;

+ (UIButton *)customButtonWithImgName:(NSString *)imgName
                              clicked:(void(^)(void))clicked
                                 size:(CGSize)size
                         rightPadding:(CGFloat)rightPadding;

/**
 *  文本按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                      clicked:(void(^)(void))clicked
                         size:(CGSize)size
                     fontSize:(CGFloat)fontSize
                   titleColor:(UIColor *)titleColor;

/**
 *  文本按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
                      clicked:(void(^)(void))clicked
                         size:(CGSize)size
                     fontSize:(CGFloat)fontSize
                   titleColor:(UIColor *)titleColor
                  borderColor:(UIColor *)borderColor;

/**
 *  图片按钮
 */
+ (UIButton *)buttonWithImgName:(NSString *)imgName
                        clicked:(void(^)(void))clicked
                           size:(CGSize)size
                          color:(UIColor *)color;

/**
 *  图片+文字按钮
 */
+ (UIButton *)customBtnWithImgName:(NSString *)imgName
                          title:(NSString *)title
                       fontSize:(CGFloat)fontSize
                     titleColor:(UIColor *)titleColor
                        clicked:(void(^)(void))clicked;

/**
 *  font 14, contentInset UIEdgeInsetsMake(8, 15, 8, 15)
 */
+ (UIButton *)buttonStyleSizeToFit:(NSString *)title clicked:(void(^)(void))clicked;

+ (UIButton *)customBtnWithImgName:(NSString *)imgName size:(CGSize)size;

+ (UIButton *)customBtnWithImgName:(NSString *)imgName clicked:(void(^)(void))clicked size:(CGSize)size;

+ (UIButton *)clearColorBtnWithClicked:(void(^)(void))clicked;

+ (UIButton *)defaultDarkBtn;

+ (UIButton *)defaultCellBtn;

// 返回右侧图标左侧文字的按钮，字体14pt
+ (UIButton *)rightImageStyleBtnWithTitle:(NSString *)title
                                imageName:(NSString *)imageName
                                  minSize:(CGSize)size;

+ (UIButton *)topImageStyleBtnWithTitle:(NSString *)title
                              imageName:(NSString *)imageName
                               fontSize:(CGFloat)fontSize
                                   size:(CGSize)size;

+ (UIButton *)locationBtnWithTitle:(NSString *)title;

@end
