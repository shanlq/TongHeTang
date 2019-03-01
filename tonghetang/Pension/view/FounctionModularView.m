//
//  FounctionModularView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import "FounctionModularView.h"
#import "ClassifyItem.h"

@interface FounctionModularView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation FounctionModularView
{
    __weak IBOutlet UICollectionView *_classifyCollectionView;
    __weak IBOutlet UILabel *_titleLab;
    
    NSArray *_dataArr;
}

#define cellIdentify @"founctionItem"

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _classifyCollectionView.delegate = self;
    _classifyCollectionView.dataSource = self;
    [_classifyCollectionView registerNib:[UINib nibWithNibName:@"ClassifyItem" bundle:nil] forCellWithReuseIdentifier:cellIdentify];
}

#pragma mark private Methods
+(CGSize)defaultSize:(id)data
{
    NSArray *arr = (NSArray *)data;
    CGFloat height = arr.count % 4 == 0 ? (arr.count/4)*50 : (arr.count/4+1)*50;
    return CGSizeMake(Main_Screen_Width, height + 40);
}
-(void)loadDataToView:(id)data
{
    _dataArr = (NSArray *)data;
    [_classifyCollectionView reloadData];
}

#pragma mark delegate/dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ClassifyItem *item = (ClassifyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentify forIndexPath:indexPath];
    [item loadDataToView:_dataArr[indexPath.row][@"name"]];
    return item;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int itemNum = _dataArr.count >= 4 ? 4 : _dataArr.count;
    return CGSizeMake((Main_Screen_Width - itemNum*20)/itemNum, 50);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(toBeadHouseListWithTypeId:title:)]){
        [_delegate toBeadHouseListWithTypeId:_dataArr[indexPath.row][@"typeId"] title:_dataArr[indexPath.row][@"name"]];
    }
}

#pragma mark touchEvnet

- (IBAction)toIntroduce:(id)sender {
    
    if([_delegate respondsToSelector:@selector(toIntroduce:)]){
        [_delegate toIntroduce:@""];
    }
}

@end
