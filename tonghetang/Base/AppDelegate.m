//
//  AppDelegate.m
//  tonghetang
//
//  Created by ZSY on 2018/6/13.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "Location.h"
#import "PensionViewController.h"
#import "GuiDeViewController.h"

#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate ()<WXApiDelegate, BMKGeneralDelegate>

@end

@implementation AppDelegate

#define NSEC_PER_SEC 1000000000ull
#define NSEC_PER_MSEC 1000000ull
#define USEC_PER_SEC 1000000ull
#define NSEC_PER_USEC 1000ull

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[TabBarViewController alloc] init];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:ISFIRSTLOGIN])
    {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[GuiDeViewController alloc] init]];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        NSDictionary *dic = UNGetObject(HomeGoodsListUrl);
        if(dic.allKeys.count == 0)
        {
            UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
            [self.window.rootViewController presentViewController:loginNavController animated:YES completion:nil];
        }
    }
    
    //微信
    [WXApi registerApp:wxappId];
    //百度定位
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    [manager start:baidappId generalDelegate:self];
    [[Location shareLocation] configBMKLocation:self];
    [[Location shareLocation] getCityList];
    
    return YES;
}

#pragma mark WXApiDelegate
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"%@", url.host);
    if ([url.host isEqualToString:@"safepay"])            //支付宝支付
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"lalalalresult = %@",resultDic);
            [self aliPayResult:resultDic];
        }];
    }
    if([url.host isEqualToString:@"oauth"] || [url.host isEqualToString:@"pay"])             //微信登录
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return true;
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])                    //登录
    {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:WXLoginCode object:nil userInfo:@{@"code": authResp.code}];
    }
    if([resp isKindOfClass:[PayResp class]])                          //支付
    {
        PayResp *payResult = (PayResp *)resp;
        switch(payResult.errCode){
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:ReloadHomeUrl object:nil];
                break;
                
            default:
                break;
        }
        [self showAlertViewWithText:payResult.errCode == 0 ? @"支付成功" : @"支付失败"];
    }
}

- (void)aliPayResult:(NSDictionary *)resultDic{
    
    NSString *alert;
    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        alert = @"支付成功";
        [[NSNotificationCenter defaultCenter] postNotificationName:ReloadHomeUrl object:nil];           //支付成功刷新链接
    }else if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]){
        alert = @"支付订单支付失败";
    }else if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
        alert = @"支付取消";
    }else if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]){
        alert = @"支付网络出错";
    }else if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]){
        alert = @"支付正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
    }else if ([resultDic[@"resultStatus"] isEqualToString:@"6004"]){
        alert = @"支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态";
    }else{
        alert = @"其它支付错误";
    }
    [self showAlertViewWithText:alert];
}

-(void)showAlertViewWithText:(NSString *)msg
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertVC dismissViewControllerAnimated:true completion:nil];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
