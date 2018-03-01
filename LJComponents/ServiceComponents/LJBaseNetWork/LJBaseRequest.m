//
//  LJBaseRequest.m
//  LJNetWork
//
//  Created by long on 2016/7/4.
//  Copyright © 2016年 long. All rights reserved.
//

#import "LJBaseRequest.h"
#import "LJNetworkProxy.h"
#import <CommonCrypto/CommonDigest.h>
#import "LJReachability.h"

/**
 *  请求状态
 */
typedef NS_ENUM(NSInteger, LJBaseReqStatus) {
    /**
     *  初始状态
     */
    kLJBaseReqStatusInit = 0,
    /**
     *  等待响应状态，如果收到响应或超时则转为kLJBaseReqStatusFinished，如果被取消则转为kLJBaseReqStatusCancled
     */
    kLJBaseReqStatusWaitingResp,
    /**
     *  请求被取消状态
     */
    kLJBaseReqStatusCancled,
    /**
     *  请求已完成状态
     */
    kLJBaseReqStatusFinished
};

@interface LJBaseRequest ()

@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) void(^successBaseCallback)(id response, BOOL isFromCache);
@property (nonatomic, copy) void(^failedBaseCallback)(NSInteger status, NSString *message);
@property (nonatomic, copy) void(^finalBaseCallback)(void);
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, assign) BOOL isResponseFromCache;
@property (nonatomic, assign) LJBaseReqStatus reqStatus;
@property (nonatomic, assign) NSInteger retryCount;

// 可选，全路径URL，默认为空，eg. @"https://api.weixin.qq.com/sns/oauth2/access_token"，如果reqFullPathUrl已经有值，则忽略reqRelativePath
@property (nonatomic, copy) NSString *reqFullPathUrl;

// 可选，请求的相对路径，默认为空，eg. @"/orders/fetch_my_orders"，如果reqFullPathUrl已经有值，则忽略reqRelativePath
@property (nonatomic, copy) NSString *reqRelativePath;

@end

@implementation LJBaseRequest

static NSString *__baseUrl = nil;
+ (NSString *)baseUrl {
    if (!__baseUrl) {
        return @"";
    }
    return __baseUrl;
}

+ (void)setBaseUrl:(NSString *)baseUrl {
    __baseUrl = baseUrl;
}

- (instancetype)initWithFullPathUrl:(NSString *)reqFullPathUrl {
    if (self = [super init]) {
        [self setup];
        self.reqFullPathUrl = reqFullPathUrl;
    }
    
    return self;
}

- (instancetype)initWithRelativePath:(NSString *)relativePath {
    if (self = [super init]) {
        [self setup];
        self.reqRelativePath = relativePath;
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.headers = [[NSMutableDictionary alloc] init];
    self.params = [[NSMutableDictionary alloc] init];
    self.methodType = kLJReqMethodGet;
    self.reqSerializerType = kLJSerializerTypeJSON;
    self.respSerializerType = kLJSerializerTypeJSON;
    self.shouldUseCache = NO;
    self.cacheTimeInSeconds = 60;
    self.reqStatus = kLJBaseReqStatusInit;
    self.maxRetryCount = 0;
    self.retryCount = 0;
    self.hasSecretParamsOrResponse = NO;
}

- (NSString *)url {
    if (self.reqFullPathUrl.length > 0) {
        return self.reqFullPathUrl;
    }
    else {
        return [[LJBaseRequest baseUrl] stringByAppendingString:self.reqRelativePath];
    }
}

- (NSString *)path {
    NSURL *url = [NSURL URLWithString:self.url];
    return url ? url.path : nil;
}

#pragma mark - 请求配置

- (void)addHeaders:(NSDictionary *)headers {
    if (headers) {
        [self.headers addEntriesFromDictionary:headers];
    }
}

- (void)addHeader:(NSString *)header forKey:(NSString *)key {
    if (header.length > 0 && key.length > 0) {
        self.headers[key] = header;
    }
}

- (void)addParam:(id)param forKey:(NSString *)key {
    if (param && key.length > 0) {
        self.params[key] = param;
    }
}

- (void)addParams:(NSDictionary *)params {
    if (params) {
        [self.params addEntriesFromDictionary:params];
    }
}

#pragma mark - 发送请求

- (void)startWithSuccessCallback:(void(^)(id response, BOOL isFromCache))successCallback
                  failedCallback:(void(^)(NSInteger status, NSString *message))failedCallback
                   finalCallback:(void(^)(void))finalCallback {
    self.successBaseCallback = successCallback;
    self.failedBaseCallback = failedCallback;
    self.finalBaseCallback = finalCallback;
    [self start];
}

- (void)start {
    if (self.reqStatus != kLJBaseReqStatusInit) {
        return;
    }
    
    NSLog(@"will send request [%@][%@], args = %@",
          (self.methodType == kLJReqMethodGet ? @"GET" : @"POST"),
          self.url,
          (self.hasSecretParamsOrResponse ? @"******" : self.params));
    self.reqSendingTimestamp = [[NSDate date] timeIntervalSince1970];
    
    if (self.mockFilePath.length > 0) {
        [self startWithMockFile];
    }
    else if (self.shouldUseCache) {
        WeakSelf()
        [self fetchCachedResponseObjWithBlock:^(id cachedObj) {
            if (cachedObj) {
                [weakSelf startWithCachedJson:cachedObj];
            }
            else {
                [weakSelf startWithoutCache];
            }
        }];
    }
    else {
        [self startWithoutCache];
    }
    
    [[LJNetworkProxy sharedInstance] addRequest:self];
    
    self.reqStatus = kLJBaseReqStatusWaitingResp;
}

- (NSTimeInterval)retryDelayIntervalInSec {
    static NSTimeInterval __delayTimes[3] = {5, 15, 30};
    return (self.retryCount < 3) ? __delayTimes[self.retryCount] : 60;
}

- (void)retryDelayed {
    if (self.reqStatus == kLJBaseReqStatusWaitingResp) {
        WeakSelf()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self retryDelayIntervalInSec] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf doRetry];
        });
    }
}

- (void)doRetry {
    if (self.reqStatus == kLJBaseReqStatusWaitingResp) {
        self.retryCount++;
        self.reqSendingTimestamp = [[NSDate date] timeIntervalSince1970];
        [self startWithoutCache];
        NSLog(@"Retry send request [%@], retry count = %ld", self.url, (long)self.retryCount);
    }
}

- (void)startWithCachedJson:(id)cachedJson {
    if (cachedJson) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf onSuccessFromCache:nil responseObj:cachedJson];
        });
    }
}

- (void)startWithMockFile {
    NSString *mockStr = [[NSString alloc] initWithContentsOfFile:self.mockFilePath encoding:NSUTF8StringEncoding error:nil];
    id mockObject = [NSJSONSerialization JSONObjectWithData:[mockStr dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingMutableContainers
                                                      error:nil];
    if (mockObject) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf onSuccessFromCache:nil responseObj:mockObject];
        });
    }
    else {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf onFailed:nil error:[[NSError alloc] initWithDomain:@"LJ.request.mock" code:NSURLErrorUnknown userInfo:nil]];
        });
    }
}

- (void)startWithoutCache {
    [self setupReqSerializer];
    [self setupReqHeaders];
    
    switch (self.methodType) {
        case kLJReqMethodGet:
            [self doStartGet];
            break;
        case kLJReqMethodPost:
            [self doStartPost];
            break;
        case kLJReqMethodDelete:
            [self doStartDelete];
            break;
        default:
            break;
    }
}

- (AFHTTPSessionManager *)session {
    if (self.respSerializerType == kLJSerializerTypeHTTP) {
        return [LJNetworkProxy sharedInstance].httpResponseSession;
    }
    else {
        return [LJNetworkProxy sharedInstance].jsonResponseSession;
    }
}

- (void)setupReqSerializer {
    if (self.reqSerializerType == kLJSerializerTypeHTTP) {
        self.session.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else {
        self.session.requestSerializer = [AFJSONRequestSerializer serializer];
    }
}

- (void)setupReqHeaders {
    [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [self.session.requestSerializer setValue:value forHTTPHeaderField:key];
    }];
}

- (void)doStartGet {
    __weak typeof(self) weakSelf = self;
    [self.session GET:self.url parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf onSuccessFromNet:task responseObj:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf onFailed:task error:error];
    }];
}

- (void)doStartPost {
    __weak typeof(self) weakSelf = self;
    if (self.postConstructingBlock) {
        [self.session POST:self.url parameters:self.params constructingBodyWithBlock:self.postConstructingBlock progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf onSuccessFromNet:task responseObj:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf onFailed:task error:error];
        }];
    }
    else {
        [self.session POST:self.url parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf onSuccessFromNet:task responseObj:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf onFailed:task error:error];
        }];
    }
}

- (void)doStartDelete {
    __weak typeof(self) weakSelf = self;
    [self.session DELETE:self.url parameters:self.params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf onSuccessFromNet:task responseObj:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf onFailed:task error:error];
    }];
}

- (void)cancel {
    if ([[LJNetworkProxy sharedInstance] hasRequest:self]) {
        [[LJNetworkProxy sharedInstance] removeRequest:self];
    }
    
    if (self.reqStatus == kLJBaseReqStatusWaitingResp) {
        self.reqStatus = kLJBaseReqStatusCancled;
        NSLog(@"Request [%@] cancled", self.url);
    }
}

#pragma mark - 响应

- (BOOL)isWaitingForResponse {
    return self.reqStatus == kLJBaseReqStatusWaitingResp;
}

- (void)onSuccessFromNet:(NSURLSessionDataTask * _Nullable)task responseObj:(id _Nullable)responseObj {
    [self onSuccess:task responseObj:responseObj shouldCache:self.shouldUseCache isFromCache:NO];
}

- (void)onSuccessFromCache:(NSURLSessionDataTask * _Nullable)task responseObj:(id _Nullable)responseObj {
    [self onSuccess:task responseObj:responseObj shouldCache:NO isFromCache:YES];
}

- (void)onSuccess:(NSURLSessionDataTask * _Nullable)task responseObj:(id _Nullable)responseObj shouldCache:(BOOL)shouldCache isFromCache:(BOOL)isFromCache {
    if (self.reqStatus != kLJBaseReqStatusWaitingResp) {
        return;
    }
    
    NSTimeInterval respDuration = [[NSDate date] timeIntervalSince1970] - self.reqSendingTimestamp;
    NSLog(@"[%@] recv response success, duration = %.2f, isFromCache(%@), response = %@",
            self.url, respDuration * 1000,
            (isFromCache ? @"YES" : @"NO"),
            (self.hasSecretParamsOrResponse ? @"******" : responseObj));
    
    self.response = (NSHTTPURLResponse *)task.response;
    self.responseObject = responseObj;
    self.isResponseFromCache = isFromCache;
    
    if (self.successBaseCallback) {
        self.successBaseCallback(responseObj, isFromCache);
    }
    
    if (self.finalBaseCallback) {
        self.finalBaseCallback();
    }
    
    if (shouldCache) {
        [self saveJsonResponseToCacheFile:responseObj];
    }
    
    [[LJNetworkProxy sharedInstance] removeRequest:self];
    self.reqStatus = kLJBaseReqStatusFinished;
}

- (void)onFailed:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error {
    if (self.reqStatus != kLJBaseReqStatusWaitingResp) {
        return;
    }
    
    // 失败尝试重新请求
    if (self.maxRetryCount > 0) {
        self.maxRetryCount--;
        [self retryDelayed];
        return;
    }
    
    NSTimeInterval respDuration = [[NSDate date] timeIntervalSince1970] - self.reqSendingTimestamp;
    NSLog(@"[%@] recv response failed, retry count = %ld, net connection status = %@, duration = %.2f, status code = %ld. description = %@",
          self.url, (long)self.retryCount, [LJReachability sharedInstance].connectionStatusDesc, respDuration * 1000, (long)self.response.statusCode, error.localizedDescription);
    
    self.response = (NSHTTPURLResponse *)task.response;
    
    if (self.failedBaseCallback) {
        self.failedBaseCallback(self.response.statusCode, error.localizedDescription);
    }
    
    if (self.finalBaseCallback) {
        self.finalBaseCallback();
    }
    
    [[LJNetworkProxy sharedInstance] removeRequest:self];
    self.reqStatus = kLJBaseReqStatusFinished;
}

#pragma mark - Cache

- (void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    }
    else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NSLog(@"Create cache directory failed, reason = %@", error.localizedDescription);
    }
}

- (NSString *)cacheBasePath {
    NSString *path = [kPathCache stringByAppendingPathComponent:@"LJRequestCaches"];
    [self checkDirectory:path];
    return path;
}

- (NSString *)appVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)md5StringFromString:(NSString *)string {
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)cacheFileName {
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Url:%@ Argument:%@ AppVersion:%@",
                             (long)self.methodType, self.url, self.params, [self appVersionString]];
    NSString *cacheFileName = [self md5StringFromString:requestInfo];
    return cacheFileName;
}

- (int)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        NSLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError.localizedDescription);
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}

- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

- (void)saveJsonResponseToCacheFile:(id)jsonResponse {
    if (jsonResponse && [jsonResponse isKindOfClass:[NSDictionary class]]) {
        NSString *path = [self cacheFilePath];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSKeyedArchiver archiveRootObject:jsonResponse toFile:path];
        });
    }
}

- (void)fetchCachedResponseObjWithBlock:(void(^)(id cachedObj))callback {
    if (!callback) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    if (!self.shouldUseCache || self.cacheTimeInSeconds <= 0) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    // check cache existance
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:nil]) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    // check cache time
    int seconds = [self cacheFileDuration:path];
    if (seconds < 0 || seconds > self.cacheTimeInSeconds) {
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    // load cache
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id cachedObj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(cachedObj);
            }
        });
    });
}

@end
