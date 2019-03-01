//
//  ZYSettingViewController.m
//  aixiaoping
//
//  Created by Zhao on 16/7/14.
//  Copyright © 2016年 ZSY. All rights reserved.
//

#import "ZYSettingViewController.h"
#import "ResetPhoneViewController.h"
#import "LoginViewController.h"

@interface ZYSettingViewController ()
{
    __weak IBOutlet UIImageView *_newIconImgView;
    __weak IBOutlet UILabel *_newVersionLabel;
    __weak IBOutlet UILabel *_huanCunLab;
    
    __weak IBOutlet UILabel *_userPhoneLab;
    __weak IBOutlet UIImageView *_userImgView;
    __weak IBOutlet UILabel *_userNameLab;
}
@end

@implementation ZYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleText.text= @"设置";

    NSUInteger huanCun = [[SDImageCache sharedImageCache] getSize];
    _huanCunLab.text = [NSString stringWithFormat:@"%ldM",(unsigned long)huanCun/1024/1024];
    
    NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _newVersionLabel.text = appVersion;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self requestData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark privateMethods
-(void)requestData
{
    NSMutableDictionary *dic = [[HttpClient defaultClient] getParameter:@{}];
    
    [[HttpClient defaultClient] requestWithPath:THT_USER_GETUSERINFO method:HttpRequestPost parameters:dic prepareExecute:^{
        
        [self showHubWithMode];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHub];
        if([responseObject[@"status"] intValue] == 1)
        {
            [self->_userImgView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"userHead"]]];
            self->_userPhoneLab.text = responseObject[@"data"][@"userPhone"];
            self->_userNameLab.text = responseObject[@"data"][@"userName"];
            NSMutableDictionary *userInfoDic = UNGetSerializedObject(USERINFO);
            [userInfoDic setValue:responseObject[@"data"][@"userPhone"] forKey:@"phone"];
            [userInfoDic setValue:responseObject[@"data"][@"userHead"] forKey:@"headimage"];
            [userInfoDic setValue:responseObject[@"data"][@"userName"] forKey:@"name"];
            UNSaveSerializedObject(userInfoDic, USERINFO);
        }
        else
        {
            [self showAlertWithSatusMessage:responseObject[@"message"] title:nil time:1.5];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self hideHub];
        [self showAlertWithSatusMessage:@"网络错误" title:nil time:1.5];
    }];
}
#pragma mark touchEvent
//清除缓存
- (IBAction)clearCache:(id)sender {
    
    __weak typeof (self) weakSelf = self;
    [self showAlertWithMessage:@"是否清除app缓存?" title:@"提示" left:@"取消" right:@"清除" leftAction:nil rightAction:^{
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [self showAlertWithSatusMessage:@"缓存清除成功" title:@"提示" time:1.5];
        }];
        NSUInteger huanCun = [[SDImageCache sharedImageCache] getSize];
        strongSelf->_huanCunLab.text = [NSString stringWithFormat:@"%ldM",(unsigned long)huanCun/1024/1024];
    }];
}
- (IBAction)toChangePhoneNum:(id)sender {
    
    ResetPhoneViewController *vc = [[ResetPhoneViewController alloc] init];
    vc.data = _userPhoneLab.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginOut:(id)sender {
    
    [self showAlertWithMessage:@"是否退出登录" title:@"提示" left:@"取消" right:@"退出" leftAction:nil rightAction:^{
        
        UNDeletedSerializedObject(USERINFO);
        UNDeletedSerializedObject(HomeGoodsListUrl);
        UNDeletedSerializedObject(UserWXInfo);
        [self.navigationController popViewControllerAnimated:YES];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]] animated:YES completion:nil];
    }];
}

@end
