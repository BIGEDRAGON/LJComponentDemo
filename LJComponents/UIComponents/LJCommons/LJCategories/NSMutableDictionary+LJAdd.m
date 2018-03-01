//
//  NSMutableDictionary+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/11/17.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "NSMutableDictionary+LJAdd.h"

@implementation NSMutableDictionary (LJAdd)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)safeSetValue:(id)value forKey:(NSString *)key {
    if (value && key.length > 0) {
        [self setValue:value forKey:key];
    }
}

@end
