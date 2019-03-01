//
//  UIImage+Scale.h
//  AxpSeller
//
//  Created by ZSY on 2017/2/15.
//  Copyright © 2017年 Lyra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)scaleToRectSize;

- (UIImage *)scaleToSize:(CGSize)size;

@end
