//
//  BeadHouseCollectionView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import "BeadHouseCollectionView.h"
#import "BeadHouseInfoView.h"
#import "BHIntroduceView.h"
#import "BHActivityView.h"

@interface BeadHouseCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@end

@implementation BeadHouseCollectionView
{
    NSDictionary *_dataDic;
    int _type;
}
NSString *const infoIdentify = @"beadHouseInfoId";
NSString *const introduceIdentify = @"introduceId";
NSString *const activityIdentify = @"activityId";

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if(self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        _type = 1;
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"BeadHouseInfoView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:infoIdentify];
        [self registerNib:[UINib nibWithNibName:@"BHIntroduceView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:introduceIdentify];
        [self registerNib:[UINib nibWithNibName:@"BHActivityView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:activityIdentify];
    }
    return self;
}

#pragma mark privateMethods
-(void)loadDataToView:(id)data
{
    _dataDic = (NSDictionary *)data;
    [self reloadData];
}
#pragma mark delegate/dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return [UICollectionViewCell new];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return BeadHouseInfoView.defaultSize;
    }
    else if(section == 1)
    {
        return [BHIntroduceView defaultSize:_dataDic[@"synopsis"]];
    }
    else
    {
        BHActivityView *headerView = [[NSBundle mainBundle] loadNibNamed:@"BHActivityView" owner:nil options:nil].firstObject;
        return [headerView defaultSize:_dataDic[@"introduce"] evaluate:_dataDic[@"evaluateList"] type:_type];
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader)
    {
        if(indexPath.section == 0)
        {
            BeadHouseInfoView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:infoIdentify forIndexPath:indexPath];
            headerView.delegate = _vcDelegate;
            [headerView loadDataToView:_dataDic];
            return headerView;
        }
        if(indexPath.section == 1)
        {
            BHIntroduceView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:introduceIdentify forIndexPath:indexPath];
            headerView.delegate = _vcDelegate;
            [headerView loadDataToView:_dataDic[@"synopsis"]];
            return headerView;
        }
        else
        {
            BHActivityView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:activityIdentify forIndexPath:indexPath];
            headerView.delegate = _vcDelegate;
            [headerView defaultSize:_dataDic[@"introduce"] evaluate:_dataDic[@"evaluateList"] type:_type];
            headerView.typeSelectBlock = ^(int type) {
                self->_type = type;
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            };
            return headerView;
        }
    }
    else
    {
        return [UICollectionReusableView new];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if((int)(scrollView.contentSize.height - scrollView.contentOffset.y) + 1 == (int)Main_Screen_Height && _type == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HtmlScrollEnableYES" object:nil];
    }
}

@end
