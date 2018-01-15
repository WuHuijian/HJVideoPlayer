//
//  HJViewFactory.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/18.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+getImage.h"

@interface HJViewFactory : NSObject


+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage;

@end
