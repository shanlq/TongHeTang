//
//  AENetworkUrlHeader.h
//  AntElephant
//
//  Created by Dee on 2/5/15.
//  Copyright (c) 2015 Dee. All rights reserved.
//

#ifndef AntElephant_AENetworkUrlHeader_h
#define AntElephant_AENetworkUrlHeader_h

// "http://27.54.226.210:8080/aixiaoping/invoke/"
// "http://www.aixiaoping.com:8080/aixiaoping/invoke/"

// 正式服务器
#define BASE_LINK  @"https://www.ahthtwl.cn/tht/index.php/"
// 测试服务器
//#define BASE_LINK  @"http://192.168.110.35/tht/tht/index.php/"
// 测试服务器公网
//#define BASE_LINK  @"http://test.aixiaoping.cn:8888/aixiaopingAPI/invoke/"
// 张璐
//#define BASE_LINK  @"http://192.168.200.152:8080/aixiaopingAPI/invoke/"
//钟善达
//#define BASE_LINK  @"http://192.168.200.182:8080/aixiaopingAPI/invoke/"
//邬工
//#define BASE_LINK  @"http://192.168.200.227:8080/aixiaopingAPI/invoke/"

/*
 登录模块
 */
//微信账号登录
#define THT_WXLOGIN [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/Loginapi/wcLogin"]
//手机号登录
#define THT_PHONELOGIN [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/Loginapi/mobileLogin"]
//绑定手机号
#define THT_BINDPHONE [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/Loginapi/bindPhone"]
//获取短信验证码
#define THT_GETCODE [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/Loginapi/code"]
/*
  养老院模块
 */
//获取城市列表
#define THT_PS_GETCITYLIST [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/index/getZoneList"]
//养老模块首页
#define THT_PS_GETHEALTHHOME [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/invoke/getHealthHome"]
//养老院列表
#define THT_PS_GETPSLIST [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/invoke/getHomeList"]
//养老院详情
#define THT_PS_BEADHOUSEDETAIL [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/invoke/BeadhouseDetail"]
//评论点赞
#define THT_PS_THUMBSUP [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/invoke/thumbsUp"]
//获取用户信息
#define THT_USER_GETUSERINFO [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/invoke/getUserInfo"]
//修改手机号
#define THT_USER_CHANGEPHONE [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/invoke/save_phone"]
//验证验证码
#define THT_USER_VERIFYCODE [NSString stringWithFormat:@"%@%@",BASE_LINK,@"Tht/invoke/verify_code"]
#endif
