//
//  UIButton+TouchZone.h
//  AiXiaoPing
//
//  Created by ZSY on 2018/2/6.
//  Copyright © 2018年 ZSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TouchZone)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

- (void)setEnlargeEdge:(CGFloat) size;  

@end
