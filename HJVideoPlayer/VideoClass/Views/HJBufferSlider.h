//
//  HJBufferSlider.h
//  HJBufferSlider
//
//  Created by WHJ on 2016/11/22.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJBufferSlider : UIView

@property (nonatomic, assign) CGFloat minimumValue;

@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, assign) CGFloat bufferValue;//缓冲进度值

@property (nonatomic, assign) CGFloat progressValue;//进度值

// Color

@property (nonatomic, strong) UIColor * progressTrackColor;//进度颜色

@property (nonatomic, strong) UIColor * bufferTrackColor;//缓冲进度颜色

@property (nonatomic, strong) UIColor * maxBufferTrackColor;//背景色

@property (nonatomic, strong) UIColor * thumbTintColor;//滑块颜色


// Image

@property (nonatomic, strong) UIImage * progressTrackImage;//进度图片

@property (nonatomic, strong) UIImage * bufferTrackImage;//缓冲进度图片

@property (nonatomic, strong) UIImage * maxBufferTrackImage;//背景图片

@property (nonatomic, strong) UIImage * thumbImage;//滑块图片


// Methods
- (void)addTarget:(nullable id)target action:(nonnull SEL)sel
                            forControlEvents:(UIControlEvents)controlEvent;


@end
