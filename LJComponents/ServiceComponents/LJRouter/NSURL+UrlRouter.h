//
//  NSURL+UrlRouter.h
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (UrlRouter)

/**
 @return 返回Url中Ruery参数
 */
- (NSDictionary *)urlRouter_params;

@end
