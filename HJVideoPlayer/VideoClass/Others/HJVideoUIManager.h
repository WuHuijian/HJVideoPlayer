//
//  HJVideoUIManager.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/31.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJVideoTopView.h"
#import "HJVideoBottomView.h"
#import "HJSingletonService.h"

#define kHJVideoUIManager [HJVideoUIManager sharedHJVideoUIManager]

@interface HJVideoUIManager : NSObject

ServiceSingletonH(HJVideoUIManager)

@property (nonatomic ,weak) HJVideoTopView *topView;

@property (nonatomic ,weak) HJVideoBottomView *bottomView;

@end
