//
//  HJVideoPlayerController.m
//  HJVideoPlayer
//
//  Created by WHJ on 2016/12/8.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJVideoPlayerController.h"
#import "HJVideoTopView.h"
#import "HJVideoBottomView.h"
#import "HJVideoPlayManager.h"
#import "HJVideoUIManager.h"
#import "HJPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HJViewFactory.h"
#import "HJVideoMaskView.h"
#import "HJVideoPlayerHeader.h"
#import "AppDelegate+HJExtendion.h"

typedef NS_ENUM(NSUInteger, MoveDirection) {
    MoveDirection_none = 0,
    MoveDirection_up,
    MoveDirection_down,
    MoveDirection_left,
    MoveDirection_right
};



@interface HJVideoPlayerController ()

@property (nonatomic ,strong) HJVideoMaskView * maskView;

@property (nonatomic ,strong) HJVideoTopView * topView;

@property (nonatomic ,strong) HJVideoBottomView * bottomView;

@property (nonatomic ,assign) CGRect originFrame;

@property (nonatomic ,assign) CGFloat toolBarHeight;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) HJPlayerView *playerView;

@property (nonatomic, assign) VideoPlayerStatus playStatus;

@property (nonatomic, assign) VideoPlayerStatus prePlayStatus;

@property (nonatomic, assign) NSInteger secondsForBottom;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) MoveDirection moveDirection;

/** 音量调节 */
@property (nonatomic, strong) UISlider *volumeSlider;

@property (nonatomic, assign) CGFloat sysVolume;
/** 亮度调节 */
@property (nonatomic, assign) CGFloat brightness;

/** 进度调节 */
@property (nonatomic, assign) CGFloat currentTime;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@end

#define kToolBarHalfHeight 44.f
#define kToolBarFullHeight 44.f
#define kFullScreenFrame CGRectMake(0 , 0, kScreenHeight, kScreenWidth)

#define imgVideoBackImg [UIImage imageFromBundleWithName:@"video_backImg.jpeg"]
#define imgPlay         [UIImage imageFromBundleWithName:@"video_play"]
#define imgPause        [UIImage imageFromBundleWithName:@"video_pause"]
static const NSInteger maxSecondsForBottom = 5.f;

@implementation HJVideoPlayerController

#pragma mark -lifeCycle

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.originFrame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initW];
    [self handleVideoPlayerStatus];
    [self addObservers];
    [self addTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    //允许屏幕旋转
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = YES;
    //开启屏幕长亮
    [UIApplication sharedApplication].idleTimerDisabled =YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    //关闭屏幕旋转
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = NO;
    //关闭屏幕长亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


- (void)dealloc{

    NSLog(@"播放器视图已销毁");
}



- (void)initW
{
    self.secondsForBottom = maxSecondsForBottom;
    self.currentTime      = 0;
    
    //获取系统音量滚动条
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIView *tmpView in volumeView.subviews) {
        if ([[tmpView.class description] isEqualToString:@"MPVolumeSlider"]) {
            self.volumeSlider = (UISlider *)tmpView;
        }
    }
}

#pragma mark - About UI
- (void)setupUI
{
    // 设置self
    [self.view setFrame:self.originFrame];
    
    // 设置player
    [self.playerView setFrame:self.view.frame];
    [self.playerView setBackgroundColor:[UIColor clearColor]];
    [self.playerView setImage:imgVideoBackImg];
    [self.playerView setUserInteractionEnabled:YES];
    [self.view addSubview:self.playerView];
    
    
    //设置遮罩层
    self.maskView = [[HJVideoMaskView alloc] initWithFrame:self.playerView.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    self.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
    WS(weakSelf);
    self.maskView.playBlock = ^(BOOL isPlay) {
        if (isPlay) {
            [weakSelf play];
        }else{
            [weakSelf pause];
        }
        
        [weakSelf resetTimer];
    };
    
    __weak HJVideoMaskView * weakMaskView = self.maskView;
    self.maskView.replayBlock = ^{
        [kVideoPlayerManager seekToTime:0];
        weakMaskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
    };
    [self.playerView addSubview:self.maskView];
    

    
    // 设置topView
    self.topView.frame = CGRectMake(0, 0, self.view.frame.size.width, kToolBarHalfHeight);
    self.topView.title = @"吴辉建的视频播放器";
    [self.view addSubview:self.topView];
    
    // 设置BottomView
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - kToolBarHalfHeight, self.view.frame.size.width, kToolBarHalfHeight);
    [self.view addSubview:self.bottomView];
    
    //
    kHJVideoUIManager.topView = self.topView;
    kHJVideoUIManager.bottomView = self.bottomView;
    
}

- (void)changeFullScreen:(BOOL)changeFull{
    
    [self.view.superview bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        CGFloat toolBarHeight = 0;
        if (changeFull) {
            NSNumber * value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            
            self.view.frame = kFrame;
            toolBarHeight = kToolBarFullHeight;
        }else{
            NSNumber * value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
            
            self.view.frame = self.originFrame;
            toolBarHeight = kToolBarHalfHeight;
        }
        
        self.playerView.frame = self.view.bounds;
        self.maskView.frame = self.playerView.bounds;
        self.topView.frame = CGRectMake(0, 0, self.maskView.width, toolBarHeight);
        self.bottomView.frame = CGRectMake(0, self.maskView.height-toolBarHeight, self.maskView.width, toolBarHeight);
        self.isFullScreen = changeFull;
        // 发送屏幕改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeScreen object:@(changeFull)];
    }];
}






#pragma mark - 底部栏显示/隐藏

- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTimer)];
    [self.view addGestureRecognizer:tap];
    [self startTimer];
}

- (void)showBottomAction
{
    if (!self.bottomView.onlySlider) {
        [self.bottomView hide];
    }else{
        [self.bottomView show];
    }
}


- (void)startTimer
{
    //看是否正在计时，若是则结束计时 否则开始计时
    if (self.timer) {
    
        [self cancelTimer];
        
    }else{
        [self setSecondsForBottom:maxSecondsForBottom];
        self.topView.hidden = NO;
        [self.bottomView show];
        
        [self.maskView show];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(hideMaskViewWithTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


- (void)resetTimer{
    
    if ([self.timer isValid]) {
        self.secondsForBottom = 5.f;
    }else{
        [self startTimer];
    }
}

- (void)cancelTimer{
    if (!self.timer) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self hideSomeViews];
    
}

- (void)hideSomeViews{
    
    //顶部视图隐藏
    if (self.isFullScreen) {
        self.topView.hidden = YES;
    }
    
    //底部视图隐藏
    [self.bottomView hide];
    
    //中间内容隐藏 暂停 播放失败 和播放结束 无需隐藏显示内容
    if(self.playStatus != videoPlayer_pause &&
       self.playStatus != videoPlayer_readyToPlay){
        [self.maskView hide];
    }
    
    self.secondsForBottom = 0;
}

- (void)hideMaskViewWithTimer:(NSTimer *)timer{
    
        self.secondsForBottom --;
        NSLog(@"隐藏底部栏:%zd",self.secondsForBottom);
        if (self.secondsForBottom <= 0) {
            [self cancelTimer];
        }
}


#pragma mark - Pravite Methods
- (void)handleVideoPlayerStatus{
    
    WS(weakSelf);
    [kVideoPlayerManager readyBlock:^(CGFloat totoalDuration) {
        NSLog(@"[%@]:准备播放",[self class]);
        weakSelf.playStatus = videoPlayer_readyToPlay;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
        [weakSelf startTimer];
    } monitoringBlock:^(CGFloat currentDuration) {
        weakSelf.playStatus = videoPlayer_playing;
        if (weakSelf.maskView.maskViewStatus != VideoMaskViewStatus_showPlayBtn) {
            weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
        };
    } endBlock:^{
        NSLog(@"[%@]:播放结束",[self class]);
        weakSelf.playStatus = videoPlayer_playEnd;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showReplayBtn;
        [weakSelf startTimer];
    } failedBlock:^{
        NSLog(@"[%@]:播放失败",[self class]);
        weakSelf.playStatus = videoPlayer_playFailed;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showReplayBtn;
        [weakSelf startTimer];
    }];
}


- (void)addObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

}


#pragma mark - Public Methods
- (void)play{
    NSLog(@"开始播放");
    [kVideoPlayerManager play];
    [self setPlayStatus:videoPlayer_playing];
}

- (void)pause{
    NSLog(@"暂停播放");
    [kVideoPlayerManager pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setPlayStatus:videoPlayer_pause];
    });
}

#pragma mark - Event Methods
- (void)applicationDidEnterBackground {

    if (self.playStatus == videoPlayer_playing) {
        [kVideoPlayerManager pause];
    }
}


- (void)applicationWillEnterForeground {
   
    if (self.prePlayStatus == videoPlayer_playing) {
        [kVideoPlayerManager play];
    }
}

- (void)playOrPauseAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self play];
    }else{
        [self pause];
    }
}


- (void)popAction{
    [self cancelTimer];
    [kVideoPlayerManager reset];
    [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
#pragma mark - getters / setters
- (HJVideoTopView *)topView{
    if (!_topView) {
        WS(weakSelf);
        _topView = [[HJVideoTopView alloc]init];
        _topView.backBlock = ^(){
            
            if(weakSelf.isFullScreen){//全屏返回
                [weakSelf changeFullScreen:NO];
            }else{//半屏返回操作
                [weakSelf popAction];
            }
        };
        
        _topView.showListBlock = ^(BOOL show){
            
        };
    }
    return _topView;
}

- (HJVideoBottomView *)bottomView{
    if (!_bottomView) {
        WS(weakSelf);
        _bottomView = [[HJVideoBottomView alloc] init];
        _bottomView.fullScreenBlock = ^(BOOL isFull){
            [weakSelf changeFullScreen:isFull];
        };
        
        _bottomView.loadingBlock = ^{
            weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showLoading;
        };
    }
    return _bottomView;
}

- (HJPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[HJPlayerView alloc] init];
    }
    return _playerView;
}


- (void)setUrl:(NSString *)url{
    if (!url) return;
    _url = url;
    [self.playerView setPlayer:[kVideoPlayerManager setUrl:_url]];
    self.maskView.maskViewStatus = VideoMaskViewStatus_showLoading;
}

- (void)setPlayStatus:(VideoPlayerStatus)playStatus{
    
    self.prePlayStatus = _playStatus;
    _playStatus = playStatus;
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    
    _isFullScreen = isFullScreen;
    self.bottomView.fullScreen = isFullScreen;
    
}

#pragma mark - 触摸方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.view];
    self.sysVolume = self.volumeSlider.value;
    self.brightness = [UIScreen mainScreen].brightness;
    self.currentTime = self.bottomView.progressValue;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesMoved:touches withEvent:event];
    [self setSecondsForBottom:maxSecondsForBottom];
    UITouch * touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self.view];
    
    CGFloat subX = movePoint.x - self.startPoint.x;
    CGFloat subY = movePoint.y - self.startPoint.y;
    CGFloat width  = self.view.width;
    CGFloat height = self.view.height;
    
    BOOL startInLeft = movePoint.x < self.view.width/2.f;
    
    
    if (self.moveDirection == MoveDirection_none) {
        if (subX >= 30) {
            self.moveDirection = MoveDirection_right;
        }else if(subX <= -30){
            self.moveDirection = MoveDirection_left;
        }else if (subY >= 30){
            self.moveDirection = MoveDirection_down;
        }else if (subY <= -30){
            self.moveDirection = MoveDirection_up;
        }
    }
    
    if (self.moveDirection == MoveDirection_right || self.moveDirection == MoveDirection_left) {//快进
        CGFloat ratio = subX/width;
        CGFloat offsetSeconds = self.bottomView.maximumValue*ratio;
        CGFloat seekTime = self.currentTime + offsetSeconds;
        [self.maskView.fastForwardView setMaxDuration:self.bottomView.maximumValue];
        self.maskView.maskViewStatus = VideoMaskViewStatus_showFastForward;
        [self.maskView.fastForwardView moveRight:offsetSeconds>0];
        [self.maskView.fastForwardView setProgress:seekTime/self.bottomView.maximumValue];
        [self resetTimer];
    }else if (self.moveDirection == MoveDirection_up || self.moveDirection == MoveDirection_down){
        if (startInLeft) {//上调亮度
            [UIScreen mainScreen].brightness = self.brightness - subY/height;//10;
        }else{//上调音量
            self.volumeSlider.value = self.sysVolume - subY/height;//10;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesEnded:touches withEvent:event];
    if (self.moveDirection == MoveDirection_left || self.moveDirection == MoveDirection_right) {
        [self.bottomView seekTo:self.maskView.fastForwardView.currentDuration];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playStatus = self.prePlayStatus;
            [self resetTimer];
        });
    }
    [self setMoveDirection:MoveDirection_none];
    [self setCurrentTime:0];
}


#pragma mark - 系统方法
// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (kAppDelegate.allowRotation) {
        return YES;
    }else{
        return NO;
    }
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            //屏幕从竖屏变为横屏时执行
            [self changeFullScreen:YES];
        }else{
            //屏幕从横屏变为竖屏时执行
            [self changeFullScreen:NO];
        }
    });
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
}

@end
