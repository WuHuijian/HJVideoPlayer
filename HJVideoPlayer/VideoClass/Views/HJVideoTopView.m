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

@end

#define imgBack [UIImage imageFromBundleWithName:@"video_back"]

@implementation HJVideoTopView

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

- (void)setupUI
{
    [self addSubview:self.backBtn];
    
    [self addSubview:self.listBtn];
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


- (UIButton *)listBtn
{
    if (!_listBtn) {
        _listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listBtn setTitle:@"···" forState:UIControlStateNormal];
        [_listBtn setShowsTouchWhenHighlighted:NO];
        [_listBtn addTarget:self action:@selector(showOrCloseListAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.backBtn.frame = CGRectMake(0, 0, self.height, self.height);
    
    self.listBtn.frame = CGRectMake(self.width-self.height, 0, self.height, self.height);
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

@end
