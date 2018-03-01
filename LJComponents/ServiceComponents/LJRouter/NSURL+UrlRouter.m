//
//  NSURL+UrlRouter.m
//  LJRouter
//
//  Created by longlj on 2017/9/17.
//  Copyright © 2017年 longlj. All rights reserved.
//

#import "NSURL+UrlRouter.h"

@implementation NSURL (UrlRouter)

- (NSDictionary *)urlRouter_params {
    NSString *query = [self query];
    if (query.length > 0) {
        query = [query stringByRemovingPercentEncoding];
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        NSCharacterSet *seperatorChars = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
        NSArray *keyValues = [query componentsSeparatedByCharactersInSet:seperatorChars];
        NSEnumerator *theEnum = [keyValues objectEnumerator];
        NSString *keyValuePair;
        
        while (nil != (keyValuePair = [theEnum nextObject]) )
        {
            NSRange whereEquals = [keyValuePair rangeOfString:@"="];
            if (NSNotFound != whereEquals.location)
            {
                NSString *key = [keyValuePair substringToIndex:whereEquals.location];
                NSString *value = [keyValuePair substringFromIndex:whereEquals.location+1];
                [result setValue:value forKey:key];
            }
        }
        return result;
    }
    
    return @{};
}

@end
