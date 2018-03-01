//
//  NSArray+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/11/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LJAdd)

- (id)objectAtIndexOrLast:(NSInteger)index;

- (NSArray *)map:(id(^)(id element))transform;

- (NSArray *)filter:(BOOL(^)(id element))filter;

- (NSInteger)sum:(NSInteger(^)(id element))transform;

@end
