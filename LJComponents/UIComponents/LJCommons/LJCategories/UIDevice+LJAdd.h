//
//  UIDevice+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/21.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (LJAdd)

+ (NSString *)deviceId;

+ (NSString*)deviceModel;

+ (BOOL)isVersionLargeOrEqualThan:(CGFloat)version;

+ (float)getVersion;

@end
