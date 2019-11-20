//
//  SYAudioPlayItem.m
//  Shining
//
//  Created by letv_lzb on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYAudioPlayItem.h"

@implementation SYAudioPlayItem

- (id)initWithUrl:(NSString *)url audioType:(SYAudioType)type
{
    self = [super init];
    if (self) {
        self.url = url;
        self.audioType = type;
        [self setup];
    }
    return self;
}

- (void)setup
{
    if (self.audioType == SYAudioTypeOnline) {
        self.item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.url]];
    }else{
        self.item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.url]];
    }
}

@end
