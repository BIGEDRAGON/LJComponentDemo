//
//  UIImage+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMG(imageName) [UIImage imageNamed:imageName]

@interface UIImage (LJAdd)

/**
 *  高斯模糊
 */
+ (UIImage *)gaussianBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color withWH:(CGFloat)widthAndHeight;
+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size;
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

- (UIImage *)reSizeToMaxSize:(CGFloat)maxSize;

+ (UIImage *)getTheLaunchImage;

- (CGFloat)heightOfFullScreenImage;


+ (CGFloat)heightFromUrl:(NSString *)imgUrl defaultHeight:(CGFloat)defaultHeight;

+ (CGFloat)heightFromUrl:(NSString *)imgUrl defaultHeight:(CGFloat)defaultHeight width:(CGFloat)width;

@end
