//
//  HJVideoBottomView.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void(^videoPlayerFullScreenBlock)(BOOL isFull);

@interface HJVideoBottomView : UIView

/** 大小屏切换回调*/
@property (nonatomic, copy) videoPlayerFullScreenBlock fullScreenBlock;
/** 进度*/
@property (nonatomic, assign ,readonly) CGFloat progressValue;
/** 缓冲进度*/
@property (nonatomic, assign ,readonly) CGFloat bufferValue;
/** 最大进度 */
@property (nonatomic, assign ,readonly) CGFloat maximumValue;




// 设置进度
- (void)setProgress:(CGFloat)progressValue;

// 设置缓冲进度
- (void)setBufferValue:(CGFloat)bufferValue;

// 设置最大进度
- (void)setMaximumValue:(CGFloat)value;

// seekTo
- (void)seekTo:(CGFloat)playTime;


@end
