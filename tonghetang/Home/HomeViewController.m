//
//  HomeViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/6/13.
//

#import "HomeViewController.h"
#import "GoodsViewController.h"
#import "LoginViewController.h"
#import <WebKit/WebKit.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CitySwitchViewController.h"
#import "PensionViewController.h"
#import "ZYSettingViewController.h"

@interface HomeViewController ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *homeWebView;

@end

@implementation HomeViewController
{
    UIProgressView *_progressView;
    NSString *_currentCity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationZone) name:LocationUsrZone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebUrl) name:ReloadHomeUrl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebUrl) name:@"HomeReload" object:nil];
    self.titleText.text = @"易络淘";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.homeWebView];
    _currentCity = UNGetObject(USER_ZONE_NAME) ? UNGetObject(USER_ZONE_NAME) : @"选择城市";
    [self setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, 100, 44) title:_currentCity imageName:@"xiadebiaozhi" target:self action:@selector(selectAddress)];
    
    NSString *homeUrl = [(NSDictionary *)UNGetObject(HomeGoodsListUrl) objectForKey:@"home"];
    if(homeUrl.length != 0)
    {
        [self reloadWebUrl];
    }
}

-(void)dealloc
{
    [self.homeWebView.configuration.userContentController removeScriptMessageHandlerForName:@"LINK_RELOAD"];
    [self.homeWebView.configuration.userContentController removeScriptMessageHandlerForName:@"PENSION"];
    [self.homeWebView.configuration.userContentController removeScriptMessageHandlerForName:@"WXPay"];
    [self.homeWebView.configuration.userContentController removeScriptMessageHandlerForName:@"ZFBPay"];
//    [self.homeWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark nsnotification
-(void)locationZone
{
    _currentCity = UNGetObject(USER_ZONE_NAME) ? UNGetObject(USER_ZONE_NAME) : @"选择城市";
    [self setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, 100, 44) title:_currentCity imageName:@"xiadebiaozhi" target:self action:@selector(selectAddress)];
}

-(void)reloadWebUrl
{
    NSString *url = [NSString stringWithFormat:@"%@&openid=%@", [(NSDictionary *)UNGetObject(HomeGoodsListUrl) objectForKey:@"home"], [(NSDictionary *)UNGetObject(UserWXInfo) objectForKey:@"openid"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.homeWebView loadRequest:request];
    [self showHub];
    
//    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 2)];                //进度条
//    _progressView.backgroundColor = [UIColor blueColor];
//    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    [self.view addSubview:_progressView];
    
//    //给WKWebView的“estimatedProgress"属性（即网页加载进度）添加KVO监听
//    [self.homeWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
//微信支付
-(void)WXPayWithData:(id)data
{
    NSDictionary *dict = (NSDictionary *)data;
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];    //时间戳
    //调起微信支付
    PayReq *request = [[PayReq alloc] init];
    request.openID = dict[@"appid"];                                     //appId
    request.partnerId = dict[@"partnerid"];                           //商户号
    request.prepayId = dict[@"prepayid"];
    request.package = dict[@"package"];
    request.nonceStr= dict[@"noncestr"];
    request.timeStamp= (UInt32)[stamp longLongValue];
    request.sign= dict[@"sign"];
    [WXApi sendReq:request];
}

-(void)ZFBPayWithData:(id)data
{
    NSArray *arr = [(NSString *)data componentsSeparatedByString:@"amp;"];
    NSString *sign = @"";
    for(NSString *str in arr)
    {
        sign = [sign stringByAppendingString:str];
    }
    NSString *appScheme = @"TongHeTang";
    [[AlipaySDK defaultService] payOrder:sign fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        if([resultDic[@"resultStatus"] intValue] == 9000)
        {
            NSLog(@"支付宝支付成功");
        }
        else
        {
            NSLog(@"支付宝支付失败：%@", resultDic);
        }
    }];
}

#pragma mark touchEvent
-(void)selectAddress
{
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[CitySwitchViewController alloc] init]];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

//#pragma mark KVO
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    //监听网页加载进度并以进度条（UIProgressView）的方式显示
//    if ([keyPath isEqualToString:@"estimatedProgress"])
//    {
//        _progressView.progress = self.homeWebView.estimatedProgress;
//        if (_progressView.progress == 1)
//        {
//            /* *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍 *动画时长0.25s，延时0.3s后开始动画 *动画结束后将progressView隐藏 */
//            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
//                self->_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
//            } completion:^(BOOL finished){
//                self->_progressView.hidden = YES;
//            }];
//        }
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

#pragma mark privateFouncation
-(void)popToViewController
{
    [self.homeWebView goBack];
}
-(void)toUserExit
{
    [self.navigationController pushViewController:[[ZYSettingViewController alloc] init] animated:YES];
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if([message.name isEqualToString:@"PENSION"])
    {
        PensionViewController *vc = [[PensionViewController alloc] init];
        vc.city = _currentCity;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if([message.name isEqualToString:@"LINK_RELOAD"])
    {
        [self reloadWebUrl];
    }
    if([message.name isEqualToString:@"WXPay"])
    {
        [self WXPayWithData:message.body];
    }
    if([message.name isEqualToString:@"ZFBPay"])
    {
        [self ZFBPayWithData:message.body];
    }
    if([message.name isEqualToString:@"EXIT"])
    {
        [self toUserExit];
    }
}

#pragma mark WKNavigationDelegate
//-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//    _progressView.hidden = NO;
//    [self.view bringSubviewToFront:_progressView];           //将子视图_progressView带到self.view的上层，即显示进度条
//    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self hideHub];
    
    //使用网页底部Bar时的处理
//    self.titleText.text = webView.title;
//    if([webView.title isEqualToString:@"会员中心"])
//    {
//        [self setRightBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"icon_shezhi" target:self action:@selector(toUserExit)];
//    }
//    else
//    {
//        [self setRightBarButtonItemWithFrameFrame:CGRectZero title:nil imageName:nil target:nil action:nil];
//    }
//    if([webView.title isEqualToString:@"易络淘"])
//    {
//        [self setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, 100, 44) title:self->_currentCity imageName:@"xiadebiaozhi" target:self action:@selector(selectAddress)];
//    }
//    else if([webView.title isEqualToString:@"全部分类"] || [webView.title isEqualToString:@"购物车"] || [webView.title isEqualToString:@"会员中心"])
//    {
//        [self setLeftBarButtonItemWithFrameFrame:CGRectZero title:nil imageName:nil target:nil action:nil];
//    }
//    else
//    {
//        [self setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"fanhui-1" target:self action:@selector(popToViewController)];
//    }
//
//    BOOL isChangeFrame;
//    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    if([webView.title isEqualToString:@"易络淘"])
//    {
//        isChangeFrame = self.navigationController.navigationBarHidden;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        if(isChangeFrame)
//        {
//            [UIView animateWithDuration:.5 animations:^{
//
//                CGRect frame = self.homeWebView.frame;
//                frame.size.height = Main_Screen_Height - statusBarHeight - self.navigationController.navigationBar.height;
//                frame.origin.y = 0;
//                self.homeWebView.frame = frame;
//            } completion:^(BOOL finished) {
//
//            }];
////            CGRect frame = self.homeWebView.frame;
////            frame.size.height = Main_Screen_Height - statusBarHeight - self.navigationController.navigationBar.height;
////            frame.origin.y = 0;
////            self.homeWebView.frame = frame;
//        }
//    }
//    else
//    {
//        isChangeFrame = !self.navigationController.navigationBarHidden;
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        if(isChangeFrame)
//        {
////            CGRect frame = self.homeWebView.frame;
////            frame.size.height = Main_Screen_Height-statusBarHeight;
////            frame.origin.y = statusBarHeight;
////            self.homeWebView.frame = frame;
//
//            [UIView animateWithDuration:.5 animations:^{
//
//                CGRect frame = self.homeWebView.frame;
//                frame.size.height = Main_Screen_Height-statusBarHeight;
//                frame.origin.y = statusBarHeight;
//                self.homeWebView.frame = frame;
//            } completion:^(BOOL finished) {
//
//            }];
//        }
//    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self hideHub];
    
//    _progressView.hidden = YES;
//    if([error code] == NSURLErrorCancelled)  {
//        return;
//    }
//    [self showAlertWithSatusMessage:@"网页加载失败" title:@"提示" time:1.5];
}

#pragma mark getter
-(WKWebView *)homeWebView
{
    if(!_homeWebView)
    {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.preferences.minimumFontSize = 10;
        configuration.preferences.javaScriptEnabled = true;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false;
        
        configuration.processPool = [[WKProcessPool alloc] init];
        
        // 通过JS与webview内容交互
        configuration.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        [configuration.userContentController addScriptMessageHandler:self name:@"LINK_RELOAD"];
        [configuration.userContentController addScriptMessageHandler:self name:@"PENSION"];
        [configuration.userContentController addScriptMessageHandler:self name:@"WXPay"];
        [configuration.userContentController addScriptMessageHandler:self name:@"ZFBPay"];
        [configuration.userContentController addScriptMessageHandler:self name:@"EXIT"];
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat barHeight = statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
        _homeWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - barHeight - 49) configuration:configuration];
        _homeWebView.navigationDelegate = self;
        _homeWebView.UIDelegate = self;
        _homeWebView.scrollView.showsVerticalScrollIndicator = false;
        _homeWebView.scrollView.showsHorizontalScrollIndicator = false;
    }
    return _homeWebView;
}
@end
