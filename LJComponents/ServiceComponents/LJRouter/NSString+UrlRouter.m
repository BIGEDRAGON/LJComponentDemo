//
//  NSString+UrlRouter.m
//  URLRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import "NSString+UrlRouter.h"

@implementation NSString (UrlRouter)

- (NSString *)urlRouter_toBaseUrl {
    NSRange rangeOfString = [self rangeOfString:@"?"];
    if (rangeOfString.length > 0) {
        return [self substringToIndex:rangeOfString.location];
    }
    else {
        return self;
    }
}

@end
