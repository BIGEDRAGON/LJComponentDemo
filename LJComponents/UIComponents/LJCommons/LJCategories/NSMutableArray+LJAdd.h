//
//  NSMutableArray+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/23.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LJAdd)

/**
 *  如果object为nil，则忽略
 */
- (void)safeAddObject:(id)object;

@end
