//
//  PensionProtocol.h
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PensionProtocol <NSObject>

//养老院列表
-(void)toBeadHouseListWithTypeId:(NSString *)typeId title:(NSString *)title;
//同和堂介绍
-(void)toIntroduce:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
