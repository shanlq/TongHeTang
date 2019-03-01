//
//  PensionCollectionView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import "PensionCollectionView.h"
#import "PImgScrollView.h"
#import "FounctionModularView.h"
#import "PensionClassifyView.h"

@interface PensionCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *introduceBtn;

@end

@implementation PensionCollectionView
{
    NSDictionary *_dataDic;
}

static NSString *const imgIdentify = @"pensionCollectionImgId";
static NSString *const classifyIdentify = @"pensionCollectionClassifyId";
static NSString *const introduceIdentify = @"introduceIdentifier";

//-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
//{
//    if(self = [super initWithFrame:frame collectionViewLayout:layout])
//    {
//        self.delegate = self;
//        self.dataSource = self;
//        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
//        flowLayout.minimumLineSpacing = 0;
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//
//        [self registerClass:[[PImgScrollView alloc] init] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:imgIdentify];
//        [self registerNib:[UINib nibWithNibName:@"FounctionModularView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:classifyIdentify];
//        [self registerNib:[UINib nibWithNibName:@"FounctionModularView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:introduceIdentify];
//    }
//    return self;
//}

#pragma mark private Methods
-(void)loadDataToView:(id)data
{
    self.delegate = self;
    self.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    [self registerClass:[PImgScrollView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:imgIdentify];
    [self registerNib:[UINib nibWithNibName:@"FounctionModularView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:classifyIdentify];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:introduceIdentify];
    
    _dataDic = (NSDictionary *)data;
    for(int i = 0; i < [_dataDic[@"nursingHomeType"] count]; i++)
    {
        [self registerNib:[UINib nibWithNibName:@"PensionClassifyView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[NSString stringWithFormat:@"pension%d", i]];
    }
    [self reloadData];
}
#pragma mark delegate/dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSArray *classifyArr = _dataDic[@"nursingHomeType"];
    return 3 + classifyArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return [UICollectionViewCell new];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSArray *classifyArr = _dataDic[@"nursingHomeType"];
    if(section == 0){
        return [PImgScrollView defaultSize:_dataDic[@"banners"]];
    }
    if(section == 1){
        return [FounctionModularView defaultSize:_dataDic[@"classifiesTag"]];
    }
    for(int i = 0; i < classifyArr.count; i++)
    {
        if(section == 2 + i)
        {
            return [PensionClassifyView defaultSize:classifyArr[i]];
        }
    }
    if(collectionView.numberOfSections - 1 == section){
        return CGSizeMake(Main_Screen_Width, 80);
    }
    else{
        return CGSizeZero;
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader)
    {
        if(indexPath.section == 0)
        {
            PImgScrollView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:imgIdentify forIndexPath:indexPath];
            [headerView loadDataToView:_dataDic[@"banners"]];
            headerView.delegate = _vcDelegate;
            return headerView;
        }
        if(indexPath.section == 1)
        {
            FounctionModularView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:classifyIdentify forIndexPath:indexPath];
            [headerView loadDataToView:_dataDic[@"classifiesTag"]];
            headerView.delegate = _vcDelegate;
            return headerView;
        }
        for(int i = 0; i < [_dataDic[@"nursingHomeType"] count]; i++)
        {
            if(indexPath.section == 2 + i)
            {
                PensionClassifyView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[NSString stringWithFormat:@"pension%d", (int)indexPath.row] forIndexPath:indexPath];
                [headerView loadDataToView:_dataDic[@"nursingHomeType"][i]];
                headerView.delegate = _vcDelegate;
                return headerView;
            }
        }
        if(indexPath.section == collectionView.numberOfSections - 1)
        {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:introduceIdentify forIndexPath:indexPath];
            [headerView addSubview:self.introduceBtn];
            return headerView;
        }
        else
        {
            return [UICollectionReusableView new];
        }
    }
    else
    {
        return [UICollectionReusableView new];
    }
}
#pragma mark touchEvent
-(void)toWebIntroduce
{
    if([_vcDelegate respondsToSelector:@selector(toIntroduce:)]){
        [_vcDelegate toIntroduce:_dataDic[@"thtUrl"]];
    }
}
#pragma mark getter
-(UIButton *)introduceBtn
{
    if(!_introduceBtn)
    {
        _introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_introduceBtn setTitle:@"了解易络淘" forState:UIControlStateNormal];
        _introduceBtn.frame = CGRectMake((Main_Screen_Width - 150)/2, 25, 150, 30);
        [_introduceBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _introduceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_introduceBtn addTarget:self action:@selector(toWebIntroduce) forControlEvents:UIControlEventTouchUpInside];
    }
    return _introduceBtn;
}


@end
