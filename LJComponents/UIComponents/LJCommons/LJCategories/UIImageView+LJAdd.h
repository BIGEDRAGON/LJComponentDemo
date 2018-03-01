//
//  UIImageView+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, LJImageOptions) {
    LJImageSizeOptimize = 1 << 0,           // 图片大小是否根据View的size做优化，默认YES，如果为NO则使用LowQaulityImage
    LJImageAnimationIfNeed = 1 << 1,        // 图片显示时是否动画，默认YES
    LJImageUseDefaultPlaceholder = 1 << 2,  // 默认的占位图，默认YES
    LJImageUseGaussianBlur = 1 << 3,        // 高斯模糊效果，默认NO
    LJImageForceAnimation = 1 << 4,         // 强制动画，默认NO
    LJImageDelayPlaceholder = 1 << 5,       // 对应SDWebImageDelayPlaceholder，默认NO
};

@interface UIImageView (LJAdd)

/**
 *  图片失败重试次数，默认为1
 */
@property (nonatomic, assign) NSInteger lj_maxRetryCount;

/**
 *  图片URL设置是否成功
 */
@property (nonatomic, assign, readonly) BOOL lj_isImageSetSuccessed;

#pragma mark - 设置图片

/**
 * 根据尺寸获取对应的链接
 */
+ (NSString *)rewriteImgUrl:(NSString *)imgUrl withSize:(CGSize)size;

- (void)setImgUrl:(NSString *)imgUrl;

- (void)setImgUrl:(NSString *)imgUrl size:(CGSize)size;

- (void)setImgUrl:(NSString *)imgUrl size:(CGSize)size completed:(void(^)(UIImage *image))completed;

- (void)setImgUrl:(NSString *)imgUrl options:(LJImageOptions)options;

- (void)setImgUrl:(NSString *)imgUrl options:(LJImageOptions)options size:(CGSize)size;

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder;

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder completed:(void(^)(UIImage *image))completed;

- (void)setImgUrl:(NSString *)imgUrl options:(LJImageOptions)options completed:(void(^)(UIImage *image))completed;

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder size:(CGSize)size;

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder options:(LJImageOptions)options;

/**
 Set a image from network or local with url.
 @param completed   Called when image set completed. Not Called if canceled or set the same image url.
 */
- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder options:(LJImageOptions)options size:(CGSize)size completed:(void(^)(UIImage *image))completed;

#pragma mark - 自定义视图

/**
 *  loading视图，默认Size(24, 24)
 */
+ (UIImageView *)loadingImgView;

/**
 *  loading视图，自动启动动画，默认Size(24, 24)
 */
+ (UIImageView *)loadingImgViewWithAnimationStarted;

/**
 *  默认Size(24, 24)
 */
+ (UIImageView *)radioOnImgView;

/**
 *  默认Size(24, 24)
 */
+ (UIImageView *)radioOffImgView;

/**
 *  使用Gif图片
 */
+ (UIImageView *)imgViewWithGifName:(NSString *)gifName size:(CGSize)size;

+ (UIImageView *)imgViewWithName:(NSString *)imgName;

+ (UIImageView *)resizableWithName:(NSString *)imgName;

@end
