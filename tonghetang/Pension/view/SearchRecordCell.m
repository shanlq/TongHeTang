//
//  SearchRecordCell.m
//  aixiaoping
//
//  Created by ZSY on 2017/4/20.
//  Copyright © 2017年 ZSY. All rights reserved.
//

#import "SearchRecordCell.h"

@interface SearchRecordCell ()
{
    __weak IBOutlet UILabel *_recordLabel;
    __weak IBOutlet UIButton *_deleteRecord;
}

@end

@implementation SearchRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)recordClear:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(singleRecordClear:)]) {
        [self.delegate singleRecordClear:_record];
    }
}

-(void)LoadDataToViewWithRecord:(NSString *)record
{
    _record = [record copy];
    _recordLabel.text = _record;
    if([record isEqualToString:@"全部"]){
        _deleteRecord.hidden = YES;
    }
}

- (void)setRecord:(NSString *)record {
    
    _record = [record copy];
    _recordLabel.text = _record;
}

@end
