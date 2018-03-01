//
//  LJTabBarController.m
//  LJTabBarController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "LJTabBarController.h"
#import "LJTabBarItem.h"

@interface LJTabBarController () <LJTabBarDelegate>

@end

@implementation LJTabBarController

@synthesize badgeTitleFont;
@synthesize itemTitleFont;
@synthesize itemTitleColor;
@synthesize selectedItemTitleColor;

- (void)setBadgeTitleFont:(UIFont *)aBadgeTitleFont {
    badgeTitleFont = aBadgeTitleFont;
    
    self.LJTabBar.badgeTitleFont = aBadgeTitleFont;
}

- (void)setItemTitleFont:(UIFont *)aItemTitleFont {
    itemTitleFont = aItemTitleFont;
    
    self.LJTabBar.itemTitleFont = aItemTitleFont;
}

- (void)setItemTitleColor:(UIColor *)aItemTitleColor {
    itemTitleColor = aItemTitleColor;
    
    self.LJTabBar.itemTitleColor = aItemTitleColor;
}

- (void)setItemImageRatio:(CGFloat)itemImageRatio {
    _itemImageRatio = itemImageRatio;
    
    self.LJTabBar.itemImageRatio = itemImageRatio;
}

- (void)setSelectedItemTitleColor:(UIColor *)aSelectedItemTitleColor {
    selectedItemTitleColor = aSelectedItemTitleColor;
    
    self.LJTabBar.selectedItemTitleColor = aSelectedItemTitleColor;
}

- (UIFont *)itemTitleFont {
    if (!itemTitleFont) {
        itemTitleFont = [UIFont systemFontOfSize:11.0f];
    }
    return itemTitleFont;
}

- (UIFont *)badgeTitleFont {
    if (!badgeTitleFont) {
        badgeTitleFont = [UIFont systemFontOfSize:11.0f];
    }
    return badgeTitleFont;
}

- (UIColor *)itemTitleColor {
    if (!itemTitleColor) {
        itemTitleColor = COLOR_RGB(117, 117, 117);
    }
    return itemTitleColor;
}

- (UIColor *)selectedItemTitleColor {
    if (!selectedItemTitleColor) {
        selectedItemTitleColor = COLOR_RGB(234, 103, 7);
    }
    return selectedItemTitleColor;
}

#pragma mark -

- (void)loadView {
    
    [super loadView];
    
    self.itemImageRatio = 0.70f;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tabBar addSubview:({
        
        LJTabBar *tabBar = [[LJTabBar alloc] init];
        tabBar.frame     = self.tabBar.bounds;
        tabBar.delegate  = self;
        
        tabBar.badgeTitleFont         = self.badgeTitleFont;
        tabBar.itemTitleFont          = self.itemTitleFont;
        tabBar.itemTitleColor         = self.itemTitleColor;
        tabBar.itemImageRatio         = self.itemImageRatio;
        tabBar.selectedItemTitleColor = self.selectedItemTitleColor;
        
        self.LJTabBar = tabBar;
    })];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTabBarItemChanged) name:LJNotificationTabBarItemChanged object:nil];
}

- (void)handleTabBarItemChanged {
    [self hideOriginControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideOriginControls];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self hideOriginControls];
}

- (void)hideOriginControls {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 1.0) {
        // iOS 11.0+
        [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * obj, NSUInteger idx, BOOL * stop) {
            if ([obj isKindOfClass:[UIControl class]]) {
                [obj setHidden:YES];
            }
        }];
    } else {
        // TODO: fix iOS 11.0-
        
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.LJTabBar.frame;
    frame.size.width = self.tabBar.bounds.size.width;
    self.LJTabBar.frame = frame;
}

- (void)removeOriginControls {
    [self hideOriginControls];
}

- (void)addChildViewController:(UIViewController *)childController {
    
    // add 之前先设置 vc 的navibar
    [self setupNavigationBarOfViewController:childController];
    
    [super addChildViewController:childController];
    
    self.LJTabBar.tabBarItemCount = self.viewControllers.count;
    
    UIImage *selectedImage = childController.tabBarItem.selectedImage;
    childController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.LJTabBar addTabBarItem:childController.tabBarItem];
    
    LJTabBarItem *addTabBarItem = self.LJTabBar.tabBarItems.lastObject;
    [self setupTabBarItemPoint:addTabBarItem OfViewController:childController];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.LJTabBar.selectedItem.selected = NO;
    self.LJTabBar.selectedItem = self.LJTabBar.tabBarItems[selectedIndex];
    self.LJTabBar.selectedItem.selected = YES;
    
    UIViewController *selectedVC = self.viewControllers[selectedIndex];
    switch ([selectedVC tabbarDidClickAnimation]) {
        case LJTabBarDidClickAnimationRotate:
            [self addRotateAnimationOnView:self.LJTabBar.selectedItem.imageView];
            break;
        case LJTabBarDidClickAnimationScale:
            [self addScaleAnimationOnView:self.LJTabBar.selectedItem.imageView repeatCount:1];
            break;
        default:
            break;
    }
}

// 隐藏tabbar的navibar
- (BOOL)shouldUseNavigationBar {
    return NO;
}

// 针对单独的vc，设置其navibar
- (void)setupNavigationBarOfViewController:(UIViewController *)vc {
    if (vc.isSetup) {
        return;
    }
    
    if (vc) {
        vc.navigationBarView = [[LJNavigationBarView alloc] init];
        
        // 属性赋值
        vc.navigationBarView.hidden = vc.isBarViewHidden;
        if (![vc shouldUseNavigationBar]) {
            vc.navigationBarView.hidden = YES;
        }
        vc.navigationBarView.backgroundColor = vc.barViewBackgroundColor;
        [vc.navigationBarView setBarTitle:vc.barTitle];
        [vc.navigationBarView setBarTitleColor:vc.barTitleColor];
        
        // 触发viewDidLoad，配置导航栏相关属性
        // 将会导致此时的vc在viewDidLoad中访问不到navi和tabbarcontroller，但是一般在此时也用不上它们
        [vc.view addSubview:vc.navigationBarView];
    }
    
    vc.isSetup = YES;
}

- (void)setupTabBarItemPoint:(LJTabBarItem *)item OfViewController:(UIViewController *)vc {
    vc.currentTabBarItem = item;
    item.showPoint = vc.showPoint;
    item.pointColor = vc.pointColor;
}

// 缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.75;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

// 旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
//    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DIdentity;
        } completion:nil];
    });
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(LJTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    self.selectedIndex = to;
}

@end
