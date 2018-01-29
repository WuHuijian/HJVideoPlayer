//
//  HJVideoPlayerController.h
//  HJVideoPlayer
//
//  Created by WHJ on 2016/12/8.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


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

@property (nonatomic ,strong) NSString *url;

@property (nonatomic, assign , readonly) BOOL isFullScreen;

@property (nonatomic, assign , readonly) VideoPlayerStatus playStatus;

- (instancetype)initWithFrame:(CGRect)frame;

@end
