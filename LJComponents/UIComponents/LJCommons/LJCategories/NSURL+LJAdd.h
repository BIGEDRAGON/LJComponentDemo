//
//  NSURL+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/7/6.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (LJAdd)

// It's common to use the query part of a URL for a dictionary-like series of parameters. This method will decode that for you, including handling strings which were escaped to fit the scheme
- (NSDictionary *)queryParameters;

// To do the reverse, construct a dictonary for the query and pass into either of these methods. You can base the result off of an existing URL, or specify all the components.
- (NSURL *)URLWithQueryParameters:(NSDictionary *)parameters;
+ (NSURL *)URLWithScheme:(NSString *)scheme
                       host:(NSString *)host
                       path:(NSString *)path
            queryParameters:(NSDictionary *)parameters;

// Primitive methods for if you need tighter control over handling query dictionaries
+ (NSString *)queryWithParameters:(NSDictionary *)parameters;
+ (NSDictionary *)parametersOfQuery:(NSString *)queryString;

@end
