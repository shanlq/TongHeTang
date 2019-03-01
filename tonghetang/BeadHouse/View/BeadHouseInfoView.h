//
//  BeadHouseInfoView.h
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import <UIKit/UIKit.h>
#import "BeadHouseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeadHouseInfoView : UICollectionReusableView

@property (nonatomic, weak) id<BeadHouseProtocol>delegate;

+(CGSize)defaultSize;
-(void)loadDataToView:(id)data;

@end

NS_ASSUME_NONNULL_END
