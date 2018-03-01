//
//  NSDate+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/3.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LJAdd)

#pragma mark - 字符串与日期转换

/**
 *  字符串转日期，字符串格式"yyyy-MM-dd hh:mm:ss"，时区为北京时间(8时区)
 */
+ (NSDate *)fromDateString:(NSString *)dateString;

/**
 *  日期转字符串，字符串格式"yyyy-MM-dd hh:mm:ss"，时区为北京时间(8时区)
 */
- (NSString *)toDateString;

/**
 *  日期转字符串，字符串格式"yyyy.MM.dd hh:mm:ss"，时区为北京时间(8时区)
 */
- (NSString *)toYMDHmsString;

/**
 *  日期转字符串，字符串格式"yyyy.MM.dd"，时区为北京时间(8时区)
 */
- (NSString *)toYMDString;

/**
 *  日期转字符串，字符串格式"yyyy年MM月dd日"，时区为北京时间(8时区)
 */
- (NSString *)toYMDZhString;

/**
 *  日期转字符串，字符串格式"HH:mm"
 */
- (NSString *)toHHmmString;
/**
 *  日期转字符串，字符串格式"mm:ss"
 */
- (NSString *)tommssString;

/**
 *  日期转字符串，字符串格式"2016年6月8日 12:23"
 */
- (NSString *)toYMDHmStringCn;

/**
 *  日期转字符串，字符串格式"6月8日 12:23"
 */
- (NSString *)toMDHmStringCn;

/**
 *  日期转字符串，字符串格式"6月8日"
 */
- (NSString *)toMDStringCn;

#pragma mark - 日历相关

- (BOOL)isSameYearWith:(NSDate *)date;

- (BOOL)isSameDayWith:(NSDate *)date;

// 返回星期几的字符串
- (NSString *)fm_weekDay;

/**
 *  返回当月的日期总数
 */
- (NSInteger)countDaysInThisMonth;

/**
 *  将月数日数转换成时间
 */
+ (NSDate *)fromMonth:(NSInteger)monthNum andDay:(NSInteger)dayNum;

/**
 *  返回月数
 */
- (NSInteger)monthNum;

/**
 *  计算当月第一天是星期几
 *
 *  @return index of @[Sun, Mon, Thes, Wed, Thur, Fri, Sat]
 */
- (NSInteger)firstWeekdayInThisMonth;

/**
 *  返回在当月日数, [1...31]
 */
- (NSString *)toDayNumStr;

/**
 *  将月数转换成yyyy年MM月格式的字符串
 */
+ (NSString *)toYearMonthFromMonthNum:(NSInteger)monthNum;

#pragma mark - 辅助方法

- (BOOL)isEarlierThan:(NSDate *)date;
- (BOOL)isEarlierThanOrEqual:(NSDate *)date;
- (BOOL)isLaterThan:(NSDate *)date;
- (BOOL)isLaterThanOrEqual:(NSDate *)date;

@end
