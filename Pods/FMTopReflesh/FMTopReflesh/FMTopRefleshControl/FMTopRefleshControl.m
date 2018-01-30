//
//  FMTopRefleshControl.m
//  FMTopReflesh
//
//  Created by 李传格 on 16/6/25.
//  Copyright © 2016年 lichuange. All rights reserved.
//

#import "FMTopRefleshControl.h"

#define FM_REFLESH_TOP_INSET (64)
#define FM_RELEASE_TO_REFLESH_TOP_INSET (FM_REFLESH_TOP_INSET + 20)

static char __stateDesc[4][30] = {"None", "Possible", "ReleaseToReflesh", "Refleshing"};

typedef NS_ENUM(NSInteger, FMRefleshState) {
    kFMRefleshStateNone = 0,
    kFMRefleshStatePossible,
    kFMRefleshStateReleaseToReflesh,
    kFMRefleshStateRefleshing
};

@interface FMTopRefleshControl ()

@property (nonatomic, assign) FMRefleshState state;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<FMTopRefleshControlTopView> *topRefleshView;
@property (nonatomic, copy) void(^refleshCallback)(FMTopRefleshControl *control);

@end

@implementation FMTopRefleshControl

- (instancetype)initWithScrollView:(UIScrollView *)scrollView withRefleshCallback:(void(^)(FMTopRefleshControl *control))refleshCallback withTopView:(UIView<FMTopRefleshControlTopView> *)topView {
    if (self = [super init]) {
        self.state = kFMRefleshStateNone;
        self.scrollView = scrollView;
        self.refleshCallback = refleshCallback;
        self.topRefleshView = topView;
        
        if (topView) {
            CGRect rc = topView.frame;
            rc.origin.y = -rc.size.height;
            topView.frame = rc;
        }
        
        if (scrollView) {
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
            [scrollView addSubview:self.topRefleshView];
        }
    }
    
    return self;
}

- (void)dealloc {
    if (self.state == kFMRefleshStateRefleshing) {
        self.state = kFMRefleshStateNone;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top -= FM_REFLESH_TOP_INSET;
        self.scrollView.contentInset = insets;
    }
    [self.topRefleshView removeFromSuperview];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)setState:(FMRefleshState)state {
    NSLog(@"Top reflesh state from %s to %s.", __stateDesc[_state], __stateDesc[state]);
    _state = state;
    
    switch (self.state) {
        case kFMRefleshStateNone:
            [self.topRefleshView refleshFinished];
            break;
        case kFMRefleshStatePossible:
            [self.topRefleshView pullToReflesh];
            break;
        case kFMRefleshStateReleaseToReflesh:
            [self.topRefleshView releaseToReflesh];
            break;
        case kFMRefleshStateRefleshing:
            [self.topRefleshView startReflesh];
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqual:@"contentOffset"]) {
        [self scrollViewContentOffsetChanged];
    }
}

- (void)scrollViewContentOffsetChanged {
    if (!self.scrollView.dragging && !self.scrollView.decelerating) {
        return;
    }
    
    switch (self.state) {
    case kFMRefleshStateNone:
            if (self.scrollView.contentOffset.y < -self.scrollView.contentInset.top) {
                self.state = kFMRefleshStatePossible;
            }
        break;
    case kFMRefleshStatePossible:
            if (self.scrollView.contentOffset.y <= -FM_RELEASE_TO_REFLESH_TOP_INSET - self.scrollView.contentInset.top) {
                self.state = kFMRefleshStateReleaseToReflesh;
            }
            else if (self.scrollView.contentOffset.y >= -self.scrollView.contentInset.top) {
                self.state = kFMRefleshStateNone;
            }
        break;
    case kFMRefleshStateReleaseToReflesh:
            if (self.scrollView.decelerating) {
                self.state = kFMRefleshStateRefleshing;
                
                CGFloat offsetY = self.scrollView.contentOffset.y;
                UIEdgeInsets insets = self.scrollView.contentInset;
                insets.top += FM_REFLESH_TOP_INSET;
                self.scrollView.contentInset = insets;
                self.scrollView.contentOffset = CGPointMake(0, offsetY);
                [self.scrollView setContentOffset:CGPointMake(0, -insets.top) animated:YES];
                
                if (self.refleshCallback) {
                    self.refleshCallback(self);
                }
            }
            else {
                if (self.scrollView.contentOffset.y > -FM_RELEASE_TO_REFLESH_TOP_INSET - self.scrollView.contentInset.top) {
                    self.state = kFMRefleshStatePossible;
                }
            }
        break;
    case kFMRefleshStateRefleshing:
        break;
    default:
        break;
    }
}

- (void)endReflesh {
    if (self.state == kFMRefleshStateRefleshing) {
        self.state = kFMRefleshStateNone;
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.top -= FM_REFLESH_TOP_INSET;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentInset = insets;
        }];
    }
}

@end
