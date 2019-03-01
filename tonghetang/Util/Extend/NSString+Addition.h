//
//  NSString+Addition.h
//  YMFinance
//
//  Created by S.K. on 14-7-24.
//  Copyright (c) 2014年 TuanDai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Addition)

//字符串行数
- (CGFloat)getMultiLineStrHeight:(UIFont *) font andMaxWidth:(CGFloat) maxwidth;

//字符串长度
- (CGFloat)getStringWidth:(UIFont *)font;

//获取拼音
//- (NSString*)getPinyinFromHanyu;

@end
