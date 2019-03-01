//
//  BHActivityView.h
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import <UIKit/UIKit.h>
#import "BeadHouseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BHActivityView : UICollectionReusableView

@property (nonatomic, weak) id<BeadHouseProtocol> delegate;
@property (nonatomic, strong) void(^typeSelectBlock)(int type);

-(CGSize)defaultSize:(id)introduceData evaluate:(id)evaluateData type:(int)type;

@end

NS_ASSUME_NONNULL_END
