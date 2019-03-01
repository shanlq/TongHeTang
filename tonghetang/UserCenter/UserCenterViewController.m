//
//  UserCenterViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import "UserCenterViewController.h"
#import "ZYSettingViewController.h"
#import "CustomWebView.h"

@interface UserCenterViewController ()

@property (nonatomic, strong) CustomWebView *webView;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleText.text = @"会员中心";
    self.navigationController.navigationBarHidden = YES;
    [self setLeftBarButtonItemWithFrameFrame:CGRectZero title:nil imageName:nil target:nil action:nil];
    [self setRightBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"icon_shezhi" target:self action:@selector(toSet)];
    [self.view addSubview:self.webView];
    [self reloadUrl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUrl) name:@"UserCenterRload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUrl) name:ReloadHomeUrl object:nil];        //刷新
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark privateMethods
-(void)toSet
{
    [self.navigationController pushViewController:[[ZYSettingViewController alloc] init] animated:YES];
}

-(void)popToViewController
{
    [self.webView.webView goBack];
}
-(void)reloadUrl
{
    NSString *url = [NSString stringWithFormat:@"%@&openid=%@", [(NSDictionary *)UNGetObject(HomeGoodsListUrl) objectForKey:@"userCenter"], [(NSDictionary *)UNGetObject(UserWXInfo) objectForKey:@"openid"]];
    self.webView.url = url;
    [self showHub];
}
#pragma mark getter
-(CustomWebView *)webView
{
    if(!_webView)
    {
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        _webView = [[CustomWebView alloc] initWithFrame:CGRectMake(0, statusBarHeight, self.view.width, self.view.height-statusBarHeight-49)];
//        NSString *url = [NSString stringWithFormat:@"%@&openid=%@", [(NSDictionary *)UNGetObject(HomeGoodsListUrl) objectForKey:@"userCenter"], [(NSDictionary *)UNGetObject(UserWXInfo) objectForKey:@"openid"]];
//        _webView.url = url;
        __weak typeof (self) weakSelf = self;
        _webView.loadFinishBlock = ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf hideHub];
        };
        _webView.exitBlock = ^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf.navigationController pushViewController:[[ZYSettingViewController alloc] init] animated:YES];
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
