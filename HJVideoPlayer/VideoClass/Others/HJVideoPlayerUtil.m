//
//  HJVideoPlayerUtil.m
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/29.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJVideoPlayerUtil.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@implementation HJVideoPlayerUtil

+ (UIImage *)getImageWithVideoUrl:(NSString *)urlString{
    
    //视频地址
    NSURL *url = nil;
    if ([urlString hasPrefix:@"http"]) {
        url = [NSURL URLWithString:urlString];
    }else{
        url = [NSURL fileURLWithPath:urlString];
    }
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];//
    
    //获取视频时长，单位：秒
    NSLog(@"%llu",urlAsset.duration.value/urlAsset.duration.timescale);
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    generator.appliesPreferredTrackTransform = YES;
    
    generator.maximumSize = CGSizeMake(1136, 640);
    
    NSError *error = nil;
    
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    
    UIImage *image = [UIImage imageWithCGImage: img];
    
    return image;
}

@end
