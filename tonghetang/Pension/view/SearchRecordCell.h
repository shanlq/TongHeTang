//
//  SearchRecordCell.h
//  aixiaoping
//
//  Created by ZSY on 2017/4/20.
//  Copyright © 2017年 ZSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchRecordDelegate <NSObject>

- (void)singleRecordClear:(NSString *)record;

@end

@interface SearchRecordCell : UITableViewCell

@property (nonatomic, copy) NSString * record;
@property (nonatomic, weak) id<SearchRecordDelegate> delegate;

-(void)LoadDataToViewWithRecord:(NSString *)record;

@end
