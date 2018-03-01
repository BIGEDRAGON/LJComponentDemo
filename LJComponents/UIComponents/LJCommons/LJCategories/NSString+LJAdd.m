//
//  NSString+LJAdd.m
//  LJCategories
//
//  Created by longlj on 2016/6/3.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "NSString+LJAdd.h"

@implementation NSString (LJAdd)

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber {
    return [phoneNumber isValidPhoneNumber];
}

- (BOOL)isValidPhoneNumber {
    if (self.length == 11) {
        NSString *pattern = @"^1[0-9][0-9]\\d{8}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatched = [predicate evaluateWithObject:self];
        return isMatched;
    }
    
    return NO;
}

- (NSString *)toDisplayCode {
    if (self.length == 0) {
        return @"";
    }

    NSMutableString *newCode = [[NSMutableString alloc] initWithString:NotNilStr(self)];
    NSInteger insertCount = self.length / 4;
    
    for (NSInteger index = 0; index < insertCount; ++index) {
        [newCode insertString:@" " atIndex:(5 * index + 4)];
    }
    
    return newCode;
}

/*
 
 By default, with null:
 
 encoded:		#%<>[\]^`{|}"  space
 
 Not encoded:	!$&'()*+,-./:;=?@_~
 
 
 exclamation!number%23dollar$percent%25ampersand&tick'lparen(rparen)aster*plus+space%20comma,dash-dot.slash/colon:semicolon;lessthan%3Cequals=greaterthan%3Equestion?at@lbracket%5Bbackslashl%0Dbracket%5Dcaret%5Eunderscore_backtick%60lbrace%7Bvbar%7Crbrace%7Dtilde~doublequote%22
 
 RFC2396:  Within a query component, the characters ";", "/", "?", ":", "@", "&", "=", "+", ",", and "$" are reserved.
 
 Changed to NOT convert space into + ... while this is fine for web parameters, it doesn't work on mail clients reliably (e.g. mailto:foo@bar.com?subject=Hi+There+Mom)
 
 */

- (NSString *)stringByAddingQueryComponentPercentEscapes;
{
    CFStringRef converted = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                    (CFStringRef)self,
                                                                    NULL,
                                                                    CFSTR(";/?:@&=+,$%"),
                                                                    kCFStringEncodingUTF8);
    NSString *result = (__bridge_transfer NSString *)converted;
    return result;
}

/*!	Decode a URL's query-style string, taking out the + and %XX stuff
 */
- (NSString *)stringByReplacingQueryComponentPercentEscapes
{
    NSString *ish = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *result = [ish mutableCopy];
    [result replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [result length])]; // fix + signs too!
    
    return result;
}

- (NSString *)toBaseUrl {
    NSRange rangeOfString = [self rangeOfString:@"?"];
    if (rangeOfString.length > 0) {
        return [self substringToIndex:rangeOfString.location];
    }
    else {
        return self;
    }
}

- (BOOL)isPureNumandCharacters {
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (NSString *)disableEmoji {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@""];
    return modifiedString;
}

#pragma mark--把字典和数组转换成json字符串
+ (NSString *)stringTOjson:(id)temps {
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:temps options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (id)toJsonObject {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:0
                                             error:nil];
}

+ (instancetype)stringFromFile:(NSString *)filePath {
    if (filePath.length > 0) {
        return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
    
    return nil;
}

@end
