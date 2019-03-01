//
//  CustomAlertView.h
//  tonghetang
//
//  Created by ZSY on 2018/6/13.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

typedef void(^loginBlock)(void);
typedef void(^changeBlock)(void);

@property (nonatomic, strong) loginBlock phoneLoginBlock;
@property (nonatomic, strong) changeBlock changePhoneBlock;

+(instancetype)LoadXibView;
-(void)showAlertView;
-(void)hideAnimation;

@end
