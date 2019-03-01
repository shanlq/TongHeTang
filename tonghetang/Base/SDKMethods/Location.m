//
//  Location.m
//  TongHeTang
//
//  Created by ZSY on 2018/11/26.
//  Copyright © 2018年 Shanlq. All rights reserved.
//

#import "Location.h"

@interface Location()<BMKLocationManagerDelegate, BMKLocationAuthDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager;

@end

@implementation Location
static Location *shareLocation;

+(instancetype)shareLocation
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if(!shareLocation){
            shareLocation = [[Location alloc] init];
        }
    });
    return shareLocation;
}
-(void)configBMKLocation:(id)delegate
{
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:baidappId authDelegate:delegate];
}
-(void)location:(BMKLocatingCompletionBlock)resultCompletion
{
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    //_locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:resultCompletion];
}
-(void)locateUserZone
{
    [self location:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        
        NSString *address = location.rgcData.district.length != 0 ? location.rgcData.district : (location.rgcData.city.length != 0 ? location.rgcData.city : location.rgcData.province);
        NSLog(@"定位城市：%@", address);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",location.location.coordinate.longitude] forKey:USERLNG];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf",location.location.coordinate.latitude] forKey:USERLAT];
        [self getUserZoneIdWithLocation:location];
    }];
}
-(void)getUserZoneIdWithLocation:(BMKLocation *)location
{
    BOOL isZhiXiaShi = location.rgcData.city.length == 0;                        //判断是否是直辖市（直辖市city为空）
    NSInteger userZoneId = 0;
    NSString *userZoneName;
    NSDictionary *dic = UNGetSerializedObject(ALLCITYDATA);
    NSArray *allCityArr = dic[@"dataList"];
    for(NSDictionary *dic in allCityArr)
    {
        if(isZhiXiaShi)
        {
            if([dic[@"level"] intValue] == 1 && [dic[@"name"] isEqualToString:location.rgcData.province])            //直辖市直接比对名字
            {
                userZoneId = [dic[@"zoneId"] integerValue];
                userZoneName = dic[@"name"];
                break;
            }
        }
        else
        {
            if(([dic[@"level"] intValue] == 3 && [dic[@"name"] isEqualToString:location.rgcData.district]))               //比对区县
            {
                for(NSDictionary *sDic in allCityArr)                                                                                 //比对城市并和县区匹配
                {
                    if(([sDic[@"level"] intValue] == 2 && [sDic[@"name"] isEqualToString:location.rgcData.city]) && [dic[@"parentZoneId"] intValue] == [sDic[@"zoneId"] intValue])
                    {
                        userZoneId = [dic[@"zoneId"] integerValue];                         //最终定位是具体的县区
                        userZoneName = dic[@"name"];
                        break;
                    }
                }
                if(userZoneName.length != 0)                             //若找到匹配的区域，则跳出外层循环
                {
                    break;
                }
                
            }
        }
    }
    NSLog(@"比对城市：%@", userZoneName);
    [[NSUserDefaults standardUserDefaults] setObject:userZoneName forKey:USER_ZONE_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger:userZoneId forKey:USER_ZONE_ID];
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUsrZone object:nil];
}
//获取城市列表数据
-(void)getCityList
{
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:UNGetObject(VERSIONCITY_ZY)?UNGetObject(VERSIONCITY_ZY):@"0" forKey:@"version"];
    [[HttpClient defaultClient] requestWithPath:THT_PS_GETCITYLIST method:HttpRequestPost parameters:param prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSString * string = dic[@"status"];
        NSDictionary * dataDic = dic[@"data"];
        if (string.integerValue==1) {
            if (dataDic.allKeys.count != 0) {
                //                NSArray * array = dataDic[@"dataList"];

                //                NSArray * hotZones = dataDic[@"hotDataList"];
                //                [[NSUserDefaults standardUserDefaults]setObject:hotZones forKey:HOT_ZONES];
                //                UNSaveSerializedObject(hotZones, HOT_ZONES);

                NSArray * cityArray = UNGetObject(CITYLIST_ZY);
                BOOL shouldLocate = !cityArray || cityArray.count <= 0;

                NSString * string = [NSString stringWithFormat:@"%@",dataDic[@"version"]];
                [[NSUserDefaults standardUserDefaults]setObject:string forKey:VERSIONCITY_ZY];
                [[NSUserDefaults standardUserDefaults]synchronize];

                UNSaveSerializedObject(dataDic, ALLCITYDATA);

                if (shouldLocate) {
                    [self locateUserZone];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

#pragma mark delegate
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError
{
    NSLog(@"百度定位鉴权状态：%d", (int)iError);
}
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error
{
    NSLog(@"百度定位失败");
}
@end
