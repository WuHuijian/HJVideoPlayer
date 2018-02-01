
//
//  UIImage+getImage.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "UIImage+getImage.h"

@implementation UIImage (getImage)


+ (UIImage *)imageFromBundleWithName:(NSString *)imageName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoImages" ofType:@".bundle"];
    NSString *fullImageName = [path stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:fullImageName];
}


- (UIImage *)imageWithSize:(CGSize)size;{

    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
