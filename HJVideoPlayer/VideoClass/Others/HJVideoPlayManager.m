//
//  HJVideoPlayManager.m
//  HJVideoPlayer
//
//  Created by WHJ on 16/10/17.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJVideoPlayManager.h"
#import "HJVideoUIManager.h"
#import "HJVideoPlayerHeader.h"

@interface HJVideoPlayManager ()
// 播放相关
@property (nonatomic ,strong) AVURLAsset     *urlAsset;
@property (nonatomic ,strong) AVAsset        *asset;
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *playerItem;
@property (nonatomic, strong) NSObject       *playbackTimeObserver;
/** 是否为本地视频*/
@property (nonatomic ,assign) BOOL            isLocalVideo;
/** 视频时长(秒)*/
@property (nonatomic ,assign) CGFloat  totalDuration;
/** 当前播放时长*/
@property (nonatomic ,assign) CGFloat  currentDuration;
/** 当前缓冲进度*/
@property (nonatomic ,assign) CGFloat  bufferDuration;
/** 是否正在播放*/
@property (nonatomic ,assign) BOOL isPlaying;


@property (nonatomic ,copy) VideoPlayerManagerReadyBlock readyBlock;

@property (nonatomic ,copy) VideoPlayerManagerMonitoringBlock monitoringBlock;

@property (nonatomic ,copy) VideoPlayerManagerLoadingBlock loadingBlock;

@property (nonatomic ,copy) VideoPlayerManagerPlayEndBlock endBlock;

@property (nonatomic ,copy) VideoPlayerManagerPlayFailedBlock failedBlock;

@end


@implementation HJVideoPlayManager

ServiceSingletonM(HJVideoPlayManager)


#pragma mark - Public Methods

- (void)readyBlock:(VideoPlayerManagerReadyBlock)readyBlock
   monitoringBlock:(VideoPlayerManagerMonitoringBlock)monitoringBlock
      loadingBlock:(VideoPlayerManagerLoadingBlock)loadingBlock 
          endBlock:(VideoPlayerManagerPlayEndBlock)endBlock
       failedBlock:(VideoPlayerManagerPlayFailedBlock)faildBlock{

    [self setReadyBlock:readyBlock];
    [self setMonitoringBlock:monitoringBlock];
    [self setLoadingBlock:loadingBlock];
    [self setEndBlock:endBlock];
    [self setFailedBlock:faildBlock];
}



- (AVPlayer *)setUrl:(NSString *)url{
    if (!url || url.length == 0) return nil;
    
    //Reset player
    [self reset];
    
    NSURL *urlAddress = nil;
    
    if ([url hasPrefix:@"http://"]) {
        urlAddress = [NSURL URLWithString:url];
        [self setIsLocalVideo:NO];
    }else{
        urlAddress = [NSURL fileURLWithPath:url];
        [self setIsLocalVideo:YES];
    }
    
    self.urlAsset   = [AVURLAsset assetWithURL:urlAddress];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    [self.player      replaceCurrentItemWithPlayerItem:self.playerItem];
    
    [self addObserver];
    
    return [self player];
}

- (void)play
{
    [self.player play];
    [self setIsPlaying:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlayVideo object:nil];
    NSLog(@"开始播放！");
}


- (void)pause
{
    [self.player pause];
    [self setIsPlaying:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPauseVideo object:nil];
    NSLog(@"暂停播放！");
}


- (void)seekToTime:(CGFloat)seconds{
   
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        if (self.isPlaying) {
            [self play];
        }
    }];
}




#pragma mark - add/remove Observer
- (void)addObserver
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver
{

    [[self.player currentItem] removeObserver:self forKeyPath:@"status"];
    [[self.player currentItem] removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeTimeObserver:self.playbackTimeObserver];
}

#pragma mark - Event Response

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"VideoPlayer : [AVPlayerStatusReadyToPlay]");
            [self monitoringPlayback:playerItem];// 给播放器添加计时器
        }else if ([playerItem status] == AVPlayerStatusFailed ) {
            NSLog(@"VideoPlayer : [AVPlayerStatusFailed]");
            if(self.failedBlock){
                self.failedBlock();
            }
        }else if ([playerItem status] == AVPlayerStatusUnknown){
            NSLog(@"VideoPlayer : [AVPlayerStatusUnknown]");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
        
            NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            self.bufferDuration = startSeconds + durationSeconds;// 计算缓冲总进度
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
            NSLog(@"VideoPlayer : [playbackBufferEmpty]");
            if (playerItem.playbackBufferEmpty) {
                //缓冲中
                if (self.loadingBlock) {
                    self.loadingBlock();
                }
            }
    }
}


#pragma mark - getters / setters
- (void)setCurrentDuration:(CGFloat)currentDuration
{
    _currentDuration = currentDuration;
    [[kHJVideoUIManager bottomView] setProgress:_currentDuration];
    NSLog(@"当前播放时间 %.2f秒",currentDuration);
}


- (void)setTotalDuration:(CGFloat)totalDuration
{
    _totalDuration = totalDuration;
    [[kHJVideoUIManager bottomView] setMaximumValue:_totalDuration];
    NSLog(@"当前播放时间 %.2f秒",totalDuration);
}


- (void)setBufferDuration:(CGFloat)bufferDuration
{
    _bufferDuration = bufferDuration;
    //TODO: 设置缓冲进度
    [[kHJVideoUIManager bottomView] setBufferValue:bufferDuration];

}
- (AVPlayer *)player
{
    if(!_player){
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}

#pragma mark - Private Methods
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    //视频总时间
    self.totalDuration = playerItem.duration.value / playerItem.duration.timescale;
    //视频准备播放回调
    if (self.readyBlock) {
        self.readyBlock(self.totalDuration);
    }

    
    __weak __typeof(self)weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        weakSelf.currentDuration = playerItem.currentTime.value/playerItem.currentTime.timescale;
        
        if(weakSelf.currentDuration != weakSelf.totalDuration){
            if(weakSelf.monitoringBlock){
                weakSelf.monitoringBlock(weakSelf.currentDuration);
            }
        }else{
            if (weakSelf.endBlock) {
                weakSelf.endBlock();
            }
        }
    }];
}


- (void)reset
{
    [self removeObserver];
    [[self.player currentItem] cancelPendingSeeks];
    [[self.player currentItem].asset cancelLoading];
    [self setAsset:nil];
    [self setUrlAsset:nil];
    [self setPlayerItem:nil];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}
@end
