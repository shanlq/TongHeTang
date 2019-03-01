//
//  BeadHouseViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import "BeadHouseViewController.h"
#import "BeadHouseCollectionView.h"
#import "WebViewController.h"
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface BeadHouseViewController ()<BeadHouseProtocol, BMKRouteSearchDelegate>

@property (nonatomic, strong) BeadHouseCollectionView *collectionView;

@end

@implementation BeadHouseViewController
{
    NSDictionary *_dataDic;
    BMKRouteSearch *_mapSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleText.text = self.text;
    [self requestData];
}

#pragma mark privateMethods
-(void)requestData
{
    NSDictionary* parameter = @{@"houseId": (NSString *)_data};
    NSMutableDictionary *dic = [[HttpClient defaultClient] getParameter:parameter];
    
    [[HttpClient defaultClient] requestWithPath:THT_PS_BEADHOUSEDETAIL method:HttpRequestPost parameters:dic prepareExecute:^{
        
        [self showHubWithMode];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHub];
        if([responseObject[@"status"] intValue] == 1)
        {
            self->_dataDic = responseObject[@"data"];
            [self.collectionView loadDataToView:self->_dataDic];
        }
        else
        {
            [self showAlertWithSatusMessage:responseObject[@"message"] title:nil time:1.5];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self hideHub];
        [self showAlertWithSatusMessage:@"网络错误" title:nil time:1.5];
    }];
}
-(void)toBaiduMap
{
    //    //打开地图 公交路线检索
    //    BMKOpenTransitRouteOption *opt = [[BMKOpenTransitRouteOption alloc] init];
    //打开地图 驾车路线检索
    BMKOpenDrivingRouteOption *opt = [[BMKOpenDrivingRouteOption alloc] init];
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    start.pt = CLLocationCoordinate2DMake([UNGetObject(USERLAT) doubleValue], [UNGetObject(USERLNG) doubleValue]);
    //指定起点名称
    start.name = @"我的位置";
    //指定起点
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = CLLocationCoordinate2DMake([_dataDic[@"lat"] doubleValue], [_dataDic[@"lng"] doubleValue]);
    //指定终点名称
    end.name = _dataDic[@"address"];
    opt.endPoint = end;
    
    //    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapTransitRoute:opt];      //公交
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapDrivingRoute:opt];              //驾车
    if (code != BMK_OPEN_NO_ERROR) {
        NSLog(@"导航开启失败");
    }
}
#pragma mark getter
-(BeadHouseCollectionView *)collectionView
{
    if(!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[BeadHouseCollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
        _collectionView.vcDelegate = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark BeadHouseProtocol
-(void)beadHouseIntroduce:(CGFloat)height
{
    
}
-(void)navigationToBeadHouse
{
    [self showAlertWithMessage:@"即将开始导航，确认此操作？" title:nil left:@"取消" right:@"确认" leftAction:nil rightAction:^{
        [self toBaiduMap];
    }];
    
}
-(void)laudWithCommentId:(NSString *)commentId
{
    NSDictionary* parameter = @{@"evaluateId":commentId};
    NSMutableDictionary *dic = [[HttpClient defaultClient] getParameter:parameter];
    
    [[HttpClient defaultClient] requestWithPath:THT_PS_THUMBSUP method:HttpRequestPost parameters:dic prepareExecute:^{
        
        [self showHubWithMode];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHub];
        if([responseObject[@"status"] intValue] == 1)
        {
            [self requestData];
        }
        else
        {
            [self showAlertWithSatusMessage:responseObject[@"message"] title:nil time:1.5];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self hideHub];
        [self showAlertWithSatusMessage:@"网络错误" title:nil time:1.5];
    }];
}
-(void)toAboutThtWebView
{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.url = _dataDic[@"thtUrl"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
