//
//  HJDefines.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>


/**********************   CONSTS  ***********************/

#define kFrame                       [UIScreen mainScreen].bounds
#define kScreenSize                  [UIScreen mainScreen].bounds.size
#define kScreenWidth                 [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                [UIScreen mainScreen].bounds.size.height
#define kAppDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kHalfScreenVideoHeight       kScreenHeight/3.f


/**********************  STATIC CONSTS  ***********************/
static float const kNavigationBarHeight = 64;
static float const kTabBarHeight = 49;
static float const kDefaultAnimationDuration = 0.35f;


/**********************   Methods  ***********************/
// 屏幕适配
#define RatioHeight [UIScreen mainScreen].bounds.size.height / 667.f-0.001
#define RatioWidth [UIScreen mainScreen].bounds.size.width / 375.f-0.001
#define Ratio_X(x) (x * RatioWidth)
#define Ratio_Y(y) (y * RatioHeight)

// 播放器高度 16：9
#define VideoHeight(width) (width*9/16.f)

// weakSelf
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self


// NSLog
#ifdef DEBUG

#define NSLog(format, ...) printf("%s \n",[[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);

#else

#define NSLog(format, ...)

#endif


/**********************   Notifications  ***********************/
// 切换屏幕通知
#define kNotificationChangeScreen  @"notificationChangeScreen"
#define kNotificationPlayVideo     @"NotificationPlayVideo"
#define kNotificationPauseVideo    @"kNotificationPauseVideo"


