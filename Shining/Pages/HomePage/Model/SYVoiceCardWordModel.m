//
//  SYVoiceCardWordModel.m
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceCardWordModel.h"
@implementation SYVoiceCardWordsListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"word_list": [SYVoiceCardWordModel class]};
}
@end
@implementation SYVoiceCardWordModel

@end

