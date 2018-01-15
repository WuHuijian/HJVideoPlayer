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
}



- (void)enterAction{
    
    HJVideoListController *listVC = [[HJVideoListController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}



@end
