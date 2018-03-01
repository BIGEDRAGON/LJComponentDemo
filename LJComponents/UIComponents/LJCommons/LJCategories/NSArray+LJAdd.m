//
//  NSArray+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/11/18.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "NSArray+LJAdd.h"

@implementation NSArray (LJAdd)

- (id)objectAtIndexOrLast:(NSInteger)index {
    if (self.count > 0) {
        if (index < self.count && index >= 0) {
            return [self objectAtIndex:index];
        }
        else {
            return [self lastObject];
        }
    }
    return nil;
}

- (NSArray *)map:(id(^)(id element))transform {
    if (transform) {
        NSMutableArray *mappedElements = [[NSMutableArray alloc] initWithCapacity:self.count];
        for (id originalElement in self) {
            id mappedElement = transform(originalElement);
            if (mappedElement) {
                [mappedElements addObject:mappedElement];
            }
        }
        return mappedElements;
    } else {
        return self;
    }
}

- (NSArray *)filter:(BOOL(^)(id element))filter {
    if (filter) {
        NSMutableArray *filteredElements = [[NSMutableArray alloc] initWithCapacity:self.count];
        for (id originalElement in self) {
            if (filter(originalElement)) {
                [filteredElements addObject:originalElement];
            }
        }
        return filteredElements;
    } else {
        return self;
    }
}

- (NSInteger)sum:(NSInteger(^)(id element))transform {
    if (transform) {
        NSInteger sum = 0;
        for (id originalElement in self) {
            sum += transform(originalElement);
        }
        return sum;
    } else {
        return 0;
    }
}

@end
