//
//  WebView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/24.
//

#import "CustomWebView.h"
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

@interface CustomWebView()<WKNavigationDelegate, WKScriptMessageHandler>

@end

@implementation CustomWebView

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addSubview:self.webView];
    }
    return self;
}

#pragma mark getter/setter
-(void)setUrl:(NSString *)url
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}
-(WKWebView *)webView
{
    if(!_webView)
    {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.preferences.minimumFontSize = 10;
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.userContentController = [[WKUserContentController alloc] init];
        
        [configuration.userContentController addScriptMessageHandler:self name:@"LINK_RELOAD"];
        [configuration.userContentController addScriptMessageHandler:self name:@"WXPay"];
        [configuration.userContentController addScriptMessageHandler:self name:@"ZFBPay"];
        [configuration.userContentController addScriptMessageHandler:self name:@"EXIT"];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) configuration:configuration];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

#pragma mark delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    if(_showTitleBlock){
        _showTitleBlock([webView canGoBack]);
    }
//    if(_titleBlock){
//        _titleBlock(webView.title);
//    }
    if(_loadFinishBlock){
        _loadFinishBlock();
    }
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"网页加载失败：%@", error.domain);
    if(_loadFinishBlock){
        _loadFinishBlock();
    }
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if([message.name isEqualToString:@"LINK_RELOAD"]){
        
        if(_webReloadBlock){
            _webReloadBlock();
        }
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
        if(_exitBlock){
            _exitBlock();
        }
    }
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

@end
