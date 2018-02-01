//
//  HJVideoTopView.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^videoBackBlock)(void);

typedef void(^videoShowListBlock)(BOOL show);

@class HJVideoConfigModel;

@interface HJVideoTopView : UIView

@property (nonatomic, copy) videoBackBlock  backBlock;

@property (nonatomic, copy) videoShowListBlock  showListBlock;

@property (nonatomic, strong) HJVideoConfigModel *configModel;

@property (nonatomic, copy) NSString *title;

@end
