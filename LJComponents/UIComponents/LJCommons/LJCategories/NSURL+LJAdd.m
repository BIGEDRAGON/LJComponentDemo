//
//  NSURL+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/7/6.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "NSURL+LJAdd.h"
#import "NSString+LJAdd.h"

@implementation NSURL (LJAdd)

- (NSDictionary *)queryParameters {
    NSDictionary *result = [[self class] parametersOfQuery:[self query]];
    return result;
}

- (NSURL *)URLWithQueryParameters:(NSDictionary *)parameters {
    NSString *query = [NSURL queryWithParameters:parameters];
    return [NSURL URLWithString:[@"?" stringByAppendingString:query] relativeToURL:self];
}

+ (NSURL *)URLWithScheme:(NSString *)scheme
                       host:(NSString *)host
                       path:(NSString *)path
            queryParameters:(NSDictionary *)parameters {
    NSURL *baseURL = [[NSURL alloc] initWithScheme:scheme host:host path:path];
    NSURL *result = [baseURL URLWithQueryParameters:parameters];
    return result;
}

/*  These 2 methods form the main backbone for URL query operations
 */

+ (NSString *)queryWithParameters:(NSDictionary *)parameters {
    // Build the list of parameters as a string
    NSMutableString *parametersString = [NSMutableString string];
    
    if (nil != parameters)
    {
        NSEnumerator *enumerator = [parameters keyEnumerator];
        NSString *key;
        BOOL thisIsTheFirstParameter = YES;
        
        while (nil != (key = [enumerator nextObject]))
        {
            id rawParameter = [parameters objectForKey: key];
            NSString *parameter = nil;
            
            // Treat arrays specially, otherwise just get the object description
            if ([rawParameter isKindOfClass:[NSArray class]]) {
                parameter = [rawParameter componentsJoinedByString:@","];
            }
            else {
                parameter = [rawParameter description];
            }
            
            // Append the parameter and its key to the full query string
            if (!thisIsTheFirstParameter)
            {
                [parametersString appendString:@"&"];
            }
            else
            {
                thisIsTheFirstParameter = NO;
            }
            [parametersString appendFormat:
             @"%@=%@",
             [key stringByAddingQueryComponentPercentEscapes],
             [parameter stringByAddingQueryComponentPercentEscapes]];
        }
    }
    return parametersString;
}

+ (NSDictionary *)parametersOfQuery:(NSString *)queryString {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    // Handle & or ; as separators, as per W3C recommendation
    NSCharacterSet *seperatorChars = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSArray *keyValues = [queryString componentsSeparatedByCharactersInSet:seperatorChars];
    NSEnumerator *theEnum = [keyValues objectEnumerator];
    NSString *keyValuePair;
    
    while (nil != (keyValuePair = [theEnum nextObject]) )
    {
        NSRange whereEquals = [keyValuePair rangeOfString:@"="];
        if (NSNotFound != whereEquals.location)
        {
            NSString *key = [keyValuePair substringToIndex:whereEquals.location];
            NSString *value = [[keyValuePair substringFromIndex:whereEquals.location+1] stringByReplacingQueryComponentPercentEscapes];
            [result setValue:value forKey:key];
        }
    }
    return result;
}

@end
