//
//  HJCircleLoading.h
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/16.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJCircleLoading : UIView

/** 直径 */
@property (nonatomic, assign) CGFloat circleDiameter;
/** 一次动画时长 */
@property (nonatomic, assign) CGFloat duration;
/** 画线颜色 */
@property (nonatomic, strong) UIColor *strokeColor;
/** 线条宽度 */
@property (nonatomic, assign) CGFloat lineWidth;
/** layer背景色 */
@property (nonatomic, strong) UIColor *fillColor;

- (void)startAnimating;

- (void)stopAnimating;

@end
