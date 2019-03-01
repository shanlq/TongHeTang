//
//  PensionViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import "PensionViewController.h"
#import "PensionCollectionView.h"
#import "CitySwitchViewController.h"
#import "Location.h"
#import "PensionProtocol.h"
#import "PensionListViewController.h"
#import "ZYSeacherViewController.h"
#import "WebViewController.h"

@interface PensionViewController ()<PensionProtocol>

@end

@implementation PensionViewController
{
    __weak IBOutlet UIButton *_cityBtn;
    __weak IBOutlet UILabel *_titleLab;
    __weak IBOutlet PensionCollectionView *_collectionView;
    
    NSDictionary *_dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    [_cityBtn setTitle:_city forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationZone) name:LocationUsrZone object:nil];
    
    self.titleText.text = @"健康养老";
    [self setLeftBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"fanhui-1" target:self action:@selector(popViewController)];
    [self setRightBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"chazhao" target:self action:@selector(searchPension)];
//    [self setRightBarButtonItemWithFrameFrame:CGRectMake(0, 0, 44, 44) title:nil imageName:@"gengduo" target:self action:@selector(msgList)];
    
    _collectionView.vcDelegate = self;
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated
{
//    if([_cityBtn.titleLabel.text isEqualToString:@"选择城市"]){
//        [_cityBtn setTitle:_city forState:UIControlStateNormal];
//    }
    [super viewWillAppear:animated];
//    [self configNavigationBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    UIButton *searchBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:100];
//    [searchBtn removeFromSuperview];
//    UIButton *msgBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:101];
//    [msgBtn removeFromSuperview];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark privateMethods
//-(void)configNavigationBar
//{
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [searchBtn setImage:[UIImage imageNamed:@"chazhao"] forState:UIControlStateNormal];
//    searchBtn.frame = CGRectMake(Main_Screen_Width - 70, 10, 20, 20);
//    searchBtn.tag = 100;
//    [searchBtn addTarget:self action:@selector(searchPension) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:searchBtn];
    
//    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [msgBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
//    msgBtn.frame = CGRectMake(Main_Screen_Width - 35, 10, 20, 20);
//    msgBtn.tag = 101;
//    [msgBtn addTarget:self action:@selector(msgList) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:msgBtn];
//}
-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestData
{
    NSDictionary* parameter = @{@"":@""};
    NSMutableDictionary *dic = [[HttpClient defaultClient] getParameter:parameter];
    
    [self showHub];
    __weak typeof (self) weakSelf = self;
    [[HttpClient defaultClient] requestWithPath:THT_PS_GETHEALTHHOME method:HttpRequestPost parameters:dic prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHub];
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if([responseObject[@"status"] intValue] == 1)
        {
            strongSelf->_dataDic = responseObject[@"data"];
            strongSelf->_titleLab.text = [NSString stringWithFormat:@"当前共有%@家养老院", strongSelf->_dataDic[@"nursingHomeCount"]];
            [strongSelf->_collectionView loadDataToView:strongSelf->_dataDic];
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
-(void)msgList
{
    
}
-(void)searchPension
{
    ZYSeacherViewController *vc = [[ZYSeacherViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark notification
-(void)locationZone
{
    [_cityBtn setTitle:UNGetObject(USER_ZONE_NAME) ? UNGetObject(USER_ZONE_NAME) : @"选择城市" forState:UIControlStateNormal];
}

#pragma mark PensionProtocol
-(void)toBeadHouseListWithTypeId:(NSString *)typeId title:(nonnull NSString *)title
{
    PensionListViewController *vc = [[PensionListViewController alloc] init];
    vc.typeId = typeId;
    vc.text = title;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)toIntroduce:(NSString *)url
{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark touchEvent

- (IBAction)citySwitch:(id)sender {
    
    CitySwitchViewController *cityVc = [[CitySwitchViewController alloc] init];
    UINavigationController *navCityVc = [[UINavigationController alloc] initWithRootViewController:cityVc];
    [self.navigationController presentViewController:navCityVc animated:YES completion:nil];
}


@end
