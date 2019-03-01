//
//  BHIntroduceView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import "BHIntroduceView.h"

@implementation BHIntroduceView
{
    __weak IBOutlet UILabel *_contentLab;
    __weak IBOutlet UIButton *_moreBtn;
    
    CGFloat _contentHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark privateMethods
+(CGSize)defaultSize:(id)data
{
    CGRect rect = [(NSString *)data boundingRectWithSize:CGSizeMake(Main_Screen_Width - 30 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    CGFloat height = CGRectGetHeight(rect)+16;
    return CGSizeMake(Main_Screen_Width, 20 + height);
}
-(void)loadDataToView:(id)data
{
    _contentLab.text = (NSString *)data;
    CGRect rect = [_contentLab.text boundingRectWithSize:CGSizeMake(_contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _contentLab.font} context:nil];
    _contentHeight = CGRectGetHeight(rect);
}

#pragma mark touchEvnet

- (IBAction)moreContent:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if(!btn.selected)
    {
        if(_contentHeight > 115 - 30 - 15)
        {
            if([_delegate respondsToSelector:@selector(beadHouseIntroduce:)]){
                [_delegate beadHouseIntroduce:_contentHeight + 15 + 30];
            }
        }
        btn.selected = YES;
    }
    else
    {
        if(_contentHeight > 115 - 30 - 15)
        {
            if([_delegate respondsToSelector:@selector(beadHouseIntroduce:)]){
                [_delegate beadHouseIntroduce:115];
            }
        }
        btn.selected = NO;
    }
}

@end
