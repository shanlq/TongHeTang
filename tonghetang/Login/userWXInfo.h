//
//  userWXInfo.h
//  tonghetang
//
//  Created by ZSY on 2018/6/15.
//

#import <Foundation/Foundation.h>

@interface userWXInfo : NSObject

/*@"unionid":info[@"unionid"],
 @"openid" : info[@"openid"],
 @"nickname" : info[@"nickname"],
 @"headimgurl" : info[@"headimgurl"],
 @"phone" : @""*/

@property (nonatomic, strong) NSString *unionid;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headimgurl;

@end
