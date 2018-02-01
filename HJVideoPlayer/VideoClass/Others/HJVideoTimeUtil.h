//
//  HJVideoTimeUtil.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/27.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HJVideoTimeUtil : NSObject

// 将秒数转换为时分秒字符串
+ (NSString *)hmsStringWithFloat:(CGFloat)seconds;

@end
