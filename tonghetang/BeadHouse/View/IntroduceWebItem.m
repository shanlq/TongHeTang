//
//  IntroduceWebItem.m
//  tonghetang
//
//  Created by ZSY on 2018/12/20.
//

#import "IntroduceWebItem.h"
#import <WebKit/WebKit.h>

@interface IntroduceWebItem()<WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation IntroduceWebItem
{
    NSString *_url;
}
static int num = 0;                    //注册的通知数量

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        ++num;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HtmlScrollEnable) name:@"HtmlScrollEnableYES" object:nil];
        [self addSubview:self.webView];
    }
    return self;
}
-(void)dealloc
{
    for(int i = 0; i < num; i++)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    num = 0;
}
#pragma mark privateMethods
-(void)loadDataToView:(id)data
{
    if(![_url isEqualToString:(NSString *)data]){
        _url = (NSString *)data;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:(NSString *)data]]];
    }
}
#pragma mark getter
-(WKWebView *)webView
{
    if(!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y == 0){
        self.webView.scrollView.scrollEnabled = NO;
    }
}
#pragma mark NSNotify
-(void)HtmlScrollEnable
{
    self.webView.scrollView.scrollEnabled = YES;
    NSLog(@"恢复网页的滑动");
}

@end
