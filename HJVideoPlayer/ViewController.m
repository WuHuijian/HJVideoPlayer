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
#import "HJVideoListController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterBtn setTitle:@"进入视频播放列表" forState:UIControlStateNormal];
    [enterBtn setFrame:CGRectMake(0, 0, 200, 44)];
    [enterBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [enterBtn setCenter:self.view.center];
    [enterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    
    UIButton * fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullBtn setTitle:@"进入全屏播放" forState:UIControlStateNormal];
    CGRect fullBtnFrame = enterBtn.frame;
    fullBtnFrame.origin.y = CGRectGetMaxY(enterBtn.frame)+20;
    [fullBtn setFrame:fullBtnFrame];
    [fullBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [fullBtn addTarget:self action:@selector(enterFull) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fullBtn];
}



- (void)enterAction{
    
    HJVideoListController *listVC = [[HJVideoListController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}


- (void)enterFull{

    HJVideoPlayerController * videoC = [[HJVideoPlayerController alloc] init];
    [videoC.configModel setOnlyFullScreen:YES];
    [videoC setUrl:@"http://hc31.aipai.com/user/128/31977128/1006/card/44340096/card.mp4?l=f"];
    [self.navigationController pushViewController:videoC animated:YES];

}

@end
