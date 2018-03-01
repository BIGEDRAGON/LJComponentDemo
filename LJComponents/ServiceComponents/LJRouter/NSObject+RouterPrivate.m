//
//  NSObject+routerPrivate.m
//  LJRouter
//
//  Created by long on 2017/12/8.
//  Copyright © 2017年 long. All rights reserved.
//

#import "NSObject+RouterPrivate.h"
#import <objc/runtime.h>

NSString * const RouterNotFoundErrorDomain         = @"RouterNotFoundErrorDomain";
NSString * const RouterSelectorNotFoundErrorDomain = @"RouterSelectorNotFoundErrorDomain";

/**
 * 基本类型和对象pointer类型
 */
typedef NS_ENUM(NSInteger,RouterArgumentType) {
    RouterArgumentType_None,
    RouterArgumentType_Pointer,
    RouterArgumentType_Bool,
    RouterArgumentType_Float,
    RouterArgumentType_Double,
    RouterArgumentType_Integer,
    RouterArgumentType_UInteger,
};

RouterArgumentType RouterArgumentTypeForTypeChar(char argType);

@implementation NSObject (RouterPrivate)

- (void)notifyRouterSuccessed:(void(^)(id))successed withValue:(id)value {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (successed) {
            successed(value);
        }
    });
}

- (void)notifyRouterNotFoundFailed:(void(^)(NSError *error))failed
                     withFailedMsg:(NSString *)failedMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (failed) {
            failed([NSError errorWithDomain:RouterNotFoundErrorDomain code:(-100) userInfo:@{NSLocalizedDescriptionKey: failedMsg}]);
        }
    });
}

- (void)notifyRouterSelectorNotFoundFailed:(void(^)(NSError *error))failed
                     withFailedMsg:(NSString *)failedMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (failed) {
            failed([NSError errorWithDomain:RouterSelectorNotFoundErrorDomain code:(-101) userInfo:@{NSLocalizedDescriptionKey: failedMsg}]);
        }
    });
}

/**
 1.拿到实例 或者 类 method 得到方法签名
 2.实例invoke
 3.拿到参数类型 ，进行参数赋值
 4.调用invoke 执行方法
 5.拿到返回值 并返回
 */
+ (id)performSelector:(SEL)sel withParams:(NSArray *)params {
    return [self performSelector:sel withParams:params designObj:nil];
}

+ (id)performSelector:(SEL)sel withParams:(NSArray *)params designObj:(id)obj {
    
    id target = nil;
    Method clsMethod = class_getClassMethod(self, sel);
    if (clsMethod) {
        target = self;
    }else {
        clsMethod = class_getInstanceMethod(self, sel);
        target = obj ? obj : [[self alloc] init];
    }
    
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:sel];
    
    if (!methodSignature) return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:target];
    [invocation setSelector:sel];
    
    if (params != nil && ![params isKindOfClass:[NSNull class]]) {
        // numberOfArguments是包含 target 和 selector 的,真正的参数是从第二个开始的
        NSUInteger methodArgsCount = methodSignature.numberOfArguments-2;
        NSUInteger count = MIN(methodArgsCount, params.count);
        for (NSInteger i = 0; i < count; i++) {
            
            NSInteger index = i + 2;
            const char *typeChar =  [methodSignature getArgumentTypeAtIndex:index];
            RouterArgumentType type = RouterArgumentTypeForTypeChar(typeChar[0]);
            
            id value = params[i];
            
            [self setArgument:value withType:type atIndex:index forInvocation:invocation];
        }
    }
    
    [invocation invoke];
    
    NSUInteger length = [methodSignature methodReturnLength];
    if (length) {
        const char *returnType = methodSignature.methodReturnType;
        RouterArgumentType type = RouterArgumentTypeForTypeChar(returnType[0]);
        
        void *buffer = (void *)malloc(length);
        return [self getReturnValueBuffer:buffer WithType:type forInvocation:invocation];
    }
    return nil;
}

+ (void)setArgument:(id)argument
           withType:(RouterArgumentType)type
            atIndex:(NSInteger)index
      forInvocation:(NSInvocation *)invocation {
    
    if (argument == [NSNull null])
        argument = nil;
    if (argument == nil && type != RouterArgumentType_Pointer)
        argument = @"0";
    
    switch (type) {
        case RouterArgumentType_None:
            break;
        case RouterArgumentType_Integer: {
            int val = [argument intValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
        case RouterArgumentType_UInteger: {
            long long val = [argument unsignedIntegerValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
        case RouterArgumentType_Bool: {
            BOOL val = [argument boolValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
        case RouterArgumentType_Float: {
            float val = [argument floatValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
        case RouterArgumentType_Double: {
            double val = [argument doubleValue];
            [invocation setArgument:&val atIndex:index];
            break;
        }
        case RouterArgumentType_Pointer: {
            [invocation setArgument:&argument atIndex:index];
            break;
        }
    }
}

+ (__unsafe_unretained id)getReturnValueBuffer:(void *)buffer
                                      WithType:(RouterArgumentType)type
                                 forInvocation:(NSInvocation *)invocation {
    __unsafe_unretained id returnValue;
    [invocation getReturnValue:buffer];
    switch (type) {
        case RouterArgumentType_None:
            break;
        case RouterArgumentType_Integer: {
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
            break;
        }
        case RouterArgumentType_UInteger: {
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
            break;
        }
        case RouterArgumentType_Bool: {
            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
            break;
        }
        case RouterArgumentType_Float: {
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
            break;
        }
        case RouterArgumentType_Double: {
            returnValue = [NSNumber numberWithDouble:*((double*)buffer)];
            break;
        }
        case RouterArgumentType_Pointer: {
            [invocation getReturnValue:&returnValue];
        }
    }
    return returnValue;
}

RouterArgumentType RouterArgumentTypeForTypeChar(char argType) {
    switch (argType) {
        case 'i':
        case 's':
        case 'l':
        case 'c':
        case 'I':
        case 'S':
        case 'L':
        case 'C': {
            return RouterArgumentType_Integer;
        }
        case 'q':
        case 'Q': {
            return RouterArgumentType_UInteger;
        }
        case 'f': {
            return RouterArgumentType_Float;
        }
        case 'd': {
            return RouterArgumentType_Double;
            
        }
        case 'B': {
            return RouterArgumentType_Bool;
        }
        default: {
            return RouterArgumentType_Pointer;
        }
    }
}

@end
