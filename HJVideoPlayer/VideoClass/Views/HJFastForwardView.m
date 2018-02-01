//
//  HJFastForwardView.m
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/15.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJFastForwardView.h"
#import "HJVideoTimeUtil.h"

@interface HJFastForwardView ()

/** 图标 */
@property (nonatomic, strong) UIImageView *imageView;

/** 进度时长 */
@property (nonatomic, strong) UILabel *progressLabel;

/** 进度条 */
@property (nonatomic, strong) UIProgressView * progressView;

/** 当前值 */
@property (nonatomic, assign) CGFloat currentDuration;

@property (nonatomic, strong) UIImage *leftImage;

@property (nonatomic, strong) UIImage *rightImage;

/**  */
@property (nonatomic, assign) CGRect fullFrame;

@property (nonatomic, assign) CGRect halfFrame;

@end

@implementation HJFastForwardView

#pragma mark - Life Circle
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
 
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;
    [self addSubview:imageView];
    
    UILabel *progressLabel = [[UILabel alloc] init];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.font = [UIFont systemFontOfSize:10.f];
    self.progressLabel = progressLabel;
    [self addSubview:progressLabel];
    
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.progressTintColor = [UIColor redColor];
    self.progressView = progressView;
    [self addSubview:self.progressView];
}

- (void)layoutSubviews{
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    self.imageView.frame = CGRectMake(0, 0, width/2.f, height/4.f);
    self.imageView.center = CGPointMake(width/2.f, height/4.f);
    
    self.progressLabel.frame = CGRectMake(0, height/2.f, width, height/4.f);
    
    self.progressView.frame = CGRectMake(5,(height+height*3/4.f-4)/2.f, width - 10.f, 4.f);
}


#pragma mark - Pravite Method

#pragma mark - Public Method
- (void)configForwardLeftImage:(UIImage *)leftImage forwardRightImage:(UIImage *)rightImage;{
    self.leftImage = leftImage;
    self.rightImage = rightImage;
}

- (void)moveRight:(BOOL)isRight{
    
    self.imageView.image = isRight?self.rightImage:self.leftImage;
}

#pragma mark - Event response

#pragma mark - Delegate methods

#pragma mark - Getters/Setters/Lazy
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    [self.progressView setProgress:progress];

    self.currentDuration = self.maxDuration * progress;
    
    [self.progressLabel setText:[NSString stringWithFormat:@"%@/%@",[HJVideoTimeUtil hmsStringWithFloat:self.currentDuration],[HJVideoTimeUtil hmsStringWithFloat:self.maxDuration]]];
}


- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
}

@end
