//
//  SYVoiceChatRoomPasswordVC.h
//  Shining
//
//  Created by 杨玄 on 2019/4/17.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomPasswordVC : UIViewController

// 上一级页面传过来的原始的房间密码
@property (nonatomic, copy) NSString *originPassword;
@property (nonatomic, copy) NSString *channelId;

@end

NS_ASSUME_NONNULL_END
