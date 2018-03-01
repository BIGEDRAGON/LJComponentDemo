//
//  LJServiceViewController.m
//  LJComponentDemo
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2018年 longlj. All rights reserved.
//

#import "LJServiceViewController.h"

@interface LJServiceViewController ()

@end

@implementation LJServiceViewController

- (BOOL)shouldDisplayDefaultBackBtn {
    return NO;
}

- (LJTabBarDidClickAnimation)tabbarDidClickAnimation {
    return LJTabBarDidClickAnimationRotate;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"服务" image:IMG(@"service_tabbar") selectedImage:IMG(@"service_tabbar_selected")];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barTitle = @"服务组件";

    self.showPoint = YES;
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
