//
//  LJTransitionAnimator.m
//  LJNavigationController
//
//  Created by longlj on 2016/6/1.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "LJTransitionAnimator.h"
#import "UIViewController+LJNavigationController.h"
#import "LJCategories.h"
#import "LJMacros.h"

#define SLIDE_MAIN_VIEW_TAG (12345)

@interface LJTransitionAnimator ()

@property (nonatomic, assign) LJTransitionAnimatorStyle style;

@end

@implementation LJTransitionAnimator

- (instancetype)init {
    return [self initWithOperation:kLJTransitionOperationPush style:kLJTransitionCoverFromBottom];
}

- (instancetype)initWithOperation:(LJTransitionAnimatorOperation)operation
                            style:(LJTransitionAnimatorStyle)style {
    if (self = [super init]) {
        self.operation = operation;
        self.style = style;
        
        if (style == kLJTransitionCoverFromRight) {
            self.transitionDuration = 0.3;
        }
        else {
            self.transitionDuration = 0.5;
        }
        
        self.interactivePopDirection = kLJInteractivePopDirectionFromLeft;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.operation == kLJTransitionOperationPush) {
        [self animateTransitionForPush:transitionContext];
    }
    else if (self.operation == kLJTransitionOperationPop) {
        [self animateTransitionForPop:transitionContext];
    }
}

- (void)animateTransitionForPush:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.style) {
        case kLJTransitionFlipFromTop:
            [self pushTransitionWithFlipFromTop:transitionContext];
            break;
        case kLJTransitionCoverFromBottom:
            [self pushTransitionWithCover:transitionContext isFromBottomOrTop:YES];
            break;
        case kLJTransitionCoverFromTop:
            [self pushTransitionWithCover:transitionContext isFromBottomOrTop:NO];
            break;
        case kLJTransitionCrossDissolve:
            [self pushTransitionWithCurveEaseInOut:transitionContext];
            break;
        case kLJTransitionCoverFromRight:
            [self pushTransitionWithCoverFromRight:transitionContext];
            break;
        default:
            break;
    }
}

- (void)animateTransitionForPop:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.style) {
        case kLJTransitionFlipFromTop:
            [self popTransitionWithFlipFromTop:transitionContext];
            break;
        case kLJTransitionCoverFromBottom:
            [self popTransitionWithCover:transitionContext isFromBottomOrTop:YES];
            break;
        case kLJTransitionCoverFromTop:
            [self popTransitionWithCover:transitionContext isFromBottomOrTop:NO];
            break;
        case kLJTransitionCoverFromRight:
            [self popTransitionWithCoverFromRight:transitionContext];
            break;
        default:
            break;
    }
}

- (void)pushTransitionWithFlipFromTop:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    
    [containerView addSubview:fromVc.view];
    [containerView addSubview:toVc.view];
    
    toVc.view.top -= toVc.view.height - toVc.navigationBarView.height;
    toVc.navigationBarView.bottom = toVc.view.height;
    
    [UIView springAnimateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVc.view.top += toVc.view.height - toVc.navigationBarView.height;
        toVc.view.top = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)popTransitionWithFlipFromTop:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    
    [[transitionContext containerView] addSubview:toVc.view];
    [[transitionContext containerView] addSubview:fromVc.view];
    
    toVc.view.top += toVc.view.height - toVc.navigationBarView.height;
    
    [UIView springAnimateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVc.view.top -= fromVc.view.height - fromVc.navigationBarView.height;
        toVc.view.top -= toVc.view.height - toVc.navigationBarView.height;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)pushTransitionWithCover:(id<UIViewControllerContextTransitioning>)transitionContext isFromBottomOrTop:(BOOL)isFromBottom {
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    [containerView addSubview:toVc.view];
    
    if (isFromBottom) {
        toVc.view.top += toVc.view.height;
    }
    else {
        toVc.view.top -= toVc.view.height;
        
        [toVc.navigationBarView removeFromSuperview];
        [fromVc.navigationBarView removeFromSuperview];
        [fromVc.navigationController.view addSubview:fromVc.navigationBarView];
    }
    
    [UIView springAnimateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (isFromBottom) {
            toVc.view.top -= toVc.view.height;
        }
        else {
            toVc.view.top += toVc.view.height;
            
            fromVc.navigationBarView.leftBtn.alpha = 0;
            fromVc.navigationBarView.rightBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }
    } completion:^(BOOL finished) {
        if (!isFromBottom) {
            [toVc.navigationBarView removeFromSuperview];
            [toVc.view addSubview:toVc.navigationBarView];
            [fromVc.navigationBarView removeFromSuperview];
            [fromVc.view addSubview:fromVc.navigationBarView];
            fromVc.navigationBarView.rightBtn.imageView.transform = CGAffineTransformIdentity;
            fromVc.navigationBarView.leftBtn.alpha = 1.0;
        }
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)popTransitionWithCover:(id<UIViewControllerContextTransitioning>)transitionContext isFromBottomOrTop:(BOOL)isFromBottom {
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    
    [containerView addSubview:toVc.view];
    [containerView addSubview:fromVc.view];
    
    if (isFromBottom) {
    }
    else {
        [fromVc.navigationBarView removeFromSuperview];
        [toVc.navigationBarView removeFromSuperview];
        [toVc.navigationController.view addSubview:toVc.navigationBarView];
        toVc.navigationBarView.rightBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        toVc.navigationBarView.leftBtn.alpha = 0;
    }
    
    [UIView springAnimateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (isFromBottom) {
            fromVc.view.top += fromVc.view.height;
        }
        else {
            fromVc.view.top = -fromVc.view.height;
            toVc.navigationBarView.rightBtn.imageView.transform = CGAffineTransformIdentity;
            toVc.navigationBarView.leftBtn.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        if (!isFromBottom) {
            [fromVc.navigationBarView removeFromSuperview];
            [fromVc.view addSubview:fromVc.navigationBarView];
            [toVc.navigationBarView removeFromSuperview];
            [toVc.view addSubview:toVc.navigationBarView];
        }
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)pushTransitionWithCoverFromRight:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    fromVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    [containerView addSubview:fromVc.view];
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    [containerView addSubview:toVc.view];
    
    toVc.view.left = toVc.view.width;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVc.view.left -= fromVc.view.width * 0.3;
        toVc.view.left = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)popTransitionWithCoverFromRight:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    [containerView addSubview:toVc.view];
    fromVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    [containerView addSubview:fromVc.view];
    
    UIView *fromVcSnapShotView = [fromVc.view snapshotViewAfterScreenUpdates:NO];
    [fromVc.view addSubview:fromVcSnapShotView];
    
    toVc.view.left -= toVc.view.width * 0.3;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVc.view.left = fromVc.view.width;
        toVc.view.left = 0;
    } completion:^(BOOL finished) {
        if (fromVcSnapShotView.superview) {
            [fromVcSnapShotView removeFromSuperview];
        }
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)pushTransitionWithCurveEaseInOut:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    fromVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    [containerView addSubview:fromVc.view];
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    [containerView addSubview:toVc.view];
    
    [UIView transitionFromView:fromVc.view toView:toVc.view duration:[self transitionDuration:transitionContext] options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
