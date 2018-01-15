//
//  HJVideoMaskView.m
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/14.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJVideoMaskView.h"
#import "HJViewFactory.h"
#import "UIImage+getImage.h"


@interface HJVideoMaskView ()

@property (nonatomic ,strong) UIButton * playBtn;
// 当前显示的视图
@property (nonatomic, strong) UIView *currentShowV;

@end


#define imgPlay         [UIImage imageFromBundleWithName:@"video_play"]
#define imgPause        [UIImage imageFromBundleWithName:@"video_pause"]


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

- (void)hide{
 
    self.hidden = YES;
}

- (void)showPlayBtn{
    
    self.hidden = NO;
    self.playBtn.hidden = NO;
    self.playBtn.center = self.center;
    self.currentShowV = self.playBtn;
}

#pragma mark - Event response
- (void)playOrPauseAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.playBlock) {
        self.playBlock(sender.selected);
    }
}
#pragma mark - Private methods

#pragma mark - Delegate methods

#pragma mark - getters and setters
- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [HJViewFactory buttonWithNormalImage:imgPlay selectedImage:imgPause];
        [_playBtn addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setFrame:CGRectMake(0, 0, 44, 44)];
        [_playBtn setHidden:YES];
        [self addSubview:_playBtn];
    }
    return _playBtn;
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
