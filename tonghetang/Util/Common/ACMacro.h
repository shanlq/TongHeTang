//
//  ACMacros.h
//

#ifndef ACMacros_h
#define ACMacros_h

//** globle ***********************************************************************************
#define ShareDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define WindowRootViewCtrl ((UIViewController*)[UIApplication sharedApplication].keyWindow.rootViewController)

//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/* ****************************************************************************************************************** */
/** DEBUG LOG **/


#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else


#define NSLog(...)

#define DLog( s, ... )

#endif


/** DEBUG RELEASE **/
#if DEBUG

#define MCRelease(x)            [x release]

#else

#define MCRelease(x)            [x release], x = nil

#endif


/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil


/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)
//导航条高度
#define BARHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.height


/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES];\
                                [View.layer setBorderWidth:(Width)];\
                                [View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 960), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 1136), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)

#define isiPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)


// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
                                \
                                [_OBJECT viewWithTag : _TAG]


#ifdef __IPHONE_6_0 // iOS6 and later
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#   define UITextAlignmentLeft      NSTextAlignmentLeft
#   define UITextAlignmentRight     NSTextAlignmentRight
#   define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#   define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#endif

//iphonex适配
#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)



#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

// ARC
#if __has_feature(objc_arc)
/** Compiling with ARC */
#else
/** Compiling without ARC */
#endif



#define ALERT(msg) (msg ? [[[CustomAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show] : [[[CustomAlertView alloc] initWithTitle:nil message:@"加载失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show])

//NSUserDefault 存取数据
#define UNSaveObject(obj,key) \
[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \

#define UNSaveInteger(obj,key) \
if(key){ \
[[NSUserDefaults standardUserDefaults] setInteger:obj forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}

#define UNGetInteger(key)   [[NSUserDefaults standardUserDefaults] integerForKey:key]

#define UNGetObject(key)    [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define UNSaveBool(obj,key) \
if(key){ \
[[NSUserDefaults standardUserDefaults] setBool:obj forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}
#define UNGetBool(key)    [[NSUserDefaults standardUserDefaults] boolForKey:key]


//NSUserDefault 序列化存取数据
#define UNSaveSerializedObject(obj,key) \
NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:obj];\
if(serialized){ \
[[NSUserDefaults standardUserDefaults] setObject:serialized forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; \
}

#define UNGetSerializedObject(key)  ([[NSUserDefaults standardUserDefaults] objectForKey:key] ? [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:key]] : nil)

//NSUserDefault 删除数据
#define UNDeletedSerializedObject(key) { [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]; \
}


#define SafeString(string)  string? string:@""

//城市选择
#define USERLNG @"userLng"
#define USERLAT @"userLat"
#define ALLCITYDATA @"allCityData"
#define USER_ZONE_NAME  @"USER_ZONE_NAME"
#define USER_ZONE_ID    @"USER_ZONE_ID"
#define USER_LOCATION @"LASTLOCATION"
#define USER_CITY @"MyCity"
#define USER_QU @"MyQu"
#define USER_CITY_ID @"MyCityID"
#define AECHANGECITYNOTIFICATION @"ChangeCity"     //列表选择城市
#define VERSIONCITY_ZY @"version"                  //城市列表的版本号
#define CITYLIST_ZY @"全部城市列表数据"
#define HOT_ZONES   @"HOT_ZONES"                  //热门城市
#define ALLCITYDATA @"allCityData"                //“获取城市列表”接口的所有返回数据
//通知
#define LocationUsrZone @"locationUserZoneAddress"         //定位zone

#endif
