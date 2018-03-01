//
//  LJNavigationBarView.m
//  LJNavigationController
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "LJNavigationBarView.h"
#import "LJCategories.h"

typedef NS_ENUM(NSInteger, BarViewHiddenStyle) {
    kBarViewHiddenStyleShow = 0, // default
    kBarViewHiddenStyleHidden,
};

@interface LJNavigationBarView ()

@property (nonatomic, strong) UIView *barBackgroundView;
@property (nonatomic, assign) BarViewHiddenStyle hiddenStyle;
@property (nonatomic, strong) UIButton *barClickBtn;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation LJNavigationBarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self init];
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, LJ_SCREEN_WIDTH, LJ_NAV_BAR_HEIGHT)]) {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = COLOR_TEXT_Dark;
        self.clipsToBounds = YES;
        [self setBottomLineLightContentStyle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentCenterY = (self.height + LJ_STAUS_HEIGHT) / 2;
    
    if (_leftBtn) {
        _leftBtn.left = 0;
        _leftBtn.centerY = contentCenterY;
    }
    
    if (_titleView) {
        _titleView.centerX = self.width / 2;
        _titleView.centerY = contentCenterY;
    }
    
    if (_rightBtn) {
        _rightBtn.right = self.width;
        _rightBtn.centerY = contentCenterY;
    }
    
    if (_barClickBtn) {
        _barClickBtn.frame = self.bounds;
    }
}

#pragma mark - Left View

- (void)setLeftBtn:(UIButton *)leftBtn {
    if (![_leftBtn isEqual:leftBtn]) {
        if (_leftBtn) {
            if (_leftBtn.superview) {
                [_leftBtn removeFromSuperview];
                _leftBtn = nil;
            }
        }
        _leftBtn = leftBtn;
        [self addSubview:_leftBtn];
        [self setNeedsLayout];
    }
}

- (void)displayDefaultBackBtnWithCallback:(void(^)(void))backBtnClicked {
    self.leftBtn = [UIButton buttonWithImgName:@"nav_back_default" clicked:backBtnClicked size:CGSizeMake(64, self.height) leftPadding:NAV_BAR_ITEM_LEFT_INSET color:COLOR_BG_Dark];
}

- (void)displayCloseBackBtnWithCallback:(void(^)(void))backBtnClicked {
    self.leftBtn = [UIButton buttonWithImgName:@"login_nav_close_black" clicked:backBtnClicked size:CGSizeMake(64, self.height) leftPadding:NAV_BAR_ITEM_LEFT_INSET color:COLOR_BG_Dark];
}

#pragma mark - Title View

- (void)setTitleView:(UIView *)titleView {
    if (![_titleView isEqual:titleView]) {
        [_titleView removeFromSuperview];
        _titleView = titleView;
        [self addSubview:titleView];
        [self setNeedsLayout];
    }
}

- (void)setBarTitle:(NSString *)title {
    if (title.length == 0) {
        self.titleView = nil;
    }
    else {
        UILabel *titleLabel = [UILabel labelWithTextColor:COLOR_TEXT_Dark fontSize:16 frameSize:CGSizeMake(self.width - 64 * 2, self.height - LJ_STAUS_HEIGHT) alignment:NSTextAlignmentCenter];
        titleLabel.text = title;
        
        self.titleView = titleLabel;
    }
}

- (void)setBarTitleColor:(UIColor *)color {
    if ([self.titleView isKindOfClass:[UILabel class]]) {
        ((UILabel *)self.titleView).textColor = color;
    }
}

- (void)setBarTitleFont:(UIFont *)font {
    if ([self.titleView isKindOfClass:[UILabel class]]) {
        ((UILabel *)self.titleView).font = font;
    }
}

#pragma mark - Right View

- (void)setRightBtn:(UIButton *)rightBtn {
    if (![_rightBtn isEqual:rightBtn]) {
        if (_rightBtn) {
            if (_rightBtn.superview) {
                [_rightBtn removeFromSuperview];
                _rightBtn = nil;
            }
        }
        _rightBtn = rightBtn;
        [self addSubview:_rightBtn];
        [self setNeedsLayout];
    }
}

- (void)setRightCloseBtnWithCallback:(void(^)(void))backBtnClicked {
    self.rightBtn = [UIButton buttonWithImgName:@"login_nav_close_black" clicked:backBtnClicked size:CGSizeMake(64, self.height) rightPadding:NAV_BAR_ITEM_RIGHT_INSET color:COLOR_BG_Dark];
}

#pragma mark - Others

- (void)setHidden:(BOOL)hidden {
    [self setHidden:hidden animated:NO];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated {
    
    //NSLog(@"Set Navigation %@ %@", hidden ? @"hidden" : @"show", animated ? @"animated" : @"");
    
    if ((self.hiddenStyle == kBarViewHiddenStyleHidden && hidden)
        || (self.hiddenStyle == kBarViewHiddenStyleShow && !hidden)) {
        return;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.top = hidden ? -self.height : 0;
        } completion:^(BOOL finished) {
            self.hiddenStyle = hidden ? kBarViewHiddenStyleHidden : kBarViewHiddenStyleShow;
        }];
    }
    else {
        self.top = hidden ? -self.height : 0;
        [super setHidden:hidden];
        self.hiddenStyle = hidden ? kBarViewHiddenStyleHidden : kBarViewHiddenStyleShow;
    }
}

- (void)setBarClicked:(void (^)(void))barClicked {
    if (barClicked) {
        if (!_barClickBtn) {
            _barClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_barClickBtn];
            [self sendSubviewToBack:_barClickBtn];
            [self setNeedsLayout];
        }
        _barClickBtn.clickedCallback = barClicked;
    }
    else {
        [_barClickBtn removeFromSuperview];
        _barClickBtn = nil;
    }
}

- (UIView *)barBackgroundView {
    if (!_barBackgroundView) {
        _barBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _barBackgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_barBackgroundView];
        [self sendSubviewToBack:_barBackgroundView];
    }
    
    return _barBackgroundView;
}

- (void)setBottomLineStyle:(LJNavigationBarViewBottomLineStyle)bottomLineStyle {
    if (bottomLineStyle == kLJNavigationBarViewBottomLineStyleNone) {
        [_bottomLine removeFromSuperview];
        _bottomLine = nil;
    }
    else {
        if (!_bottomLine) {
            _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
            [self addSubview:_bottomLine];
        }
        if (bottomLineStyle == kLJNavigationBarViewBottomLineStyleLightContent) {
            _bottomLine.backgroundColor = COLOR_BG_Light;
        }
        else if (bottomLineStyle == kLJNavigationBarViewBottomLineStyleDarkContent) {
            _bottomLine.backgroundColor = COLOR_WhiteAlpha(0.2);
        } else if (bottomLineStyle == kLJNavigationBarViewBottomLineStyleHome) {
            _bottomLine.backgroundColor = COLOR_HexStr(@"#e7e7e7");
        }
    }
}

- (void)setBottomLineNone {
    self.bottomLineStyle = kLJNavigationBarViewBottomLineStyleNone;
}

- (void)setBottomLineLightContentStyle {
    self.bottomLineStyle = kLJNavigationBarViewBottomLineStyleLightContent;
}

- (void)setBottomLineDarkContentStyle {
    self.bottomLineStyle = kLJNavigationBarViewBottomLineStyleDarkContent;
}

@end
