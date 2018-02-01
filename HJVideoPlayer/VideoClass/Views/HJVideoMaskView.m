//
//  HJVideoMaskView.m
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/14.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJVideoMaskView.h"
#import "HJVideoPlayerHeader.h"
#import "HJCircleLoading.h"
#import "HJVideoConst.h"
#import "HJViewFactory.h"

@interface HJVideoMaskView ()

@property (nonatomic ,strong) UIButton * playBtn;

@property (nonatomic ,strong) UIButton * replayBtn;
// 当前显示的视图
@property (nonatomic, strong) UIView *currentShowV;
/** 快进视图 */
@property (nonatomic, strong) HJFastForwardView *fastForwardView;
/** 加载视图 */
@property (nonatomic, strong) HJCircleLoading *circleLoading;

@end




@implementation HJVideoMaskView


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
        [self setupUI];
    }
    return self;
}

#pragma mark - About UI

- (void)setupUI{
    
}

- (void)show{
    
    self.hidden = NO;
}

- (void)hide{
 
    self.hidden = YES;
}

- (void)showPlayBtn{
    
    [self showSomeView:self.playBtn];
}


- (void)showReplayBtn{
   
    [self.replayBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.replayBtn addTarget:self action:@selector(playFailedClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.replayBtn setTitle:@"重新播放" forState:UIControlStateNormal];
    [self showSomeView:self.replayBtn];
}

- (void)showPlayFailed{
    
    [self.replayBtn removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.replayBtn addTarget:self action:@selector(replayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.replayBtn setTitle:@"播放失败" forState:UIControlStateNormal];
    [self showSomeView:self.replayBtn];
}

- (void)showFastForward{
    
    [self showSomeView:self.fastForwardView];
}

- (void)showLoading{
    
    [self showSomeView:self.circleLoading];
    [self.circleLoading startAnimating];
}

- (void)showSomeView:(UIView *)showView{
    
    self.playBtn.hidden = YES;
    self.replayBtn.hidden = YES;
    self.fastForwardView.hidden = YES;
    self.circleLoading.hidden = YES;
    [self.circleLoading stopAnimating];
    
    self.hidden = NO;
    self.currentShowV = showView;
    
    showView.hidden = NO;
    showView.center = self.center;
}


#pragma mark - Event response
- (void)setPlayStatus:(BOOL)play;{
    
    self.playBtn.selected = play;
    
}
- (void)playOrPauseAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (self.playBlock) {
        self.playBlock(sender.selected);
    }
}

- (void)replayAction{
    
    if(self.replayBlock){
        self.replayBlock();
    }
}

- (void)playFailedClickAction{
    
    if (self.playFailedClickBlock) {
        self.playFailedClickBlock();
    }
}
#pragma mark - Private methods

#pragma mark - Public methods
- (BOOL)isPausing{
    
    return !self.playBtn.selected;
}
#pragma mark - Delegate methods

#pragma mark - getters and setters
- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [HJViewFactory buttonWithNormalImage:imgPlay selectedImage:imgPause];
        [_playBtn addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setImageEdgeInsets:UIEdgeInsetsZero];
        [_playBtn setFrame:CGRectMake(0, 0, 60, 60)];
        [_playBtn setHidden:YES];
        [self addSubview:_playBtn];
    }
    return _playBtn;
}


- (UIButton *)replayBtn
{
    if (!_replayBtn) {
        _replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replayBtn setFrame:CGRectMake(0, 0, 100, 50)];
        [_replayBtn setHidden:YES];
        [_replayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_replayBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        _replayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _replayBtn.layer.cornerRadius = 4.f;
        _replayBtn.layer.masksToBounds = YES;
        [self addSubview:_replayBtn];
    }
    return _replayBtn;
}

- (HJFastForwardView *)fastForwardView{
    if (!_fastForwardView) {
        _fastForwardView = [[HJFastForwardView alloc] init];
        [_fastForwardView setFrame:CGRectMake(0, 0, 150, 100)];
        [_fastForwardView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        [_fastForwardView setHidden:YES];
        [_fastForwardView configForwardLeftImage:[UIImage imageNamed:@"video_farword_left"] forwardRightImage:[UIImage imageNamed:@"video_farword_right"]];
        _fastForwardView.layer.cornerRadius = 8.f;
        _fastForwardView.layer.masksToBounds = YES;
        [self addSubview:_fastForwardView];
    }
    return _fastForwardView;
}


- (HJCircleLoading *)circleLoading{
    if (!_circleLoading) {
        _circleLoading = [[HJCircleLoading alloc] init];
        _circleLoading.frame = CGRectMake(0, 0, 80, 80);
        _circleLoading.backgroundColor = [UIColor clearColor];
        _circleLoading.hidden = YES;
        [self addSubview:_circleLoading];
    }
    return _circleLoading;
}

- (void)setMaskViewStatus:(VideoMaskViewStatus)maskViewStatus
{
    _maskViewStatus = maskViewStatus;
    
    switch (maskViewStatus) {
        case VideoMaskViewStatus_hide:
            [self hide];
            break;
        case VideoMaskViewStatus_showPlayBtn:
            [self showPlayBtn];
            break;
        case VideoMaskViewStatus_showReplayBtn:
            [self showReplayBtn];
            break;
        case VideoMaskViewStatus_showPlayFailed:
            [self showPlayFailed];
            break;
        case VideoMaskViewStatus_showFastForward:
            [self showFastForward];
            break;
        case VideoMaskViewStatus_showLoading:
            [self showLoading];
            break;
        default:
            
            break;
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if (_currentShowV) {
        self.currentShowV.center = self.center;
    }
}

@end
