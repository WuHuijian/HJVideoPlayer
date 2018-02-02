//
//  HJBufferSlider.m
//  HJBufferSlider
//
//  Created by WHJ on 2016/11/22.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJBufferSlider.h"


@interface HJBufferSlider ()

@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) UISlider *bufferSlider;

/** 缓冲slider背景色 */
@property (nonatomic, strong) UIColor *bufferBgColor;

@end

@implementation HJBufferSlider


- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}


#pragma mark - About UI
- (void)setupUI{

    UISlider *bufferSlider = [[UISlider alloc]init];
    [bufferSlider setUserInteractionEnabled:NO];
    [bufferSlider setThumbTintColor:[UIColor clearColor]];
    [self setBufferSlider:bufferSlider];
    [self addSubview:bufferSlider];
    
    
    UISlider *progressSlider = [[UISlider alloc]init];
    [progressSlider setMaximumTrackTintColor:[UIColor clearColor]];
    [self setProgressSlider:progressSlider];
    [self addSubview:progressSlider];
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.bufferSlider setFrame:self.bounds];
    [self.progressSlider setFrame:self.bounds];
}


#pragma mark - Public Methods

- (void)addTarget:(nullable id)target action:(nonnull SEL)sel
                            forControlEvents:(UIControlEvents)controlEvent;{

    [self.progressSlider addTarget:target action:sel forControlEvents:controlEvent];
    
}




#pragma mark - Setters/Getters

- (void)setMinimumValue:(CGFloat)minimumValue{
    
    _minimumValue = minimumValue;
    [self.progressSlider setMinimumValue:minimumValue];
    [self.bufferSlider setMinimumValue:minimumValue];
}

- (void)setMaximumValue:(CGFloat)maximumValue{
    
    _maximumValue = maximumValue;
    [self.progressSlider setMaximumValue:maximumValue];
    [self.bufferSlider setMaximumValue:maximumValue];
}

- (void)setFrame:(CGRect)frame{

    [super setFrame:frame];
    [self.bufferSlider setFrame:self.bounds];
    [self.progressSlider setFrame:self.bounds];
}
/**
 *  Buffer Slider
 */

- (void)setBufferValue:(CGFloat)bufferValue{
    
    _bufferValue = bufferValue;
    [self.bufferSlider setValue:bufferValue];
    //临时解决缓冲完成但是进度条不充满问题
    if(self.bufferSlider.maximumValue == bufferValue){
        [self setMaxBufferTrackColor:self.bufferSlider.minimumTrackTintColor];
    }else{
        [self setMaxBufferTrackColor:self.bufferBgColor];
    }
}

- (void)setBufferTrackColor:(UIColor *)bufferTrackColor{
    
    _bufferTrackColor = bufferTrackColor;
    [self.bufferSlider setMinimumTrackTintColor:bufferTrackColor];
}


- (void)setMaxBufferTrackColor:(UIColor *)maxBufferTrackColor{
    
    _maxBufferTrackColor = maxBufferTrackColor;
    [self.bufferSlider setMaximumTrackTintColor:maxBufferTrackColor];
    if (!self.bufferBgColor) {
        self.bufferBgColor = maxBufferTrackColor;
    }
}


- (void)setBufferTrackImage:(UIImage *)bufferTrackImage{

    _bufferTrackImage = bufferTrackImage;
    [self.bufferSlider setMinimumTrackImage:bufferTrackImage forState:UIControlStateNormal];
}
 

- (void)setMaxBufferTrackImage:(UIImage *)maxBufferTrackImage{

    _maxBufferTrackImage = maxBufferTrackImage;
    [self.bufferSlider setMaximumTrackImage:maxBufferTrackImage forState:UIControlStateNormal];
}
/**
 *  Progress Slider
 */
- (void)setProgressValue:(CGFloat)progressValue{
    
    _progressValue = progressValue;
    [self.progressSlider setValue:progressValue];
}


- (void)setProgressTrackColor:(UIColor *)progressTrackColor{

    _progressTrackColor = progressTrackColor;
    [self.progressSlider setMinimumTrackTintColor:progressTrackColor];
}


- (void)setThumbTintColor:(UIColor *)thumbTintColor{

    _thumbTintColor = thumbTintColor;
    [self.progressSlider setThumbTintColor:thumbTintColor];
}


- (void)setProgressTrackImage:(UIImage *)progressTrackImage{
    
    _progressTrackImage = progressTrackImage;
    [self.progressSlider setMinimumTrackImage:progressTrackImage forState:UIControlStateNormal];
}

- (void)setThumbImage:(UIImage *)thumbImage{

    _thumbImage = thumbImage;
    [self.progressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
}




@end
