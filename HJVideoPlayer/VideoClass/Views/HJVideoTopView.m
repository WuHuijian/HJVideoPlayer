//
//  HJVideoTopView.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJVideoTopView.h"
#import "HJVideoPlayerHeader.h"

@interface HJVideoTopView ()

@property (nonatomic ,strong) UIButton * backBtn;

@property (nonatomic ,strong) UIButton * listBtn;

@property (nonatomic, strong) UILabel  * titleLabel;

@end

#define imgBack [UIImage imageFromBundleWithName:@"video_back"]

@implementation HJVideoTopView

-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self addObservers];
        
        [self setupUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addObservers];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.backBtn];
    
    [self addSubview:self.listBtn];
}

- (void)addObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFullScreenAction:) name:kNotificationChangeScreen object:nil];
    
}

#pragma mark - getters / setters
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [HJViewFactory buttonWithNormalImage:imgBack selectedImage:nil];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [_backBtn setShowsTouchWhenHighlighted:NO];
    }
    return _backBtn;

}


- (UIButton *)listBtn{
    if (!_listBtn) {
        _listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listBtn setTitle:@"···" forState:UIControlStateNormal];
        [_listBtn setShowsTouchWhenHighlighted:NO];
        [_listBtn addTarget:self action:@selector(showOrCloseListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.hidden = YES;
        _titleLabel.numberOfLines = 1;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}



- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.backBtn.frame = CGRectMake(0, 0, self.height, self.height);
    
    self.listBtn.frame = CGRectMake(self.width-self.height, 0, self.height, self.height);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backBtn.frame)+10, 0, self.width-CGRectGetMaxX(self.backBtn.frame)-self.listBtn.origin.y-20, self.height);
    
}

- (void)setTitle:(NSString *)title{
   
    _title = title;
    
    self.titleLabel.text = title;
}

#pragma mark - Event Response
- (void)backAction:(UIButton *)sender
{
    if (self.backBlock) {
        self.backBlock();
    }
}


- (void)showOrCloseListAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.showListBlock) {
        self.showListBlock(sender.selected);
    }
}


- (void)changeFullScreenAction:(NSNotification *)notif{
    
    BOOL isFullScreen = [[notif object] boolValue];
    self.titleLabel.hidden = !isFullScreen;
}
@end
