//
//  GoodsViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/6/21.
//

#import "GoodsViewController.h"
#import <WebKit/WebKit.h>

@interface GoodsViewController ()<WKNavigationDelegate>

@end

@implementation GoodsViewController
{
    WKWebView *_homeWebView;
    UIProgressView *_progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"fanhui" target:self action:@selector(goBack)];
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat barHeight = statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    _homeWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 2, Main_Screen_Width, Main_Screen_Height - barHeight - 2)];
    _homeWebView.navigationDelegate = self;
    [_homeWebView loadRequest:request];
    [self.view addSubview:_homeWebView];
    //    [self showHub];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 2)];
    _progressView.backgroundColor = [UIColor blueColor];
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:_progressView];
    
    //给WKWebView的“estimatedProgress"属性（即网页加载进度）添加KVO监听
    [_homeWebView addObserver:self forKeyPath:@"goodsEstimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)dealloc
{
    [_homeWebView removeObserver:self forKeyPath:@"goodsEstimatedProgress"];
}

#pragma private founcation
-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"goodsEstimatedProgress"])
    {
        _progressView.progress = _homeWebView.estimatedProgress;
        if (_progressView.progress == 1)
        {
            /* *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍 *动画时长0.25s，延时0.3s后开始动画 *动画结束后将progressView隐藏 */
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self->_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished){
                self->_progressView.hidden = YES;
            }];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark WKNavigationDelegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    _progressView.hidden = NO;
    [self.view bringSubviewToFront:_progressView];           //将子视图_progressView带到self.view的上层，即显示进度条
    _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"++++++++");
    _progressView.hidden = YES;
    //    [self hideHub];
    [_homeWebView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        
        self.titleText.text = [NSString stringWithFormat:@"%@", title];
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    //    [self hideHub];
    _progressView.hidden = YES;
    if([error code] == NSURLErrorCancelled)  {
        return;
    }
    [self showAlertWithSatusMessage:@"网页加载失败" title:@"提示" time:1.5];
}


@end
