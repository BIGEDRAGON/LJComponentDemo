//
//  LJStudyViewController.m
//  LJComponentDemo
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2018年 longlj. All rights reserved.
//

#import "LJOthersViewController.h"

@interface LJOthersViewController ()

@end

@implementation LJOthersViewController

- (BOOL)shouldUseNavigationBar {
    return NO;
}

- (LJTabBarDidClickAnimation)tabbarDidClickAnimation {
    return LJTabBarDidClickAnimationScale;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"其它" image:IMG(@"study_tabbar") selectedImage:IMG(@"study_tabbar_selected")];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIViewController *vc1 = self.tabBarController.childViewControllers[0];
    vc1.tabBarItem.badgeValue = nil;
    
    UIViewController *vc = self.tabBarController.childViewControllers[1];
    vc.pointColor = [UIColor blueColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showPoint = YES;
    self.pointColor = [UIColor orangeColor];
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
