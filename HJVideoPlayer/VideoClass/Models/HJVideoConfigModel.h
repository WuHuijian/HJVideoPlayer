//
//  HJVideoConfigModel.h
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/30.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJVideoConfigModel : NSObject

/** 是否仅支持全屏 */
@property (nonatomic, assign) BOOL onlyFullScreen;
/** 设置URL后自动播放 */
@property (nonatomic, assign) BOOL autoPlay;

@end
