//
//  HJVideoBottomView.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJVideoBottomView.h"
#import "HJVideoPlayManager.h"
#import "HJBufferSlider.h"
#import "HJTimeUtil.h"
#import "HJVideoPlayerHeader.h"


#define imgBack         [UIImage imageFromBundleWithName:@"video_back"]
#define imgPlay         [UIImage imageFromBundleWithName:@"video_play"]
#define imgPause        [UIImage imageFromBundleWithName:@"video_pause"]
#define imgFullScreen   [UIImage imageFromBundleWithName:@"video_toFullScreen_white"]
#define imgHalfScreen   [UIImage imageFromBundleWithName:@"video_toHalfScreen_white"]
#define imgSliderThumb  [UIImage imageFromBundleWithName:@"video_slider_thumb"]


static const CGFloat kSliderHeight = 4.f;
static const CGFloat kTimeLabelWidth = 40.f;
static const CGFloat kTimeLabelHeight = 13.f;

@interface HJVideoBottomView ()

@property (nonatomic ,strong) UIButton *fullScreenBtn;

@property (nonatomic ,strong) UILabel *progressLbl;

@property (nonatomic ,strong) UILabel *totalDurationLbl;

@property (nonatomic ,strong) HJBufferSlider *bufferSlider;

@end

@implementation HJVideoBottomView


-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addNotification];
        
        [self setupUI];
        
    }
    return self;
}



- (void)addNotification
{
    //屏幕切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScreenAction:) name:kNotificationChangeScreen object:nil];
    
}



- (void)setupUI
{
    [self addSubview:self.progressLbl];
    
    [self addSubview:self.totalDurationLbl];
    
    [self addSubview:self.fullScreenBtn];
    
    [self addSubview:self.bufferSlider];
}

#define mark - getters /setters


- (UIButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [HJViewFactory buttonWithNormalImage:imgFullScreen selectedImage:imgHalfScreen];
        [_fullScreenBtn addTarget:self action:@selector(fullOrHalfScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UILabel *)progressLbl
{
    if (!_progressLbl) {
        _progressLbl = [[UILabel alloc]init];
        [_progressLbl setBackgroundColor:[UIColor clearColor]];
        [_progressLbl setText:@"00:00"];
        [_progressLbl setTextColor:[UIColor whiteColor]];
        [_progressLbl setTextAlignment:NSTextAlignmentRight];
    }
    return _progressLbl;
}


- (UILabel *)totalDurationLbl
{
    if (!_totalDurationLbl) {
        _totalDurationLbl = [[UILabel alloc]init];
        [_totalDurationLbl setBackgroundColor:[UIColor clearColor]];
        [_totalDurationLbl setText:@"/00:00"];
        [_totalDurationLbl setTextColor:[UIColor colorWithRed:200 green:200 blue:200 alpha:1]];
    }
    return _totalDurationLbl;
}

- (HJBufferSlider *)bufferSlider
{
    if (!_bufferSlider) {
        _bufferSlider = [[HJBufferSlider alloc]initWithFrame:CGRectMake(0, -kSliderHeight/2.f, self.width, kSliderHeight)];
        [_bufferSlider setProgressTrackColor:[UIColor yellowColor]];
        [_bufferSlider setBufferTrackColor:[UIColor whiteColor]];
        [_bufferSlider setMaxBufferTrackColor:[UIColor darkGrayColor]];
        [_bufferSlider setThumbImage:[imgSliderThumb imageWithSize:CGSizeMake(8, 8)]];
        [_bufferSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _bufferSlider;
}

- (CGFloat)progressValue
{
    return self.bufferSlider.progressValue;
}


- (CGFloat)bufferValue
{
    return self.bufferSlider.bufferValue;
}

- (CGFloat)maximumValue
{
    return self.bufferSlider.maximumValue;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    
    self.bufferSlider.frame = CGRectMake(0, -kSliderHeight/2.f, self.width, kSliderHeight);
    
    self.fullScreenBtn.frame = CGRectMake(self.width-self.height, 0, self.height, self.height);
    
    self.progressLbl.frame = CGRectMake(20, 0, kTimeLabelWidth, kTimeLabelHeight);
    self.progressLbl.centerY = self.fullScreenBtn.centerY;
    self.progressLbl.font = [UIFont systemFontOfSize:kTimeLabelHeight-2.f];
    
    self.totalDurationLbl.frame = CGRectMake(self.progressLbl.right, 0, kTimeLabelWidth, kTimeLabelHeight);
    self.totalDurationLbl.centerY = self.progressLbl.centerY;
    self.totalDurationLbl.font = self.progressLbl.font;
}

#pragma mark - Event Response

- (void)fullOrHalfScreenAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.fullScreenBlock) {
        self.fullScreenBlock(sender.selected);
    }
}

- (void)sliderValueChanged:(UISlider *)sender{
    
    [self seekTo:sender.value];
}


- (void)changeScreenAction:(NSNotification *)notif{

    BOOL isFullScreen = [notif.object boolValue];
    // 修改切换屏幕按钮图片
    [self.fullScreenBtn setSelected:isFullScreen];

}

#pragma mark - Public Methods
- (void)setProgress:(CGFloat)progressValue{
    
    [self.bufferSlider setProgressValue:progressValue];
    
    [self.progressLbl setText:[NSString stringWithFormat:@"%@",[HJTimeUtil hmsStringWithFloat:progressValue]]];
}

- (void)setBufferValue:(CGFloat)bufferValue{

    [self.bufferSlider setBufferValue:bufferValue];
}

- (void)setMaximumValue:(CGFloat)value{
    
    [self.bufferSlider setMaximumValue:value];
    
    [self.totalDurationLbl setText:[NSString stringWithFormat:@"/%@",[HJTimeUtil hmsStringWithFloat:value]]];
}

- (void)seekTo:(CGFloat)playTime{

    [kVideoPlayerManager seekToTime:playTime];
    NSLog(@"SeekTo:%zds",playTime);
}

@end
