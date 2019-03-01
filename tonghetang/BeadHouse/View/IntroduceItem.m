//
//  IntroduceItem.m
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import "IntroduceItem.h"

@implementation IntroduceItem
{
    __weak IBOutlet UILabel *_introduceLab;
    __weak IBOutlet UIImageView *_ImgView;
    __weak IBOutlet NSLayoutConstraint *_introduceLabHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)loadDataToView:(id)data
{
    NSDictionary *dic = (NSDictionary *)data;
    if([dic[@"type"] intValue] == 1)
    {
        _introduceLab.text = dic[@"text"];
        _ImgView.hidden = YES;
    }
    else
    {
        [_ImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"picture"]]];
        _introduceLabHeight.constant = 0;
        _introduceLab.hidden = YES;
    }
}

@end
