//
//  LJNavigationController.m
//  LJNavigationController
//
//  Created by longlj on 2016/4/19.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "LJNavigationController.h"
#import "LJMacros.h"
#import "UrlRouter.h"
#import "LJCategories.h"

@interface LJNavigationController ()

@property (nonatomic, strong) LJNavigationControllerDelegation *delegation;

@end

@implementation LJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegation = [[LJNavigationControllerDelegation alloc] initWithController:self];
    self.delegate = self.delegation;
    
    // 禁用原生导航栏
    self.navigationBarHidden = YES;
    
    [self setupNavigationBarOfViewController:self.topViewController];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    // 确保首页的viewDidLoad被调用
    CGRect frame = self.topViewController.view.frame;
#pragma clang diagnostic pop
}

- (BOOL)isNavTransitioning {
    return [[self valueForKey:@"_isTransitioning"] boolValue];
}

- (void)setupNavigationBarOfViewController:(UIViewController *)vc {
    if (vc.isSetup) {
        return;
    }
    
    if (vc && [vc shouldUseNavigationBar]) {
        vc.navigationBarView = [[LJNavigationBarView alloc] init];
        if ([vc shouldDisplayDefaultBackBtn]) {
            WeakSelf()
            [vc.navigationBarView displayDefaultBackBtnWithCallback:^{
                if (weakSelf && !weakSelf.isNavTransitioning) {
                    [UrlRouter closePage];
                }
            }];
        }
        
        vc.navigationBarView.hidden = vc.isBarViewHidden;
        vc.navigationBarView.backgroundColor = vc.barViewBackgroundColor;
        [vc.navigationBarView setBarTitle:vc.barTitle];
        [vc.navigationBarView setBarTitleColor:vc.barTitleColor];
        [vc.navigationBarView setBarTitleFont:vc.barTitleFont];
        
        // 触发viewDidLoad，配置导航栏相关属性
        [vc.view addSubview:vc.navigationBarView];
    }
    
    vc.isSetup = YES;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:NO];
    
    [self.topViewController.navigationBarView setHidden:hidden animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //NSLog(@"pushViewController vc = %@", viewController);
    //NSLog(@"pushViewController enter... %@", self.viewControllers);
    [self setupNavigationBarOfViewController:viewController];
    [super pushViewController:viewController animated:animated];
    //NSLog(@"pushViewController exit... %@", self.viewControllers);
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    //NSLog(@"popViewControllerAnimated enter... %@", self.viewControllers);
    UIViewController *vc = [super popViewControllerAnimated:animated];
    //NSLog(@"popViewControllerAnimated exit... %@", self.viewControllers);
    //NSLog(@"popViewControllerAnimated vc = %@", vc);
    return vc;
}

@end
