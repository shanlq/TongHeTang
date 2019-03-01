//
//  EvaluateItem.m
//  tonghetang
//
//  Created by ZSY on 2018/12/14.
//

#import "EvaluateItem.h"

@interface EvaluateItem ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation EvaluateItem
{
    __weak IBOutlet UIImageView *_userImgView;
    __weak IBOutlet UILabel *_userNickNameLab;
    __weak IBOutlet UILabel *_timeLab;
    __weak IBOutlet UICollectionView *_imgCollectionView;
    __weak IBOutlet NSLayoutConstraint *_imgCollectionViewHeight;
    __weak IBOutlet UILabel *_imgNumLab;
    __weak IBOutlet UILabel *_contentLab;
    __weak IBOutlet UIButton *_laudBtn;
    
    NSArray *_imgArr;
    NSDictionary *_dataDic;
}
NSString *const evaluateItemImageId = @"evaluateItemImageId";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imgCollectionView.delegate = self;
    _imgCollectionView.dataSource = self;
    _imgNumLab.backgroundColor = [UIColorFromRGB(0x333333) colorWithAlphaComponent:.5];
    [_imgCollectionView registerNib:[UINib nibWithNibName:@"imgItem" bundle:nil] forCellWithReuseIdentifier:evaluateItemImageId];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_imgCollectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 10;
}

#pragma mark privateMethods
-(void)loadDataToView:(id)data
{
    _dataDic = (NSDictionary *)data;
    [_userImgView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"userHeadImg"]]];
    _userNickNameLab.text = _dataDic[@"userName"];
    _timeLab.text = _dataDic[@"time"];
    if([_dataDic[@"pics"] count] >= 4){
        _imgNumLab.text = [NSString stringWithFormat:@"%dP", (int)[_dataDic[@"pics"] count]];
    }
    else{
        _imgNumLab.hidden = YES;
    }
    _contentLab.text = _dataDic[@"content"];
    [_laudBtn setTitle:_dataDic[@"laudNum"] forState:UIControlStateNormal];
    [_laudBtn setImage:[UIImage imageNamed:[_dataDic[@"hadLaud"] intValue] == 1 ? @"zanzanzan2" : @"zanzanzan"] forState:UIControlStateNormal];
    
    _imgArr = _dataDic[@"pics"];
    [_imgCollectionView reloadData];
    _imgCollectionViewHeight.constant = _imgArr.count == 0 ? 0 : 80;
}

#pragma mark delegate/dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imgArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EvaluateItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:evaluateItemImageId forIndexPath:indexPath];
    [item loadDataToView:_imgArr[indexPath.row]];
    return item;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((Main_Screen_Width - 60)/4, (Main_Screen_Width - 60)/4);
}
#pragma mark touchEvent
//点赞
- (IBAction)laud:(id)sender {
    
    if(_laudBlock){
        _laudBlock(_dataDic[@"evaluateId"]);
    }
}

@end
