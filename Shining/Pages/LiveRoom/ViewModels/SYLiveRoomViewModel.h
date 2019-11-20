//
//  SYLiveRoomViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomViewModel : NSObject

- (instancetype)initWithChannelID:(NSString *)channelID
                         password:(NSString *)password;

- (void)startProcess;

@end

NS_ASSUME_NONNULL_END
