//
//  LoginViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/6/13.
//

#import "LoginViewController.h"
#import "PhoneLoginViewController.h"
#import "userWXInfo.h"
#import <WXApi.h>
#import "WebViewController.h"

@interface LoginViewController ()<WXApiDelegate>

@end

@implementation LoginViewController
{
    __weak IBOutlet UIButton *_otherLoginBtn;
    __weak IBOutlet UITextField *_phoneNumTF;
    __weak IBOutlet UITextField *_codeTF;
    __weak IBOutlet UIButton *_sendCodeBtn;
    __weak IBOutlet UIButton *_agreeBtn;
    __weak IBOutlet UILabel *_wxTitleLab;
    __weak IBOutlet UIButton *_wxLoginBtn;
    
    NSTimer *_timer;
    int _count;
    BOOL _canLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = false;
    
    _wxTitleLab.hidden = _wxLoginBtn.hidden = ![WXApi isWXAppInstalled];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCode:) name:WXLoginCode object:nil];
    
    _canLogin = YES;
    _count = 60;
    _otherLoginBtn.layer.borderWidth = 0.5;
    _otherLoginBtn.layer.borderColor = UIColorFromRGB(0xff3b67).CGColor;
    [_agreeBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

//微信登录获取code通知
-(void)getCode:(NSNotification *)notify
{
    NSDictionary* parameter = @{@"appid":wxappId,
                                @"secret":wxappSecret,
                                @"code":notify.userInfo[@"code"],
                                @"grant_type":@"authorization_code"
                                };
    
    [[HttpClient defaultClient] requestWithPath:@"https://api.weixin.qq.com/sns/oauth2/access_token" method:HttpRequestPost parameters:parameter prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if(responseObject[@"access_token"] && responseObject[@"openid"])
        {
            [self getUserWXInfoRequestToken:responseObject[@"access_token"] openid:responseObject[@"openid"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//获取用户微信信息
-(void)getUserWXInfoRequestToken:(NSString *)token openid:(NSString *)openid
{
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    NSDictionary* parameter = @{@"access_token" : token, @"openid" : openid};
    
    [[HttpClient defaultClient] requestWithPath:@"https://api.weixin.qq.com/sns/userinfo" method:HttpRequestPost parameters:parameter prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"用户微信基础信息%@", responseObject);
        UNSaveObject(responseObject, UserWXInfo);
        [self loginWithInfo:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
}
//登录
-(void)loginWithInfo:(id)info
{
    NSDictionary* parameter = @{@"unionid":info[@"unionid"],
                                @"openid" : info[@"openid"],
                                @"nickname" : info[@"nickname"],
                                @"headimgurl" : info[@"headimgurl"],
                                };
    
    [self showHub];
    [[HttpClient defaultClient] requestWithPath:THT_WXLOGIN method:HttpRequestPost parameters:parameter prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHub];
        if([responseObject[@"status"] integerValue] == 1)           //登录成功
        {
            if(responseObject[@"data"][@"url"]){
                NSDictionary *dic = @{@"home": responseObject[@"data"][@"url"], @"classify": responseObject[@"data"][@"ClassifyUrl"], @"shopCart": responseObject[@"data"][@"ShopCartUrl"], @"userCenter":responseObject[@"data"][@"UserCenterUrl"]};
                UNSaveObject(dic, HomeGoodsListUrl);
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
        else if([responseObject[@"status"] integerValue] == -1)            //未绑定手机号
        {
            PhoneLoginViewController *vc = [[PhoneLoginViewController alloc] init];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self hideHub];
        [self showAlertWithSatusMessage:@"网络错误" title:@"提示" time:1.5];
    }];
}

#pragma mark privateFouncation
-(void)timeCount
{
    _count --;
    if(_count == 0){
        [_timer invalidate];
        [_sendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        _sendCodeBtn.userInteractionEnabled = YES;
        _count = 60;
        return;
    }
    [_sendCodeBtn setTitle:[NSString stringWithFormat:@"%d", _count] forState:UIControlStateNormal];
}

#pragma mark touchEvent
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_phoneNumTF resignFirstResponder];
    [_codeTF resignFirstResponder];
}
- (IBAction)agreeClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundImage:[UIImage imageNamed:btn.selected ? @"duiduidudi3" : @"duidui6"] forState:UIControlStateNormal];
    _canLogin = btn.selected;
    btn.selected = !btn.selected;
}
- (IBAction)agreementContent:(id)sender {
    
    WebViewController *vc = [[WebViewController alloc] init];
    vc.url = @"http://tht.518wk.cn/tht/index.php/Tht/Admin/agreement.html";
    vc.haveTitle = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//微信登录
- (IBAction)weixinLogin:(id)sender {
    
    if(!_canLogin)
    {
        [self showAlertWithSatusMessage:@"请先阅读服务协议" title:nil time:1.5];
        return;
    }
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"自定义标识符";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
}
- (IBAction)phoneNumLogin:(id)sender {
    
    if(!_canLogin)
    {
        [self showAlertWithSatusMessage:@"请先阅读服务协议" title:nil time:1.5];
        return;
    }
    if(![Util valiMobile:_phoneNumTF.text] || _phoneNumTF.text.length == 0){
        [self showAlertWithSatusMessage:@"请输入正确的手机号" title:nil time:1.5];
        return;
    }
    if(_codeTF.text.length == 0 || _codeTF.text.length != 6){
        [self showAlertWithSatusMessage:@"请输入正确的验证码" title:nil time:1.5];
        return;
    }
    NSDictionary* parameter = @{@"phone": _phoneNumTF.text, @"code": _codeTF.text};
    
    [[HttpClient defaultClient] requestWithPath:THT_PHONELOGIN method:HttpRequestPost parameters:parameter prepareExecute:^{
        
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
            self->_codeTF.text = nil;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self showAlertWithSatusMessage:@"网络错误" title:@"提示" time:1.5];
    }];
    
}
- (IBAction)clearPhone:(id)sender {
    
    _phoneNumTF.text = nil;
}
- (IBAction)sendVerifyCode:(id)sender {
    
    if(![Util valiMobile:_phoneNumTF.text] || _phoneNumTF.text.length == 0){
        [self showAlertWithSatusMessage:@"请输入正确的手机号" title:nil time:1.5];
        return;
    }
    
    NSDictionary* parameter = @{@"phone":_phoneNumTF.text};
    [[HttpClient defaultClient] requestWithPath:THT_GETCODE method:HttpRequestPost parameters:parameter prepareExecute:^{
        
        [self showHubWithMode];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if([responseObject[@"status"] intValue] == 1)
        {
            self->_sendCodeBtn.userInteractionEnabled = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
