//
//  SYLiveRoomPlayListVC.h
//  Shining
//
//  Created by mengxiangjian on 2019/11/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYLiveRoomVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomPlayListVC : UIViewController

- (instancetype)initWithChannelIDList:(NSArray <NSString *>*)channelIDList
                     currentChannelID:(NSString *)currentChannelID
                             password:(NSString *)password
                           categoryID:(NSInteger)categoryID;

@property (nonatomic, weak) id <SYVoiceChatRoomVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
