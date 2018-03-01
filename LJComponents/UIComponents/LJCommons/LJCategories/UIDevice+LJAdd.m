//
//  UIDevice+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/21.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIDevice+LJAdd.h"
#include <sys/utsname.h>

@implementation UIDevice (LJAdd)

+ (NSString *)deviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString*)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}

+ (BOOL)isVersionLargeOrEqualThan:(CGFloat)version {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= version);
}

+ (float)getVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

@end
