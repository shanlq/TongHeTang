
//  Created by Huan Cho on 13-8-9.


#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

@end
