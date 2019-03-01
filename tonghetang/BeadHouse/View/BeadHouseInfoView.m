//
//  BeadHouseInfoView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import "BeadHouseInfoView.h"
#import "SDCycleScrollView.h"

@implementation BeadHouseInfoView
{
    __weak IBOutlet SDCycleScrollView *_imgScrollView;
    __weak IBOutlet UILabel *_nameLab;
    __weak IBOutlet UIImageView *_headImgView;
    __weak IBOutlet UILabel *_addressLab;
    __weak IBOutlet UILabel *_bedNumLab;
    __weak IBOutlet UILabel *_priceLab;
    __weak IBOutlet UILabel *_contactWayLab;
    __weak IBOutlet UILabel *_distanceLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark privateMethods
+(CGSize)defaultSize
{
    return CGSizeMake(Main_Screen_Width, 170 + Main_Screen_Width*26/75);
}
-(void)loadDataToView:(id)data
{
    NSDictionary *dic = (NSDictionary *)data;
    _imgScrollView.imageURLStringsGroup = @[dic[@"topImage"]];
    _nameLab.text = dic[@"name"];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"headImage"]]];
    _addressLab.text = dic[@"address"];
    _bedNumLab.text = [NSString stringWithFormat:@"床位:%@", dic[@"bedNum"]];
    _priceLab.text = [NSString stringWithFormat:@"收费:￥%@", dic[@"price"]];
    _contactWayLab.text = [NSString stringWithFormat:@"电话:%@", dic[@"contactWay"]];
    _distanceLab.text = [NSString stringWithFormat:@"%@km", dic[@"distance"]];
}
#pragma mark touchEvent

- (IBAction)navigationToBeadHouse:(id)sender {
    
    if([_delegate respondsToSelector:@selector(navigationToBeadHouse)]){
        [_delegate navigationToBeadHouse];
    }
}

@end
