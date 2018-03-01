//
//  LJConstant.h
//  LJCommons
//
//  Created by longlj on 2016/7/18.
//  Copyright © 2018年 longlj. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "LJMacros.h"

// 第三方平台
LJKit_EXTERN NSString * const UM_APPKEY;

// notification
LJKit_EXTERN NSString * const kNoti_showUMengMessage;

// cache
LJKit_EXTERN NSString * const kUserDefault_userForbbiden;

// 正则
LJKit_EXTERN NSString * const kRegexPattern_Phone;

// 普通常量
LJKit_EXTERN NSString * const kNewNickNameKey;

// enum
typedef NS_ENUM(NSInteger, LJImageMode) {
    LJImageModeTile = 0,
    LJImageModeStretch,
};
