//
//  AEFatherViewController.h
//  AntElephant
//
//  Created by Dee on 2/5/15.
//  Copyright (c) 2015 Dee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEFatherViewController : UIViewController
{
    UIActivityIndicatorView *uaiv;
    
}

@property (nonatomic,strong) UILabel *titleText;

/**
 * 呈现加载框
 */
-(void)showHub;

/**
 * 隐藏加载框
 */
- (void)hideHub;

/**
 * 开始加载
 */
- (void)startAnimate;

/**
 * 结束加载
 */
-(void)endAnimate;

/**
 *  设置右上角的按钮（不带图片）
 */

- (void)setRightBarButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action;

/**
 *  设置右上角的按钮（带图片）
 */

- (void)setRightBarButtonItemWithFrameFrame:(CGRect)frame
                                      title:(NSString *)title
                                  imageName:(NSString *)imageName
                                     target:(id)target
                                     action:(SEL)action;


/**
 *  设置左上角的按钮（不带图片）
 */
- (void)setLeftBarButtonItemWithTitle:(NSString *)title
                               target:(id)target
                               action:(SEL)action;

/**
 *  设置左上角的按钮（带图片）
 */
- (void)setLeftBarButtonItemWithFrameFrame:(CGRect)frame
                                     title:(NSString *)title
                                 imageName:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action;
//移除有上角按钮
- (void)setRemoveRightBarButtonItem;
//设置是否显示右上角按钮
- (BOOL)isRightBarButtonExist;


-(void)showHudWithTitle:(NSString*)titleString;


-(void)showHubWithMode;

- (void)presentPopUpView:(UIViewController*)aPopup;
- (void)dismissPopupView;

//一个label两种颜色
-(NSMutableAttributedString*)setString:(NSString*)string colorOne:(UIColor*)colorOne colorTwo:(UIColor*)colorTwo numberOne:(NSInteger)numberOne numberTwo:(NSInteger)numberTwo sizeOne:(NSInteger)sizeOne sizeTwo:(NSInteger)sizeTwo;

- (void)receivedNetworkStatus:(NSNotification *)notification;
//弹框提示1
-(void)showAlertWithMessage:(NSString *)message title:(NSString *)title left:(NSString *)left right:(NSString *)right leftAction:(void(^)(void))leftAction rightAction:(void(^)(void))rightAction;
//提示2
-(void)showAlertWithMessage:(NSString *)message title:(NSString *)title right:(NSString *)right rightAction:(void(^)(void))rightAction;
//提示3
-(void)showAlertWithSatusMessage:(NSString *)message title:(NSString *)title time:(CGFloat)time;

@end
