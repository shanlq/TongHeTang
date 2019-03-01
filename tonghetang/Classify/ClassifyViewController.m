//
//  ClassifyViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import "ClassifyViewController.h"
#import "CustomWebView.h"

@interface ClassifyViewController ()

@property (nonatomic, strong) CustomWebView *webView;

@end

@implementation ClassifyViewController
{
    BOOL _canReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _canReload = NO;
    self.titleText.text = @"分类";
//    self.navigationController.navigationBarHidden = YES;
    [self setLeftBarButtonItemWithFrameFrame:CGRectZero title:nil imageName:nil target:nil action:nil];
    [self.view addSubview:self.webView];
    [self reloadUrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUrl) name:@"ClassifyReload" object:nil];      //点击TabBar刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUrl) name:ReloadHomeUrl object:nil];        //刷新
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark privateMethods
-(void)popToViewController
{
    [self.webView.webView goBack];
}
-(void)reloadUrl
{
    NSString *url = [NSString stringWithFormat:@"%@&openid=%@", [(NSDictionary *)UNGetObject(HomeGoodsListUrl) objectForKey:@"classify"], [(NSDictionary *)UNGetObject(UserWXInfo) valueForKey:@"openid"]];
    self.webView.url = url;
    [self showHub];
}
#pragma mark getter
-(CustomWebView *)webView
{
    if(!_webView)
    {
        CGFloat barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
        _webView = [[CustomWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - barHeight - 49)];
//        NSString *url = [NSString stringWithFormat:@"%@&openid=%@", [(NSDictionary *)UNGetObject(HomeGoodsListUrl) objectForKey:@"classify"], [(NSDictionary *)UNGetObject(UserWXInfo) valueForKey:@"openid"]];
//        _webView.url = url;
        __weak typeof (self) weakSelf = self;
        _webView.loadFinishBlock = ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf hideHub];
        };
//        _webView.showTitleBlock = ^(BOOL canGoBack) {
//            __strong typeof (weakSelf) strongSelf = weakSelf;
//            if(canGoBack){
//                [strongSelf setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"fanhui-1" target:strongSelf action:@selector(popToViewController)];
//                strongSelf.tabBarController.tabBar.hidden = YES;
//            }
//            else{
//                [strongSelf setLeftBarButtonItemWithFrameFrame:CGRectZero title:nil imageName:nil target:nil action:nil];
//                strongSelf.tabBarController.tabBar.hidden = NO;
//            }
//        };
        _webView.webReloadBlock = ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf reloadUrl];
        };
    }
    return _webView;
}

@end
