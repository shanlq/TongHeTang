//
//  classifyItem.m
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import "ClassifyItem.h"

@implementation ClassifyItem
{
    __weak IBOutlet UILabel *_contentLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadDataToView:(id)data
{
    _contentLab.text = (NSString *)data;
}

@end
