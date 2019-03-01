//
//  AEMacro.h
//  AntElephant
//
//  Created by Dee on 2/5/15.
//  Copyright (c) 2015 Dee. All rights reserved.
//

#ifndef AntElephant_AEMacro_h
#define AntElephant_AEMacro_h

//微信登录
//每天积分
//#define wxappId @"wx466dd364a7b82daa"
//#define wxappSecret @"18d894d1a2111fc300fb42cb0f30db86"
//易洛淘
#define wxappId @"wxb42b880af42d17f4"
#define wxappSecret @"203b8482581814dbed2e9ab2bf51365c"
//百度
//每天积分
//#define baidappId @"fAcFM5llq88UIuLmFNFW0ERIZ1smP7lP"
#define baidappId @"nP8VuTmU1GDWogCKoYSwYIe89aQfQPYg"
// app是否第一次开
#define APP_IS_FIRST_LAUNCH  @"afdfdfdafdacccssc"
//
#define AD_LAST_ALERT_Time  @"cbadadddd"


//账号  密码  
#define USER_USERNAME @"username"

#define USER_USERPSW @"userPassword"

#define USER_SERVICE @"userService"


#define ShareHudTag  666

//通知 key
#define WXLoginCode @"WeiXinLoginCode"          //微信授权登录 获取code
#define ReloadHomeUrl @"reloadHomeDataUrl"       //更新首页网页的url

//本地存储 key
#define HomeGoodsListUrl @"homeGoodsListUrl"      //首页链接
#define UserWXInfo @"userInfoWX"                  //用户的微信基础信息
#define ISFIRSTLOGIN @"isFirstLogin"
#define USERINFO @"userInfoModel"



#define weakly(o) autoreleasepool{} __weak typeof(o) w##o = o;
#define strongly(o) autoreleasepool{} __strong typeof(o) s##o = o;


#endif
