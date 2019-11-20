//
//  SYVoiceRoomHomeListModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomListModel.h"
#import "SYVoiceRoomHomeManualModel.h"
#import "SYVoiceRoomHomeFocusModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomHomeListModel : NSObject

@property (nonatomic, strong) NSArray *focus;
@property (nonatomic, strong) NSArray *maunal;
@property (nonatomic, strong) SYVoiceRoomListModel *page;

@end

NS_ASSUME_NONNULL_END
