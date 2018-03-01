//
//  UIImageView+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIImageView+LJAdd.h"
#import <objc/runtime.h>
#import <SDWebImage/UIImage+GIF.h>
//#import <UMMobClick/MobClick.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "UIImage+LJAdd.h"
#import "UIColor+LJAdd.h"
#import "UIView+LJAdd.h"
#import "UIScreen+LJAdd.h"
#import "NSMutableArray+LJAdd.h"
#import "NSString+LJAdd.h"
#import "LJMacros.h"
//#import "LJReachability.h"

/**
 *  图片质量
 */
typedef NS_ENUM(NSInteger, ImageQuality) {
    /**
     *  原图
     */
    kImageQualityOriginal = 0,
    /**
     *  高清
     */
    kImageQuality1200,
    /**
     *  标清
     */
    kImageQuality800,
    /**
     *  小图
     */
    kImageQuality400,
    /**
     *  小图
     */
    kImageQuality200
};

/**
 *  图片设置状态
 */
typedef NS_ENUM(NSInteger, LJImageStatus) {
    /**
     *  未设置状态或设置失败
     */
    kLJImageStatusUnsetOrFailed = 0,
    /**
     *  正在设置（图片URL不为nil，正在从网络或磁盘或内存等加载）或正在清除（图片URL为nil）状态
     */
    kLJImageStatusSettingOrCleaning,
    /**
     *  设置（图片URL不为nil）或清除（图片URL为nil）完成状态
     */
    kLJImageStatusFinished
};

@interface UIImageView (LJAdd_internal)

/**
 *  重试次数，默认为0
 */
@property (nonatomic, assign) NSInteger lj_retryCount;

/**
 *  图片设置状态，默认为kLJImageStatusUnsetOrFailed
 */
@property (nonatomic, assign) LJImageStatus lj_imgSetStatus;

@end

@implementation UIImageView (LJAdd)

static int kContentModeBeforUsePlaceholder;
- (NSNumber *)contentModeBeforUsePlaceholder {
    return objc_getAssociatedObject(self, &kContentModeBeforUsePlaceholder);
}

- (void)setContentModeBeforUsePlaceholder:(NSNumber *)contentModeBeforUsePlaceholder {
    objc_setAssociatedObject(self, &kContentModeBeforUsePlaceholder, contentModeBeforUsePlaceholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kLJ_maxRetryCount;
- (NSInteger)lj_maxRetryCount {
    NSNumber *ret = objc_getAssociatedObject(self, &kLJ_maxRetryCount);
    // 默认返回1
    return ret ? [ret integerValue] : 1;
}

- (void)setLj_maxRetryCount:(NSInteger)lj_maxRetryCount {
    objc_setAssociatedObject(self, &kLJ_maxRetryCount, @(lj_maxRetryCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lj_isImageSetSuccessed {
    return self.lj_imgSetStatus == kLJImageStatusFinished;
}

static int kLJ_retryCount;
- (NSInteger)lj_retryCount {
    NSNumber *ret = objc_getAssociatedObject(self, &kLJ_retryCount);
    return ret ? [ret integerValue] : 0;
}

- (void)setLj_retryCount:(NSInteger)lj_retryCount {
    objc_setAssociatedObject(self, &kLJ_retryCount, @(lj_retryCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kLJ_imgSetStatus;
- (LJImageStatus)lj_imgSetStatus {
    NSNumber *ret = objc_getAssociatedObject(self, &kLJ_imgSetStatus);
    return ret ? [ret integerValue] : kLJImageStatusUnsetOrFailed;
}

- (void)setLj_imgSetStatus:(LJImageStatus)lj_imgSetStatus {
    objc_setAssociatedObject(self, &kLJ_imgSetStatus, @(lj_imgSetStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 图片质量&URL重写

/**
 *  根据图片大小，选择不同的图片质量
 */
+ (ImageQuality)imageQualityForSize:(CGSize)size {

    // 弱网络情况
//    if ([LJReachability sharedInstance].connectionStatus == kLJConnectionStatus2G) {
//        return kImageQuality200;
//    }
    
    CGFloat scaleRatio = [UIScreen mainScreen].scale;
    CGFloat maxSize = size.width * scaleRatio;
    
    if (maxSize <= 200) {
        return kImageQuality200;
    }
    else if (maxSize <= 400) {
        return kImageQuality400;
    }
    else if (maxSize <= 800) {
        return kImageQuality800;
    }
    else {
        return kImageQuality1200;
    }
}

/**
 *  根据图片质量，重写图片URL
 */
+ (NSString *)rewriteImgUrl:(NSString *)imgUrl withQuality:(ImageQuality)quality {
    if (imgUrl.length == 0) {
        return imgUrl;
    }
    
    switch (quality) {
        case kImageQualityOriginal:
            return imgUrl;
        case kImageQuality1200:
            return [imgUrl stringByAppendingString:@"@!1200wp"];
        case kImageQuality800:
            return [imgUrl stringByAppendingString:@"@!800wp"];
        case kImageQuality400:
            return [imgUrl stringByAppendingString:@"@!400wp"];
        case kImageQuality200:
            return [imgUrl stringByAppendingString:@"@!200wp"];
        default:
            return [imgUrl stringByAppendingString:@"@!200wp"];
    }
}

+ (NSString *)rewriteImgUrl:(NSString *)imgUrl withSize:(CGSize)size  {
    return [self rewriteImgUrl:imgUrl withQuality:[self imageQualityForSize:size]];
}

+ (NSString *)originalUrlFromRewritedImgUrl:(NSString *)rewritedImgUrl {
    static NSArray *__suffixs = nil;
    if (!__suffixs) {
        __suffixs = @[@"@!1200wp", @"@!800wp", @"@!400wp", @"@!200wp"];
    }
    
    if (rewritedImgUrl.length > 0) {
        for (NSString *suffix in __suffixs) {
            if ([rewritedImgUrl hasSuffix:suffix]) {
                rewritedImgUrl = [rewritedImgUrl substringToIndex:rewritedImgUrl.length - suffix.length];
                break;
            }
        }
    }
    
    return rewritedImgUrl;
}

+ (BOOL)isSameImageUrl:(NSString *)rewritedImgUrl1 withUrl:(NSString *)rewritedImgUrl2 {
    NSString *originalUrl1 = [self originalUrlFromRewritedImgUrl:rewritedImgUrl1];
    NSString *originalUrl2 = [self originalUrlFromRewritedImgUrl:rewritedImgUrl2];
    if (!originalUrl1 && !originalUrl2) {
        return YES;
    }
    
    return [originalUrl1 isEqualToString:originalUrl2];
}

#pragma mark - 设置图片

+ (LJImageOptions)LJ_defaultImgSetOptions {
    return (LJImageSizeOptimize | LJImageAnimationIfNeed | LJImageUseDefaultPlaceholder);
}

- (void)restoreContentMode {
    if ([self contentModeBeforUsePlaceholder]) {
        self.contentMode = [[self contentModeBeforUsePlaceholder] integerValue];
        [self setContentModeBeforUsePlaceholder:nil];
        self.backgroundColor = nil;
    }
}

- (void)setImgUrl:(NSString *)imgUrl {
    [self setImgUrl:imgUrl placeholder:nil options:[UIImageView LJ_defaultImgSetOptions] size:self.size completed:nil];
}

- (void)setImgUrl:(NSString *)imgUrl size:(CGSize)size {
    [self setImgUrl:imgUrl placeholder:nil options:[UIImageView LJ_defaultImgSetOptions] size:size completed:nil];
}

- (void)setImgUrl:(NSString *)imgUrl size:(CGSize)size completed:(void(^)(UIImage *image))completed {
    [self setImgUrl:imgUrl placeholder:nil options:[UIImageView LJ_defaultImgSetOptions] size:size completed:completed];
}

- (void)setImgUrl:(NSString *)imgUrl options:(LJImageOptions)options {
    [self setImgUrl:imgUrl placeholder:nil options:options size:self.size completed:nil];
}

- (void)setImgUrl:(NSString *)imgUrl options:(LJImageOptions)options size:(CGSize)size {
    [self setImgUrl:imgUrl placeholder:nil options:options size:size completed:nil];
}

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder {
    [self setImgUrl:imgUrl placeholder:placeholder options:[UIImageView LJ_defaultImgSetOptions] size:self.size completed:nil];
}

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder completed:(void(^)(UIImage *image))completed {
    [self setImgUrl:imgUrl placeholder:placeholder options:[UIImageView LJ_defaultImgSetOptions] size:self.size completed:completed];
}

- (void)setImgUrl:(NSString *)imgUrl options:(LJImageOptions)options completed:(void(^)(UIImage *image))completed {
    [self setImgUrl:imgUrl placeholder:nil options:options size:self.size completed:completed];
}

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder size:(CGSize)size {
    [self setImgUrl:imgUrl placeholder:placeholder options:[UIImageView LJ_defaultImgSetOptions] size:size completed:nil];
}

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage *)placeholder options:(LJImageOptions)options {
    [self setImgUrl:imgUrl placeholder:placeholder options:options size:self.size completed:nil];
}

- (void)setImgUrl:(NSString *)imgUrl
      placeholder:(UIImage *)placeholder
          options:(LJImageOptions)options
             size:(CGSize)size
         completed:(void(^)(UIImage *image))completed {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        NSLog(@"Img view size is zero.");
    }
    
    // 根据视图小大，重写图片URL
    ImageQuality imageQuality = kImageQuality200;
    if (options & LJImageSizeOptimize) {
        imageQuality = [UIImageView imageQualityForSize:size];
    }
    imgUrl = [self.class rewriteImgUrl:imgUrl withQuality:imageQuality];
    
    // 判断设置的URL是否相同
    NSString *imgUrlSetOrSetting = [self sd_imageURL].absoluteString; // 正在设置或已经设置完成的图片URL
    BOOL isSameUrl = [UIImageView isSameImageUrl:imgUrlSetOrSetting withUrl:imgUrl];

    // 如果为相同的URL，且当前已经设置该URL图片或正在设置，则不做重复设置，直接返回
    if (isSameUrl && self.lj_imgSetStatus != kLJImageStatusUnsetOrFailed) {
        return;
    }
    // 设置新的图片前，清除原先数据
    self.lj_retryCount = 0;
    [self restoreContentMode];
    
    // 是否需要使用默认占位图
    if (!placeholder && (options & LJImageUseDefaultPlaceholder)) {
        CGFloat largePlaceholderThreshold = 200;
        if (size.height > largePlaceholderThreshold && size.width > largePlaceholderThreshold) {
            placeholder = IMG(@"placeholder_big");
        }
        else {
            placeholder = IMG(@"placeholder_small");
        }
        
        [self setContentModeBeforUsePlaceholder:@(self.contentMode)];
        self.contentMode = UIViewContentModeCenter;
        self.backgroundColor = COLOR_BG_Light;
    }
    
    NSTimeInterval imageLoadBeginTime = [[NSDate date] timeIntervalSince1970];
    
    // 开始设置图片
    [self doSettingImgWithUrl:imgUrl placeholder:placeholder imageQuality:imageQuality LJOptions:options completed:completed beginTime:imageLoadBeginTime];
}

- (void)doSettingImgWithUrl:(NSString *)imgUrl
                placeholder:(UIImage *)placeholder
               imageQuality:(ImageQuality)imageQuality
                  LJOptions:(LJImageOptions)LJOptions
                   completed:(void(^)(UIImage *image))completed
                  beginTime:(NSTimeInterval)beginTime {
    self.lj_imgSetStatus = kLJImageStatusSettingOrCleaning;
    
    SDWebImageOptions options = (SDWebImageAvoidAutoSetImage | SDWebImageRetryFailed);
    if (LJOptions & LJImageDelayPlaceholder) { // 如果占位符为空，则不改变当前视图的image
        options |= SDWebImageDelayPlaceholder;
    }
    
    WeakSelf()
    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (weakSelf) {
            if (image) {
                
                /**
                 *  图片加载时间
                 */
                NSTimeInterval imgLoadtime = [[NSDate date] timeIntervalSince1970] - beginTime;
                static char __imageCacheType[3][10] = {"network", "disk", "memory"};
                static char __imageQuality[5][10] = {"original", "high", "normal", "low", "verylow"};
                NSLog(@"Image %p load duration(%.2f) source(%s) quality(%s) for %@",
                      self,
                      imgLoadtime * 1000,
                      __imageCacheType[MIN(cacheType, 2)],
                      __imageQuality[MIN(imageQuality, kImageQuality200)],
                      imgUrl);
                
                // 记录图片加载时长, 埋点：网络加载高清图片的时长
                if (imageQuality == kImageQuality1200 && cacheType == SDImageCacheTypeNone) {
//                    [MobClick event:@"loadtime_high_quality_image" attributes:nil counter:(imgLoadtime * 1000)];
                }
                
                [weakSelf restoreContentMode];
                
                if (LJOptions & LJImageUseGaussianBlur) {
                    image = [UIImage boxblurImage:image withBlurNumber:10.0];
                }
                
                BOOL shouldAnimation = NO;
                if (LJOptions & LJImageForceAnimation) {
                    shouldAnimation = YES;
                }
                else {
                    if (cacheType != SDImageCacheTypeMemory
                        && (LJOptions & LJImageAnimationIfNeed)) {
                        shouldAnimation = YES;
                    }
                }
                
                if (shouldAnimation) {
                    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        weakSelf.image = image;
                    } completion:nil];
                }
                else {
                    weakSelf.image = image;
                }
                
                weakSelf.lj_retryCount = 0;
                weakSelf.lj_imgSetStatus = kLJImageStatusFinished;
                
                if (completed) {
                    completed(image);
                }
            }
            else {
                if (imgUrl.length > 0) {
                    // 重试
                    if (weakSelf.lj_retryCount < weakSelf.lj_retryCount) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([weakSelf retryDelayIntervalInSec] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if (weakSelf) {
                                if ([weakSelf.sd_imageURL.absoluteString isEqualToString:imgUrl]) {
                                    NSLog(@"Retry loading image for %@, retry count = %@", imgUrl, @(weakSelf.lj_retryCount));
                                    [weakSelf doSettingImgWithUrl:imgUrl placeholder:placeholder imageQuality:imageQuality LJOptions:LJOptions completed:completed beginTime:beginTime];
                                }
                                else {
                                    // sd_imageURL值已经被修改，说明有新图片被设置，不需要重试
                                }
                            }
                        });
                        weakSelf.lj_retryCount++;
                    }
                    else {
                        weakSelf.lj_imgSetStatus = kLJImageStatusUnsetOrFailed;
                        
                        if (completed) {
                            completed(image);
                        }
                        
                        // 图片加载失败埋点
//                        LogError(@"Image load failed for %@, errorcode = %@, desc = %@", imgUrl, @(error.code), error.localizedDescription);
//                        NSDictionary *eventArgs = @{@"path" : NotNilStr(imgUrl),
//                                                    @"net" : NotNilStr([LJReachability sharedInstance].connectionStatusDesc),
//                                                    @"errorcode" : [NSString stringWithFormat:@"%@", @(error.code)]};
//                        [MobClick event:@"img_download_failure" attributes:eventArgs];
                    }
                }
                else {
                    weakSelf.image = placeholder;
                    weakSelf.lj_imgSetStatus = kLJImageStatusFinished;
                    
                    if (completed) {
                        completed(image);
                    }
                }
            }
        }
    }];
}

- (NSTimeInterval)retryDelayIntervalInSec {
    static NSTimeInterval __delayTimes[3] = {1, 8, 15};
    return (self.lj_retryCount < 3) ? __delayTimes[self.lj_retryCount] : 30;
}

#pragma mark - 自定义视图

+ (UIImageView *)loadingImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSInteger idx = 0; idx < 45; ++idx) {
        [images safeAddObject:[UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)(idx + 1)]]];
    }
    
    imgView.animationImages = images;
    
    return imgView;
}

+ (UIImageView *)loadingImgViewWithAnimationStarted {
    UIImageView *imgView = [self loadingImgView];
    [imgView startAnimating];
    return imgView;
}

+ (UIImageView *)radioOnImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imgView.image = IMG(@"radio on");
    return imgView;
}

+ (UIImageView *)radioOffImgView {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imgView.image = IMG(@"radio off");
    return imgView;
}

+ (UIImageView *)imgViewWithGifName:(NSString *)gifName size:(CGSize)size {
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [mainBundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.gif", gifName]];
    
    UIImage *image = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:filePath]];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    return imageView;
}

+ (UIImageView *)imgViewWithName:(NSString *)imgName {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgView.image = IMG(imgName);
    imgView.size = imgView.image.size;
    return imgView;
}

+ (UIImageView *)resizableWithName:(NSString *)imgName {
    UIImage *image = [UIImage imageNamed:imgName];
    CGFloat topPad = image.size.height/2 - 1;
    CGFloat leftPad = image.size.width/2 - 1;
    UIImage *scanImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(topPad, leftPad, topPad, leftPad)];
    UIImageView *scanView = [[UIImageView alloc]initWithImage:scanImage];
    scanView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    return scanView;
}

@end
