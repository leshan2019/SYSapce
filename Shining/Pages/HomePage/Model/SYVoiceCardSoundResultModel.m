//
//  SYVoiceCardSoundResultModel.m
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceCardSoundResultModel.h"

@implementation SYVoiceCardSoundResultModel

@end
@implementation SYMyVoiceCardSoundModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"soundtone_list": [SYVoiceCardSoundResultModel class]};
}

@end
