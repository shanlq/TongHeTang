//
//  BindPhoneViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/6/14.
//

#import "PhoneLoginViewController.h"
#import "HomeViewController.h"

@interface PhoneLoginViewController ()

@end

@implementation PhoneLoginViewController
{
    __weak IBOutlet UITextField *_phoneTF;
    __weak IBOutlet UITextField *_verifyCodeTF;
    __weak IBOutlet UILabel *_titleLab;
    __weak IBOutlet UIButton *_queueBtn;
    __weak IBOutlet UIButton *_verifyBtn;
    __weak IBOutlet UIView *_verifyView;
    __weak IBOutlet UIButton *_cancelBtn;
    
    int _count;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _count = 60;
    _titleLab.text = (_type == 1 ? @"绑定手机号" : @"以短信验证码快速登录");
    [_queueBtn setTitle:_type == 1 ? @"确定" : @"登录" forState:UIControlStateNormal];
    _verifyView.backgroundColor = [UIColorFromRGB(0x505050) colorWithAlphaComponent:0.6];
    [_cancelBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
}

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark touchEvent
- (IBAction)Login:(id)sender {
    
    if(![Util valiMobile:_phoneTF.text] || _phoneTF.text.length == 0){
        [self showAlertWithSatusMessage:@"请输入正确的手机号" title:nil time:1.5];
        return;
    }
    if(_verifyCodeTF.text.length == 0 || _verifyCodeTF.text.length != 6){
        [self showAlertWithSatusMessage:@"请输入正确的验证码" title:nil time:1.5];
        return;
    }
    NSDictionary *dic = (NSDictionary *)UNGetObject(UserWXInfo);
    NSDictionary* parameter = (_type == 1 ? @{@"openid":dic[@"openid"], @"phone": _phoneTF.text, @"code":_verifyCodeTF.text} : @{@"phone": _phoneTF.text, @"code": _verifyCodeTF.text});
    
    [[HttpClient defaultClient] requestWithPath:_type == 1 ? THT_BINDPHONE : THT_PHONELOGIN method:HttpRequestPost parameters:parameter prepareExecute:^{
        
        [self showHubWithMode];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject[@"status"] integerValue] == 1)
        {
            if(responseObject[@"data"][@"url"]){
                //网页地址
                NSDictionary *dic = @{@"home": responseObject[@"data"][@"url"], @"classify": responseObject[@"data"][@"ClassifyUrl"], @"shopCart": responseObject[@"data"][@"ShopCartUrl"], @"userCenter":responseObject[@"data"][@"UserCenterUrl"]};
                UNSaveObject(dic, HomeGoodsListUrl);
                //用户信息
                NSMutableDictionary *userInfoDic = UNGetSerializedObject(USERINFO) ? UNGetSerializedObject(USERINFO) : [NSMutableDictionary dictionaryWithCapacity:0];
                [userInfoDic setValue:responseObject[@"data"][@"userId"] forKey:@"userId"];
                UNSaveSerializedObject(userInfoDic, USERINFO);
                //微信信息
                NSMutableDictionary *infoDic = (NSMutableDictionary *)UNGetObject(UserWXInfo);
                NSMutableDictionary *wxInfoDic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
                [wxInfoDic setObject:responseObject[@"data"][@"openid"] forKey:@"openid"];
                UNSaveObject(wxInfoDic, UserWXInfo);
                
                if([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController)
                {
                    [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadHomeUrl object:nil];
                }
            }
        }
        else
        {
            [self showAlertWithSatusMessage:responseObject[@"message"] title:@"提示" time:1.5];
            self->_verifyCodeTF.text = nil;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self showAlertWithSatusMessage:@"网络错误" title:@"提示" time:1.5];
    }];
}
//发送验证码
- (IBAction)sendVerifyCode:(id)sender {
    
    if(![Util valiMobile:_phoneTF.text] || _phoneTF.text.length == 0){
        [self showAlertWithSatusMessage:@"请输入正确的手机号" title:nil time:1.5];
        return;
    }
    
    NSDictionary* parameter = @{@"phone":_phoneTF.text};
    [[HttpClient defaultClient] requestWithPath:THT_GETCODE method:HttpRequestPost parameters:parameter prepareExecute:^{
        
        [self showHubWithMode];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject[@"status"] intValue] == 1)
        {
            self->_verifyBtn.userInteractionEnabled = NO;
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
        }
        else
        {
            [self showAlertWithSatusMessage:responseObject[@"message"] title:@"提示" time:1.5];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self showAlertWithSatusMessage:@"网络错误" title:@"提示" time:1.5];
    }];
}

- (IBAction)cancelViewController:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_verifyCodeTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
}

#pragma mark privateFouncation
-(void)timeCount
{
    _count --;
    if(_count == 0){
        [_timer invalidate];
        [_verifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        _verifyBtn.userInteractionEnabled = YES;
        _count = 60;
        return;
    }
    [_verifyBtn setTitle:[NSString stringWithFormat:@"%d", _count] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
