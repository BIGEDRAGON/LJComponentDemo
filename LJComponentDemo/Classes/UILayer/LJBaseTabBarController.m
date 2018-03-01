//
//  LJBaseTabBarController.m
//  LJBaseTabBarController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2018年 longlj. All rights reserved.
//

#import "LJBaseTabBarController.h"

@interface LJBaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation LJBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBar.translucent = NO;
    self.tabBar.backgroundColor = COLOR_BG_Light;
//    self.tabBar.backgroundImage = [UIImage imageFromColor:COLOR_BG_Light];
    self.tabBar.shadowImage = [UIImage imageFromColor:COLOR_LINE_Cell withWH:1.0];
    
    self.itemTitleColor = COLOR_TEXT_Dark;
    self.selectedItemTitleColor = COLOR_TEXT_Red;
}

@end

