//
//  BeadHouseProtocol.h
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BeadHouseProtocol <NSObject>

-(void)beadHouseIntroduce:(CGFloat)height;               //修改“简介”的高度
-(void)navigationToBeadHouse;                             //导航到养老院地址
-(void)laudWithCommentId:(NSString *)commentId;        //点赞
-(void)toAboutThtWebView;              //关于同和堂

@end

NS_ASSUME_NONNULL_END
