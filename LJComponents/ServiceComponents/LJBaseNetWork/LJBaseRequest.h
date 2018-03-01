//
//  LJBaseRequest.h
//  LJNetWork
//
//  Created by longlj on 2016/7/4.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

/**
 *  请求方法类型
 */
typedef NS_ENUM(NSInteger , LJReqMethod) {
    /**
     *  GET
     */
    kLJReqMethodGet = 0,
    /**
     *  POST
     */
    kLJReqMethodPost,
    /*
     * DELETE
     */
    kLJReqMethodDelete
};

/**
 *  请求或响应数据的序列化方式
 */
typedef NS_ENUM(NSInteger , LJSerializerType) {
    /**
     *  HTTP
     */
    kLJSerializerTypeHTTP = 0,
    /**
     *  JSON
     */
    kLJSerializerTypeJSON,
};

/**
 *  基于AFNetworking的封装
 */
@interface LJBaseRequest : NSObject

/**
 *  设置基础URL
 */
+ (void)setBaseUrl:(NSString *)baseUrl;

/**
 *  初始化，使用全路径
 */
- (instancetype)initWithFullPathUrl:(NSString *)reqFullPathUrl;

/**
 *  初始化，使用相对路径
 */
- (instancetype)initWithRelativePath:(NSString *)relativePath;

@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *path;

#pragma mark - 请求配置

// 可选，Http请求方法，默认为kLJReqMethodGet
@property (nonatomic, assign) LJReqMethod methodType;

// 可选，请求参数的序列化方式，默认为kLJSerializerTypeJSON
@property (nonatomic, assign) LJSerializerType reqSerializerType;

// 可选，响应数据的序列化方式，默认为kLJSerializerTypeJSON
@property (nonatomic, assign) LJSerializerType respSerializerType;

// 可选，Multipart form Post的数据构造回调，默认为nil
@property (nonatomic, copy) void (^postConstructingBlock)(id<AFMultipartFormData> formData);

/**
 *  添加请求头部域
 */
- (void)addHeaders:(NSDictionary *)headers;
- (void)addHeader:(NSString *)header forKey:(NSString *)key;

/**
 *  添加请求参数值
 */
- (void)addParam:(id)param forKey:(NSString *)key;
- (void)addParams:(NSDictionary *)params;

// 可选，是否需要Cache，默认为NO
@property (nonatomic, assign) BOOL shouldUseCache;

// 配合shouldUseCache变量使用，默认为60秒
@property (nonatomic, assign) NSInteger cacheTimeInSeconds;

/**
 *  失败重试次数，小于等于0为不重试，默认为0，不重试
 */
@property (nonatomic, assign) NSInteger maxRetryCount;

/**
 *  接口中是否包含敏感数据，如果为YES，则不打印数据，默认为NO
 */
@property (nonatomic, assign) BOOL hasSecretParamsOrResponse;

/**
 *  可选，mock数据文件路径
 */
@property (nonatomic, copy) NSString *mockFilePath;

#pragma mark - 响应数据

/**
 *  是否正在等待响应
 */
@property (nonatomic, assign, readonly) BOOL isWaitingForResponse;

/**
 *  请求消息发送起始时间，如果重试，则为最后一次发送请求的起始时间，timeIntervalSince1970
 */
@property (nonatomic, assign) NSTimeInterval reqSendingTimestamp;

// 响应对象，失败响应或命中Cache时该字段为空
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;

// 响应数据
@property (nonatomic, strong, readonly) id responseObject;

// 是否命中Cache
@property (nonatomic, assign, readonly) BOOL isResponseFromCache;

#pragma mark - 发送请求

/**
 *  发送请求
 */
- (void)startWithSuccessCallback:(void(^)(id response, BOOL isFromCache))successCallback
                  failedCallback:(void(^)(NSInteger status, NSString *message))failedCallback
                   finalCallback:(void(^)(void))finalCallback;

/**
 *  取消请求
 */
- (void)cancel;

@end
