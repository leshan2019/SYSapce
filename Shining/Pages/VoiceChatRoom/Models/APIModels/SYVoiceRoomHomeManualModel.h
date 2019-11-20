//
//  SYVoiceRoomHomeManualModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomHomeManualModel : NSObject

@property (nonatomic, strong) SYChatRoomModel *roomInfo;
@property (nonatomic, assign) NSInteger posId;

@end

NS_ASSUME_NONNULL_END
