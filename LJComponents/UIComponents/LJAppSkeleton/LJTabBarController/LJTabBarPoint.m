//
//  LJTabBarPoint.m
//  LJComponentDemo
//
//  Created by long on 2018/2/27.
//  Copyright © 2018年 long. All rights reserved.
//

#import "LJTabBarPoint.h"

@implementation LJTabBarPoint

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat radius = 10;
        self.size = CGSizeMake(radius, radius);
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = radius/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImageView *imageV = (UIImageView *)self.superview.subviews[0];
    CGSize imageViewSize = imageV.bounds.size;
    CGSize imageSize = imageV.image.size;
    
    CGFloat w = self.size.width;
    CGFloat x = (imageViewSize.width + imageSize.width - w/2)/2;
    CGFloat y = (imageViewSize.height - imageSize.height-w/2)/2;
    
    self.frame = CGRectMake(x, y, w, w);
}

- (void)setPointColor:(UIColor *)pointColor {
    
    _pointColor = pointColor;
    
    self.backgroundColor = pointColor;
}

- (void)setPointRadius:(CGFloat)pointRadius {
    
    _pointRadius = pointRadius;
    
    self.layer.cornerRadius = pointRadius/2;
    self.layer.masksToBounds = YES;
}

@end
