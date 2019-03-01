//
//  EvaluateItem.h
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EvaluateItem : UICollectionViewCell

@property (nonatomic, strong) void(^laudBlock)(id data);

-(void)loadDataToView:(id)data;

@end

NS_ASSUME_NONNULL_END
