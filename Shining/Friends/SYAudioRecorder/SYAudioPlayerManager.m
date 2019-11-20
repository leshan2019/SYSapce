//
//  SYAudioPlayerManager.m
//  Shining
//
//  Created by letv_lzb on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYAudioPlayerManager.h"
@interface SYAudioPlayerManager ()
@property (nonatomic, strong) SYAudioPlayer *player;
@end

@implementation SYAudioPlayerManager
SYSingleCaseM(SYAudioPlayerManager)

- (void)setup
{
    //一般在方法：application: didFinishLaunchingWithOptions:设置
    //获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //设置类型是播放。
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //激活音频会话。
    [session setActive:YES error:nil];
}

- (void)playVideoWith:(NSArray *)urls isAutoPlay:(BOOL)isAuto callBack:(SYAudioPlayerCallBack)block
{
    if (!_player) {
        _player = [[SYAudioPlayer alloc] initWithUrls:urls seekDuration:0 duration:0];
    }
    [_player play];
    _player.isAutomaticPlayNext = isAuto;
}

@end
