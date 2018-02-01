//
//  HJVideoTopView.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJVideoTopView.h"
#import "HJVideoPlayerHeader.h"
#import "HJVideoConfigModel.h"
#import "HJVideoConst.h"
#import "HJViewFactory.h"

@interface HJVideoTopView ()

@property (nonatomic ,strong) UIButton * backBtn;

@property (nonatomic ,strong) UIButton * listBtn;

@property (nonatomic, strong) UILabel  * titleLabel;
/** 渐变layer */
@property (nonatomic, strong) CAGradientLayer* gradientLayer;
/** 是否全屏 */
@property (nonatomic, assign) BOOL fullScreen;

@end



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
    [self.layer addSublayer:self.gradientLayer];
    
    [self addSubview:self.backBtn];
    
    [self addSubview:self.listBtn];
}


- (void)changeGradientWithRect:(CGRect)rect{
    
    self.gradientLayer.frame = rect;
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)kVideoBottomGradientColor.CGColor,
                                  (__bridge id)[UIColor clearColor].CGColor];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.f), @(1.0f)];
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
        [_listBtn setHidden:YES];
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

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [[CAGradientLayer alloc] init];
    }
    return _gradientLayer;
}




- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
   
    self.backBtn.frame = CGRectMake(0, 0, height, height);
    
    self.listBtn.frame = CGRectMake(width-height, 0, height, height);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backBtn.frame)+10, 0, width-CGRectGetMaxX(self.backBtn.frame)-self.listBtn.frame.origin.y-20, height);
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
    
    [self setFullScreen:isFullScreen];
}


- (void)setFullScreen:(BOOL)fullScreen{
    
    _fullScreen = fullScreen;
    // 小屏隐藏标题
    self.titleLabel.hidden = !fullScreen;
    
    // 调整frame
    CGFloat height = fullScreen?kTopBarFullHeight:kTopBarHalfHeight;
    self.frame = CGRectMake(0, 0, CGRectGetWidth(self.superview.frame), height);
    
    // 调整渐变范围
    CGRect rect = fullScreen?self.bounds:CGRectMake(0, 0, self.bounds.size.width, 0);
    [self changeGradientWithRect:rect];
    
}

@end
