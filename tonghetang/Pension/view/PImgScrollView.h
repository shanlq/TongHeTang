//
//  PImgScrollView.h
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import <UIKit/UIKit.h>
#import "PensionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PImgScrollView : UICollectionReusableView

@property (nonatomic, weak) id<PensionProtocol> delegate;

+(CGSize)defaultSize:(id)data;
-(void)loadDataToView:(id)data;

@end

NS_ASSUME_NONNULL_END
