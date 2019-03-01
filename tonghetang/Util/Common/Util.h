//
//  Util.h
//  LocalCache
//
//  Created by tan on 13-2-6.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Util : NSObject

+ (NSString *)sha1:(NSString *)str;
+ (NSString *)md5Hash:(NSString *)str;
/**
 *  用于登录
 *  stirng:密码
 */
+ (NSString *)str2Base32MD5:(NSString *)string;

+ (NSString *)appDecryptMobile:(NSString *)string;

+ (UIColor *)mainColor;

/**
 *  返主要深绿色
 *
 *  @return 深绿色
 */
+ (UIColor *)darkGreenColor;

+ (UIColor *)backgroundColor;


+ (float)getHeight:(UITextView*)textView andFont:(UIFont*)font;


+ (NSString*)getDistanceFrom:(CLLocation*)locationA andLocation:(CLLocation*)locationB;

+ (CGSize)GetViewSizeWithText:(NSString *)aText ViewSize:(CGSize)constraintSize FontSize:(int)fontSize;
// 显示数字
+ (NSString *) getNumberStr:(NSString *)numberStr DecimalCount:(int)count;
+ (NSString *) getNumberStrFloat:(float)numberFloat DecimalCount:(int)count;
// 清掉空文字
+ (NSString *) removeWhiteSpaceInString:(NSString *) srcString;
// 日期相关函数
+ (NSString*) getCurrentTime:(NSString*) formatString Date:(NSDate*) date;
+ (NSString *) getFormatedDateStr:(NSString *) dateStr InFormat:(NSString *)fInput OutFormat:(NSString *)fOnput;
// 去掉UITableView底部分割线
+ (void) setExtraCellLineHidden:(UITableView * ) tableView;
// 显示自定义DialogViewController
+ (void)presentPopUpView:(UIViewController*)aPopup FromViewCtrl:(UIViewController *) fromViewCtrl;
//判断手机号格式
+ (BOOL)valiMobile:(NSString *)mobile;
//获取网络“北京时间”（毫秒数）
+(NSInteger)getInternetDate;
//生成视频缩略图
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
@end
