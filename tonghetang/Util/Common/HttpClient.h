//
//  HttpClient.h
//  Fhlpro
//
//  Created by dahuan on 15/3/27.
//  Copyright (c) 2015年 DongShenNianYi. All rights reserved.
//

#import <Foundation/Foundation.h>

//HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, HttpRequestType) {
    HttpRequestGet,
    HttpRequestPost,
    HttpRequestDelete,
    HttpRequestPut,
};

typedef void(^PrepareExecuteBlock)(void);

@interface HttpClient : NSObject

+ (HttpClient *)defaultClient;

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)requestWithPath:(NSString *)url
             parameters:(NSDictionary *)parameters
                  thumb:(NSData *)thumb
              thumbName:(NSString *)thumbName
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (BOOL)isConnectionAvailable;

/**
 * 开启网络状态监听
 */
+ (void)networkReachabilityMonitoring;
//获取参数
-(NSMutableDictionary *)getParameter:(NSDictionary *)dic;

@end
