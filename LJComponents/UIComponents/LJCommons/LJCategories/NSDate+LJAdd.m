//
//  NSDate+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/3.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "NSDate+LJAdd.h"
#import "NSString+LJAdd.h"

@implementation NSDate (LJAdd)

#pragma mark - Common

/**
 *  默认8时区
 */
+ (NSTimeZone *)defaultTimeZone {
    return [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
}

/**
 *  默认日历，默认时区
 */
+ (NSCalendar *)defaultCanlendar {
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    canlendar.timeZone = [NSDate defaultTimeZone];
    return canlendar;
}

#pragma mark - 字符串与日期转换

// 格式yyyy-MM-dd hh:mm:ss，默认为8时区
+ (NSDateFormatter *)defaultDateFormatter {
    static NSDateFormatter *__defaultDateFormatter = nil;
    static dispatch_once_t __once4defaultDate;
    dispatch_once(&__once4defaultDate, ^{
        __defaultDateFormatter = [[NSDateFormatter alloc] init];
        [__defaultDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        __defaultDateFormatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return __defaultDateFormatter;
}

+ (NSDate *)fromDateString:(NSString *)dateString {
    return [[self defaultDateFormatter] dateFromString:dateString];
}

- (NSString *)toDateString {
    return [[self.class defaultDateFormatter] stringFromDate:self];
}

- (NSString *)toYMDHmsString {
    static NSDateFormatter *__YMDHmsFormatter = nil;
    static dispatch_once_t YMDHmsOnceToken;
    dispatch_once(&YMDHmsOnceToken, ^{
        __YMDHmsFormatter = [[NSDateFormatter alloc] init];
        [__YMDHmsFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        __YMDHmsFormatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__YMDHmsFormatter stringFromDate:self];
}

- (NSString *)toYMDString {
    static NSDateFormatter *__yyyyMMdd2Formatter = nil;
    static dispatch_once_t yyyyMMdd2OnceToken;
    dispatch_once(&yyyyMMdd2OnceToken, ^{
        __yyyyMMdd2Formatter = [[NSDateFormatter alloc] init];
        [__yyyyMMdd2Formatter setDateFormat:@"yyyy.MM.dd"];
        __yyyyMMdd2Formatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__yyyyMMdd2Formatter stringFromDate:self];
}

- (NSString *)toYMDZhString {
    static NSDateFormatter *__yyyyMMdd2Formatter = nil;
    static dispatch_once_t yyyyMMdd2OnceToken;
    dispatch_once(&yyyyMMdd2OnceToken, ^{
        __yyyyMMdd2Formatter = [[NSDateFormatter alloc] init];
        [__yyyyMMdd2Formatter setDateFormat:@"yyyy年MM月dd日"];
        __yyyyMMdd2Formatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__yyyyMMdd2Formatter stringFromDate:self];
}

- (NSString *)tommssString {
    static NSDateFormatter *__mmssFormatter = nil;
    static dispatch_once_t mmssOnceToken;
    dispatch_once(&mmssOnceToken, ^{
        __mmssFormatter = [[NSDateFormatter alloc] init];
        [__mmssFormatter setDateFormat:@"mm:ss"];
        __mmssFormatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__mmssFormatter stringFromDate:self];
}

- (NSString *)toHHmmString {
    static NSDateFormatter *__HHmmFormatter = nil;
    static dispatch_once_t HHmmOnceToken;
    dispatch_once(&HHmmOnceToken, ^{
        __HHmmFormatter = [[NSDateFormatter alloc] init];
        [__HHmmFormatter setDateFormat:@"HH:mm"];
        __HHmmFormatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__HHmmFormatter stringFromDate:self];
}

- (NSString *)toYMDHmStringCn {
    static NSDateFormatter *__YMDhmExFormatter = nil;
    static dispatch_once_t YMDhmExOnceToken;
    dispatch_once(&YMDhmExOnceToken, ^{
        __YMDhmExFormatter = [[NSDateFormatter alloc] init];
        [__YMDhmExFormatter setDateFormat:@"Y年M月d日 HH:mm"];
        __YMDhmExFormatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__YMDhmExFormatter stringFromDate:self];
}

- (NSString *)toMDHmStringCn {
    static NSDateFormatter *__MDhmExFormatter = nil;
    static dispatch_once_t MDhmExOnceToken;
    dispatch_once(&MDhmExOnceToken, ^{
        __MDhmExFormatter = [[NSDateFormatter alloc] init];
        [__MDhmExFormatter setDateFormat:@"M月d日 HH:mm"];
        __MDhmExFormatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__MDhmExFormatter stringFromDate:self];
}

- (NSString *)toMDStringCn {
    static NSDateFormatter *__MDExFormatter = nil;
    static dispatch_once_t MDExOnceToken;
    dispatch_once(&MDExOnceToken, ^{
        __MDExFormatter = [[NSDateFormatter alloc] init];
        [__MDExFormatter setDateFormat:@"M月d日"];
        __MDExFormatter.timeZone = [NSDate defaultTimeZone];
    });
    
    return [__MDExFormatter stringFromDate:self];
}

#pragma mark - 日历相关

- (NSString *)fm_weekDay {
    static NSArray *__weekDays = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __weekDays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    });
    
    NSInteger weekDay = [[[NSDate defaultCanlendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
    
    return __weekDays[(weekDay - 1) % 7];
}

- (BOOL)isSameYearWith:(NSDate *)date {
    if (!date) {
        return NO;
    }
    NSInteger selfYear = [[NSDate defaultCanlendar] component:NSCalendarUnitYear fromDate:self];
    NSInteger dateYear = [[NSDate defaultCanlendar] component:NSCalendarUnitYear fromDate:date];
    
    return selfYear == dateYear;
}

- (BOOL)isSameDayWith:(NSDate *)date {
    if (!date) {
        return NO;
    }
    NSCalendar* calendar = [NSDate defaultCanlendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year]  == [comp2 year];
}

- (NSInteger)countDaysInThisMonth {
    NSRange daysInOfMonth = [[NSDate defaultCanlendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return daysInOfMonth.length;
}

+ (NSDate *)fromMonth:(NSInteger)monthNum andDay:(NSInteger)dayNum {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.month = monthNum;
    comps.day = dayNum;
    
    NSCalendar *calendar = [NSDate defaultCanlendar];
    
    return [calendar dateFromComponents:comps];
}

// 2016-07-22 16:00:00 +0000   ---> year 2016 month 7
- (NSInteger)monthNum {
    NSInteger year = [[NSDate defaultCanlendar] component:NSCalendarUnitYear fromDate:self];
    NSInteger month = [[NSDate defaultCanlendar] component:NSCalendarUnitMonth fromDate:self];
    return (year - 1) * 12 + month;
}

- (NSInteger)firstWeekdayInThisMonth {
    NSCalendar *calendar = [NSDate defaultCanlendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSString *)toDayNumStr {
    NSDateComponents *components = [[NSDate defaultCanlendar] components:NSCalendarUnitDay fromDate:self];
    return IntegerToStr([components day]);
}

+ (NSString *)toYearMonthFromMonthNum:(NSInteger)monthNum {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.month = monthNum;
    
    NSCalendar *calendar = [NSDate defaultCanlendar];
    
    NSDate *date = [calendar dateFromComponents:comps];
    
    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:date];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    
    return [NSString stringWithFormat:@"%ld年%ld月", (long)year, (long)month];
}

#pragma mark - 辅助方法

- (BOOL)isEarlierThan:(NSDate *)date {
    if (!date) {
        return NO;
    }
    
    return [self timeIntervalSinceDate:date] < 0;
}

- (BOOL)isEarlierThanOrEqual:(NSDate *)date {
    if (!date) {
        return NO;
    }
    
    return [self timeIntervalSinceDate:date] <= 0;
}

- (BOOL)isLaterThan:(NSDate *)date {
    if (!date) {
        return NO;
    }
    
    return [self timeIntervalSinceDate:date] > 0;
}

- (BOOL)isLaterThanOrEqual:(NSDate *)date {
    if (!date) {
        return NO;
    }
    
    return [self timeIntervalSinceDate:date] >= 0;
}

@end
