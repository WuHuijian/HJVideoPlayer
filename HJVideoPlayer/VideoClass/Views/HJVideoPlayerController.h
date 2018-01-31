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

@interface HJVideoPlayerController : UIViewController

@property (nonatomic ,copy) NSString *url;
/** 视频标题 */
@property (nonatomic, copy) NSString *videoTitle;
/** 是否全屏状态 */
@property (nonatomic, assign , readonly) BOOL isFullScreen;
/** 播放状态 */
@property (nonatomic, assign , readonly) VideoPlayerStatus playStatus;
/** 配置模型 */
@property (nonatomic, strong) HJVideoConfigModel *configModel;


- (instancetype)initWithFrame:(CGRect)frame;

@end
