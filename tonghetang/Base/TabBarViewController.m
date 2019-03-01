//
//  TabBarViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "ClassifyViewController.h"
#import "ShopCartViewController.h"
#import "UserCenterViewController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewController
{
    NSInteger _reloadIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    _reloadIndex = 0;
    
    UINavigationController *home = [self createNavigationC:@"HomeViewController" title:@"首页" color:UIColorFromRGB(0x666666) sColor:UIColorFromRGB(0x666666) image:@"shouye" sImage:@"shouye2"];
    UINavigationController *classify = [self createNavigationC:@"ClassifyViewController" title:@"分类" color:UIColorFromRGB(0x666666) sColor:UIColorFromRGB(0x666666) image:@"fenlei" sImage:@"fenlei2"];
    UINavigationController *cart = [self createNavigationC:@"ShopCartViewController" title:@"购物车" color:UIColorFromRGB(0x666666) sColor:UIColorFromRGB(0x666666) image:@"icon_shop" sImage:@"gouwu"];
    UINavigationController *user = [self createNavigationC:@"UserCenterViewController" title:@"我的" color:UIColorFromRGB(0x666666) sColor:UIColorFromRGB(0x666666) image:@"wode" sImage:@"wode2"];
    self.viewControllers = @[home, classify, cart, user];
    self.tabBar.backgroundColor = UIColorFromRGB(0xffffff);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selectedViewController = self.viewControllers.firstObject;
}

-(UINavigationController *)createNavigationC:(NSString *)vcName title:(NSString *)title color:(UIColor *)color sColor:(UIColor *)sColor image:(NSString *)image sImage:(NSString *)sImage
{
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    vc.title = title;
    vc.hidesBottomBarWhenPushed = NO;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [navVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : color} forState:UIControlStateNormal];
    [navVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : sColor} forState:UIControlStateSelected];
    navVC.tabBarItem.image = [UIImage imageNamed:image];
    navVC.tabBarItem.selectedImage = [[UIImage imageNamed:sImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return navVC;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    if(_reloadIndex != tabBarController.selectedIndex)
//    {
        NSString *name = _reloadIndex == 0 ? @"HomeReload" : (_reloadIndex == 1 ? @"ClassifyReload" : (_reloadIndex == 2 ? @"ShopCartReload" : @"UserCenterRload"));
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
        _reloadIndex = tabBarController.selectedIndex;
//    }
//    else
//    {
//
//    }
    
}

@end
