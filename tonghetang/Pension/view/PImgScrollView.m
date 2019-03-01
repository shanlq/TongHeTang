//
//  PImgScrollView.m
//  tonghetang
//
//  Created by ZSY on 2018/12/10.
//

#import "PImgScrollView.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PImgScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *imgScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *startImgView;

@end

@implementation PImgScrollView
{
    AVPlayerViewController *_playerVC;
    NSArray *_dataArr;
    int _videoIndex;
    NSString *_videoUrl;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addSubview:self.imgScrollView];
        //对视频播放结束添加监听
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark privateMethods
+(CGSize)defaultSize:(id)data
{
    NSArray *arr = (NSArray *)data;
    return CGSizeMake(Main_Screen_Width, arr.count == 0 ? 0 : Main_Screen_Width*9/20);
}
-(void)loadDataToView:(id)data
{
    _dataArr = (NSArray *)data;
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:0];
    for(NSDictionary *dic in _dataArr)
    {
        [imgArr addObject:dic[@"image"]];
    }
    for(int i = 0; i < imgArr.count; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(Main_Screen_Width * i, 0, Main_Screen_Width, Main_Screen_Width*9/20)];
        [self.imgScrollView addSubview:imgView];
        if([_dataArr[i][@"typeId"] intValue] == 2)
        {
            AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:_videoUrl]];
            if(asset.isPlayable){
                [imgView addSubview:self.startImgView];
            }
            
            _videoIndex = i;
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
            [imgView addGestureRecognizer:tap];
        }
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
    }
    self.imgScrollView.contentSize = CGSizeMake(imgArr.count * Main_Screen_Width, Main_Screen_Width*9/20);
    self.pageControl.numberOfPages = imgArr.count;
    self.pageControl.hidden = imgArr.count == 1;
}
//获取视频缩略图
-(UIImage *)getVideoImg
{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:_videoUrl]];
    AVAssetImageGenerator *imgGen = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    imgGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);                         //0.0表示视频开始时的缩略图
    CMTime endTime;
    CGImageRef imgRef = [imgGen copyCGImageAtTime:time actualTime:&endTime error:nil];
    UIImage *image = [UIImage imageWithCGImage:imgRef];
    return image;
    
}
//视频播放结束回调
-(void)moviePlayDidEnd:(AVPlayerItem *)item
{
    UIView *playerView = [self.imgScrollView viewWithTag:220];
    [playerView removeFromSuperview];
    self.startImgView.hidden = NO;
}
#pragma mark touchEvent
-(void)playVideo
{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:_videoUrl]];
    if(asset.isPlayable)
    {
        self.startImgView.hidden = YES;
        _playerVC = [[AVPlayerViewController alloc] init];
        //    _playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
        _playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:_videoUrl]];
        _playerVC.view.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width*9/20);
        _playerVC.view.tag = 220;
        _playerVC.showsPlaybackControls = YES;
        [_playerVC.player play];
        [self.imgScrollView addSubview:_playerVC.view];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToNextImg:)];
        [_playerVC.view addGestureRecognizer:pan];
    }
}

-(void)panToNextImg:(UIPanGestureRecognizer *)pan
{
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [pan velocityInView:pan.view];
        NSLog(@"%.2f, %@", pan.view.frame.origin.x, NSStringFromCGPoint(point));
        if(point.x < 0)
        {
            [_playerVC.player pause];
            [pan.view removeFromSuperview];
            if(_videoIndex + 1 < _dataArr.count)
            {
                [self.imgScrollView setContentOffset:CGPointMake((_videoIndex + 1)*Main_Screen_Width, 0) animated:YES];
            }
        }
    }
}


#pragma mark delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)scrollView.contentOffset.x / (int)Main_Screen_Width;
    self.startImgView.hidden = (int)scrollView.contentOffset.x / (int)Main_Screen_Width != _videoIndex;
}

#pragma mark getter
-(UIScrollView *)imgScrollView
{
    if(!_imgScrollView)
    {
        _imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _imgScrollView.delegate = self;
        _imgScrollView.pagingEnabled = YES;
        _imgScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_imgScrollView];
    }
    return _imgScrollView;
}
-(UIPageControl *)pageControl
{
    if(!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.width - 100)/2, self.height - 25, 100, 15)];
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xff2121);
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
-(UIImageView *)startImgView
{
    if(!_startImgView)
    {
        _startImgView = [[UIImageView alloc] initWithFrame:CGRectMake((Main_Screen_Width - 60)/2, (self.height - 60)/2, 60, 60)];
        _startImgView.image = [UIImage imageNamed:@"视频(1)"];
        _startImgView.userInteractionEnabled = YES;
    }
    return _startImgView;
}

@end
