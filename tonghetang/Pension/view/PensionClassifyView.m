//
//  PensionClassifyView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import "PensionClassifyView.h"
#import "PensionClassifyItem.h"

@interface PensionClassifyView()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation PensionClassifyView
{
    __weak IBOutlet UILabel *_titleLab;
    __weak IBOutlet UICollectionView *_collectionView;
    
    NSArray *_dataArr;
}

#define PClassifyItem @"pensionClassifyItem"

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"PensionClassifyItem" bundle:nil] forCellWithReuseIdentifier:PClassifyItem];
}
#pragma mark private Methods
+(CGSize)defaultSize:(id)data
{
    NSDictionary *dic = (NSDictionary *)data;
    return CGSizeMake(Main_Screen_Width, 48 + [dic[@"rankType"] count] * 115);
}
-(void)loadDataToView:(id)data
{
    NSDictionary *dic = (NSDictionary *)data;
    _titleLab.text = dic[@"title"];
    _dataArr = dic[@"rankType"];
    [_collectionView reloadData];
}

#pragma mark delegate/dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    PensionClassifyItem *item = (PensionClassifyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:PClassifyItem forIndexPath:indexPath];
    [item loadDataToView:_dataArr[indexPath.row]];
    return item;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Main_Screen_Width, 115);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *typeId = _dataArr[indexPath.row][@"typeId"];
    NSString *title = _dataArr[indexPath.row][@"name"];
    if([_delegate respondsToSelector:@selector(toBeadHouseListWithTypeId:title:)]){
        [_delegate toBeadHouseListWithTypeId:typeId title:title];
    }
}

@end
