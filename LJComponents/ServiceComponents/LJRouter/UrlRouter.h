//
//  UrlRouter.h
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlRouterConfig.h"
#import "UIViewController+UrlRouter.h"

NS_ASSUME_NONNULL_BEGIN

/**
 UrlRouter通过对应的pageName或url方式打开 native page 或者 url，
 如："home/myshare", "qiqiao://home/myshare"
 */
@interface UrlRouter : NSObject

+ (instancetype)sharedInstance;

#pragma mark - Setup

/**
 Register native page
 
 @param pageName page name
 @param clazz ViewController class
 @param isUrlExported page是否可以被url方式打开
 */
- (void)registerPage:(NSString *)pageName
          forVcClass:(Class)clazz 
       isUrlExported:(BOOL)isUrlExported;

/**
 初始化register
 
 @param config UrlRouter配置
 @param pageNames 初始化的几个tabbar的 page name
 @return window 的 rooterViewController
 */
- (UIViewController *)startupWithConfig:(UrlRouterConfig *)config
                        andInitialPages:(NSArray *)pageNames;

#pragma mark - Container instance
@property (nonatomic, strong, readonly) UINavigationController *navigationController;

@property (nonatomic, strong, readonly) UIViewController *webViewController;

#pragma mark - Others

#define ClassForPageName(pageName) ([[UrlRouter sharedInstance] classForPageName:(pageName)])
- (Class)classForPageName:(NSString *)pageName;

/**
 根据页面名称判断页面是否存在

 @param pageName page name
 @return 页面是否存在
 */
- (BOOL)isPageExists:(NSString *)pageName;

/**
 顶部页面名称
 
 @return 顶部页面名称
 */
- (NSString *)topPageName;

/**
 判断视图控制器是否在顶部
 
 @return 页面是否在顶部
 */
- (BOOL)isViewControllerAtTop:(UIViewController *)viewController;

#pragma mark - Open native pages action by name

/**
 get a returnValue by means of execute method with native page name and selName (with params).
 */
+ (void)executeMethodWithPage:(NSString *)pageName
                  withSelName:(NSString *)selName
                   withParams:(NSArray *)params;
+ (void)executeMethodWithPage:(NSString *)pageName
                  withSelName:(NSString * __nullable)selName
                   withParams:(NSArray *)params
                    successed:(void (^)(id returnValue))successed
                       failed:(void (^)(NSError *))failed;
+ (void)executeMethodWithPage:(NSString *)pageName
                initSelParams:(NSArray * __nullable)selParams
                  withSelName:(NSString *)selName
                   withParams:(NSArray *)params
                    successed:(void (^)(id returnValue))successed
                       failed:(void (^)(NSError *))failed;

#pragma mark - Open native pages by name

- (void)openPage:(NSString *)pageName;
- (void)openPage:(NSString *)pageName
      withParams:(NSDictionary *__nullable)params;
- (void)openPage:(NSString *)pageName
      withParams:(NSDictionary *__nullable)params
        animated:(BOOL)animated;
- (BOOL)openPage:(NSString *)pageName
      withParams:(NSDictionary *__nullable)params
        callback:(UrlPopedCallback __nullable)callback
        animated:(BOOL)animated;
- (BOOL)openPage:(NSString *)pageName
   initSelParams:(NSArray *__nullable)selParams
      withParams:(NSDictionary *__nullable)params
        callback:(UrlPopedCallback __nullable)callback
        animated:(BOOL)animated;
+ (void)openPage:(NSString *)pageName;
+ (void)openPage:(NSString *)pageName
      withParams:(NSDictionary *__nullable)params;
+ (void)openPage:(NSString *)pageName
      withParams:(NSDictionary *__nullable)params
        animated:(BOOL)animated;
+ (void)openPage:(NSString *)pageName
      withParams:(NSDictionary *__nullable)params
    withCallback:(UrlPopedCallback __nullable)callback
        animated:(BOOL)animated;

#pragma mark - Open pages by url

- (BOOL)canOpenUrl:(NSString *)urlStr;

- (BOOL)openPageWithUrl:(NSString *)urlStr;
- (BOOL)openPageWithUrl:(NSString *)urlStr
             withParams:(NSDictionary *__nullable)params;
- (BOOL)openPageWithUrl:(NSString *)urlStr
             withParams:(NSDictionary *__nullable)params
               animated:(BOOL)animated;
- (BOOL)openPageWithUrl:(NSString *)urlStr
             withParams:(NSDictionary *__nullable)params
               callback:(UrlPopedCallback __nullable)callback
               animated:(BOOL)animated;

#pragma mark - Close

+ (void)closePage;
+ (void)closeToPage:(NSString *)pageName;
+ (void)closePageWithResult:(NSDictionary *)result;
- (void)closePageWithResult:(NSDictionary *__nullable)result
                   animated:(BOOL)animated;
/**
 关闭当前页面以及其它页面
 */
- (void)closeSelfAndOtherPages:(NSArray<NSString *> *)otherPages;

@end

NS_ASSUME_NONNULL_END
