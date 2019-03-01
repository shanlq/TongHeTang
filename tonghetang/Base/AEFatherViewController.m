//
//  AEFatherViewController.m
//  AntElephant
//
//  Created by Dee on 2/5/15.
//  Copyright (c) 2015 Dee. All rights reserved.
//

#import "AEFatherViewController.h"
//#import "AEUserBaseInfo.h"
//#import "AERunWaySelViewController.h"

@interface AEFatherViewController ()


@end

@implementation AEFatherViewController

-(instancetype)init{
    
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.hidesBottomBarWhenPushed = YES;
         [self initTitleView];
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initTitleView];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBarPlease" object:nil userInfo:@{@"value":self}];
    
//    [MobClick beginLogPageView:self.titleText.text];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [MobClick endLogPageView:self.titleText.text];
}


- (UIStatusBarStyle)preferredStatusBarStyles
{
    return UIStatusBarStyleDefault;
}

- (void)initTitleView
{
    if (!_titleText) {
        
        self.titleText = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 50)];
        self.titleText.backgroundColor = [UIColor clearColor];
        self.titleText.textColor= UIColorFromRGB(0x222222);
        self.titleText.textAlignment = NSTextAlignmentCenter;
        [self.titleText setFont:[UIFont boldSystemFontOfSize:18.0]];
        self.navigationItem.titleView = self.titleText;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    
     [self initTitleView];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(0x222222)];
    
    UIButton *leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarButton setImage:[UIImage imageNamed:@"fanhui-1"] forState:UIControlStateNormal];
    [leftBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [leftBarButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
    [leftBarButton setFrame:CGRectMake(0, 0, 40, 44)];
    [leftBarButton setBackgroundColor:[UIColor clearColor]];
    [leftBarButton  addTarget:self action:@selector(popWithAnimate) forControlEvents:UIControlEventTouchUpInside];
    leftBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:leftBarButton];

    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = false;
        
    }
    
    self.navigationController.navigationBar.translucent = false;    
    
    
    
    uaiv = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uaiv.frame = CGRectMake(0, 0, 40, 40);
    uaiv.center = CGPointMake(Main_Screen_Width /2, (Main_Screen_Height -64)/ 2);
    [self.view addSubview:uaiv];
    
    MBProgressHUD *myHud = [[MBProgressHUD alloc]  initWithView:self.view];
    myHud.tag = ShareHudTag;
    myHud.labelText = @"加载中...";
    [self.view addSubview:myHud];
    
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNetworkStatus:) name:@"NotifyNetWorkStatus" object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotifyNetWorkStatus" object:nil];
}

-(void)popWithAnimate
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showHubWithMode
{
    
    MBProgressHUD *myHud =(MBProgressHUD *)[self.view viewWithTag:ShareHudTag];
    [myHud  show:true];
    myHud.userInteractionEnabled = true;
    
    [self.view bringSubviewToFront:myHud];
    
}

-(void)showHub{
    
    MBProgressHUD *myHud =(MBProgressHUD *)[self.view  viewWithTag:ShareHudTag];
    [myHud  show:true];
    myHud.userInteractionEnabled = YES;
    
    [self.view bringSubviewToFront:myHud];
}

-(void)hideHub{
    
    MBProgressHUD *myHud =(MBProgressHUD *)[self.view  viewWithTag:ShareHudTag];
    [myHud  hide:true];
    
}

-(void)startAnimate{
    
    [uaiv startAnimating];
    
    [self.view bringSubviewToFront:uaiv];
}


-(void)endAnimate{
    
    [uaiv stopAnimating];
    
}

- (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame
                                      title:(NSString *)title
                                  imageName:(NSString *)imageName
                                     target:(id)target
                                     action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    }
    
    if (imageName && image) {
        
        [btn setTintColor:UIColorFromRGB(0x222222)];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [btn setImage:image forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
    }
    
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barBtnItem;
}

- (void)setRightBarButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action
{
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    CGFloat width = [title getStringWidth:font];
    
    [self setRightBarButtonItemWithFrameFrame:CGRectMake(0, 0, width + 15, 40)
                                        title:title
                                    imageName:nil
                                       target:target
                                       action:action];
}

- (void)setRightBarButtonItemWithFrameFrame:(CGRect)frame
                                      title:(NSString *)title
                                  imageName:(NSString *)imageName
                                     target:(id)target
                                     action:(SEL)action
{
    UIBarButtonItem *barBtnItem = [self barButtonItemWithFrame:frame
                                                         title:title
                                                     imageName:imageName
                                                        target:target
                                                        action:action];
    
    if (FSystemVersion >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //negativeSeperator.width = -12;
        negativeSeperator.width = frame.origin.x - 12;
        self.navigationItem.rightBarButtonItems = @[negativeSeperator,barBtnItem];
    }
    else{
        self.navigationItem.rightBarButtonItem = barBtnItem;
    }
}

- (void)setRemoveRightBarButtonItem
{
    if (FSystemVersion >= 7.0)
    {
        self.navigationItem.rightBarButtonItems = nil;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (BOOL)isRightBarButtonExist
{
    if (FSystemVersion >= 7.0)
    {
        if(self.navigationItem.rightBarButtonItems == nil)
            return FALSE;
    }
    else
    {
        if(self.navigationItem.rightBarButtonItem == nil)
            return FALSE;
    }
    return TRUE;
}

- (void)setLeftBarButtonItemWithTitle:(NSString *)title
                               target:(id)target
                               action:(SEL)action
{
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    CGFloat width = [title getStringWidth:font];
    
    [self setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, width + 15, 40)
                                       title:title
                                   imageName:nil
                                      target:target
                                      action:action];
}

- (void)setLeftBarButtonItemWithFrameFrame:(CGRect)frame
                                     title:(NSString *)title
                                 imageName:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action
{
    UIBarButtonItem *barBtnItem = [self barButtonItemWithFrame:frame
                                                         title:title
                                                     imageName:imageName
                                                        target:target
                                                        action:action];
    
    if (FSystemVersion >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -12;
        self.navigationItem.leftBarButtonItems = @[negativeSeperator,barBtnItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = barBtnItem;
    }
}

-(void)showHudWithTitle:(NSString*)titleString
{
    
    MBProgressHUD *myHud =(MBProgressHUD *)[self.view  viewWithTag:ShareHudTag];
    
    if (titleString) {
        
        myHud.labelText = titleString;
        
    }else
    {
        myHud.labelText = @"加载中...";
    }
    
    
    [myHud  show:true];
    myHud.userInteractionEnabled = false;
    
    [self.view bringSubviewToFront:myHud];
}

#pragma mark - Show/Dismiss Custom Dialog View Controller
// if window.rootViewController = UITabBarController then 不起作用
- (void)presentPopUpView:(UIViewController*)aPopup {
    aPopup.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:aPopup animated:NO completion:nil];
    [aPopup beginAppearanceTransition:YES animated:YES];
    aPopup.view.alpha = 0;
    [UIView animateWithDuration:.2 animations: ^{[aPopup.view setAlpha:1.0];} completion:^(BOOL finished) {
        [aPopup endAppearanceTransition];
        [aPopup didMoveToParentViewController:self];
    }];
}

- (void)dismissPopupView {
    [self willMoveToParentViewController:nil];
    [self beginAppearanceTransition:NO animated:YES];
    [UIView animateWithDuration:.2 animations: ^{[self.view setAlpha:0.0];} completion:^(BOOL finished) {
        [self endAppearanceTransition];
        [self removeFromParentViewController];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    
}


-(NSMutableAttributedString*)setString:(NSString*)string colorOne:(UIColor*)colorOne colorTwo:(UIColor*)colorTwo numberOne:(NSInteger)numberOne numberTwo:(NSInteger)numberTwo sizeOne:(NSInteger)sizeOne sizeTwo:(NSInteger)sizeTwo
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:colorOne range:NSMakeRange(0,numberOne)];
    [str addAttribute:NSForegroundColorAttributeName value:colorTwo range:NSMakeRange(numberOne,numberTwo)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:sizeOne] range:NSMakeRange(0, numberOne)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:sizeTwo] range:NSMakeRange(numberOne,numberTwo)];
//    attrLabel.attributedText = str;
    return str;
}

- (void)receivedNetworkStatus:(NSNotification *)notification {
    
    NSLog(@"asd");
}

//弹框提示1
-(void)showAlertWithMessage:(NSString *)message title:(NSString *)title left:(NSString *)left right:(NSString *)right leftAction:(void(^)(void))leftAction rightAction:(void(^)(void))rightAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leftOption = [UIAlertAction actionWithTitle:left style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            leftAction();
        }];
    }];
    UIAlertAction *rightOption = [UIAlertAction actionWithTitle:right style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(rightAction){
            rightAction();
        }
    }];
    
    left ? [alert addAction:leftOption] : nil;
    right ? [alert addAction:rightOption] : nil;
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)showAlertWithMessage:(NSString *)message title:(NSString *)title right:(NSString *)right rightAction:(void(^)(void))rightAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *rightOption = [UIAlertAction actionWithTitle:right style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(rightAction){
            rightAction();
        }
    }];

    right ? [alert addAction:rightOption] : nil;
    [self presentViewController:alert animated:YES completion:nil];
}
//状态弹框提示
-(void)showAlertWithSatusMessage:(NSString *)message title:(NSString *)title time:(CGFloat)time
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    //GCD：从现在算起过多少毫秒后执行block
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:true completion:nil];
    });
}


-(void)test
{
    NSURLSession *session = [[NSURLSession alloc] init];
    [session downloadTaskWithURL:[NSURL URLWithString:@""]];
}

@end
