//
//  UIImage+getImage.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (getImage)


+ (UIImage *)imageFromBundleWithName:(NSString *)imageName;


- (UIImage *)imageWithSize:(CGSize)size;


@end
