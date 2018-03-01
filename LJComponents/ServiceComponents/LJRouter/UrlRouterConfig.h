//
//  UrlRouterConfig.h
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UrlRouterContainerMode) {
    UrlRouterContainerModeNavigationAndTabBar = 0,
    UrlRouterContainerModeOnlyNavigation
};

@interface UrlRouterConfig : NSObject

#pragma mark - container

@property (nonatomic, assign) UrlRouterContainerMode mode;
@property (nonatomic, strong) Class navigationControllerClass;
@property (nonatomic, strong) Class tabBarControllerClass;
@property (nonatomic, strong) Class webContainerClass;

#pragma mark - schemes

@property (nonatomic, copy) NSString *nativeUrlScheme;
@property (nonatomic, copy) NSString *nativeUrlHostName;

@end
