//
//  SYAudioPlayerManager.h
//  Shining
//
//  Created by letv_lzb on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYSigleCase.h"
#import "SYAudioPlayer.h"

NS_ASSUME_NONNULL_BEGIN


@interface SYAudioPlayerManager : NSObject
SYSingleCaseH(SYAudioPlayerManager)

- (void)playVideoWith:(NSArray *)urls isAutoPlay:(BOOL)isAuto callBack:(SYAudioPlayerCallBack)block;

- (void)setup;

@end

NS_ASSUME_NONNULL_END
