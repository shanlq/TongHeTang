//
//  UIView+Frame.h
//  折线图1
//
//  Created by ZSY on 2017/2/21.
//  Copyright © 2017年 Lyra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**
 * origin中x值
 */
@property (nonatomic, assign) CGFloat x;
/**
 * origin中y值
 */
@property (nonatomic, assign) CGFloat y;
/**
 * size中width值
 */
@property (nonatomic, assign) CGFloat width;
/**
 * size中height值
 */
@property (nonatomic, assign) CGFloat height;
/**
 * center中x值
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 * origin中y值
 */
@property (nonatomic, assign) CGFloat centerY;
/**
 * size
 */
@property (nonatomic, assign) CGSize size;
/**
 * origin
 */
@property (nonatomic, assign) CGPoint origin;
/**
 * top 最小y值
 */
@property (nonatomic, assign) CGFloat top;
/**
 * left 最小x值
 */
@property (nonatomic, assign) CGFloat left;
/**
 * bottom 最大y值
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 * right 最大x值
 */
@property (nonatomic, assign) CGFloat right;

@end
