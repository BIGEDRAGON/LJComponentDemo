//
//  LJViewViewController.m
//  LJComponentDemo
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2018年 longlj. All rights reserved.
//

#import "LJViewViewController.h"

@interface LJViewViewController ()

@end

@implementation LJViewViewController

- (BOOL)shouldDisplayDefaultBackBtn {
    return NO;
}

- (LJTabBarDidClickAnimation)tabbarDidClickAnimation {
    return LJTabBarDidClickAnimationScale;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"视图" image:IMG(@"view_tabbar") selectedImage:IMG(@"view_tabbar_selected")];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barTitle = @"视图组件";
    
    self.tabBarItem.badgeValue = @"66";
    
    NSLog(@"%@---%@---%ld", self.LJTabBar, self.LJTabBar.tabBarItems, (long)self.LJTabBar.tabBarItemCount);
    NSLog(@"%@---%@", self.navigationController, [UrlRouter sharedInstance].navigationController);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@---%@---%ld", self.LJTabBar, self.LJTabBar.tabBarItems, (long)self.LJTabBar.tabBarItemCount);
    NSLog(@"%@---%@", self.navigationController, [UrlRouter sharedInstance].navigationController);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
