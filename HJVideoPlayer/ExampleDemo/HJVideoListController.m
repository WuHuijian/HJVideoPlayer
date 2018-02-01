//
//  HJVideoListController.m
//  HJVideoPlayer
//
//  Created by WHJ on 2018/1/15.
//  Copyright © 2018年 WHJ. All rights reserved.
//

#import "HJVideoListController.h"
#import "HJVideoPlayerController.h"
#import "HJVideoPlayerHeader.h"
#import "HJVideoConst.h"

@interface HJVideoListController ()<UITableViewDelegate,UITableViewDataSource>

/** 视频播放器 */
@property (nonatomic, strong) HJVideoPlayerController *videoPlayerVC;

/** 数据 */
@property (nonatomic, strong) NSArray *urls;

@property (nonatomic, strong) NSArray *names;


@end

@implementation HJVideoListController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildDatas];
    
    [self setupUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}
- (void)dealloc{
   
    NSLog(@"视频播放列表销毁了");
}

- (void)buildDatas{
    
    //@"https://oss.zonghenggongkao.cn/course/microcourse/shenlun/sg02.mp4
    self.urls = @[@"http://hc34.aipai.com/user/128/31977128/6009407/card/44044719/card.mp4?l=f",
                  @"http://hc31.aipai.com/user/128/31977128/1006/card/44340096/card.mp4?l=f"
                  ];
    
    self.names = @[@"王者荣耀德古拉：44杀貂蝉？谁能阻挡我",
                   @"德古拉貂蝉"];

}
#pragma mark - About UI
- (void)setupUI{
    
    HJVideoPlayerController *videoPlayer = [[HJVideoPlayerController alloc]initWithFrame:CGRectMake(0, 0, kVideoScreenW, VideoH(kVideoScreenW))];
    [self.view addSubview:videoPlayer.view];
    [self addChildViewController:videoPlayer];
    self.videoPlayerVC = videoPlayer;
    [self.videoPlayerVC setUrl:self.urls[0]];
    [self.videoPlayerVC setTitle:self.names[0]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(videoPlayer.view.frame), kVideoScreenW, kVideoScreenH-CGRectGetHeight(videoPlayer.view.frame)) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.view addSubview:tableView];
    
    [tableView reloadData];
}

#pragma mark - Request Data

#pragma mark - Pravite Method

#pragma mark - Public Method

#pragma mark - Event response

#pragma mark - Delegate methods

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.names[indexPath.row];
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"name:%@ url=%@",self.names[indexPath.row],self.urls[indexPath.row]);
    [self.videoPlayerVC.configModel setOnlyFullScreen:NO];
    [self.videoPlayerVC setUrl:self.urls[indexPath.row]];
    [self.videoPlayerVC setVideoTitle:self.names[indexPath.row]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}


#pragma mark - Getters/Setters/Lazy
@end
