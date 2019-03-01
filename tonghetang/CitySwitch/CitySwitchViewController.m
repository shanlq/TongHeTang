//
//  CitySwitchViewController.m
//  aixiaoping
//
//  Created by ZSY on 2017/9/25.
//  Copyright © 2017年 ZSY. All rights reserved.
//

#import "CitySwitchViewController.h"
#import "PinYin4Objc.h"


@interface CitySwitchViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate>
{
    IBOutlet UIView *_tableHeaderView;
    
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UITextField *_textField;
    
    __weak IBOutlet UILabel *_currentLabel;
    __weak IBOutlet UIView *_locateCityView;
    __weak IBOutlet UIView *_subZonesView;
    __weak IBOutlet UIView *_recordCityView;
    __weak IBOutlet UIView *_hotCityView;
    
    __weak IBOutlet UIView *_coverView;
    
    __weak IBOutlet NSLayoutConstraint *_subZonesViewHeight;
    __weak IBOutlet NSLayoutConstraint *_hotZonesViewHeight;
    __weak IBOutlet NSLayoutConstraint *_cancelButtonWidth;
    __weak IBOutlet UIButton *_cancelButton;
    
    NSMutableArray * _cityArray;
    NSMutableDictionary * _cityDic;
    NSMutableArray * _zoneArray;
    NSMutableArray * _searchZones;
    NSString * _parentName;
}

@property (nonatomic, strong) UIImageView * searchIconImgView;

@end

@implementation CitySwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleText.text = @"城市定位";
    
    [self setLeftBarButtonItemWithFrameFrame:(CGRect){0, 0, 44, 44} title:nil imageName:@"icon_close" target:self action:@selector(popBack)];
    
    [_textField addSubview:self.searchIconImgView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self configCityData];
    
    [self configCurrentButton];
    [self configSubZones];
    [self loadZoneRecord];
    [self loadHotZones];
}

- (void)configCityData {
    
//    _cityArray = UNGetObject(CITYLIST_ZY);
    NSDictionary *dic = (NSDictionary *)UNGetSerializedObject(ALLCITYDATA);
    _cityArray = dic[@"dataList"];
    _cityDic = [[NSMutableDictionary alloc] init];
    
    NSInteger zoneId = 0;
    NSString * zoneName;
    NSInteger parentId = -1000;
    
    for (int i = 0; i < [_cityArray count]; i++)
    {
        // 城市列表数据处理
        NSNumber * string = _cityArray[i][@"level"];
        if (string.intValue != 3) {
            
            NSArray *cityArray = [_cityDic   objectForKey:_cityArray[i][@"englishChar"]];
            NSMutableArray *array ;
            
            if (cityArray) {
                array  = [NSMutableArray arrayWithArray:cityArray];
                [array addObject:_cityArray[i]];
                [_cityDic   setObject:array forKey:_cityArray[i][@"englishChar"]];
            }
            else {
                array = [NSMutableArray arrayWithArray:@[_cityArray[i]]] ;
                [_cityDic   setObject:array forKey:_cityArray[i][@"englishChar"]];
            }
        }
        
        
        NSDictionary * dic = _cityArray[i];
        
        // 定位城市数据处理
        if ( [[NSUserDefaults standardUserDefaults] integerForKey:USER_ZONE_ID] == [dic[@"zoneId"] integerValue]) {
            NSString * string = dic[@"level"];
            if (string.integerValue == 2) {                       //level：1->省  2->市  3->县区
                zoneId = [dic[@"zoneId"] integerValue];
                zoneName = dic[@"name"];
            } else {
                zoneId = [dic[@"parentZoneId"] integerValue];
            }
        }
        
        // 当前城市数据处理
        if ( [[NSUserDefaults standardUserDefaults] integerForKey:USER_ZONE_ID] == [dic[@"zoneId"] integerValue]) {
            NSString * string = dic[@"level"];
            if (string.integerValue == 3) {                  //若用户当前选择的是县区 则取上级zoneid
                parentId = [dic[@"parentZoneId"] integerValue];
            }
            if(string.integerValue == 2){                   //若是市级 则取该市的zoneid
                parentId = [dic[@"zoneId"] integerValue];
            }
        }
    }
    
    // 定位城市数据处理
    if (!zoneName) {
        
        for (int i = 0; i < [_cityArray count]; i++)
        {
            NSDictionary * dic = _cityArray[i];
            
            if (zoneId == [dic[@"zoneId"] integerValue]) {
                zoneName = dic[@"name"];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:zoneName forKey:USER_ZONE_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger: zoneId forKey:USER_ZONE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //  当前城市数据处理
    for (int i = 0; i < [_cityArray count]; i++)
    {
        NSDictionary * dic = _cityArray[i];
        
        if (parentId == [dic[@"zoneId"] integerValue]) {
            NSString * parentName = [NSString stringWithFormat:@"当前：%@  ", dic[@"name"]] ? dic[@"name"] : @"未定位到城市";
            _parentName = dic[@"name"];
            if([_parentName isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ZONE_NAME]]){
                _currentLabel.text = parentName;
            }else{
                _currentLabel.text = [parentName stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ZONE_NAME]];
            }
        }
    }
    
    if (parentId == -1000) {
        _currentLabel.text = [NSString stringWithFormat:@"当前：%@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ZONE_NAME] ? [[NSUserDefaults standardUserDefaults] objectForKey:USER_ZONE_NAME] : @"未定位到城市"];
    }
}

- (void)configSubZones {
    
    NSInteger ParentZoneId = 0;
//    NSArray * array = UNGetObject(CITYLIST_ZY);
    NSDictionary *dic = (NSDictionary *)UNGetSerializedObject(ALLCITYDATA);
    NSArray *array = dic[@"dataList"];
    for (NSDictionary * dic in array) {
        //        [UNGetObject(USER_ZONE_NAME) rangeOfString:dic[@"name"]].location != NSNotFound
        if ( [[NSUserDefaults standardUserDefaults] integerForKey:USER_ZONE_ID] == [dic[@"zoneId"] integerValue]) {
            NSString * string =dic[@"level"];
            if (string.integerValue == 2) {
                ParentZoneId = [dic[@"zoneId"] integerValue];
            } else {
                ParentZoneId = [dic[@"parentZoneId"] integerValue];
            }
        }
    }
    _zoneArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary * dic in array) {
        
        if (ParentZoneId == [dic[@"parentZoneId"] integerValue]) {
            [_zoneArray addObject:dic];
        }
    }
    
    NSString * zoneName;
    NSInteger selDistrictId;
    
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = (Main_Screen_Width - 3 * 10 - 24) / 3;
    CGFloat height = 38.f;
    
    for (int i = 0; i <= [_zoneArray count]; i++){
        
        if (i == 0){ // 全部
            zoneName = @"全部";
            selDistrictId = -1;
        } else { // 县，区
            zoneName = [[_zoneArray objectAtIndex:i - 1] objectForKey:@"name"];
            selDistrictId = [[[_zoneArray objectAtIndex:i - 1] objectForKey:@"zoneId"] integerValue];
        }
        
        NSInteger x_idx = i % 3 + 1;
        NSInteger y_idx = i / 3;
        
        UIButton * button = [self zoneButtonCreateX:x * x_idx + (x_idx - 1) * width Y: y + y_idx * (10 + height) Title:zoneName];
        button.tag = selDistrictId == -1 ? ParentZoneId : selDistrictId;
        [button addTarget:self action:@selector(subZoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_subZonesView addSubview:button];
    }
}

- (void)subZoneButtonClicked:(UIButton*)button
{
    NSString * zoneName = [button titleForState:UIControlStateNormal];
    if ([zoneName isEqualToString:@"全部"]) {
        zoneName = _parentName;
    }
    NSInteger zoneId = button.tag;
    
    [[NSUserDefaults standardUserDefaults]  setObject:zoneName forKey:USER_ZONE_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger: zoneId forKey:USER_ZONE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUsrZone object:nil];
    
//    [self popWithAnimate];
    
    [self saveZoneRecordWithName:zoneName ZoneId:[NSString stringWithFormat:@"%d", (int)zoneId]];
    
    [self popBack];
}

- (IBAction)showSubZones:(UIButton *)sender {
    
    CGFloat height = 38.f;
    CGFloat subZonesHeight = (_zoneArray.count + 1 - 1)/3 * (10 + height) + height + 15;
    
    _tableView.tableHeaderView = nil;
    
    if (_subZonesViewHeight.constant == 0) {
        
        _subZonesViewHeight.constant = subZonesHeight;
        CGRect frame = _tableHeaderView.frame;
        _tableHeaderView.frame = (CGRect){frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + subZonesHeight};
        
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, M_PI);//旋转180
        //[UIImage imageWithCGImage:image.CGImageRef scale:1 orientation:UIImageOrientationLeft];
    }
    else {
        _subZonesViewHeight.constant = 0;
        CGRect frame = _tableHeaderView.frame;
        _tableHeaderView.frame = (CGRect){frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - subZonesHeight};
        
        sender.imageView.transform = CGAffineTransformIdentity;
    }
    
    _tableView.tableHeaderView = _tableHeaderView;
}

- (void)configCurrentButton {
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:USER_ZONE_NAME]) {
        
        NSString * city = [[NSUserDefaults standardUserDefaults]  valueForKey:USER_ZONE_NAME];
        UIButton * button = [self zoneButtonCreateX:10 Y:40 Title:city];
        [button addTarget:self action:@selector(currentCityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_locateCityView addSubview:button];
    }
}

- (void)currentCityButtonClicked:(UIButton*)button
{
    NSString * zoneName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ZONE_NAME];
    NSInteger zoneId = (NSInteger)[[NSUserDefaults standardUserDefaults] integerForKey:USER_ZONE_ID];
    
    [[NSUserDefaults standardUserDefaults]  setObject:zoneName forKey:USER_ZONE_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger: zoneId forKey:USER_ZONE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUsrZone object:nil];
    
//    [self popWithAnimate];
    
    [self saveZoneRecordWithName:zoneName ZoneId:[NSString stringWithFormat:@"%d", (int)zoneId]];
    
    [self popBack];
}


- (UIButton *)zoneButtonCreateX:(CGFloat)x Y:(CGFloat)y Title:(NSString *)title {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
    button.layer.masksToBounds = true;
    
    CGFloat width = (Main_Screen_Width - 3 * 10 - 24) / 3;
    CGFloat height = 38.f;
    button.frame = (CGRect){x, y, width, height};
    
    return button;
}

- (void)recordButtonClicked:(UIButton*)button
{
    NSArray * zones = (NSArray *)UNGetSerializedObject(@"ZonesReocrd");
    NSString * name = @"";
    NSString * zoneId = @"";
    
    for (NSDictionary * dict in zones) {
        if ([dict[@"name"] isEqualToString:[button titleForState:UIControlStateNormal]]) {
            name = dict[@"name"];
            zoneId = dict[@"zoneId"];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]  setObject:name forKey:USER_ZONE_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger: [zoneId intValue] forKey:USER_ZONE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUsrZone object:nil];
    
//    [self popWithAnimate];
    [self popBack];
}

- (void)loadZoneRecord {
    
    NSArray * zones = (NSArray *)UNGetSerializedObject(@"ZonesReocrd");
    
    if (!zones || zones.count == 0) {
        NSString * name = [[NSUserDefaults standardUserDefaults]  valueForKey:USER_ZONE_NAME];
        NSString * zoneId = [[NSUserDefaults standardUserDefaults]  valueForKey:USER_ZONE_ID];
        [self saveZoneRecordWithName:name ZoneId:zoneId];
    }
    
    zones = (NSArray *)UNGetSerializedObject(@"ZonesReocrd");
    
    for (NSInteger idx = 0; idx < zones.count; idx ++) {
        
        NSDictionary * dict = zones[idx];
        CGFloat width = (Main_Screen_Width - 3 * 10 - 24) / 3;
        UIButton * button = [self zoneButtonCreateX:10 * (idx+1) + idx * width Y:40 Title:dict[@"name"]];
        [button addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_recordCityView addSubview:button];
    }
}

- (void)saveZoneRecordWithName:(NSString *)name ZoneId:(NSString *)zoneId {
    
    if (!name || [name length] <= 0) {
        return;
    }
    
    NSArray * zones = (NSArray *)UNGetSerializedObject(@"ZonesReocrd");
    
    for (NSDictionary * dict in zones) {
        if ([dict[@"zoneId"] integerValue] == zoneId.integerValue) {
            return;
        }
    }
    
    NSDictionary * dict = @{@"name" : name,
                            @"zoneId" : zoneId
                            };
    NSMutableArray * new_zones = [NSMutableArray arrayWithArray:zones];
    [new_zones addObject:dict];
    if (new_zones.count > 3) {
        [new_zones removeObjectAtIndex:0];
    }
    UNSaveSerializedObject(new_zones, @"ZonesReocrd");
}

- (void)hotButtonClicked:(UIButton*)button
{
//    NSArray * hotZones = UNGetSerializedObject(HOT_ZONES);
    NSDictionary *dic = (NSDictionary *)UNGetSerializedObject(ALLCITYDATA);
    NSArray *hotZones = dic[@"hotDataList"];
    NSDictionary * dict = hotZones[button.tag];
    
    [[NSUserDefaults standardUserDefaults]  setObject:dict[@"name"] forKey:USER_ZONE_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger: [dict[@"zoneId"] intValue] forKey:USER_ZONE_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUsrZone object:nil];
    
    [self saveZoneRecordWithName:dict[@"name"] ZoneId:dict[@"zoneId"]];
    
//    [self popWithAnimate];
    [self popBack];
}

- (void)loadHotZones {
    
//    NSArray * hotZones = UNGetSerializedObject(HOT_ZONES);
    NSDictionary *dic = (NSDictionary *)UNGetSerializedObject(ALLCITYDATA);
    NSArray *hotZones = dic[@"hotDataList"];
    
    if (!hotZones || hotZones.count <= 0) {
        return;
    }
    
    CGFloat x = 10;
    CGFloat y = 40;
    CGFloat width = (Main_Screen_Width - 3 * 10 - 24) / 3;
    CGFloat height = 38.f;
    
    for (NSInteger idx = 0; idx < hotZones.count; idx++) {
        
        NSDictionary * dict = hotZones[idx];
        
        NSInteger x_idx = idx % 3 + 1;
        NSInteger y_idx = idx / 3;
        
        UIButton * button = [self zoneButtonCreateX:x * x_idx + (x_idx - 1) * width Y: y + y_idx * (10 + height) Title:dict[@"name"]];
        button.tag = idx;
        [button addTarget:self action:@selector(hotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_hotCityView addSubview:button];
    }
    
    CGFloat header_height = 330.f + (hotZones.count - 1)/3 * (10 + height);
    _tableHeaderView.frame = (CGRect){0, 0, Main_Screen_Width, header_height};
    _tableView.tableHeaderView = _tableHeaderView;
    _hotZonesViewHeight.constant = 93 + (hotZones.count - 1)/3 * (10 + height);
}

- (UIImageView *)searchIconImgView {
    
    if (!_searchIconImgView) {
        CGFloat x = (Main_Screen_Width - 28.f * 2 - 180.f) / 2.f - 27.5f;
        _searchIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x + 27.5f + 7.5f, 5.f, 20, 20)];
        _searchIconImgView.contentMode = UIViewContentModeCenter;
        _searchIconImgView.image = [UIImage imageNamed:@"icon_magnifying_glass"];
    }
    return _searchIconImgView;
}



#pragma mark - UITablViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    if (_searchZones.count > 0) {
        return 1;
    }
    
    return [[_cityDic  allKeys] count]  ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchZones.count > 0) {
        return _searchZones.count;
    }
    
    NSArray *array = [[_cityDic  allKeys]  sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    if (array.count > 0) {
        return [_cityDic[array[section ]]  count];
    }
    
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSString * zoneName;
    NSInteger zoneId;
    
    if (_searchZones.count > 0) {
        NSDictionary * dict = _searchZones[indexPath.row];
        zoneName = dict[@"name"];
        zoneId = [dict[@"zoneId"] integerValue];
    }
    else {
        NSArray *array = [[_cityDic  allKeys]  sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        zoneName = _cityDic[array[indexPath.section ]][indexPath.row][@"name"];
        zoneId = [_cityDic[array[indexPath.section]][indexPath.row][@"zoneId"] intValue];
    }
    
    [[NSUserDefaults standardUserDefaults]  setObject:zoneName forKey:USER_ZONE_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger:zoneId  forKey:USER_ZONE_ID];
//    NSInteger a = [_cityDic[array[indexPath.section]][indexPath.row][@"zoneId"] intValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationUsrZone object:nil];
    
    [self saveZoneRecordWithName:zoneName ZoneId:[NSString stringWithFormat:@"%d", (int)zoneId]];
    
//    [self popWithAnimate];
    [self popBack];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myTabelViewCell = [tableView dequeueReusableCellWithIdentifier:@"switchViewCell"];
    
    if (myTabelViewCell==nil)
    {
        myTabelViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switchViewCell"];
        myTabelViewCell.selectionStyle = UITableViewCellAccessoryNone;
    }
    if (_searchZones.count > 0) {
        NSDictionary * dict = _searchZones[indexPath.row];
        myTabelViewCell.textLabel.text = dict[@"name"];
    }
    else {
        NSArray *array = [[_cityDic  allKeys]  sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        myTabelViewCell.textLabel.text = _cityDic[array[indexPath.section]][indexPath.row][@"name"];
    }
    myTabelViewCell.textLabel.textAlignment = NSTextAlignmentLeft;
    myTabelViewCell.textLabel.font = [UIFont systemFontOfSize:15];
    return myTabelViewCell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (_searchZones.count > 0) {
        return nil;
    }
    
    NSArray *array = [[_cityDic  allKeys]  sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    if (array.count == 0) {
        return nil;
    }
    return [array objectAtIndex:section];
}

//tableview系统索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    if (_searchZones.count > 0) {
        return @[];
    }

    NSArray *array = [[_cityDic  allKeys]  sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

    if (array.count == 0) {
        return @[];
    }

    return array ? array : [NSArray new];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {

    return index;
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_cityDic.count <= 0) {
        return true;
    }
    
    _coverView.hidden = false;
    _tableView.scrollEnabled = false;
    _cancelButtonWidth.constant = 46;
    _cancelButton.hidden = false;
    self.searchIconImgView.frame = CGRectMake(7.5f, 5.f, 20, 20);
    
    if (string.length == 1) {
        
        const char * c = [string cStringUsingEncoding:NSUTF8StringEncoding];
        
        if (strcmp(c, "\n") == 0) {
            [textField resignFirstResponder];
            _coverView.hidden = true;
            _tableView.scrollEnabled = true;
            return true;
        }
    }
    
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _searchZones = nil;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str.length > 0) {
        
        for (int i = 0; i < [_cityArray count]; i++) {
            
            NSDictionary * dict = _cityArray[i];
            NSString * thisName = dict[@"name"];
            
            BOOL match1 = [thisName containsString:str];
            BOOL match2 = [str containsString:thisName];
            BOOL match3 = [dict[@"pinYin"] containsString:str];
            
            if (match1 || match2 || match3) {
                
                if (_searchZones) {
                    [_searchZones addObject:dict];
                }
                else {
                    _searchZones = [NSMutableArray array];
                    [_searchZones addObject:dict];
                }
            }
        }
        
        [_tableView reloadData];
    }
    else {
        _searchZones = nil;
        [_tableView reloadData];
    }
    
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    _coverView.hidden = true;
    _tableView.scrollEnabled = true;
    _cancelButtonWidth.constant = 0;
    _cancelButton.hidden = true;
    
    CGFloat x = (Main_Screen_Width - 28.f * 2 - 180.f) / 2.f - 27.5f;
    self.searchIconImgView.frame = CGRectMake(x + 27.5f + 7.5f, 5.f, 20, 20);
    
    return true;
}

- (IBAction)coverViewTap:(id)sender {
    
    _coverView.hidden = true;
    _tableView.scrollEnabled = true;
    [_textField resignFirstResponder];
    _cancelButtonWidth.constant = 0;
    _cancelButton.hidden = false;
    
    CGFloat x = (Main_Screen_Width - 28.f * 2 - 180.f) / 2.f - 27.5f;
    self.searchIconImgView.frame = CGRectMake(x + 27.5f + 7.5f, 5.f, 20, 20);
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    _coverView.hidden = true;
    _tableView.scrollEnabled = true;
    _textField.text = nil;
    _searchZones = nil;
    [_textField resignFirstResponder];
    
    _cancelButtonWidth.constant = 0;
    _cancelButton.hidden = false;
    [_tableView reloadData];
    
    CGFloat x = (Main_Screen_Width - 28.f * 2 - 180.f) / 2.f - 27.5f;
    self.searchIconImgView.frame = CGRectMake(x + 27.5f + 7.5f, 5.f, 20, 20);
}

- (void)popBack {
    
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}



@end
