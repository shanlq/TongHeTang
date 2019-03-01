//
//  TableViewIndexes.h
//  aixiaoping
//
//  Created by ZSY on 2018/3/4.
//  Copyright © 2018年 ZSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewIndexes : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *indexes;
@property (nonatomic, strong) void(^ClickBlock)(int row);

-(id)initWithFrame:(CGRect)frame WithArr:(NSArray *)indexes;

@end
