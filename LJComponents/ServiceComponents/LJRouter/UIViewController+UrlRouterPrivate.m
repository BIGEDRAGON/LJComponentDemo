//
//  UIViewController+UrlRouterPrivate.m
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import "UIViewController+UrlRouterPrivate.h"
#import <objc/runtime.h>

@implementation UIViewController (UrlRouterPrivate)

static int kVCPageName;
- (NSString *)vcPageName {
    return objc_getAssociatedObject(self, &kVCPageName);
}

- (void)setVcPageName:(NSString *)vcPageName {
    objc_setAssociatedObject(self, &kVCPageName, vcPageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static int kUrlParams;
- (NSDictionary *)urlParams {
    NSDictionary *params = objc_getAssociatedObject(self, &kUrlParams);
    return params ?: @{};
}

- (void)setUrlParams:(NSDictionary *)urlParams {
    objc_setAssociatedObject(self, &kUrlParams, urlParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static int kFromPage;
- (NSString *)fromPage {
    return objc_getAssociatedObject(self, &kFromPage);
}

- (void)setFromPage:(NSString *)fromPage {
    objc_setAssociatedObject(self, &kFromPage, fromPage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static int kUrlCallback;
- (UrlPopedCallback)urlCallback {
    return objc_getAssociatedObject(self, &kUrlCallback);
}

- (void)setUrlCallback:(UrlPopedCallback)urlCallback {
    objc_setAssociatedObject(self, &kUrlCallback, urlCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

static int kH5Url;
- (NSString *)h5Url {
    return objc_getAssociatedObject(self, &kH5Url);
}

- (void)setH5Url:(NSString *)h5Url {
    if (h5Url && ![h5Url isKindOfClass:[NSString class]]) {
        if ([h5Url isKindOfClass:[NSURL class]]) {
            h5Url = [((NSURL *)h5Url) absoluteString];
        }
        else {
            return;
        }
    }
    
    objc_setAssociatedObject(self, &kH5Url, h5Url, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)parseInputParams {
    if (self.urlParams) {
        [self.urlParams enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id obj, BOOL *stop) {
            [self setValue:obj forKeyPath:propertyName];
        }];
    }
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
}


+ (UIViewController *)topVC {
    UIViewController *resultVC;
    resultVC = [self subTopViewController:[[UIApplication sharedApplication].windows.firstObject rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self subTopViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)subTopViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self subTopViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self subTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
