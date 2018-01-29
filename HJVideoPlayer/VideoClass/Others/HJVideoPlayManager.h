//
//  HJVideoPlayManager.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "HJSingletonService.h"

#define kVideoPlayerManager [HJVideoPlayManager sharedHJVideoPlayManager]


typedef void(^VideoPlayerManagerReadyBlock)(CGFloat totoalDuration);//准备播放回调
typedef void(^VideoPlayerManagerMonitoringBlock)(CGFloat currentDuration);//播放监听回调
typedef void(^VideoPlayerManagerLoadingBlock)();//loading回调
typedef void(^VideoPlayerManagerPlayFailedBlock)();//播放失败回调
typedef void(^VideoPlayerManagerPlayEndBlock)();//播放结束回调


@interface HJVideoPlayManager : NSObject

@property (nonatomic, strong, readonly) AVPlayer       *player;

ServiceSingletonH(HJVideoPlayManager)


- (void)readyBlock:(VideoPlayerManagerReadyBlock)readyBlock
   monitoringBlock:(VideoPlayerManagerMonitoringBlock)monitoringBlock
      loadingBlock:(VideoPlayerManagerLoadingBlock)loadingBlock
          endBlock:(VideoPlayerManagerPlayEndBlock)endBlock
       failedBlock:(VideoPlayerManagerPlayFailedBlock)faildBlock;

- (AVPlayer *)setUrl:(NSString *)url;

- (void)play;

- (void)pause;

- (void)seekToTime:(CGFloat)second;

- (void)reset;

@end
