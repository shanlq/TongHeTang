//
//  PensionListViewController.m
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import "PensionListViewController.h"
#import "PensionCell.h"
#import "UIScrollView+NOData.h"
#import "ZYSeacherViewController.h"
#import "BeadHouseViewController.h"

@interface PensionListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) int indexPage;

@end

@implementation PensionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indexPage = 1;
    [self configNavigationBar];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIButton *searchBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:100];
    [searchBtn removeFromSuperview];
}
#pragma mark privateMethods
-(void)configNavigationBar
{
    self.titleText.text = self.text;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"chazhao"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(Main_Screen_Width - 70, 10, 20, 20);
    searchBtn.tag = 100;
    [searchBtn addTarget:self action:@selector(searchPension) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:searchBtn];
}
-(void)requestData
{
    NSDictionary* parameter = @{@"pageIndex":@(self.indexPage), @"typeId":_typeId ? _typeId : @"", @"search":_search ? _search : @""};
    NSMutableDictionary *dic = [[HttpClient defaultClient] getParameter:parameter];
    
    [[HttpClient defaultClient] requestWithPath:THT_PS_GETPSLIST method:HttpRequestPost parameters:dic prepareExecute:^{
        
        [self showHubWithMode];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideHub];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if([responseObject[@"status"] intValue] == 1)
        {
            NSArray *arr = responseObject[@"data"][@"dataList"];
            [self.dataArr addObjectsFromArray:arr];
            if(self.indexPage > [responseObject[@"data"][@"pageSize"] intValue])
            {
                if([responseObject[@"data"][@"pageSize"] intValue] == 0){
                    self.tableView.mj_footer.hidden = YES;
                }
                else{
                    [self.tableView.mj_footer resetNoMoreData];
                }
            }
        }
        else
        {
            [self showAlertWithSatusMessage:responseObject[@"message"] title:nil time:1.5];
        }
        [self.tableView reloadData];
        [self.tableView showNoDataViewByData:self.dataArr text:@"暂无养老院"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self hideHub];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [self.tableView showNoDataViewByData:self.dataArr text:@"暂无养老院"];
        [self showAlertWithSatusMessage:@"网络错误" title:nil time:1.5];
    }];
}
-(void)searchPension
{
    ZYSeacherViewController *vc = [[ZYSeacherViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark delegate/dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
//afs
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PensionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pensionCell"];
    if(!cell){
        cell = [[NSBundle mainBundle] loadNibNamed:@"PensionCell" owner:nil options:nil].firstObject;
    }
    [cell loadDataToView:self.dataArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pensionIntroduce = self.dataArr[indexPath.row][@"description"];
    CGRect rect = [pensionIntroduce boundingRectWithSize:CGSizeMake(Main_Screen_Width - 130, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return 250 + CGRectGetHeight(rect);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeadHouseViewController *vc = [[BeadHouseViewController alloc] init];
    vc.data = self.dataArr[indexPath.row][@"typeId"];
    vc.text = self.dataArr[indexPath.row][@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark getter
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        __weak typeof (self) weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            strongSelf.indexPage = 1;
            [strongSelf.dataArr removeAllObjects];
            [strongSelf requestData];
        }];
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            __strong typeof (weakSelf) strongSelf = weakSelf;
            strongSelf.indexPage ++;
            [strongSelf requestData];
        }];
    }
    return _tableView;
}
-(NSMutableArray *)dataArr
{
    if(!_dataArr)
    {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

@end
