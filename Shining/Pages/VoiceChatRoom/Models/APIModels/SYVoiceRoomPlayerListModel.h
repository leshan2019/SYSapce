//
//  SYVoiceRoomPlayerListModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomPlayerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomPlayerListModel : NSObject

@property (nonatomic, strong) NSArray *jockeyList; // 主持人list
@property (nonatomic, strong) NSArray *playList; // 麦上人list
@property (nonatomic, strong) NSArray *waitList; // 排麦list

@end

NS_ASSUME_NONNULL_END
