//
//  BHActivityView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/13.
//

#import "BHActivityView.h"
//#import "IntroduceItem.h"
#import "IntroduceWebItem.h"
#import "EvaluateItem.h"
#import "UIScrollView+NOData.h"

@interface BHActivityView ()<UICollectionViewDelegate, UICollectionViewDataSource>

//@property (nonatomic, strong) NSMutableArray *introduceHeightArr;
@property (nonatomic, strong) NSMutableArray *evaluateHeightArr;
@property (nonatomic, strong) UIButton *aboutThtBtn;

@end

@implementation BHActivityView
{
    __weak IBOutlet UIButton *_introduceBtn;
    __weak IBOutlet UIView *_introduceMarkView;
    __weak IBOutlet UIButton *_evaluateBtn;
    __weak IBOutlet UIView *_evaluateMarkView;
    __weak IBOutlet UICollectionView *_collectionVIew;
    
    NSArray *_introduceArr;
    NSArray *_evaluateArr;
    CGFloat _viewHeight;
    int _type;
}

NSString *const bhaIntroduceId = @"BHAIntroduceId";
NSString *const bhaAboutThtId = @"bhaAboutThtId";

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _collectionVIew.delegate = self;
    _collectionVIew.dataSource = self;
    [_collectionVIew registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bhaAboutThtId];
}
#pragma mark praviateMethods
-(CGSize)defaultSize:(id)introduceData evaluate:(id)evaluateData type:(int)type
{
    [_introduceBtn setTitleColor:type == 1 ? UIColorFromRGB(0xff2121) : UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _introduceMarkView.backgroundColor = type == 1 ? UIColorFromRGB(0xff2121) : UIColorFromRGB(0xffffff);
    [_evaluateBtn setTitleColor:type == 2 ? UIColorFromRGB(0xff2121) : UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _evaluateMarkView.backgroundColor = type == 2 ? UIColorFromRGB(0xff2121) : UIColorFromRGB(0xffffff);
    
    if(type == 1)                                                      //介绍
    {
        _viewHeight = Main_Screen_Height - 120;
        _type = type;
        _introduceArr = introduceData ? @[introduceData] : @[];
        [_collectionVIew registerClass:[IntroduceWebItem class] forCellWithReuseIdentifier:bhaIntroduceId];
        
//        [_collectionVIew registerNib:[UINib nibWithNibName:@"IntroduceItem" bundle:nil] forCellWithReuseIdentifier:bhaIntroduceId];
//        if(![_introduceArr isEqualToArray:(NSArray *)introduceData])
//        {
//            _introduceArr = (NSArray *)introduceData;
//            _type = type;
//            for(NSDictionary *dic in _introduceArr)
//            {
//                CGFloat cellHeight = 0;
//                if([dic[@"type"] intValue] == 1)              //文字
//                {
//                    CGRect rect = [dic[@"text"] boundingRectWithSize:CGSizeMake(Main_Screen_Width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//                    cellHeight = CGRectGetHeight(rect) + 5;
//                }
//                else
//                {
//                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"picture"]]]];
//                    cellHeight = image.size.height*(Main_Screen_Width - 30)/image.size.width;
//                }
//                [self.introduceHeightArr addObject:@(cellHeight)];
//                _viewHeight = _viewHeight + cellHeight;
//            }
//        }
//        else
//        {
//            if(_type != type)
//            {
//                _type = type;
//                _viewHeight = 0;
//                for(int i = 0; i < self.introduceHeightArr.count; i++)
//                {
//                    _viewHeight = _viewHeight + [self.introduceHeightArr[i] doubleValue];
//                }
//            }
//        }
    }
    else
    {
        if(![_evaluateArr isEqualToArray:(NSArray *)evaluateData])
        {
            _evaluateArr = (NSArray *)evaluateData;
            _type = type;
            for(int i = 0;i < _evaluateArr.count; i++)
            {
                NSDictionary *dic = _evaluateArr[i];
                CGFloat cellHeight = 120;
                if([dic[@"pics"] count] != 0){
                    cellHeight = cellHeight + 80;
                }
                if([dic[@"content"] length] != 0)
                {
                    CGRect rect = [dic[@"content"] boundingRectWithSize:CGSizeMake(Main_Screen_Width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
                    cellHeight = cellHeight + CGRectGetHeight(rect) + 10;
                }
                [self.evaluateHeightArr addObject:@(cellHeight)];
                _viewHeight = _viewHeight + cellHeight;
                
                [_collectionVIew registerNib:[UINib nibWithNibName:@"EvaluateItem" bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"BHAEvaluateId%d", i]];
            }
        }
        else
        {
            if(_type != type)
            {
                _type = type;
                _viewHeight = 0;
                for(int i = 0; i < self.evaluateHeightArr.count; i++)
                {
                    _viewHeight = _viewHeight + [self.evaluateHeightArr[i] doubleValue];
                }
            }
        }
        if(_evaluateArr.count == 0)
        {
            _viewHeight = Main_Screen_Height - 120;
        }
    }
    
    NSArray *arr = (NSArray *)evaluateData;
    [_evaluateBtn setTitle:[NSString stringWithFormat:@"相关评价(%d)", (int)arr.count] forState:UIControlStateNormal];
    [_collectionVIew reloadData];
    if(_type == 2){
        [_collectionVIew showNoDataViewByData:_evaluateArr text:@"暂无评价"];
    }
    [self layoutIfNeeded];
    return CGSizeMake(Main_Screen_Width, _type == 1 ? _viewHeight + 120 : _viewHeight + 200);
}
#pragma mark touchEvent

- (IBAction)typeSelect:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if(_typeSelectBlock){
        _typeSelectBlock((int)btn.tag);
    }
}
-(void)toWebIntroduce
{
    if([_delegate respondsToSelector:@selector(toAboutThtWebView)]){
        [_delegate toAboutThtWebView];
    }
}
#pragma delegate/dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _type == 1 ? _introduceArr.count : _evaluateArr.count + 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(_type == 1)
    {
//        IntroduceItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:bhaIntroduceId forIndexPath:indexPath];
        IntroduceWebItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:bhaIntroduceId forIndexPath:indexPath];
        [item loadDataToView:_introduceArr[indexPath.row]];
        [item layoutIfNeeded];
        return item;
    }
    else
    {
        if(indexPath.row == _evaluateArr.count)
        {
            
            UICollectionViewCell *aboutItem = [collectionView dequeueReusableCellWithReuseIdentifier:bhaAboutThtId forIndexPath:indexPath];
            [aboutItem addSubview:self.aboutThtBtn];
            return aboutItem;
        }
        else
        {
            EvaluateItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"BHAEvaluateId%d", (int)indexPath.row] forIndexPath:indexPath];
            [item loadDataToView:_evaluateArr[indexPath.row]];
            item.laudBlock = ^(id  _Nonnull data) {
                if([self->_delegate respondsToSelector:@selector(laudWithCommentId:)]){
                    [self->_delegate laudWithCommentId:data];
                }
            };
            return item;
        }
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == 1)
    {
        return CGSizeMake(Main_Screen_Width, Main_Screen_Height - 120);
//        return CGSizeMake(Main_Screen_Width, [self.introduceHeightArr[indexPath.row] doubleValue]);
    }
    else
    {
        if(indexPath.row == _evaluateArr.count){
            return CGSizeMake(Main_Screen_Width, 80);
        }
        else{
            return CGSizeMake(Main_Screen_Width, [self.evaluateHeightArr[indexPath.row] doubleValue]);
        }
    }
}
#pragma mark getter
//-(NSMutableArray *)introduceHeightArr
//{
//    if(!_introduceHeightArr)
//    {
//        _introduceHeightArr = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _introduceHeightArr;
//}
-(NSMutableArray *)evaluateHeightArr
{
    if(!_evaluateHeightArr)
    {
        _evaluateHeightArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _evaluateHeightArr;
}
-(UIButton *)aboutThtBtn
{
    if(!_aboutThtBtn)
    {
        _aboutThtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_aboutThtBtn setTitle:@"了解易络淘" forState:UIControlStateNormal];
        _aboutThtBtn.frame = CGRectMake((Main_Screen_Width - 150)/2, 25, 150, 30);
        [_aboutThtBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _aboutThtBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_aboutThtBtn addTarget:self action:@selector(toWebIntroduce) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aboutThtBtn;
}

@end
