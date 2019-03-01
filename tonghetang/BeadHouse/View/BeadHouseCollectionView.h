//
//  BeadHouseCollectionView.h
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import <UIKit/UIKit.h>
#import "BeadHouseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeadHouseCollectionView : UICollectionView

@property (nonatomic, weak) id<BeadHouseProtocol>vcDelegate;

-(void)loadDataToView:(id)data;

@end

NS_ASSUME_NONNULL_END
