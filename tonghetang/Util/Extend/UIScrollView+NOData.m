//
//  UIScrollView+NOData.m
//  aixiaoping
//
//  Created by ZSY on 2018/9/12.
//  Copyright © 2018年 ZSY. All rights reserved.
//

#import "UIScrollView+NOData.h"

@implementation UIScrollView (NOData)

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}
-(void)showNoDataViewByData:(NSArray *)arr text:(NSString *)text
{
    if(arr.count == 0)
    {
        UIImageView *imgView = (UIImageView *)[self viewWithTag:100];
        if(!imgView)
        {
            UIImage *image = [UIImage imageNamed:@"默认背景图"];
            CGFloat height = 100*image.size.height/image.size.width;
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 100)/2, (self.height - height)/2, 100, height)];
            imgView.image = image;
            imgView.tag = 100;
            [self addSubview:imgView];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 5, self.width, 20)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = text;
            lab.tag = 101;
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = UIColorFromRGB(0x333333);
            [self addSubview:lab];
        }
    }
    else
    {
        UIImageView *imgView = (UIImageView *)[self viewWithTag:100];
        UILabel *lab = (UILabel *)[self viewWithTag:101];
        if(imgView){
            [imgView removeFromSuperview];
        }
        if(lab){
            [lab removeFromSuperview];
        }
    }
}

@end
