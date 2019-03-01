//
//  Location.h
//  TongHeTang
//
//  Created by ZSY on 2018/11/26.
//  Copyright © 2018年 Shanlq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocationAuth.h>
#import <BMKLocationKit/BMKLocationManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSObject

+(instancetype)shareLocation;
-(void)configBMKLocation:(id)delegate;
-(void)location:(BMKLocatingCompletionBlock)resultCompletion;
-(void)getCityList;

@end

NS_ASSUME_NONNULL_END
