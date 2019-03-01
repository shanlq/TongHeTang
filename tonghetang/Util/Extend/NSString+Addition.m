//
//  NSString+Addition.m
//  YMFinance
//
//  Created by S.K. on 14-7-24.
//  Copyright (c) 2014年 TuanDai. All rights reserved.
//

#import "NSString+Addition.h"


@implementation NSString(Addition)

- (CGFloat)getMultiLineStrHeight:(UIFont *)font andMaxWidth:(CGFloat)maxwidth
{
    CGSize size = CGSizeZero;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        size = [self boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(maxwidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    
    return size.height;
}

- (CGFloat)getStringWidth:(UIFont *)font
{
    CGSize size = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        size = CGSizeMake(ceilf(size.width), ceilf(size.height));
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    
    return size.width;
}

//- (NSString*)getPinyinFromHanyu
//{
//    char pinyin[100] = {0};
//    for (int i=0; i<[self length]; ++i) {
//        pinyin[i] = pinyinFirstLetter([self characterAtIndex:i]);
//    }
//    
//    NSString *pinyinStr = [NSString stringWithCString:pinyin encoding:NSASCIIStringEncoding];
//    
//    return pinyinStr;
//}

@end