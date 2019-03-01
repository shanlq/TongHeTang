//
//  WebView.h
//  tonghetang
//
//  Created by ZSY on 2018/12/24.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomWebView : UIView

@property (nonatomic, strong) void(^showTitleBlock)(BOOL canGoBack);
@property (nonatomic, strong) void(^webReloadBlock)();
@property (nonatomic, strong) void(^loadFinishBlock)();
@property (nonatomic, strong) void(^exitBlock)();
@property (nonatomic, strong) void(^titleBlock)(NSString *title);
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
