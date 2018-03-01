//
//  UrlRouter.m
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import "UrlRouter.h"
#import "NSURL+UrlRouter.h"
#import "NSString+UrlRouter.h"
#import <objc/runtime.h>
#import "UIViewController+UrlRouterPrivate.h"
#import "NSObject+RouterPrivate.h"

@interface UrlRouter ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UrlRouterConfig *config;

@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) UIViewController *webViewController;

/**
 Supported schemes, 包括自定义的 native scheme，如@"qiqiao"
 */
@property (nonatomic, strong) NSMutableArray *supportedSchemes;

/**
 所有的 native page
 */
@property (nonatomic, strong) NSMutableDictionary *nativePages;

/**
 所有能被url打开的 native page
 */
@property (nonatomic, strong) NSMutableArray *urlExportedNativePages;

@end

@implementation UrlRouter

+ (instancetype)sharedInstance {
    static UrlRouter *__sharedInstance;
    static dispatch_once_t __once;
    dispatch_once(&__once, ^{
        __sharedInstance = [[UrlRouter alloc] init];
    });
    return __sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.supportedSchemes = [[NSMutableArray alloc] init];
        self.nativePages = [[NSMutableDictionary alloc] init];
        self.urlExportedNativePages = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Utils

- (Class)classForPageName:(NSString *)pageName {
    if (pageName.length > 0) {
        NSString *pageClassName = self.nativePages[pageName];
        if (pageClassName.length > 0) {
            Class pageClass = NSClassFromString(pageClassName);
            return pageClass;
        }
    }
    return nil;
}

- (NSString *)localPageNameFromUrl:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    /*
     eg: 1.qiqiao://www.qiqiao.com/product/productDetail
         2.qiqiao://product/productDetail
         get: /product/productDetail
     */
    NSString *pageName;
    if (self.config.nativeUrlHostName.length > 0) {
        if (![url.host isEqualToString:self.config.nativeUrlHostName]) {
            return nil;
        }
        pageName = url.path;
    }else {
        pageName = [url.host stringByAppendingString:url.path];
    }
    
    if ([pageName hasPrefix:@"/"]) {
        pageName = [pageName substringFromIndex:1];
    }
    
    if (pageName.length == 0) {
        return nil;
    }
    
    return pageName;
}

- (BOOL)checkValidOfPageName:(NSString *)pageName className:(NSString *)className {
    if (pageName.length == 0 || className.length == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Setup

- (void)registerPage:(NSString *)pageName forVcClass:(Class)clazz isUrlExported:(BOOL)isUrlExported {
    NSString *className = NSStringFromClass(clazz);
    if ([self checkValidOfPageName:pageName className:className]) {
        self.nativePages[pageName] = className;
        if (isUrlExported) {
            [self.urlExportedNativePages addObject:pageName];
        }
    }
}

- (UIViewController *)startupWithConfig:(UrlRouterConfig *)config andInitialPages:(NSArray *)pageNames {
    [self.supportedSchemes removeAllObjects];
    
    if (config.webContainerClass) {
        [self.supportedSchemes addObject:@"file"];
        [self.supportedSchemes addObject:@"http"];
        [self.supportedSchemes addObject:@"https"];
    }
    
    if (config.nativeUrlScheme.length > 0) {
        [self.supportedSchemes addObject:config.nativeUrlScheme];
    }
    
    self.config = config;
    
    return [self startupWithInitialPages:pageNames];
}

- (UIViewController *)startupWithInitialPages:(NSArray *)pageNames {
#if defined(DEBUG) && DEBUG
    NSLog(@"Registered %@ pages total.", @(self.nativePages.count));
    [self.nativePages enumerateKeysAndObjectsUsingBlock:^(NSString *pageName, NSString *className, BOOL * _Nonnull stop) {
        NSLog(@"Page(%@) registered with class [%@].", pageName, className);
    }];
#endif
    
    if (!pageNames) {
        return nil;
    }
    
//    if (self.config.navigationControllerClass && self.config.tabBarControllerClass) {
//        self.tabBarController = [[self.config.tabBarControllerClass alloc] init];
////        self.tabBarController.delegate = self;
//
//        NSMutableArray *contentVCs = [[NSMutableArray alloc] init];
//        if (pageNames.count > 0) {
//            [pageNames enumerateObjectsUsingBlock:^(NSString *pageName, NSUInteger idx, BOOL * _Nonnull stop) {
//                Class pageClass = ClassForPageName(pageName);
//                if (pageClass) {
//                    UIViewController *vc = [[pageClass alloc] init];
//                    vc.vcPageName = pageName;
//                    UINavigationController *navi = [[self.config.navigationControllerClass alloc] initWithRootViewController:vc];
//                    [contentVCs addObject:navi];
//                }
//            }];
//        }
//        self.tabBarController.viewControllers = contentVCs;
//
//        return self.tabBarController;
//    }
    
    if (self.config.mode == UrlRouterContainerModeOnlyNavigation) {
        Class initialPageClass = nil;
        NSString *pageName = nil;
        if (pageNames.count > 0) {
            pageName = pageNames.firstObject;
            initialPageClass = ClassForPageName(pageName);
        }
        
        if (self.config.navigationControllerClass && initialPageClass) {
            UIViewController *contentVC = [[initialPageClass alloc] init];
            contentVC.vcPageName = pageName;
            self.navigationController = [[self.config.navigationControllerClass alloc] initWithRootViewController:contentVC];
            return self.navigationController;
        }
    } else if (self.config.mode == UrlRouterContainerModeNavigationAndTabBar) {
        
        if (self.config.navigationControllerClass && self.config.tabBarControllerClass) {
            self.tabBarController = [[self.config.tabBarControllerClass alloc] init];
            
            NSMutableArray *contentVCs = [[NSMutableArray alloc] init];
            if (pageNames.count > 0) {
                [pageNames enumerateObjectsUsingBlock:^(NSString *pageName, NSUInteger idx, BOOL * _Nonnull stop) {
                    Class pageClass = ClassForPageName(pageName);
                    if (pageClass) {
                        UIViewController *vc = [[pageClass alloc] init];
                        vc.vcPageName = pageName;
                        [contentVCs addObject:vc];
                    }
                }];
            }
            self.tabBarController.viewControllers = contentVCs;
            self.navigationController = [[self.config.navigationControllerClass alloc] initWithRootViewController:self.tabBarController];
            
            return self.navigationController;
        }
    }
    
    return nil;
}

#pragma mark - Others

- (BOOL)isPageExists:(NSString *)pageName {
    if (pageName.length == 0) {
        return NO;
    }
    
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc.vcPageName isEqualToString:pageName]) {
//            return YES;
//        }
//    }
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc.vcPageName isEqualToString:pageName]) {
            return YES;
        }
    }
    
    for (UIViewController *vc in self.tabBarController.viewControllers) {
        if ([vc.vcPageName isEqualToString:pageName]) {
            return YES;
        }
    }
    
    return NO;
}

- (UIViewController *)viewControllerMatchedWithPageName:(NSString *)pageName {
    if (pageName.length == 0) {
        return nil;
    }
    
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc.vcPageName isEqualToString:pageName]) {
//            return vc;
//        }
//    }

    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc.vcPageName isEqualToString:pageName]) {
            return vc;
        }
    }
    
    for (UIViewController *vc in self.tabBarController.viewControllers) {
        if ([vc.vcPageName isEqualToString:pageName]) {
            return vc;
        }
    }
    
    return nil;
}

//#define TopViewController ([UIViewController topVC])
//
//- (NSString *)topPageName {
//    return TopViewController.vcPageName;
//}
- (NSString *)topPageName {
    if ([self.navigationController.topViewController isEqual:self.tabBarController]) {
        return self.tabBarController.selectedViewController.vcPageName;
    } else {
        return self.navigationController.topViewController.vcPageName;
    }
}

- (BOOL)isViewControllerAtTop:(UIViewController *)viewController {
//    return [TopViewController isEqual:viewController];
    if ([self.navigationController.topViewController isEqual:self.tabBarController]) {
        return [self.tabBarController.selectedViewController isEqual:viewController];
    } else {
        return [self.navigationController.topViewController isEqual:viewController];
    }
}

//- (UINavigationController *)navigationController {
//    return TopViewController.navigationController;
//}

#pragma mark - execute native page method by name

+ (void)executeMethodWithPage:(NSString *)pageName initSelParams:(NSArray *)selParams withSelName:(NSString *)selName withParams:(NSArray *)params successed:(void (^)(id _Nonnull))successed failed:(void (^)(NSError * _Nonnull))failed {
    NSString *failMsg = [NSString stringWithFormat:@"[pageName(%@);selName(%@)]", pageName, selName];
    Class cls = ClassForPageName(pageName);
    if (!cls) {
        [self notifyRouterNotFoundFailed:failed
                           withFailedMsg:failMsg];
        return;
    };
    
    UIViewController *vc = nil;
    if ([cls respondsToSelector:@selector(initWithParams:)]) {
        vc = [cls initWithParams:selParams];
    }else {
        vc = [[cls alloc] init];
    }
    if (!vc) {
        [self notifyRouterNotFoundFailed:failed
                           withFailedMsg:failMsg];
        return;
    }
    
    if ([cls respondsToSelector:@selector(SELNameArray)]) {
        NSArray *selNames = [cls SELNameArray];
        
        if (selNames.count && [selNames containsObject:selName]) {
            SEL sel = NSSelectorFromString(selName);
            id returnValue = [cls performSelector:sel withParams:params];
            [self notifyRouterSuccessed:successed
                              withValue:returnValue];
            return;
        }
    }
    
    [self notifyRouterSelectorNotFoundFailed:failed
                               withFailedMsg:failMsg];
}

+ (void)executeMethodWithPage:(NSString *)pageName withSelName:(NSString *)selName withParams:(NSArray *)params successed:(void (^)(id _Nonnull))successed failed:(void (^)(NSError * _Nonnull))failed {
    [self executeMethodWithPage:pageName initSelParams:nil withSelName:selName withParams:params successed:successed failed:failed];
}

+ (void)executeMethodWithPage:(NSString *)pageName withSelName:(NSString *)selName withParams:(NSArray *)params {
    [self executeMethodWithPage:pageName withSelName:selName withParams:params successed:^(id  _Nonnull returnValue) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - Open native pages by name

- (void)configVCBeforePush:(UIViewController *)vc params:(NSDictionary *)params callback:(UrlPopedCallback)callback {
    vc.urlCallback = callback;
    vc.urlParams = params;
    [vc parseInputParams];
    vc.fromPage = [self topPageName];
}

- (BOOL)openPage:(NSString *)pageName initSelParams:(NSArray *)selParams withParams:(NSDictionary *)params callback:(UrlPopedCallback)callback animated:(BOOL)animated {
    
    Class cls = ClassForPageName(pageName);
    if (!cls) return NO;
    
    if ([cls isSingletonPage]) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc.vcPageName isEqualToString:pageName]) {
                [self configVCBeforePush:vc params:params callback:callback];
                [self popToViewController:vc animated:animated];
                return YES;
            }
        }
    }
    
    
    // push 别的 navi rootViewController
    if (self.tabBarController) {
        __block BOOL isContainedInTabBarController = NO;
        __block NSInteger index = 0;
        [self.tabBarController.viewControllers enumerateObjectsUsingBlock:^(__kindof UINavigationController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = obj.viewControllers.firstObject;
            if ([vc.vcPageName isEqualToString:pageName]) {
                isContainedInTabBarController = YES;
                index = idx;
                *stop = YES;
            }
        }];
        
        if (isContainedInTabBarController) {
            UINavigationController *beforeNavi = self.navigationController;
            self.tabBarController.selectedIndex = index;
            NSArray *popedVCs = [beforeNavi popToRootViewControllerAnimated:animated];
            for (UIViewController *vc in popedVCs) {
                [UrlRouter invokePopedCallback:vc.urlCallback withResult:nil shouldDelay:animated];
            }
            return YES;
        }
    }
    
    // push new page
    UIViewController *vc = nil;
    if ([cls respondsToSelector:@selector(initWithParams:)]) {
        vc = [cls initWithParams:selParams];
    }else {
        vc = [[cls alloc] init];
    }
    vc.vcPageName = pageName;
    [self configVCBeforePush:vc params:params callback:callback];
    [self.navigationController pushViewController:vc animated:animated];
    
    return YES;
}

- (BOOL)openPage:(NSString *)pageName withParams:(NSDictionary *)params callback:(UrlPopedCallback)callback animated:(BOOL)animated {
    return [self openPage:pageName initSelParams:nil withParams:params callback:callback animated:animated];;
}

- (void)openPage:(NSString *)pageName {
    [self openPage:pageName withParams:nil callback:nil animated:YES];
}

- (void)openPage:(NSString *)pageName withParams:(NSDictionary *)params {
    [self openPage:pageName withParams:params callback:nil animated:YES];
}

- (void)openPage:(NSString *)pageName withParams:(NSDictionary *)params animated:(BOOL)animated {
    [self openPage:pageName withParams:params callback:nil animated:animated];
}

+ (void)openPage:(NSString *)pageName {
    [[UrlRouter sharedInstance] openPage:pageName withParams:nil callback:nil animated:YES];
}

+ (void)openPage:(NSString *)pageName withParams:(NSDictionary *__nullable)params {
    [[UrlRouter sharedInstance] openPage:pageName withParams:params callback:nil animated:YES];
}

+ (void)openPage:(NSString *)pageName withParams:(NSDictionary *__nullable)params animated:(BOOL)animated {
    [[UrlRouter sharedInstance] openPage:pageName withParams:params callback:nil animated:animated];
}

+ (void)openPage:(NSString *)pageName withParams:(NSDictionary *__nullable)params withCallback:(UrlPopedCallback __nullable)callback animated:(BOOL)animated{
    [[UrlRouter sharedInstance] openPage:pageName withParams:params callback:callback animated:animated];
}

#pragma mark - Open pages by url

- (BOOL)canOpenUrl:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([self.supportedSchemes containsObject:url.scheme]) {
        if ([url.scheme isEqualToString:self.config.nativeUrlScheme]) {
            // local url
            NSString *pageName = [self localPageNameFromUrl:url];
            return pageName && [self.urlExportedNativePages containsObject:pageName];
        } else {
            // http/https url
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)_openLocalUrl:(NSURL *)url
           withParams:(NSDictionary *)params
             animated:(BOOL)animated
         withCallback:(UrlPopedCallback)callback {
    NSString *pageName = [self localPageNameFromUrl:url];
    if (![self.urlExportedNativePages containsObject:pageName]) {
        return NO;
    }
    
    // URL Params
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    NSDictionary *queryParams = [url urlRouter_params];
    if (queryParams) {
        [allParams addEntriesFromDictionary:queryParams];
    }
    
    if (params) {
        [allParams addEntriesFromDictionary:params];
    }
    
    return [self openPage:pageName withParams:allParams callback:callback animated:animated];
}

- (BOOL)_openH5Url:(NSURL *)url withParams:(NSDictionary *)params animated:(BOOL)animated withCallback:(UrlPopedCallback)callback {
    Class webCls = self.config.webContainerClass;
    if (webCls) {
        self.webViewController = [[webCls alloc] init];
        self.webViewController.vcPageName = [[url absoluteString] urlRouter_toBaseUrl];
        self.webViewController.h5Url = [url absoluteString];
        [self configVCBeforePush:self.webViewController params:params callback:callback];
        
        [self.navigationController pushViewController:self.webViewController animated:animated];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)_openPageWithUrl:(NSString *)urlStr params:(NSDictionary *__nullable)params callback:(UrlPopedCallback __nullable)callback animated:(BOOL)animated {
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([self.supportedSchemes containsObject:url.scheme]) {
        if ([url.scheme isEqualToString:self.config.nativeUrlScheme]) {
            return [self _openLocalUrl:url withParams:params animated:animated withCallback:callback];
        } else {
            return [self _openH5Url:url withParams:params animated:animated withCallback:callback];
        }
    }
    
    return NO;
}

- (BOOL)openPageWithUrl:(NSString *)urlStr {
    return [self _openPageWithUrl:urlStr params:nil callback:nil animated:YES];
}

- (BOOL)openPageWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params {
    return [self _openPageWithUrl:urlStr params:params callback:nil animated:YES];
}

- (BOOL)openPageWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params animated:(BOOL)animated {
    return [self _openPageWithUrl:urlStr params:params callback:nil animated:animated];
}

- (BOOL)openPageWithUrl:(NSString *)urlStr withParams:(NSDictionary *__nullable)params callback:(UrlPopedCallback __nullable)callback animated:(BOOL)animated {
    return [self _openPageWithUrl:urlStr params:params callback:callback animated:animated];
}

#pragma mark - Close

+ (void)invokePopedCallback:(UrlPopedCallback)callback withResult:(NSDictionary *)result shouldDelay:(BOOL)shouldDelay {
    if (callback) {
        if (shouldDelay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                callback(result);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(result);
            });
        }
    }
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController) {
//        if ([viewController isEqual:TopViewController]) {
//            return;
//        }
        if ([viewController isEqual:self.navigationController.topViewController]) {
            return;
        }
        
        NSArray *popedVCs = [self.navigationController popToViewController:viewController animated:animated];
        for (UIViewController *vc in popedVCs) {
            [UrlRouter invokePopedCallback:vc.urlCallback withResult:nil shouldDelay:animated];
        }
    }
}

- (void)closePageWithResult:(NSDictionary *)result animated:(BOOL)animated {
    UIViewController *vc = [self.navigationController popViewControllerAnimated:animated];
    [UrlRouter invokePopedCallback:vc.urlCallback withResult:result shouldDelay:animated];
}

+ (void)closePageWithResult:(NSDictionary *__nullable)result animated:(BOOL)animated {
    [[UrlRouter sharedInstance] closePageWithResult:result animated:animated];
}

+ (void)closePage {
    [[UrlRouter sharedInstance] closePageWithResult:nil animated:YES];
}

+ (void)closePageWithResult:(NSDictionary *)result {
    [[UrlRouter sharedInstance] closePageWithResult:result animated:YES];
}

- (void)closeSelfAndOtherPages:(NSArray<NSString *> *)otherPages {
    if (otherPages && otherPages.count > 0) {
        UINavigationController *navController = self.navigationController;
        
        // 检查下导航栈中是否有需要被移除的VC
        NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:navController.viewControllers];
        for (NSInteger index = vcs.count - 2; index >= 0; --index) {
            UIViewController *vc = vcs[index];
            
            if ([otherPages containsObject:vc.vcPageName]) {
                [vcs removeObjectAtIndex:index];
            }
        }
        if (vcs.count != navController.viewControllers.count) {
            [navController setViewControllers:vcs];
        }
    }
    
    [UrlRouter closePage];
}

+ (void)closeToPage:(NSString *)pageName {
    UIViewController *viewController = [[UrlRouter sharedInstance] viewControllerMatchedWithPageName:pageName];
    [[UrlRouter sharedInstance] popToViewController:viewController animated:YES];
}

@end
