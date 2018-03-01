//
//  LJRouterHandler.m
//  LJRouter
//
//  Created by longlj on 2017/11/20.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import "LJRouterHandler.h"
#import "LJBaseTabBarController.h"
#import "LJNavigationController.h"
//#import "QQFHybirdWebVC.h"

#define URL_ROUTER_LOCAL_SCHEME @"longlj"
#define URL_ROUTER_LOCAL_HOST   @"www.longlj.com"

NSString * const kUrlRouter_viewComponent    = @"viewComponent";
NSString * const kUrlRouter_serviceComponent = @"serviceComponent";
NSString * const kUrlRouter_study            = @"study";

@implementation LJRouterHandler

+ (UIWindow *)setUpUrlRouterInAppDel {
    [self setup];
    
    UrlRouterConfig *config = [UrlRouterConfig new];
    config.navigationControllerClass = LJNavigationController.class;
    config.tabBarControllerClass = LJBaseTabBarController.class;
    config.webContainerClass = UIViewController.class;
    config.nativeUrlScheme = URL_ROUTER_LOCAL_SCHEME;
    config.nativeUrlHostName = URL_ROUTER_LOCAL_HOST;
    
    UIWindow *window = KEYWINDOW ? : [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelNormal;
    window.rootViewController = [[UrlRouter sharedInstance] startupWithConfig:config andInitialPages:@[kUrlRouter_viewComponent, kUrlRouter_serviceComponent, kUrlRouter_study]];
    return window;
}

+ (void)setup {
    NSTimeInterval t1 = [[NSDate date] timeIntervalSince1970];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"router" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *root = [[NSArray alloc] initWithContentsOfFile:path];
        if (root && [root isKindOfClass:[NSArray class]]) {
            [root enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull module, NSUInteger idx, BOOL * _Nonnull stop) {
                [self loadConfigAndRegWithFileName:module[@"moduleName"] isPage:[module[@"isPage"] boolValue]];
            }];
        }
    }
    
    NSTimeInterval duration = [[NSDate date] timeIntervalSince1970] - t1;
    NSLog(@"Pages configuration load time = %.2fms", duration * 1000);
}

+ (void)loadConfigAndRegWithFileName:(NSString *)fileName isPage:(BOOL)isPage {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:path];
        if (root && [root isKindOfClass:[NSDictionary class]]) {
            [root enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSDictionary *config, BOOL * _Nonnull stop) {
                [self registerRouter:name withConfig:config isPage:isPage];
            }];
        }
    }
}

+ (void)registerRouter:(NSString *)name
            withConfig:(NSDictionary *)config
                isPage:(BOOL)isPage{
    if (name && [name isKindOfClass:[NSString class]]
        && config && [config isKindOfClass:[NSDictionary class]]) {
        NSString *className = config[@"class_name"];
        if (className && [className isKindOfClass:[NSString class]]) {
            if ([className hasPrefix:@"#"]) {
                className = [className substringFromIndex:1];
            }
            if (isPage) {
                NSNumber *isUrlExported = config[@"is_url_exported"];
                [[UrlRouter sharedInstance] registerPage:name forVcClass:NSClassFromString(className) isUrlExported:(isUrlExported ? [isUrlExported boolValue] : NO)];
            }else {
                [[ServiceRouter sharedInstance] registerService:name forServieceClass:NSClassFromString(className)];
            }
        }
    }
}

@end
