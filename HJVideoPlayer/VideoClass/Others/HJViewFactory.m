//
//  HJViewFactory.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/18.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJViewFactory.h"


@implementation HJViewFactory



+ (UIButton *)buttonWithNormalImage:(UIImage *)normalImage
                      selectedImage:(UIImage *)selectedImage;{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setShowsTouchWhenHighlighted:YES];
    
    if(normalImage)
    [btn setImage:normalImage forState:UIControlStateNormal];
    
    if (selectedImage)
    [btn setImage:selectedImage forState:UIControlStateSelected];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    
    return btn;
}

@end
