//
//  UIImage+Scale.m
//  AxpSeller
//
//  Created by ZSY on 2017/2/15.
//  Copyright © 2017年 Lyra. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

- (UIImage *)scaleToRectSize {
    
    return [self scaleToSize:CGSizeMake(640, 640)];
}

- (UIImage *)scaleToSize:(CGSize)size {
    
    /// 以屏幕scale为参数不失真
//    UIGraphicsBeginImageContextWithOptions(size, true, [UIScreen mainScreen].scale);
    /// 失真压缩处理
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
