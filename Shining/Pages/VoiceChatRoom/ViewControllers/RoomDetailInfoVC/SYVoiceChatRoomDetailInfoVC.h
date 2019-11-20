//
//  SYVoiceChatRoomInfoVC.h
//  Shining
//
//  Created by 杨玄 on 2019/3/12.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomInfoChangeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  房间信息VC
 */
@interface SYVoiceChatRoomDetailInfoVC : UIViewController

@property (nonatomic, weak) id <SYVoiceRoomInfoChangeProtocol> delegate;

@property (nonatomic, copy) NSString *channelId;    // 房间Id
@property (nonatomic, assign) BOOL isRoomOwner;     // 房主
@property (nonatomic, assign) BOOL isLiving;        // 是否是直播
@property (nonatomic, copy) NSString *selectRoomBackDropimage; // 当前的房间背景图

@end

NS_ASSUME_NONNULL_END
