//
//  SYVoiceChatRoomRenameVC.h
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  房间信息 - 房间名称VC
 */
@interface SYVoiceChatRoomRenameVC : UIViewController

// 上一级页面传过来的原始的房间名
@property (nonatomic, copy) NSString *originRoomName;
@property (nonatomic, copy) NSString *channelId;

@end

NS_ASSUME_NONNULL_END
