//
//  UIDevice+HJVideoRotation.m
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/31.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "UIDevice+HJVideoRotation.h"

@implementation UIDevice (HJVideoRotation)

+ (void)rotateToOrientation:(UIInterfaceOrientation)orientation{
//    // 清除方向
//    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    // 设置方向
    NSNumber *orientationTarget = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

@end
