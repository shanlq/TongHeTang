//
//  WebViewController.h
//  tonghetang
//
//  Created by ZSY on 2019/1/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : AEFatherViewController

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL haveTitle;

@end

NS_ASSUME_NONNULL_END
