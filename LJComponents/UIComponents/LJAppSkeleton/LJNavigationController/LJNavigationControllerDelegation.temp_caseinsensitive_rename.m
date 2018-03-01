//
//  LJNavigationControllerDelegation.m
//  Fanmei
//
//  Created by 李传格 on 16/8/8.
//  Copyright © 2016年 Fanmei. All rights reserved.
//

#import "LJNavigationControllerDelegation.h"
#import "LJCommons.h"
#import "LJTransitionAnimator.h"
#import "UIViewController+LJNavigationController.h"
#import "UrlRouter.h"
#import "ProfilesTransitionAnimator.h"

NSString * const kLJNavWillShowViewController = @"LJ.navigationcontroller.willshow";
NSString * const kLJNavDidShowViewController = @"LJ.navigationcontroller.didshow";
NSString * const kLJNavNotifyViewControllerKey = @"LJ.navigationcontroller.viewcontroller.key";
NSString * const kLJNavNotifyFromPageNameKey = @"LJ.navigationcontroller.frompagename.key";

@interface LJNavigationControllerDelegation () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UINavigationController *controller;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, copy) NSString *currentPageName;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) BOOL isInteracting;
@property (nonatomic, assign) LJInteractivePopDirection interactivePopDirection;

@end

@implementation LJNavigationControllerDelegation

- (BOOL)isUserCustomInteraction {
    return YES;
}

- (instancetype)initWithController:(UINavigationController *)controller {
    if (self = [super init]) {
        self.controller = controller;
        [self.controller.view addGestureRecognizer:self.panGesture];
        self.controller.interactivePopGestureRecognizer.enabled = NO;
        
        if ([self isUserCustomInteraction]) {
            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.panGesture addTarget:self action:@selector(handlePan:)];
            
            // Note：不要设置completionSpeed，在iOS10上会引起转场动画卡顿。
            //self.interactiveTransition.completionSpeed = 0.6;
        }
        else {
            NSMutableArray * _targets = [self.controller.interactivePopGestureRecognizer valueForKey:@"_targets"];
            id _UINavigationInteractiveTransition = [[_targets firstObject] valueForKey:@"_target"];
            SEL popAction = NSSelectorFromString(@"handleNavigationTransition:");
            [self.panGesture addTarget:_UINavigationInteractiveTransition action:popAction];
        }
    }
    
    return self;
}

#pragma mark - 自定义手势

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] init];
        _panGesture.delegate = self;
        _panGesture.maximumNumberOfTouches = 1;
    }
    
    return _panGesture;
}

/**
 *  自定义Pan手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)panGen {
    CGFloat directionRatio = self.interactivePopDirection == kLJInteractivePopDirectionFromLeft ? 1 : -1;
    
    switch (panGen.state) {
        case UIGestureRecognizerStateBegan:
            self.isInteracting = YES;
            [self.controller popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat movedX = [panGen translationInView:self.controller.view].x * directionRatio;
            CGFloat percent = movedX / CGRectGetWidth(self.controller.view.bounds);
            
            [self.interactiveTransition updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGFloat movedX = [panGen translationInView:self.controller.view].x * directionRatio;
            CGFloat percent = movedX / CGRectGetWidth(self.controller.view.bounds);
            
            if (percent > 0.4) {
                [self.interactiveTransition finishInteractiveTransition];
            }
            else {
                CGFloat velocity = [panGen velocityInView:self.controller.view].x * directionRatio;
                
                CGFloat velocityThreshold = 200;
                if (velocity >= velocityThreshold) {
                    [self.interactiveTransition finishInteractiveTransition];
                }
                else {
                    [self.interactiveTransition cancelInteractiveTransition];
                }
            }
            self.isInteracting = NO;
            break;
        }
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if (self.controller.viewControllers.count == 1) {
        return NO;
    }
    
    if ([[self.controller valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    UIViewController *topViewController = self.controller.topViewController;
    if (![topViewController shouldEnableNavigationInteractPop]) {
        return NO;
    }
    
    CGPoint velocity = [gestureRecognizer velocityInView:self.controller.view];
    
    if (topViewController.popAnimation && topViewController.popAnimation.interactivePopDirection == kLJInteractivePopDirectionFromRight) {
        // 从左滑向右，不启用Pop手势
        if (velocity.x >= 0) {
            return NO;
        }
        self.interactivePopDirection = kLJInteractivePopDirectionFromRight;
    }
    else {
        // 从右滑向左，不启用Pop手势
        if (velocity.x <= 0) {
            return NO;
        }
        self.interactivePopDirection = kLJInteractivePopDirectionFromLeft;
    }
    
    // 角度大于30度，不启用Pop手势
    if (fabs(velocity.y) * 2 >= fabs(velocity.x)) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UINavigationControllerDelegate

// 检查下导航栈中是否有需要被移除的VC
- (void)checkVCsInNavStackShouldDismiss {
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:self.controller.viewControllers];
    for (NSInteger index = vcs.count - 2; index >= 0; --index) {
        UIViewController *vc = vcs[index];
        if ([vc shouldDismissWhenOtherPushed]) {
            [vcs removeObjectAtIndex:index];
        }
    }
    if (vcs.count != self.controller.viewControllers.count) {
        [self.controller setViewControllers:vcs];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 通知将要显示VC
    NSDictionary *userInfo = @{ kLJNavNotifyViewControllerKey : viewController, kLJNavNotifyFromPageNameKey : NotNilStr(self.currentPageName)};
    POST_NOTIFICATION(kLJNavWillShowViewController, self, userInfo);
    
    NSLog(@"Will show vc [%@] from [%@]", viewController.vcPageName, self.currentPageName);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self checkVCsInNavStackShouldDismiss];
    
    LogInfo(@"Did show vc [%@] from [%@]", viewController.vcPageName, self.currentPageName);
    
    // 通知显示VC完成
    NSDictionary *userInfo = @{ kLJNavNotifyViewControllerKey : viewController, kLJNavNotifyFromPageNameKey : NotNilStr(self.currentPageName)};
    POST_NOTIFICATION(kLJNavDidShowViewController, self, userInfo);
    self.currentPageName = viewController.vcPageName;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.isInteracting ? self.interactiveTransition : nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    id <UIViewControllerAnimatedTransitioning> animation = nil;
    switch (operation) {
        case UINavigationControllerOperationNone:
            break;
        case UINavigationControllerOperationPush:
            animation = toVC.pushAnimation;
            break;
        case UINavigationControllerOperationPop:
            animation = fromVC.popAnimation;
            break;
        default:
            break;
    }
    
    return animation;
}

@end
