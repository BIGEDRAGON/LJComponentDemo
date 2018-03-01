//
//  UILabel+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/5.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UILabel+LJAdd.h"
#import "UIFont+LJAdd.h"
#import "UIColor+LJAdd.h"

@implementation UILabel (LJAdd)

- (void)resizeHeightToFitFontLineHeightBasedOnCenterYForSingleLine {
    if (self.numberOfLines == 1) {
        CGFloat centerY = self.centerY;
        self.height = floorf(self.font.lineHeight);
        self.centerY = centerY;
    }
}

+ (UILabel *)labelWithTextColor:(UIColor *)textColor {
    return [self labelWithText:nil textColor:COLOR_TEXT_Dark fontSize:14 frameSize:CGSizeZero alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    return [self labelWithText:nil textColor:textColor fontSize:fontSize frameSize:CGSizeZero alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize {
    return [self labelWithText:nil textColor:textColor fontSize:fontSize frameSize:frameSize alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithTextColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize alignment:(NSTextAlignment)alignment {
    return [self labelWithText:nil textColor:textColor fontSize:fontSize frameSize:frameSize alignment:alignment];
}

+ (UILabel *)labelWithText:(NSString *)text {
    return [self labelWithText:text textColor:COLOR_TEXT_Dark fontSize:14 frameSize:CGSizeZero alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor {
    return [self labelWithText:text textColor:textColor fontSize:14 frameSize:CGSizeZero alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    return [self labelWithText:text textColor:textColor fontSize:fontSize frameSize:CGSizeZero alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize {
    return [self labelWithText:text textColor:textColor fontSize:fontSize frameSize:frameSize alignment:NSTextAlignmentLeft];
}

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize frameSize:(CGSize)frameSize alignment:(NSTextAlignment)alignment {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectZero];
    l.font = FontOfSize(fontSize);
    l.textColor = textColor;
    l.textAlignment = alignment;
    l.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
    l.text = text;
    return l;
}

- (void)setText:(NSString*)text wordsSpacing:(CGFloat)wordsSpacing {
    if (wordsSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    [attributedString addAttribute:NSKernAttributeName value:@(wordsSpacing) range:NSMakeRange(0, [text length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

+ (CGFloat)text:(NSString*)text heightWithFont:(UIFont*)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = font;
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];
    return ceil(label.frame.size.height);
}

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    return [self text:text heightWithFont:[UIFont systemFontOfSize:fontSize] width:width lineSpacing:lineSpacing];
}

@end
