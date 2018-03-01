//
//  NSDecimalNumber+Addtion.h
//  有应用应用
//
//  Created by xuliying on 15/10/15.
//  Copyright (c) 2015年 xly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LJCalculationType) {
    LJCalculationAdd,
    LJCalculationSubtract,
    LJCalculationMultiply,
    LJCalculationDivide
};

typedef NS_ENUM(NSInteger, LJNumCompare) {
    LJNumCompareDY = NSOrderedDescending, // 大于号
    LJNumCompareXY = NSOrderedAscending, // 小于号
    LJNumCompareDD = NSOrderedSame, // 相等
};

@interface NSDecimalNumber (Addtion)

/**
 高精度加减乘除

 @param stringOrNumber1 第一个数字
 @param type            加减乘除
 @param stringOrNumber2 第二个数字
 @param handler         处理类型

 @return 对象
 */
+(NSDecimalNumber *)aDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber1 type:(LJCalculationType)type anotherDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber2 andDecimalNumberHandler:(NSDecimalNumberHandler *)handler;


/**
 2个数字的比较
 */
+(NSComparisonResult)aDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber1 compareAnotherDecimalNumberWithStringOrNumberOrDecimalNumber:(id)stringOrNumber2;


/**
 把一个数字放大或者缩小
 
 */
+(NSString *)stringWithDecimalNumber:(NSDecimalNumber *)str1 scale:(NSInteger)scale;


/**
 比较

 */
extern NSComparisonResult StrNumCompare(id str1,id str2);


/**
 处理数字
 */
extern NSDecimalNumber *handlerDecimalNumber(id strOrNum,NSRoundingMode mode,int scale);



/**
 比较
 */
extern NSComparisonResult LJ_Compare(id strOrNum1,id strOrNum2);



/**
 加减乘除
 */
extern NSDecimalNumber *LJ_Add(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *LJ_Sub(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *LJ_Mul(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *LJ_Div(id strOrNum1,id strOrNum2);



/**
 比较后返回小数字

 */
extern NSDecimalNumber *LJ_Min(id strOrNum1,id strOrNum2);
extern NSDecimalNumber *LJ_Max(id strOrNum1,id strOrNum2);


extern NSDecimalNumber *LJ_AddHandler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *LJ_SubHandler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *LJ_MulHandler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *LJ_DivHandler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);


extern NSDecimalNumber *LJ_MinHandler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);
extern NSDecimalNumber *LJ_MaxHandler(id strOrNum1,id strOrNum2,NSRoundingMode mode,int scale);


@end
