//
//  WebViewController.m
//  tonghetang
//
//  Created by ZSY on 2019/1/2.
//

#import "WebViewController.h"
#import "CustomWebView.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate>

//@property (nonatomic, strong) CustomWebView *webView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_haveTitle){
        self.titleText.text = @"用户协议";
    }
    else{
        self.titleText.text = @"了解易络淘";
    }
    self.navigationController.navigationBar.hidden = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self showHub];
}

#pragma mark getter
//-(CustomWebView *)webView
//{
//    if(!_webView)
//    {
//        _webView = [[CustomWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//        __weak typeof (self) weakSelf = self;
//        self.webView.titleBlock = ^(NSString * _Nonnull title) {
//
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//            strongSelf.titleText.text = title;
//        };
//        [self.view addSubview:_webView];
//    }
//    return _webView;
//}
-(WKWebView *)webView
{
    if(!_webView)
    {
        CGFloat barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-barHeight)];
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark delegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self hideHub];
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self hideHub];
}
@end
