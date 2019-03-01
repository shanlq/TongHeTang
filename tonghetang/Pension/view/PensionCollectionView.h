//
//  PensionCollectionView.h
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import <UIKit/UIKit.h>
#import "PensionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PensionCollectionView : UICollectionView

@property (nonatomic, weak) id<PensionProtocol> vcDelegate;

-(void)loadDataToView:(id)data;

@end

NS_ASSUME_NONNULL_END
