//
//  TableViewIndexes.m
//  aixiaoping
//
//  Created by ZSY on 2018/3/4.
//  Copyright © 2018年 ZSY. All rights reserved.
//

#import "TableViewIndexes.h"

@implementation TableViewIndexes

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame WithArr:(NSArray *)indexes
{
    if(self = [super initWithFrame:frame])
    {
        _indexes = indexes;
        [self addSubview:self.tableView];
    }
    return self;
}

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _indexes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = _indexes[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(int i = 0; i < _indexes.count; i++)
    {
        NSIndexPath *otherIndexPath = [NSIndexPath indexPathWithIndex:i];
        if(otherIndexPath == indexPath)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.textColor = [UIColor redColor];
        }
        else
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:otherIndexPath];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    if(_ClickBlock)
    {
        _ClickBlock((int)indexPath.row);
    }
}
#pragma mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height/_indexes.count;
}

@end
