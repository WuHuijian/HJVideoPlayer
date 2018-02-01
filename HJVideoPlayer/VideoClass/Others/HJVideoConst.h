//
//  HJVideoConst.h
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/26.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#ifndef HJVideoConst_h
#define HJVideoConst_h


/**********************   CONSTS  ***********************/

#define kVideoFullFrame              [UIScreen mainScreen].bounds
#define kVideoScreenW                [UIScreen mainScreen].bounds.size.width
#define kVideoScreenH                [UIScreen mainScreen].bounds.size.height


#define kVideoMaskViewBGColor [[UIColor blackColor] colorWithAlphaComponent:.3]

#define kVideoBottomGradientColor [[UIColor blackColor] colorWithAlphaComponent:.5]


static CGFloat const kDefaultAnimationDuration = 0.35f;

static CGFloat const kTopBarHalfHeight = 44.f;
static CGFloat const kTopBarFullHeight = 44.f;
static CGFloat const kBottomBarHalfHeight = 44.f;
static CGFloat const kBottomBarFullHeight = 44.f;

/**********************   Images  ***********************/

#define imgFullScreen   [UIImage imageFromBundleWithName:@"video_toFullScreen_white"]
#define imgHalfScreen   [UIImage imageFromBundleWithName:@"video_toHalfScreen_white"]
#define imgSliderThumb  [UIImage imageFromBundleWithName:@"video_slider_thumb"]

#define imgVideoBackImg [UIImage imageFromBundleWithName:@"video_bg.jpg"]

#define imgPlay         [UIImage imageNamed:@"video_play"]
#define imgPause        [UIImage imageNamed:@"video_pause"]
#define imgBack         [UIImage imageNamed:@"video_back"]

/**********************   methods  ***********************/
// weakSelf
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self
// 播放器高度 16：9
#define VideoH(width) (width*9/16.f)


/**********************   Notifications  ***********************/
// 切换屏幕通知
#define kNotificationChangeScreen  @"NotificationChangeScreen"
#define kNotificationPlayVideo     @"NotificationPlayVideo"
#define kNotificationPauseVideo    @"NotificationPauseVideo"







#endif /* HJVideoConst_h */
