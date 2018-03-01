//
//  NSMutableDictionary+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/11/17.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (LJAdd)

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)safeSetValue:(id)value forKey:(NSString *)key;

@end
