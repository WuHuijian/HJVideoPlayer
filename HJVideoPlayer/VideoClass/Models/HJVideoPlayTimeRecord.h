//
//  HJVideoPlayTimeRecord.h
//  HJVideoPlayer
//
//  Created by WHJ on 2018/2/1.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJVideoPlayTimeRecord : NSObject

/** 播放url */
@property (nonatomic, copy) NSString *url;

/** 播放时长记录 */
@property (nonatomic, assign) float playTime;


@end
