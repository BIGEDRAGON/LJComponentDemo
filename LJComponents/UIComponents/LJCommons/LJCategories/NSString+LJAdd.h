//
//  NSString+LJAdd.h
//  LJCategories
//
//  Created by longlj on 2016/6/3.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMacros.h"

// 用户姓名长度限制
#define UserNameMaxLength (10)

// 手机号码长度限制
#define PhoneNumberMaxLength (11)

// 密码长度限制
#define PasswordTextMaxLength (30)

// 文本视图默认字数限制
#define TextViewDefaultMaxLength (200)

#define NotNilStr(str) (str ?: @"")
#define IntegerToStr(l) ([NSString stringWithFormat:@"%lld", (long long)(l)])
#define longljToStr(l) ([NSString stringWithFormat:@"%lld", (long long)(l)])
#define IntToStr(i) ([NSString stringWithFormat:@"%d", (int)(i)])

@interface NSString (LJAdd)

/**
 *  判断手机号格式是否正确
 */
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;
- (BOOL)isValidPhoneNumber;

- (NSString *)toDisplayCode;

// Follows RFC2396, section 3.4
- (NSString *)stringByAddingQueryComponentPercentEscapes;
- (NSString *)stringByReplacingQueryComponentPercentEscapes;

- (NSString *)toBaseUrl;

- (BOOL)isPureNumandCharacters;

//是否包含表情
- (BOOL)stringContainsEmoji;
// 过滤所有表情
- (NSString *)disableEmoji;

// 转json字符串
+ (NSString *)stringTOjson:(id)temps;

- (id)toJsonObject;

+ (instancetype)stringFromFile:(NSString *)filePath;

@end
