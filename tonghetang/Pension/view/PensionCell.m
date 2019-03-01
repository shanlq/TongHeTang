//
//  PensionCell.m
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import "PensionCell.h"

@implementation PensionCell
{
    __weak IBOutlet UILabel *_pensionNameLab;
    __weak IBOutlet UIImageView *_pensionImgVIew;
    __weak IBOutlet UILabel *_pensionIntroduceLab;
    __weak IBOutlet UILabel *_bedNumLab;
    __weak IBOutlet UILabel *_workerNumLab;
    __weak IBOutlet UILabel *_priceLab;
    __weak IBOutlet UILabel *_popularLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)loadDataToView:(id)data
{
    NSDictionary *dic = (NSDictionary *)data;
    _pensionNameLab.text = dic[@"name"];
    [_pensionImgVIew sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
    _pensionIntroduceLab.text = dic[@"description"];
    _bedNumLab.text = [NSString stringWithFormat:@"床位：%@", dic[@"bedNum"]];
    _workerNumLab.text = [NSString stringWithFormat:@"工作人员：%@", dic[@"staff"]];
    _priceLab.text =dic[@"price"];
    _popularLab.hidden = [dic[@"tag"] length] == 0;
    _popularLab.text = dic[@"tag"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
