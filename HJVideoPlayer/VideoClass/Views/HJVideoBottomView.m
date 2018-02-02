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
#import "HJVideoTimeUtil.h"
#import "HJVideoPlayerHeader.h"
#import "HJVideoConst.h"
#import "HJVideoConfigModel.h"
#import "HJViewFactory.h"

static const CGFloat kSliderHeight = 4.f;
static const CGFloat kTimeLabelWidth = 50.f;
static const CGFloat kTimeLabelFontSize = 12.f;

@interface HJVideoBottomView ()

/** 全屏按钮 */
@property (nonatomic ,strong) UIButton *fullScreenBtn;
/** 播放时长Label */
@property (nonatomic ,strong) UILabel *playTimeLbl;
/** 总时长Label */
@property (nonatomic ,strong) UILabel *totalDurationLbl;
/** 缓冲进度条 */
@property (nonatomic, strong) HJBufferSlider *bufferSlider;
/** 是否仅显示slider */
@property (nonatomic, assign) BOOL onlySlider;
/** 是否全屏 */
@property (nonatomic, assign) BOOL fullScreen;

/** 渐变layer */
@property (nonatomic, strong) CAGradientLayer* gradientLayer;



@end

@implementation HJVideoBottomView


- (instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        
        [self addNotification];
        
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
    [self.layer addSublayer:self.gradientLayer];
    
    [self addSubview:self.playTimeLbl];
    
    [self addSubview:self.totalDurationLbl];
    
    [self addSubview:self.fullScreenBtn];
    
    [self addSubview:self.bufferSlider];
}

- (void)showOnlySlider:(BOOL)show{

    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setHidden:show];
    }];
    [self.bufferSlider setHidden:NO];
}


- (void)refreshUI{
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    if (self.configModel && self.configModel.onlyFullScreen && !self.onlySlider){
        [self showOnlySlider:NO];
        
        self.fullScreenBtn.frame = CGRectMake(width, 0, height, height);
        
        [self adjustSubviesOnlyFull:YES];
        
    }else if (!self.onlySlider && !self.fullScreen){
        
        [self showOnlySlider:NO];
        
        self.fullScreenBtn.frame = CGRectMake(width-height, 0, height, height);
        
        [self adjustSubviesOnlyFull:NO];
        
    }else if (!self.onlySlider && self.fullScreen) {
      
        [self showOnlySlider:NO];
    
        self.fullScreenBtn.frame = CGRectMake(width-height, 0, height, height);
        
        [self adjustSubviesOnlyFull:NO];
        
    }else{
        
        [self showOnlySlider:YES];
    }
    
}

- (void)adjustSubviesOnlyFull:(BOOL)onlyFull{
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    self.playTimeLbl.frame = CGRectMake(0, 0, kTimeLabelWidth, height);
    
    self.totalDurationLbl.frame = CGRectMake(width - (onlyFull?0:height) - kTimeLabelWidth, 0, kTimeLabelWidth, height);
    
    self.bufferSlider.frame = CGRectMake(CGRectGetMaxX(self.playTimeLbl.frame), (height - kSliderHeight)/2.f, CGRectGetMinX(self.totalDurationLbl.frame)-CGRectGetMaxX(self.playTimeLbl.frame), kSliderHeight);
}


- (void)changeGradientRect{
    
    self.gradientLayer.frame = self.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)kVideoBottomGradientColor.CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.f), @(1.0f)];
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

- (UILabel *)playTimeLbl
{
    if (!_playTimeLbl) {
        _playTimeLbl = [[UILabel alloc]init];
        [_playTimeLbl setBackgroundColor:[UIColor clearColor]];
        [_playTimeLbl setText:@"00:00"];
        [_playTimeLbl setTextColor:[UIColor whiteColor]];
        [_playTimeLbl setTextAlignment:NSTextAlignmentRight];
        [_playTimeLbl setTextAlignment:NSTextAlignmentCenter];
        [_playTimeLbl setFont:[UIFont systemFontOfSize:kTimeLabelFontSize]];
    }
    return _playTimeLbl;
}


- (UILabel *)totalDurationLbl
{
    if (!_totalDurationLbl) {
        _totalDurationLbl = [[UILabel alloc]init];
        [_totalDurationLbl setBackgroundColor:[UIColor clearColor]];
        [_totalDurationLbl setText:@"00:00"];
        [_totalDurationLbl setTextColor:[UIColor whiteColor]];
        [_totalDurationLbl setTextAlignment:NSTextAlignmentCenter];
        [_totalDurationLbl setFont:[UIFont systemFontOfSize:kTimeLabelFontSize]];
    }
    return _totalDurationLbl;
}

- (HJBufferSlider *)bufferSlider
{
    if (!_bufferSlider) {
        _bufferSlider = [[HJBufferSlider alloc]initWithFrame:CGRectMake(0, -kSliderHeight/2.f, CGRectGetWidth(self.frame), kSliderHeight)];
        [_bufferSlider setProgressTrackColor:[UIColor yellowColor]];
        [_bufferSlider setBufferTrackColor:[UIColor whiteColor]];
        [_bufferSlider setMaxBufferTrackColor:[UIColor darkGrayColor]];
        [_bufferSlider setThumbImage:[imgSliderThumb imageWithSize:CGSizeMake(8, 8)]];
        [_bufferSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _bufferSlider;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
    }
    return _gradientLayer;
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


#pragma mark - Event Response

- (void)fullOrHalfScreenAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.fullScreenBlock) {
        self.fullScreenBlock(sender.selected);
    }
}

- (void)sliderValueChanged:(UISlider *)sender{
    
    if(self.valueChangedBlock){
        self.valueChangedBlock(sender.value);
    }
}


- (void)changeScreenAction:(NSNotification *)notif{
    
    BOOL isFullScreen = [notif.object boolValue];
    
    [self setFullScreen:isFullScreen];
    // 修改切换屏幕按钮图片
    [self.fullScreenBtn setSelected:isFullScreen];
    
    //刷新界面
    if (self.onlySlider) {
        [self hide];
    }else{
        [self show];
    }
}

#pragma mark - Public Methods
- (void)setProgress:(CGFloat)progressValue{
    
    [self.bufferSlider setProgressValue:progressValue];
    
    [self.playTimeLbl setText:[NSString stringWithFormat:@"%@",[HJVideoTimeUtil hmsStringWithFloat:progressValue]]];
}

- (void)setBufferValue:(CGFloat)bufferValue{

    [self.bufferSlider setBufferValue:bufferValue];
}

- (void)setMaximumValue:(CGFloat)value{
    
    [self.bufferSlider setMaximumValue:value];
    
    [self.totalDurationLbl setText:[NSString stringWithFormat:@"%@",[HJVideoTimeUtil hmsStringWithFloat:value]]];
}

- (void)show{

    CGFloat height = self.fullScreen?kBottomBarFullHeight:kBottomBarHalfHeight;
    CGFloat width = CGRectGetWidth(self.superview.frame);
    CGFloat originY = CGRectGetHeight(self.superview.frame) - height;
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        self.frame = CGRectMake(0, originY, width, height);
    } completion:^(BOOL finished) {
        [self changeGradientRect];
    }];
    
    
    self.onlySlider = NO;
    
    [self refreshUI];
}


- (void)hide{
    
    CGFloat width = CGRectGetWidth(self.superview.frame);
    CGFloat originY = CGRectGetHeight(self.superview.frame) - kSliderHeight;
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        self.frame = CGRectMake(0, originY, width, kSliderHeight);
        self.bufferSlider.frame = self.bounds;
    }];
    
    self.onlySlider = YES;
    
    [self refreshUI];
}
@end
