
//  Created by Huan Cho on 13-8-9.


#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark show error
+ (void)showError:(NSString *)error toView:(UIView *)view{
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = error;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_failed_icon.png"]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
}

#pragma mark show message
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1];
    
    return hud;
}

@end
