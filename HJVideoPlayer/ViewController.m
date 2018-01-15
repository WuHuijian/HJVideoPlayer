//
//  ViewController.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "ViewController.h"
#import "HJVideoPlayerController.h"
#import "HJDefines.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HJVideoPlayerController *videoPlayer = [[HJVideoPlayerController alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kHalfScreenVideoHeight)];
    [self.view addSubview:videoPlayer.view];
    [self addChildViewController:videoPlayer];
//    @"http://v1.jiyoutang.com/source/publicvideo/20160521/2/YW/BZYWRJGB4020701.mp4"
//    @"http://data.vod.itc.cn/?rb=1&prot=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=flash&pt=1&new=/24/130/hy0Jstq9J9itor8u88OnBgA.mp4"
    
    [videoPlayer setUrl:@"http://hc34.aipai.com/user/20/21066020/1006/card/44203707/card.mp4"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
