//
//  HJVideoMaskView.h
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/14.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, VideoMaskViewStatus) {
    VideoMaskViewStatus_hide             = 0,
    VideoMaskViewStatus_showPlayBtn      = 1,
    VideoMaskViewStatus_showReplayBtn    = 2,
};

typedef void(^videoPlayerPlayBlock)(BOOL isPlay);
typedef void(^videoPlayerReplayClickBlock)(void);


@interface HJVideoMaskView : UIView

/** 视频播放回调*/
@property (nonatomic, copy) videoPlayerPlayBlock playBlock;
/** 视频重播回调*/
@property (nonatomic, copy) videoPlayerReplayClickBlock replayBlock;

/** 遮罩层显示状态 */
@property (nonatomic, assign) VideoMaskViewStatus maskViewStatus;

- (void)show;

@end
