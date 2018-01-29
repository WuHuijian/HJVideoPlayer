//
//  HJVideoUIManager.h
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/31.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJSingletonService.h"

#define kHJVideoUIManager [HJVideoUIManager sharedHJVideoUIManager]

@interface HJVideoUIManager : NSObject

ServiceSingletonH(HJVideoUIManager)

@end
