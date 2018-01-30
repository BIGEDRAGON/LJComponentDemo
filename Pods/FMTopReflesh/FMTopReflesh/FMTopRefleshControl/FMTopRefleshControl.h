//
//  FMTopRefleshControl.h
//  FMTopReflesh
//
//  Created by 李传格 on 16/6/25.
//  Copyright © 2016年 lichuange. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMTopRefleshControlTopView <NSObject>

@optional
- (void)pullToReflesh;

- (void)releaseToReflesh;

- (void)startReflesh;

- (void)refleshFinished;

@end

@interface FMTopRefleshControl : NSObject

/**
 Initializer

 @param scrollView A scroll view added a reflesh control, retained, shouldn't retain FMTopRefleshControl avoid retain recycle.
 @param refleshCallback Callback called when reflesh triggered.
 @param topView A view implement FMTopRefleshControlTopView protocol.
 @return instance
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView withRefleshCallback:(void(^)(FMTopRefleshControl *control))refleshCallback withTopView:(UIView<FMTopRefleshControlTopView> *)topView;

- (void)endReflesh;

@end
