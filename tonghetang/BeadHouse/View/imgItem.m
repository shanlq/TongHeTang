//
//  imgItem.m
//  tonghetang
//
//  Created by ZSY on 2018/12/17.
//

#import "imgItem.h"

@implementation imgItem
{
    __weak IBOutlet UIImageView *_imgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadDataToView:(id)data
{
    NSDictionary *dic = (NSDictionary *)data;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]]];
}

@end
