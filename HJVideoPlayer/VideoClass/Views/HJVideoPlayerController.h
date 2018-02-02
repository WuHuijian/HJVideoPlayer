//
//  HJVideoPlayerController.h
//  HJVideoPlayer
//
//  Created by WHJ on 2016/12/8.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJVideoConfigModel.h"

typedef NS_ENUM(NSUInteger, VideoPlayerStatus) {
    videoPlayer_unknown,
    videoPlayer_readyToPlay,
    videoPlayer_playing,
    videoPlayer_pause,
    videoPlayer_loading,
    videoPlayer_playEnd,
    videoPlayer_playFailed
};


typedef void (^VideoPlayerControllerBackBtnClick)(void);
typedef void (^VideoPlayerControllerPlayEndBlock)(void) ;
typedef void (^VideoPlayerChangeScreenBtnClick)(BOOL changeFull);


@class HJPlayerView;
@interface HJVideoPlayerController : UIViewController

@property (nonatomic ,copy) NSString *url;
/** 视频标题 */
@property (nonatomic, copy) NSString *videoTitle;
/** 是否全屏状态 */
@property (nonatomic, assign , readonly) BOOL isFullScreen;
/** 播放状态 */
@property (nonatomic, assign , readonly) VideoPlayerStatus playStatus;
/** 用于设置第一帧图片 */
@property (nonatomic, strong , readonly) HJPlayerView *playerView;
/** 配置模型 */
@property (nonatomic, strong) HJVideoConfigModel *configModel;
/** 返回按钮点击回调 */
@property (nonatomic, copy) VideoPlayerControllerBackBtnClick backBlock;
/** 播放完成回调 */
@property (nonatomic, copy) VideoPlayerControllerPlayEndBlock playEndBlock;
/** 屏幕切换回调 */
@property (nonatomic, copy) VideoPlayerChangeScreenBtnClick screenChangedBlock;


/** 播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** 暂停播放和缓冲 */
- (void)pausePlayAndBuffer;

- (instancetype)initWithFrame:(CGRect)frame;

@end
