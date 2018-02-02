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
#import "HJVideoConst.h"
#import "HJVideoPlayTimeRecord.h"
@interface HJVideoPlayManager ()
// 播放相关
@property (nonatomic ,strong) AVURLAsset     *urlAsset;
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) AVPlayerItem   *playerItem;
@property (nonatomic, strong) NSObject       *playbackTimeObserver;
/** 是否为本地视频*/
@property (nonatomic ,assign) BOOL            isLocalVideo;

/** 缓冲是否已暂停 */
@property (nonatomic, assign) BOOL bufferPaused;


/** 播放地址 */
@property (nonatomic, copy) NSString * videoUrl;
/** 播放记录 */
@property (nonatomic, strong) NSMutableArray<HJVideoPlayTimeRecord *> *playRecords;


/** 视频时长(秒)*/
@property (nonatomic ,assign) CGFloat  totalDuration;
/** 当前播放时长*/
@property (nonatomic ,assign) CGFloat  currentDuration;
/** 当前缓冲进度*/
@property (nonatomic ,assign) CGFloat  bufferDuration;
/** 是否正在播放*/
@property (nonatomic ,assign) BOOL isPlaying;

//播放状态回调
@property (nonatomic ,copy) VideoPlayerManagerReadyBlock readyBlock;

@property (nonatomic ,copy) VideoPlayerManagerMonitoringBlock monitoringBlock;

@property (nonatomic ,copy) VideoPlayerManagerLoadingBlock loadingBlock;

@property (nonatomic ,copy) VideoPlayerManagerPlayEndBlock endBlock;

@property (nonatomic ,copy) VideoPlayerManagerPlayFailedBlock failedBlock;


//时长回调
@property (nonatomic, copy) VideoPlayerManagerCurrentDurationBlock currentDurationBlock;

@property (nonatomic, copy) VideoPlayerManagerTotalDurationBlock totalDurationBlock;

@property (nonatomic, copy) VideoPlayerManagerBufferDurationBlock bufferDurationBlock;

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


- (void)totalDurationBlock:(VideoPlayerManagerTotalDurationBlock)totalBlock
      currentDurationBlock:(VideoPlayerManagerCurrentDurationBlock)currentBlock
       bufferDurationBlock:(VideoPlayerManagerBufferDurationBlock)bufferBlock;{
    
    [self setTotalDurationBlock:totalBlock];
    [self setCurrentDurationBlock:currentBlock];
    [self setBufferDurationBlock:bufferBlock];
}


- (AVPlayer *)setUrl:(NSString *)url{
    if (!url || url.length == 0) return nil;
    
    //Reset player
    [self reset];
    
    _videoUrl = url;
    
    NSURL *urlAddress = nil;
    
    if ([url hasPrefix:@"http"]) {
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
    if (self.bufferPaused) {
        [self recoverBuffer];
    }
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


- (void)cancelBuffer{
    
    [self.playerItem cancelPendingSeeks];
    [self.playerItem.asset cancelLoading];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self setBufferPaused:YES];
}


- (void)recoverBuffer{
    
    if (self.playerItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self setBufferPaused:NO];
    }
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

    // 已缓冲
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:nil];
    // 未缓冲
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    // 可以播放
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)removeObserver
{
    [[self.player currentItem] removeObserver:self forKeyPath:@"status"];
    [[self.player currentItem] removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[self.player currentItem] removeObserver:self forKeyPath:@"playbackBufferFull" context:nil];
    [[self.player currentItem] removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
    [[self.player currentItem] removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    if (self.playbackTimeObserver) {
        [self.player removeTimeObserver:self.playbackTimeObserver];
    }
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
    } else if ([keyPath isEqualToString:@"playbackBufferFull"]) {
       
        NSLog(@"VideoPlayer : [playbackBufferFull]");
        
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
        NSLog(@"VideoPlayer : [playbackLikelyToKeepUp]");
        
    }
}


- (void)moviePlayDidEnd:(NSNotification *)notif{
    
    if (self.endBlock) {
        self.endBlock();
    }
}

#pragma mark - getters / setters
- (void)setCurrentDuration:(CGFloat)currentDuration
{
    _currentDuration = currentDuration;
    NSLog(@"当前播放时间 %.2f秒",currentDuration);
    if (self.currentDurationBlock) {
        self.currentDurationBlock(currentDuration);
    }
}


- (void)setTotalDuration:(CGFloat)totalDuration
{
    _totalDuration = totalDuration;
    NSLog(@"当前播放时间 %.2f秒",totalDuration);
    if(self.totalDurationBlock){
        self.totalDurationBlock(totalDuration);
    }
    
}


- (void)setBufferDuration:(CGFloat)bufferDuration
{
    _bufferDuration = bufferDuration;
    NSLog(@"当前缓冲时间 %.2f秒",bufferDuration);
    if (self.bufferDurationBlock) {
        self.bufferDurationBlock(bufferDuration);
    }

}

- (AVPlayer *)player
{
    if(!_player){
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}

- (NSMutableArray<HJVideoPlayTimeRecord *> *)playRecords{
    
    if (!_playRecords) {
        _playRecords = [NSMutableArray array];
    }
    return _playRecords;
}

#pragma mark - Private Methods
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    //视频总时间
    self.totalDuration = (float)playerItem.duration.value / playerItem.duration.timescale;
    //视频准备播放回调
    if (self.readyBlock) {
        self.readyBlock(self.totalDuration);
    }

    
    __weak __typeof(self)weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        weakSelf.currentDuration = playerItem.currentTime.value/playerItem.currentTime.timescale;
    
            if(weakSelf.monitoringBlock){
                weakSelf.monitoringBlock(weakSelf.currentDuration);
            }
    }];
}


- (void)reset
{
    [[self.player currentItem] cancelPendingSeeks];
    [[self.player currentItem].asset cancelLoading];
    [self removeObserver];
    [self setUrlAsset:nil];
    [self setPlayerItem:nil];
    [self setPlaybackTimeObserver:nil];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}


#pragma mark - 播放记录
- (void)recordUrl:(NSString *)url playTime:(float)playTime{
    
    if(!url || url.length==0) return;
    
    HJVideoPlayTimeRecord * record = [self recordWithUrl:url];
    if(!record){
        record = [[HJVideoPlayTimeRecord alloc] init];
    }
    record.url = url;
    record.playTime = playTime;
    [self record:record];
}


- (HJVideoPlayTimeRecord *)recordWithUrl:(NSString *)url{
    
    __block HJVideoPlayTimeRecord * record = nil;
    [self.playRecords enumerateObjectsUsingBlock:^(HJVideoPlayTimeRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.url isEqualToString:url]) {
            record = obj;
            * stop = YES;
        }
    }];
    
    return record;
}


- (void)record:(HJVideoPlayTimeRecord *)record{
    
    if (![self.playRecords containsObject:record]) {
        if (self.playRecords.count == self.maxRecordCount && self.playRecords.count != 0) {
            [self.playRecords removeObjectAtIndex:0];
        }
        [self.playRecords addObject:record];
    }
}


- (void)removeRecord:(HJVideoPlayTimeRecord *)record{
    
    if ([self.playRecords containsObject:record]) {
        [self.playRecords removeObject:record];
    }
}

- (void)removeAllPlayRecords{
    
    [self.playRecords removeAllObjects];
}
@end
