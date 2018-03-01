//
//  LJTabBarBadge.m
//  LJTabBarController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "LJTabBarBadge.h"

@implementation LJTabBarBadge

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = NO;
        self.hidden = YES;
//        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        CGFloat badgeR = 16.0;
        UIImage *bgImage = [UIImage imageFromColor:COLOR_RGB(255.0, 91.0, 54.0) withSize:CGSizeMake(badgeR, badgeR)];
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    return self;
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    
    _badgeTitleFont = badgeTitleFont;
    
    self.titleLabel.font = badgeTitleFont;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    
    _badgeValue = [badgeValue copy];
    
    self.hidden = !(BOOL)self.badgeValue;
    
    if (self.badgeValue) {
        
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        [self updateView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateView];
}

- (void)updateView {
    CGRect frame = self.frame;
    
    if (self.badgeValue.length > 0) {
        
        CGFloat badgeW = self.currentBackgroundImage.size.width;
        CGFloat badgeH = self.currentBackgroundImage.size.height;
        
        CGSize titleSize = [self.badgeValue sizeWithAttributes:@{NSFontAttributeName : self.badgeTitleFont}];
        frame.size.width = MAX(badgeW, titleSize.width + 4);
        frame.size.height = badgeH;
        self.frame = frame;
        
    } else {
        
        frame.size.width = 12.0f;
        frame.size.height = frame.size.width;
    }
    
    frame.origin.x = self.superview.bounds.size.width * 0.5 + 10;
    frame.origin.y = 2.0f;
    self.frame = frame;
    
    self.layer.cornerRadius = frame.size.height * 0.5;
    self.layer.masksToBounds = YES;
}

- (UIImage *)resizedImageFromMiddle:(UIImage *)image {
    
    return [self resizedImage:image width:0.5f height:0.5f];
}

- (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height {
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * width
                                      topCapHeight:image.size.height * height];
}

@end
