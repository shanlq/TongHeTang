//
//  ZYSeacherViewController.m
//  aixiaoping
//
//  Created by Zhao on 16/8/18.
//  Copyright © 2016年 ZSY. All rights reserved.
//

#import "ZYSeacherViewController.h"
#import "SearchTextField.h"
#import "SearchRecordCell.h"
#import "PensionListViewController.h"

#define JILU  @"历史记录"

@interface ZYSeacherViewController ()
<UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
SearchRecordDelegate>
{
    IBOutlet UIView *_tableHeaderView;
    __weak IBOutlet UITableView *_recordTabelView;
    //约束
    __weak IBOutlet NSLayoutConstraint *_tableViewBottom;
}

@property (strong , nonatomic) UITextField * searchFieldTitleView;
@property(strong,nonatomic) NSMutableArray * JIluArray;   //历史记录
@property(strong,nonatomic) NSMutableArray * buttonArray;

@end

@implementation ZYSeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// Nav
    self.searchFieldTitleView = [[SearchTextField alloc] init];
    self.searchFieldTitleView.delegate = self;
    self.navigationItem.titleView = self.searchFieldTitleView;
    
    /// Data
    self.JIluArray = [[NSMutableArray alloc] initWithArray:UNGetObject(JILU)];
    _buttonArray = [[NSMutableArray alloc]init];
    
    /// Config
    
    [self setRightBarButtonItemWithFrameFrame:(CGRect){0, 0, 44, 44} title:@"搜索" imageName:nil target:self action:@selector(search)];
        
    [_recordTabelView registerNib:[UINib nibWithNibName:@"SearchRecordCell" bundle:nil] forCellReuseIdentifier:@"SearchRecordCell"];
    _recordTabelView.rowHeight = 41;
    _recordTabelView.tableHeaderView = _tableHeaderView;

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_searchFieldTitleView)
    {
        _searchFieldTitleView.text = nil;
    }
    
    [self SetTableViewHeight];
    [_recordTabelView reloadData];
}

-(void)SetTableViewHeight
{
    CGRect statusFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat barHeight = self.navigationController.navigationBar.size.height + statusFrame.size.height;
    _tableViewBottom.constant = self.JIluArray.count == 0 ? Main_Screen_Height - barHeight : (Main_Screen_Height - barHeight < (self.JIluArray.count * _recordTabelView.rowHeight + 40) ? 0 : Main_Screen_Height - barHeight - (self.JIluArray.count * _recordTabelView.rowHeight + 40));
    _recordTabelView.contentSize = CGSizeMake(Main_Screen_Width, self.JIluArray.count * _recordTabelView.rowHeight + 40);
}

- (void)search {
    
    if (_searchFieldTitleView.text.length <= 0) {
        return;
    }
    
    if (![self.JIluArray containsObject:_searchFieldTitleView.text])
    {
        [self.JIluArray addObject:_searchFieldTitleView.text];
        UNSaveObject(self.JIluArray, JILU);
        [_recordTabelView reloadData];
    }
    else
    {
        [self.JIluArray removeObject:_searchFieldTitleView.text];
        [self.JIluArray addObject:_searchFieldTitleView.text];
    }
    
    [self pushGoodList:_searchFieldTitleView.text];
    
    [_searchFieldTitleView resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 12) {
        return NO;
    }
    return YES;
}

- (void)pushGoodList:(NSString*)seacher {
    
    PensionListViewController *vc = [[PensionListViewController alloc] init];
    vc.search = seacher;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)buttonClick:(UIButton*)button
{
    self.searchFieldTitleView.text = button.titleLabel.text;
    [self pushGoodList:button.titleLabel.text];
}

- (IBAction)clearButto:(id)sender {
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您即将清除搜索记录，确认此操作？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.JIluArray removeAllObjects];
        UNSaveObject(self.JIluArray, JILU);
        [self SetTableViewHeight];
        [self->_recordTabelView reloadData];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:true completion:nil];
}

- (void)singleRecordClear:(NSString *)record {
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您即将清除搜索记录，确认此操作？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.JIluArray containsObject:record]) {
            [self.JIluArray removeObject:record];
            UNSaveObject(self.JIluArray, JILU);
            [self SetTableViewHeight];
            [self->_recordTabelView reloadData];
        }
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:true completion:nil];
}

- (void)searchViewReset {
    
    self.searchFieldTitleView.text = @"";
    [self setRightBarButtonItemWithFrameFrame:(CGRect){0, 0, 44, 44} title:@"搜索" imageName:nil target:self action:@selector(search)];
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.JIluArray ? self.JIluArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchRecordCell"];
    cell.record = self.JIluArray[self.JIluArray.count - 1 - indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSString *str = self.JIluArray[self.JIluArray.count - 1 - indexPath.row];
    [self.JIluArray removeObject:str];
    [self.JIluArray addObject:str];
    UNSaveObject(self.JIluArray, JILU);
    [self pushGoodList:str];
}


@end
