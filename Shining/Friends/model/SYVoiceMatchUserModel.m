//
//  SYVoiceMatchUserModel.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceMatchUserModel.h"

@implementation SYVoiceMatchUserModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"soundtone_list": [SYSoundtoneModel class]};
}
@end
