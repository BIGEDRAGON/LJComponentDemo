//
//  NSMutableArray+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/23.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "NSMutableArray+LJAdd.h"

@implementation NSMutableArray (LJAdd)

- (void)safeAddObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

@end
