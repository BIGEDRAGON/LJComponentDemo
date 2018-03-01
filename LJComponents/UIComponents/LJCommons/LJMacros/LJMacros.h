//
//  LJConstant.h
//  LJCommons
//
//  Created by long on 2016/7/18.
//  Copyright © 2018年 long. All rights reserved.
//

#ifndef LJMacros_h
#define LJMacros_h

/**
 *  一些基础的宏定义
 */

// extern
#ifdef __cplusplus
#define LJKit_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define LJKit_EXTERN extern __attribute__((visibility ("default")))
#endif

// NSAssert
#define YYAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define YYAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define YYAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")

// weaks
#define WeakObject(object) __weak __typeof__(object) weak##_##object = object;
#define StrongObject(object) __typeof__(object) strong##_##object = object;
#define WS(weakSelf) __weak __typeof(self) weakSelf = self;
#define WeakSelf() __weak __typeof(self) weakSelf = self;
#define StrongSelf() __strong __typeof(weakSelf) strongSelf = weakSelf;

// singleton
// creat
#define SINGLETON_DECLARE() + (instancetype)sharedInstance;
#define SINGLETON_IMPL(cls) \
static cls *__sharedInstance; \
static dispatch_once_t onceToken; \
+ (instancetype)sharedInstance { \
dispatch_once(&onceToken, ^{ \
__sharedInstance = [[cls alloc] init]; \
}); \
return __sharedInstance; \
} \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
if (!__sharedInstance) { \
__sharedInstance = [self sharedInstance]; \
} \
return __sharedInstance; \
} \
- (id)copyWithZone:(NSZone *)zone { \
return __sharedInstance; \
}\
// destory, can be rebuild
#define DEFINE_SINGLETON_DESTORY_INTERFACE() \
+ (void)destorySharedInstance;
#define DEFINE_SINGLETON_DESTORY_IMP() \
+ (void)destorySharedInstance { \
__sharedInstance = nil; \
onceToken = 0l; \
}

// 沙盒目录文件
#define kPathDocument ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define kPathLibrary ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define kPathCache ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define kPathTemporary (NSTemporaryDirectory())

// notification center
#define REGESTER_NOTIFICATION(observer, Selector, Name) do {[[NSNotificationCenter defaultCenter] addObserver:observer selector:(Selector) name:(Name) object:nil];} while(0)
#define SELF_REG_NOTICATION(Selector, Name) REGESTER_NOTIFICATION(self, Selector, Name)
#define POST_NOTIFICATION(NotifyName, NotifyObject, NotifyUserInfo) do { [[NSNotificationCenter defaultCenter] postNotificationName:(NotifyName) object:(NotifyObject) userInfo:(NotifyUserInfo)]; } while(0)
#define REMOVE_NOTIFICATION(observer) do{[[NSNotificationCenter defaultCenter] removeObserver:observer];} while(0);

// others
#define KEYWINDOW [UIApplication sharedApplication].delegate.window
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

// value types
typedef int LJInt;          // 32 bit
typedef long long LJLong;   // 64 bit

#endif /* LJMacros_h */
