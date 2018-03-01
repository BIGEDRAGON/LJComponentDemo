//
//  LJNetworkProxy.m
//  LJNetWork
//
//  Created by longlj on 2016/7/4.
//  Copyright © 2016年 longlj. All rights reserved.
//

#import "LJNetworkProxy.h"
#import "LJBaseRequest.h"

#define LJ_REQ_KEY(request) ([NSString stringWithFormat:@"%p", request])

@interface LJNetworkProxy ()

@property (nonatomic, strong) NSMutableDictionary *requests;

@property (nonatomic, strong) AFHTTPSessionManager *httpResponseSession;

@property (nonatomic, strong) AFHTTPSessionManager *jsonResponseSession;

@end

@implementation LJNetworkProxy

SINGLETON_IMPL(LJNetworkProxy)

- (AFHTTPSessionManager *)httpResponseSession {
    if (!_httpResponseSession) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 15; // 设定请求超时
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        sessionConfig.URLCache = nil;
        _httpResponseSession = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:sessionConfig];
        _httpResponseSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _httpResponseSession;
}

- (AFHTTPSessionManager *)jsonResponseSession {
    if (!_jsonResponseSession) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 15; // 设定请求超时
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        sessionConfig.URLCache = nil;
        _jsonResponseSession = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:sessionConfig];
        _jsonResponseSession.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSession;
}

- (NSMutableDictionary *)requests {
    if (!_requests) {
        _requests = [NSMutableDictionary new];
    }
    return _requests;
}

- (BOOL)hasRequest:(id)request {
    if (request) {
        return [self.requests objectForKey:LJ_REQ_KEY(request)] ? YES : NO;
    }
    else {
        return NO;
    }
}

- (void)addRequest:(id)request {
    if (request) {
        [self.requests setObject:request forKey:LJ_REQ_KEY(request)];
        
        NSLog(@"sending queue size = %ld", (long)self.requests.count);
    }
}

- (void)removeRequest:(id)request {
    if (request) {
        [self.requests removeObjectForKey:LJ_REQ_KEY(request)];
        
        NSLog(@"sending queue size = %ld", (long)self.requests.count);
    }
}

- (void)cleanAll {
    for (LJBaseRequest *req in self.requests) {
        if ([req isKindOfClass:[LJBaseRequest class]]) {
            [req cancel];
        }
    }
    [self.requests removeAllObjects];
    
    NSLog(@"cancel all, sending queue size = %ld", (long)self.requests.count);
}

@end
