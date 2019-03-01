//
//  SearchTextField.m
//  aixiaoping
//
//  Created by ZSY on 2017/4/7.
//  Copyright © 2017年 ZSY. All rights reserved.
//

#import "SearchTextField.h"

@interface SearchTextField ()
{
    UIView * leftView;
    UIImageView * leftImgView;
}

@end

@implementation SearchTextField

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.borderStyle = UITextBorderStyleRoundedRect;
        
        leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27.5f, 35)];
        leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5f, 7.5f, 20, 20)];
        leftImgView.contentMode = UIViewContentModeCenter;
        [leftView addSubview:leftImgView];
        leftImgView.image = [UIImage imageNamed:@"chazhao"];
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.backgroundColor = [UIColorFromRGB(0xffffff) colorWithAlphaComponent:.3];
        self.placeholder = @"搜索";
        self.font = [UIFont systemFontOfSize:13.f];
        self.returnKeyType = UIReturnKeySearch;
        
        self.frame = CGRectMake(68.f, 8.f, Main_Screen_Width-135.f, 35);
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    leftView.frame = CGRectMake(0, 0, 27.5f, 35);
    leftImgView.frame = CGRectMake(7.5f, 7.5f, 20, 20);
}

@end
