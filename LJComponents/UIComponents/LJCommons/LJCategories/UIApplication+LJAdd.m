//
//  UIApplication+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/9/9.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "UIApplication+LJAdd.h"
#import "UIDevice+LJAdd.h"
#import "NSObject+LJAdd.h"

@implementation UIApplication (LJAdd)

+ (nullable UIViewController *)getRootViewController {
    return [[LJApplication keyWindow] rootViewController];
}

+ (nullable UIViewController *)getTopViewController {
    UINavigationController *nav = (UINavigationController *)[self getRootViewController];
    if (![nav isKindOfClass:[UINavigationController class]]) {
        return nav;
    }
    
    return nav.topViewController;
}

+ (void)openSettings {
        [LJApplication openURLWithString:UIApplicationOpenSettingsURLString options:nil completionHandler:nil];
}

- (void)openURLWithString:(NSString * __nonnull )string options:(NSDictionary<NSString *,id> * __nullable)options completionHandler:(void (^__nullable)(BOOL success))completion {
    
    NSURL *url = [NSURL URLWithString:string];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        if ([UIDevice isVersionLargeOrEqualThan:10.0f]) {
            NSDictionary *params = @{};
            if (options && [options isKindOfClass:[NSDictionary class]]) {
                params = options;
            }
            [self openURL:url options:params completionHandler:completion];
            
        } else {
            
            BOOL open = [self openURL:url];
            if (completion) {
                completion(open);
            }
        }
        
    }else {
        if (completion) {
            completion(NO);
        }
    }
}

- (void)openURLWithString:(NSString * __nonnull )string {
    
    [self openURLWithString:string options:nil completionHandler:nil];
}

@end
