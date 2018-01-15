//
//  HJVideoTopView.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^videoBackBlock)();

typedef void(^videoShowListBlock)(BOOL show);


@interface HJVideoTopView : UIView

@property (nonatomic, copy) videoBackBlock  backBlock;

@property (nonatomic, copy) videoShowListBlock  showListBlock;

@end
