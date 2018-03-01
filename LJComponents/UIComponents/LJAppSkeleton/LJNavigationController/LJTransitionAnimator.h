//
//  LJTransitionAnimator.h
//  LJNavigationController
//
//  Created by longlj on 2016/6/1.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  转场类型
 */
typedef NS_ENUM(NSInteger, LJTransitionAnimatorOperation) {
    /**
     *  Push
     */
    kLJTransitionOperationPush = 0,
    /**
     *  Pop
     */
    kLJTransitionOperationPop
};

/**
 *  转场动画样式
 */
typedef NS_ENUM(NSInteger, LJTransitionAnimatorStyle) {
    /**
     *  从上向下滑动
     */
    kLJTransitionFlipFromTop = 0,
    /**
     *  从下向上覆盖
     */
    kLJTransitionCoverFromBottom,
    /**
     *  从上往下覆盖
     */
    kLJTransitionCoverFromTop,
    
    /*
     push渐入渐出
     */
    kLJTransitionCrossDissolve,
    
    /**
     *  从右向左覆盖，动画时长0.3
     */
    kLJTransitionCoverFromRight,
    
    /**
     *  子类自定义
     */
    kLJTransitionCustom
};

/**
 *  Pop手势滑动方向
 */
typedef NS_ENUM(NSInteger, LJInteractivePopDirection) {
    /**
     *  从左向右滑
     */
    kLJInteractivePopDirectionFromLeft = 0,
    /**
     *  从右向左滑
     */
    kLJInteractivePopDirectionFromRight
};

/**
 *  NavigationController的自定义转场动画
 */
@interface LJTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithOperation:(LJTransitionAnimatorOperation)operation
                            style:(LJTransitionAnimatorStyle)style;

@property (nonatomic, assign) LJTransitionAnimatorOperation operation;

/**
 *  动画时长
 */
@property (nonatomic, assign) NSTimeInterval transitionDuration;

/**
 *  Pop手势滑动方向
 */
@property (nonatomic, assign) LJInteractivePopDirection interactivePopDirection;

@end
