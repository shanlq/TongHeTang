//
//  HttpClient.m
//  Fhlpro
//
//  Created by dahuan on 15/3/27.
//  Copyright (c) 2015年 DongShenNianYi. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"
#import "UIImage+Scale.h"

@interface HttpClient()
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@property(nonatomic,assign) BOOL isConnect;

@end

@implementation HttpClient

static AFNetworkReachabilityManager * _reachablityManager;

- (id)init
{
    if (self = [super init])
    {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        self.manager.requestSerializer.timeoutInterval = 15;
    }
    return self;
}

+ (HttpClient *)defaultClient
{
    static HttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(NSMutableDictionary *)getParameter:(NSDictionary *)dic
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *userInfoDic = UNGetSerializedObject(USERINFO);
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [dataDic setValue:app_Version forKey:@"appVersion"];
    [dataDic setValue:UNGetObject(USER_ZONE_ID) ? UNGetObject(USER_ZONE_ID) : @"1961" forKey:@"zoneId"];
    [dataDic setValue:UNGetObject(USERLNG) ? UNGetObject(USERLNG) : @"" forKey:@"lng"];
    [dataDic setValue:UNGetObject(USERLAT) ? UNGetObject(USERLAT) : @"" forKey:@"lat"];
    [dataDic setValue:userInfoDic[@"userId"] ? userInfoDic[@"userId"] : @"" forKey:@"userId"];
    
    return dataDic;
}

///*
// *method:add another method of four request
// */
//- (void)requestPath:(NSString *)url
//             method:(NSInteger)method
//         parameters:(id)parameters prepareExecute:(PrepareExecuteBlock)prepareBlock
//            success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
//            failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure
//{
//    if ([self isConnectionAvailable]&&prepareBlock)
//    {
//        prepareBlock();
//    }
//    else{
//        [self showExceptionDialog];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil   ];
//    }
//    
//    switch (method) {
//        case HttpRequestGet:
//        {
//            [_manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//                
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                success(task,responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"%@", error);
//                failure(task,error);
//            }];
//
//        }
//            break;
//        case HttpRequestPost:
//        {
//            [_manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//                
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                success(task,responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"%@", error);
//                failure(task,error);
//            }];
//        }
//            break;
//        case HttpRequestDelete:
//        {
//            [_manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                success(task,responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"%@", error);
//                failure(task,error);
//            }];
//        }
//            break;
//        case HttpRequestPut:
//        {
//            [_manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                success(task,responseObject);
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"%@", error);
//                failure(task,error);
//            }];
//        }
//            break;
//        default:
//            break;
//    }
//
//}

- (void)requestWithPath:(NSString *)url
                 method:(NSInteger)method
             parameters:(id)parameters prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(void (^)(NSURLSessionDataTask *, id))success
                failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSLog(@"Request path:%@",url);
    
    BOOL isConnect = [self networkStatusIsReachability];
    NSDictionary * userInfo = @{@"isConnect" : @(isConnect),
                                @"url" : url
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyNetWorkStatus" object:nil userInfo:userInfo];
    
    if (isConnect) {
        if (prepareExecute) {
            prepareExecute();
        }
    }
    else{
        [self showExceptionDialog];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOTI_NETWORK_ERROR" object:nil   ];
    }
    
    switch (method) {
        case HttpRequestGet:
        {
            [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:success failure:failure];
        }
            break;
        case HttpRequestPost:
        {
            [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:success failure:failure];
        }
            break;
        case HttpRequestDelete:
        {
            [self.manager DELETE:url parameters:parameters success:success failure:failure];
        }
            break;
        case HttpRequestPut:
        {
            [self.manager PUT:url parameters:parameters success:success failure:false];
        }
            break;
        default:
            break;
    }
}

- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([self isConnectionAvailable]) {
        [self.manager HEAD:url parameters:parameters success:success failure:failure];
    }else{
        [self.manager HEAD:url parameters:parameters success:success failure:failure];
        [self showExceptionDialog];
    }
}

- (void)requestWithPath:(NSString *)url
             parameters:(NSDictionary *)parameters
                  thumb:(NSData *)thumb
              thumbName:(NSString *)thumbName
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    if ([self isConnectionAvailable])
    {
        
        if (prepare)
        {
            prepare();
        }
        
        UIImage * scaledImage = [[UIImage imageWithData:thumb] scaleToRectSize];
        NSData * data = UIImageJPEGRepresentation(scaledImage, 1.f);
        if (data.length > 100 * 1024) {
            data = UIImageJPEGRepresentation(scaledImage, 0.5f);
        }
        
        [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:data name:thumbName fileName:@"1.png" mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //
        } success:success
          failure:failure
        ];
        
    }else{
        [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:thumb name:thumbName fileName:@"1.png" mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:success failure:failure];
        
        [self showExceptionDialog];
    }
}

- (BOOL)isConnectionAvailable{
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.baidu.com/"];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    if (!self.manager) {
        self.manager =  [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    
    NSOperationQueue *operationQueue = self.manager.operationQueue;
    __weak typeof (self) weakSelf = self;
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                weakSelf.isConnect = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                weakSelf.isConnect = YES;
                break;
        }
    }];
    
    [self.manager.reachabilityManager startMonitoring];
    
    return !self.isConnect;
}

- (void)showExceptionDialog
{
    //    [[[UIAlertView alloc] initWithTitle:@"提示"
    //                                message:@"网络异常，请检查网络连接"
    //                               delegate:self
    //                      cancelButtonTitle:@"好的"
    //                      otherButtonTitles:nil, nil] show];
}


/**
 * 开启网络状态监听
 */
+ (void)networkReachabilityMonitoring {
    
    _reachablityManager = [AFNetworkReachabilityManager manager];
    [_reachablityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"网络不可用");
//                [[UIApplication sharedApplication].keyWindow.rootViewController showAlertWithMessage:@"您的网络不可用，请检查网络" SureCallback:nil];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"Wifi已开启");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"你现在使用的流量");
                break;
            }
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"你现在使用的未知网络");
                break;
            }
            default:
                break;
        }
    }];
    
    [_reachablityManager startMonitoring];
}

/**
 * 获取当前网络状态
 */
- (BOOL)networkStatusIsReachability {
    
    BOOL notReachable = _reachablityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable;
    
    if (notReachable) {
//        [[UIApplication sharedApplication].keyWindow.rootViewController showAlertWithMessage:@"您的网络不可用，请检查网络" SureCallback:nil];
    }
    return !notReachable;
}


@end
