//
//  UIImage+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/14.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIImage+LJAdd.h"
#import <Accelerate/Accelerate.h>
#import "UIScreen+LJAdd.h"

@implementation UIImage (LJAdd)

+ (UIImage *)gaussianBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

+ (UIImage *)imageFromColor:(UIColor *)color{
    return [self imageFromColor:color withWH:3.0];
}

+ (UIImage *)imageFromColor:(UIColor *)color withWH:(CGFloat)widthAndHeight {
    return [self imageFromColor:color withSize:CGSizeMake(widthAndHeight, widthAndHeight)];
}

+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (UIImage *) reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

- (UIImage *)reSizeToMaxSize:(CGFloat)maxSize {
    CGSize size = self.size;
    if (self.size.width > self.size.height) {
        if (self.size.width > maxSize) {
            size.width = maxSize;
            size.height = maxSize * self.size.height / self.size.width;
            return [UIImage reSizeImage:self toSize:size];
        }
    }
    else {
        if (size.height > maxSize) {
            size.height = maxSize;
            size.width = maxSize * self.size.width / self.size.height;
            return [UIImage reSizeImage:self toSize:size];
        }
    }
    
    return self;
}

+ (UIImage *)getTheLaunchImage
{
    NSString *defaultImageName = @"LaunchImage";
    NSInteger osVersion = floor([[[UIDevice currentDevice] systemVersion] floatValue])*100;
    
    NSInteger screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    // 3.5inch
    if (screenHeight < 568) {
        
        if (osVersion >= 700) {
            defaultImageName = [NSString stringWithFormat:@"%@-700",defaultImageName];
        } else {
            defaultImageName = [NSString stringWithFormat:@"%@",defaultImageName];
        }
        
    }
    // 4.0inch
    else if(screenHeight < 667){
        
        if (osVersion >= 700) {
            defaultImageName = [NSString stringWithFormat:@"%@-700-568h",defaultImageName];
        } else {
            defaultImageName = [NSString stringWithFormat:@"%@-568h",defaultImageName];
        }
    }
    // 4,7inch
    else if (screenHeight < 736) {
        
        defaultImageName = [NSString stringWithFormat:@"%@-800-667h",defaultImageName];
        
    }
    // 5.5inch
    else{
        NSString *orientation = @"";
        switch ([[UIApplication sharedApplication] statusBarOrientation]) {
            case UIInterfaceOrientationUnknown:
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                orientation = @"Portrait";
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                orientation = @"Landscape";
                break;
            default:
                break;
        }
        defaultImageName = [NSString stringWithFormat:@"%@-800-%@-736h",defaultImageName,orientation];
    }
    return [UIImage imageNamed:defaultImageName];
}


- (CGFloat)heightOfFullScreenImage {
    return ceil([[UIScreen mainScreen]bounds].size.width * self.size.height / self.size.width);
}

+ (NSValue *)defaultImageSizeParsedFromUrl:(NSString *)imgUrl {
    if (imgUrl.length > 0) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"_[0-9]+x[0-9]+_" options:NSRegularExpressionCaseInsensitive error:nil];
        
        NSArray * matches = [regex matchesInString:imgUrl options:0 range:NSMakeRange(0, imgUrl.length)];
        
        if (matches && matches.count > 0) {
            NSTextCheckingResult *lastMatch = matches.lastObject;
            NSString *matchString = [imgUrl substringWithRange:NSMakeRange(lastMatch.range.location + 1, lastMatch.range.length - 2)];
            NSArray *numbers = [matchString componentsSeparatedByString:@"x"];
            if (numbers && numbers.count == 2) {
                return [NSValue valueWithCGSize:CGSizeMake([numbers[0] floatValue], [numbers[1] floatValue])];
            }
        }
    }
    
    return nil;
}

+ (CGFloat)heightFromUrl:(NSString *)imgUrl defaultHeight:(CGFloat)defaultHeight {
    return [self heightFromUrl:imgUrl defaultHeight:defaultHeight width:LJ_SCREEN_WIDTH];
}

+ (CGFloat)heightFromUrl:(NSString *)imgUrl defaultHeight:(CGFloat)defaultHeight width:(CGFloat)width {
    CGFloat imageHeight = defaultHeight;
    NSValue *value = [self defaultImageSizeParsedFromUrl:imgUrl];
    if (value) {
        CGSize size = value.CGSizeValue;
        if (size.width > 0 && size.height > 0) {
            imageHeight = ceil(width * size.height / size.width);
        }
        else {
            imageHeight = defaultHeight;
        }
    }
    return imageHeight;
}

@end
