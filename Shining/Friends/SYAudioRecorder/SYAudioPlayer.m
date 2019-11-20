//
//  SYAudioPlayer.m
//  Shining
//
//  Created by letv_lzb on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "SYAudioPlayItem.h"

@interface SYAudioPlayer ()

@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)NSArray *urls;
@property (nonatomic, strong)NSMutableArray *playItemList;
@property (nonatomic, assign)NSTimeInterval seekTime;

@property (nonatomic, assign)NSInteger curItemIndex;
@property (nonatomic, strong)id timeObserver;

/**
 * 播放进度祥光
 */
@property (nonatomic, assign)NSTimeInterval duration;
@property (nonatomic, assign)NSTimeInterval playableDuration;
@property (nonatomic, assign)NSTimeInterval playbackTime;

@property (nonatomic, copy)SYAudioPlayerCallBack playerCallBack;

@end

@implementation SYAudioPlayer

- (id)initWithUrls:(NSArray *)urls seekDuration:(NSTimeInterval)seekTime duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        self.urls = urls;
        self.seekTime = seekTime;
        self.duration = duration;
        [self setup];
    }
    return self;
}


- (id)initWithUrls:(NSArray *)urls seekDuration:(NSTimeInterval)seekTime duration:(NSTimeInterval)duration playerCallBack:(SYAudioPlayerCallBack)callBack {
    self = [self initWithUrls:urls seekDuration:seekTime duration:duration];
    if (self) {
        self.playerCallBack = callBack;
    }
    return self;
}

- (void)setPlayerCallBack:(SYAudioPlayerCallBack)callBack {
    _playerCallBack = callBack;
}


/**
 * 加载播放器
 */
- (void)setup
{
    __weak typeof(self) weakSelf = self;
    [_urls enumerateObjectsUsingBlock:^(id  _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
            SYAudioPlayItem *item = [[SYAudioPlayItem alloc] initWithUrl:url audioType:SYAudioTypeOnline];
            item.itemIndex = idx;
            [weakSelf.playItemList addObject:item];
        }else {
            SYAudioPlayItem *item = [[SYAudioPlayItem alloc] initWithUrl:url audioType:SYAudioTypeFile];
            item.itemIndex = idx;
            [weakSelf.playItemList addObject:item];
        }
    }];
    self.curItemIndex = 0;
    if (_player == nil) {
        SYAudioPlayItem *item = [self.playItemList objectAtIndex:self.curItemIndex];
        //通过AVPlayerItem初始化player
        _player = [[AVPlayer alloc] initWithPlayerItem:item.item];
    }
    [self addNotificatin];
    [self addTimeObserver];
}


/**
 * add 播放item 播放状态、缓存、进度等 kvo
 */
- (void)addNotificatin {
    //KVO监听播放状态
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //KVO监听音乐缓冲状态
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

/**
 * remove player.currentItem observer
 */
- (void)removeNotification {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

/**
 * 添加time 进度
 *
 */
- (void)addTimeObserver {
    if (self.timeObserver) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.timeObserver =  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        weakSelf.playbackTime = current;
        //总时间
        float total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        if (weakSelf.duration != total) {
            weakSelf.duration = total;
        }
        if (weakSelf.playerCallBack) {
            weakSelf.playerCallBack(SYAudioPlayStatusPlaying,weakSelf.playbackTime,weakSelf.duration,@"");
        }
//        if (current) {
//            float progress = current / total;
            //更新播放进度条
            //            weakSelf.playSlider.value = progress;
            //            weakSelf.currentTime.text = [weakSelf timeFormatted:current];
//        }
    }];
}


/**
 * 删除 timeObserver
 *
 */
- (void)removeTimeObserver {
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

- (void)playFinished:(id)object {
    if (self.isAutomaticPlayNext) {
        if (![self next]){
            [self stop];
        }
    }else{
        [self pause];
        if (self.playerCallBack) {
            self.playerCallBack(SYAudioPlayStatusFinish,self.playbackTime,self.duration,@"");
        }
    }
}

//观察者回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //注意这里查看的是self.player.status属性
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
            {
                NSLog(@"未知转态");
                if (self.playerCallBack) {
                    self.playerCallBack(SYAudioPlayStatusPrepare,self.playbackTime,self.duration,@"");
                }
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                float total = CMTimeGetSeconds(self.player.currentItem.duration);
                self.duration = total;
                if (self.playerCallBack) {
                    self.playerCallBack(SYAudioPlayStatusPrepare,self.playbackTime,self.duration,@"");
                }
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"加载失败");
                if (self.playerCallBack) {
                    self.playerCallBack(SYAudioPlayStatusError,self.playbackTime,self.duration,@"加载失败");
                }
            }
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {

        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        NSLog(@"totalloadTime = %f",totalLoadTime);
        self.playableDuration = totalLoadTime;

        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        self.duration = duration;
//        if (self.playerCallBack) {
//            self.playerCallBack(SYAudioPlayStatusPlaying,self.playbackTime,self.duration,@"");
//        }
        //计算缓冲百分比例
//        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
//        self.loadTimeProgress.progress = scale;
    }
}

- (NSMutableArray *)playItemList
{
    if (!_playItemList) {
        _playItemList = [[NSMutableArray alloc] init];
    }
    return _playItemList;
}

- (void)play
{
    if (self.player) {
        [self.player play];
    }
    if (self.playerCallBack && self.player) {
        self.playerCallBack(SYAudioPlayStatusPlaying,self.playbackTime,self.duration,@"");
    }

}

- (void)rePLay {
    if (self.player) {
        [self seek:0];
        [self.player play];
    }
}

- (void)pause
{
    if (self.player) {
        [self.player pause];
    }
    if (self.playerCallBack && self.player) {
        self.playerCallBack(SYAudioPlayStatusPause,self.playbackTime,self.duration,@"");
    }
}

- (BOOL)next
{
    if (self.curItemIndex < self.playItemList.count - 1) {
        self.curItemIndex += 1;
        SYAudioPlayItem *item = [self.playItemList objectAtIndex:self.curItemIndex];
        [self removeNotification];
        [self removeTimeObserver];
        //替换当前音乐资源
        [self.player replaceCurrentItemWithPlayerItem:item.item];

        [self addNotificatin];
        [self addTimeObserver];
        return YES;
    }
    return NO;
}

- (BOOL)previous
{
    if (self.curItemIndex > 0
        && self.curItemIndex < self.playItemList.count - 1) {
        self.curItemIndex -= 1;
        SYAudioPlayItem *item = [self.playItemList objectAtIndex:self.curItemIndex];
        [self removeNotification];
        [self removeTimeObserver];
        //替换当前音乐资源
        [self.player replaceCurrentItemWithPlayerItem:item.item];

        [self addNotificatin];
        [self addTimeObserver];
        return YES;
    }
    return NO;
}

- (void)stop
{
    if (self.player) {
        [self.player pause];
        [self removeNotification];
        [self removeTimeObserver];
        self.player = nil;
        [self.playItemList removeAllObjects];
    }
    if (self.playerCallBack) {
        self.playerCallBack(SYAudioPlayStatusFinish,self.playbackTime,self.duration,@"");
    }
    if (self.playerCallBack) {
        self.playerCallBack(SYAudioPlayStatusFinish,self.playbackTime,self.duration,@"");
    }
}

- (void)seek:(NSTimeInterval)time
{
    //跳转到当前指定时间
    if (self.player) {
        [self.player seekToTime:CMTimeMake(time, 1)];
    }
}

- (void)dealloc
{
    self.urls = nil;
    [self.playItemList removeAllObjects];
    self.playItemList = nil;
}

@end
