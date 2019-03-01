//
//  Util.m
//  LocalCache
//
//  Created by tan on 13-2-6.
//  Copyright (c) 2013年 adways. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>


@implementation Util

+ (NSString *)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

+ (NSString *)md5Hash:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}

+ (NSString *)byteToHexString:(Byte)b
{
    int n = b;
    if (n < 0)
    {
        n += 256;
    }
    

    NSArray *charArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d",
                           @"e", @"f"];
    
    NSString *str = [charArray objectAtIndex:n/16];
    NSString *str2 = [charArray objectAtIndex:n%16];
    
    return [NSString stringWithFormat:@"%@%@",str,str2];
}


+ (NSMutableString *)byteArrayToHexString:(NSData *)data
{
    NSMutableString *resultString=[[NSMutableString alloc]init];
    
    Byte *byte = (Byte *)[data bytes];
    
    for (int i = 0; i<data.length; i++) {
        
        [resultString appendString:[Util byteToHexString:byte[i]]];
    }
    return resultString;
}

+ (NSString *)str2Base32MD5:(NSString *)string
{
    NSString *str= [Util md5Hash:string];
    
    //NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSString *tempString = [Util byteArrayToHexString:data];
    
    return str;//[tempString lowercaseString];
    
}

+ (NSString *)appDecryptMobile:(NSString *)string
{
    
    NSLog(@"%@",string);
    if([string isEqual:[NSNull null]])
        return nil;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i<string.length; i++) {
        [array addObject:[string substringWithRange:NSMakeRange(i, 1)]];
    }
    
    [array exchangeObjectAtIndex:0 withObjectAtIndex:2];
    [array exchangeObjectAtIndex:1 withObjectAtIndex:3];
    
    NSMutableString *str = [[NSMutableString alloc]init];
    for (int i=0 ; i<[array count]; i++) {
        [str appendString:[array objectAtIndex:i]];
    }

    NSLog(@"%@",str);
    return [[Util str2Base32MD5:str] uppercaseString];
}

+ (UIColor *)mainColor
{
    UIColor *color = UIColorFromRGB(0xe5672d);
    return color;
}

+ (UIColor *)backgroundColor
{
    UIColor *color = RGBCOLOR(246, 246, 246);
    return color;
}

+ (UIColor *)darkGreenColor
{
    
    return UIColorFromRGB(0x004924);
}

+ (float)getHeight:(UITextView*)textView andFont:(UIFont*)font{
    
    float height = 0 ;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        
        float fPadding = 16.0; // 8.0px x 2
        
        CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
        
//        CGSize size = [textView.text sizeWithFont: font
//                                constrainedToSize:constraint
//                                    lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = [textView.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
        height = rect.size.height ;
        
    }else {
        
        height = textView.contentSize.height;
    }
    
    height += 16 ;
    
    return height;
}


+ (NSString*)getDistanceFrom:(CLLocation*)locationA andLocation:(CLLocation*)locationB{
    
    if (!locationA) {
        
        locationA = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    }
    
    CLLocationDistance distance = [locationA distanceFromLocation:locationB];
    
    MKDistanceFormatter *formatter = [[MKDistanceFormatter alloc] init];
    formatter.units = MKDistanceFormatterUnitsMetric;

    return [formatter stringFromDistance:distance];
}

+ (CGSize)GetViewSizeWithText:(NSString *)aText ViewSize:(CGSize)constraintSize FontSize:(int)fontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName : paragraphStyle };
    
    CGRect frame = [aText boundingRectWithSize:constraintSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    
    return frame.size;
}

+ (NSString *)getNumberStr:(NSString *)numberStr DecimalCount:(int)count{
    NSString * retStr = @"0";
    if (numberStr != nil){
        if (count < 0) count = 0;
        NSUInteger location = [numberStr rangeOfString:@"."].location;
        if (location != NSNotFound){
            if (location == 0){ // 
                location = 1;
                numberStr = [@"0" stringByAppendingString:numberStr];
            }
            if (numberStr.length < (location + count + 1)){
                retStr = numberStr;
            }
            else {
                retStr = [numberStr substringToIndex:(location + count + 1)];
            }
            while ([[retStr substringFromIndex:(retStr.length - 1)] isEqualToString:@"0"]){
                retStr = [retStr substringToIndex:(retStr.length - 1)];
            }
            if ([[retStr substringFromIndex:(retStr.length - 1)] isEqualToString:@"."]){
                retStr = [retStr substringToIndex:(retStr.length - 1)];
            }
        }
        else {
            retStr = numberStr;
        }
    }
    return retStr;
}

+ (NSString *)getNumberStrFloat:(float)numberFloat DecimalCount:(int)count{
    NSString * retStr = @"0";
    retStr = [NSString stringWithFormat:@"%f", numberFloat];
    retStr = [self getNumberStr:retStr DecimalCount:count];
    return retStr;
}

+ (NSString *) removeWhiteSpaceInString:(NSString *) srcString{
    if (srcString == nil){
        srcString = @"";
    }
    NSString * resultStr = [[NSString alloc] init];
    NSArray* words = [srcString componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    resultStr = [words componentsJoinedByString:@""];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return resultStr;
}

+ (NSString *) getFormatedDateStr:(NSString *) dateStr InFormat:(NSString *)fInput OutFormat:(NSString *)fOnput{
    if ((dateStr == nil) || ([dateStr isEqualToString:@""]) || (fInput == nil) || (fOnput == nil)) return @"";
    
    NSDateFormatter* dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:fInput];
    
    NSDate* date = [NSDate date];
    date = [dateformater dateFromString:dateStr];
    return [self getCurrentTime:fOnput Date:date];
}

+ (NSString*)getCurrentTime:(NSString*) formatString Date:(NSDate*) date{
    NSDate *curDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatString];
    NSString *dateString = [dateFormatter stringFromDate:curDate];
    return dateString;
}

+ (void) setExtraCellLineHidden:(UITableView * ) tableView{
    if (tableView == nil) return;
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    view = nil;
}

+ (void)presentPopUpView:(UIViewController*)aPopup FromViewCtrl:(UIViewController * ) fromViewCtrl{
    aPopup.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [WindowRootViewCtrl presentViewController:aPopup animated:NO completion:nil];
    [aPopup beginAppearanceTransition:YES animated:YES];
    aPopup.view.alpha = 0;
    [UIView animateWithDuration:.2 animations: ^{[aPopup.view setAlpha:1.0];} completion:^(BOOL finished) {
        [aPopup endAppearanceTransition];
        [aPopup didMoveToParentViewController:fromViewCtrl];
    }];
}

//判断手机号码格式是否正确

+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
        */
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            
            return YES;
            
        }else{
            
            return NO;
        }
    }
}

+(NSInteger)getInternetDate{
    
    NSString *urlString = @"http://m.baidu.com";
    
    //下面两种方式相同
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
//    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 2];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request
     
                          returningResponse:&response error:&error];
    
    
    if (error) {
        
        return [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];         //请求失败则返回手机时间（手机已处理8小时的时差）
    }
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    
    date = [date substringFromIndex:5]; //index到这个字符串的结尾
    
    date = [date substringToIndex:[date length]-4];//从索引0到给定的索引index
    
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [dMatter setDateFormat:@"dd MM yyyy HH:mm:ss"];
    
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];//时间差8小时
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//
//    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    
    NSString *timeStr = [dMatter stringFromDate:netDate];
    NSArray *timeArr = [timeStr componentsSeparatedByString:@" "];
    NSArray *arr = [timeArr.lastObject componentsSeparatedByString:@":"];
    NSInteger timeNum = [arr[0] integerValue] * 10000 + [arr[1] integerValue] * 100 + [arr[2] integerValue];
    return timeNum;
}
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


@end
