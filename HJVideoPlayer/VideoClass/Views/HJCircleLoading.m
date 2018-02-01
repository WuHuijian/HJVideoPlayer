//
//  HJCircleLoading.m
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/16.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJCircleLoading.h"

static NSString * const kCircleLoadingKey = @"CircleLoadingKey";
static const CGFloat kDefaultCircleDiameter = 40.f;

@interface HJCircleLoading ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation HJCircleLoading

- (instancetype)init
{
    self = [super init];
    if (self) {
         [self buildSomeParams];
    }
    return self;
}



-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self buildSomeParams];
    }
    return self;
}


- (void)buildSomeParams{
    
    self.circleDiameter = kDefaultCircleDiameter;
    self.duration = 1.2f;
    self.strokeColor = [UIColor whiteColor];
    self.lineWidth = 4;
    self.fillColor = [UIColor clearColor];
}

- (void)startAnimating{
    
    //layer配置
    CGFloat margin = (self.frame.size.width - self.circleDiameter)/2.f;
    self.shapeLayer.frame = CGRectMake(margin, margin, self.circleDiameter, self.circleDiameter);
    self.shapeLayer.strokeColor = self.strokeColor.CGColor;
    self.shapeLayer.fillColor = self.fillColor.CGColor;
    self.shapeLayer.lineWidth = self.lineWidth;
    
    //设置动画路径
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.circleDiameter, self.circleDiameter)];
    self.shapeLayer.path = circlePath.CGPath;
    
    //设置出现动画
    CABasicAnimation *startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue         = @0;
    startAnimation.toValue           = @1;
    startAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    startAnimation.duration            = self.duration;
    
    //设置结束动画
    CABasicAnimation *endAnimation   = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue           = @0;
    endAnimation.toValue             = @1;
    endAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    endAnimation.duration            = self.duration * 0.5;
    
    //组动画
    CAAnimationGroup *strokeAniamtionGroup = [CAAnimationGroup animation];
    strokeAniamtionGroup.duration          = self.duration;
    strokeAniamtionGroup.animations        = @[endAnimation,startAnimation];
    strokeAniamtionGroup.repeatCount       = MAXFLOAT;
    [self.shapeLayer addAnimation:strokeAniamtionGroup forKey:kCircleLoadingKey];

}


- (void)stopAnimating{
    if ([self.shapeLayer.animationKeys containsObject:kCircleLoadingKey]) {
        [self.shapeLayer removeAnimationForKey:kCircleLoadingKey];
    }
}




- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:shapeLayer];
        _shapeLayer = shapeLayer;
    }
    return _shapeLayer;
}


- (void)setFrame:(CGRect)frame{
    
    if (frame.size.width<self.circleDiameter) {
        frame.size.width = self.circleDiameter;
    }
    
    if (frame.size.height<self.circleDiameter) {
        frame.size.height = self.circleDiameter;
    }
    
    [super setFrame:frame];
}


- (void)setCircleDiameter:(CGFloat)circleDiameter{
    
    if (circleDiameter>self.frame.size.width && self.frame.size.width!=0) {
        _circleDiameter = self.frame.size.width;
    }else{
        _circleDiameter = kDefaultCircleDiameter;
    }
}


@end
