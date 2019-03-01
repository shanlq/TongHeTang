//
//  GuiDeViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import "GuiDeViewController.h"
#import "LoginViewController.h"

@interface GuiDeViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GuiDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for(int i = 0; i < 4; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * Main_Screen_Width, 0, self.scrollView.width, self.scrollView.height)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"同和堂-引导页-%d", i+1]];
        imgView.userInteractionEnabled = YES;
        if(i == 3)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toLogin)];
            [imgView addGestureRecognizer:tap];
        }
        [self.scrollView addSubview:imgView];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark touchEvent
-(void)toLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISFIRSTLOGIN];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
}
#pragma mark getter
-(UIScrollView *)scrollView
{
    if(!_scrollView)
    {
//        CGFloat statusBarHeigh = [[UIApplication sharedApplication] statusBarFrame].size.height;
        if(self.view.width == 320){
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, Main_Screen_Width, Main_Screen_Height + 20)];
        }
        else{
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
        }
        _scrollView.pagingEnabled = YES;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.contentSize = CGSizeMake(Main_Screen_Width * 4, Main_Screen_Height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        if(self.view.width != 320){
            adjustsScrollViewInsets(_scrollView);
        }
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

@end
