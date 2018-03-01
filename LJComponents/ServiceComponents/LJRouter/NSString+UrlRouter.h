//
//  NSString+UrlRouter.h
//  URLRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlRouter)

/**
  @return 返回Url中"?"之前的字符串
  */
- (NSString *)urlRouter_toBaseUrl;

@end
