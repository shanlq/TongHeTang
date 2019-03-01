//
//  UC_TResetPhoneViewController.m
//  TongHeTang
//
//  Created by ZSY on 2018/11/28.
//  Copyright © 2018年 Shanlq. All rights reserved.
//

#import "ResetPhoneViewController.h"

@interface ResetPhoneViewController ()

@end

@implementation ResetPhoneViewController
{
    __weak IBOutlet UIImageView *_verifyPhoneImg;
    __weak IBOutlet UIImageView *_bindPhoneImg;
    __weak IBOutlet UIButton *_codeBtn;
    __weak IBOutlet UITextField *_phoneTF;
    __weak IBOutlet UITextField *_verifyTF;
    __weak IBOutlet UIButton *_nextBtn;
    
    NSTimer *_timer;
    int _timeCount;
    int _type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleText.text = @"修改手机号";
    _bindPhoneImg.hidden = YES;
    _timeCount = 60;
    _type = 1;
    _phoneTF.userInteractionEnabled = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _phoneTF.text = (NSString *)_data;
}
#pragma mark privateEvent
-(void)verifyTimeOut
{
    _timeCount--;
    if(_timeCount == 0 && _timer)
    {
        [_timer invalidate];
        _timer = nil;
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
        _timeCount = 60;
    }
    else
    {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d", _timeCount] forState:UIControlStateNormal];
    }
}
#pragma mark touchEvent

- (IBAction)sendVerifyCode:(id)sender {
    
    if(![Util valiMobile:_phoneTF.text] || _phoneTF.text.length == 0){
        [self showAlertWithSatusMessage:@"请输入正确的手机号" title:nil time:1.5];
        return;
    }
    
    NSDictionary* parameter = @{@"phone":_phoneTF.text};
    [[HttpClient defaultClient] requestWithPath:THT_GETCODE method:HttpRequestPost parameters:parameter prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject[@"status"] intValue] == 1)
        {
            [self showAlertWithSatusMessage:@"验证码已发送" title:nil time:1.5];
            UIButton *btn = (UIButton *)sender;
            btn.userInteractionEnabled = NO;
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifyTimeOut) userInfo:nil repeats:YES];
        }
        else
        {
            [self showAlertWithSatusMessage:responseObject[@"message"] title:@"提示" time:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self showAlertWithSatusMessage:@"网络错误" title:@"提示" time:1.5];
    }];
}
- (IBAction)next:(id)sender {
    
    if(_type == 1)
    {
        NSDictionary* parameter = @{@"phone":(NSString *)_data, @"code":_verifyTF.text};
        NSMutableDictionary *dic = [[HttpClient defaultClient] getParameter:parameter];
        
        [[HttpClient defaultClient] requestWithPath:THT_USER_VERIFYCODE method:HttpRequestPost parameters:dic prepareExecute:^{
            
            [self showHubWithMode];
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self hideHub];
            if([responseObject[@"status"] intValue] == 1)
            {
                self->_verifyPhoneImg.hidden = YES;
                self->_bindPhoneImg.hidden = NO;
                self->_phoneTF.userInteractionEnabled = YES;
                self->_codeBtn.userInteractionEnabled = YES;
                self->_phoneTF.text = self->_verifyTF.text = nil;
                self->_phoneTF.placeholder = @"请输入新手机号";
                [self->_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self->_timeCount = 60;
                [self->_timer invalidate];
                [self->_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
                self->_type = 2;
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
    else
    {
        NSDictionary* parameter = @{@"phone":_phoneTF.text,  @"code":_verifyTF.text};
        NSMutableDictionary *dic = [[HttpClient defaultClient] getParameter:parameter];
        
        [[HttpClient defaultClient] requestWithPath:THT_USER_CHANGEPHONE method:HttpRequestPost parameters:dic prepareExecute:^{
            
            [self showHubWithMode];
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [self hideHub];
            if([responseObject[@"status"] intValue] == 1)
            {
                [self showAlertWithMessage:@"手机号修改成功" title:nil right:@"确定" rightAction:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
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
}



@end
