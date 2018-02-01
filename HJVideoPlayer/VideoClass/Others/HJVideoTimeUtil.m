//
//  HJVideoTimeUtil.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/27.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJVideoTimeUtil.h"

@implementation HJVideoTimeUtil

// 将秒数转换为时分秒字符串
+ (NSString *)hmsStringWithFloat:(CGFloat)seconds{
    
    NSInteger hour = floor(seconds/60/60);
    NSInteger minutes = floor(seconds/60)-hour*60;
    NSInteger second = seconds - hour*60*60 - minutes*60;
    NSString * timeString = nil;
    if (hour == 0) {
        timeString = [NSString stringWithFormat:@"%02zd:%02zd", minutes, second];
    }else{
        timeString = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", hour, minutes, second];
    }
    
    return timeString;
}

@end
