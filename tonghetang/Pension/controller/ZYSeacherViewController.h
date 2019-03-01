//
//  ZYSeacherViewController.h
//  aixiaoping
//
//  Created by Zhao on 16/8/18.
//  Copyright © 2016年 ZSY. All rights reserved.
//

#import "AEFatherViewController.h"

typedef NS_ENUM(NSUInteger, SearchMode) {
    SearchModeHome,
    SearchModeSqgw,
    SearchModeStores
};

@interface ZYSeacherViewController : AEFatherViewController

//@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, assign) SearchMode searchMode;
@property (nonatomic, strong) void (^sqgwSearched)(NSString *searchText);
//@property (nonatomic, copy) NSString * searchUrl;

@end
