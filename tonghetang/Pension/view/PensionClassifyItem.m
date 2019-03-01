//
//  PensionClassifyItem.m
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import "PensionClassifyItem.h"

@implementation PensionClassifyItem
{
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UILabel *_nameLab;
    __weak IBOutlet UILabel *_introduceLab;
    __weak IBOutlet UILabel *_bedNumLab;
    __weak IBOutlet UILabel *_priceLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadDataToView:(id)data
{
    NSDictionary *dic = (NSDictionary *)data;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
    _nameLab.text = dic[@"name"];
    _introduceLab.text = dic[@"description"];
    _bedNumLab.text = dic[@"bedNum"];
    _priceLab.text = [NSString stringWithFormat:@"￥%@", dic[@"price"]];
}

@end
