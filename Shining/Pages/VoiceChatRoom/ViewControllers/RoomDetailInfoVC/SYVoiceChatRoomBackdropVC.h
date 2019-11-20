//
//  SYVoiceChatRoomBackdropVC.h
//  Shining
//
//  Created by 杨玄 on 2019/4/16.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYVoiceChatRoomBackdropVCDelegate <NSObject>

- (void)SYVoiceChatRoomBackDropVCSelectedRoomBackGroundImageNum:(NSInteger)imageNum;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  房间信息 - 房间背景VC
 */
@interface SYVoiceChatRoomBackdropVC : UIViewController

@property (nonatomic, weak) id<SYVoiceChatRoomBackdropVCDelegate> delegate;

// 房间channelId
@property (nonatomic, copy) NSString *channelId;

// 当前房间背景
@property (nonatomic, assign) NSInteger selectBackdrop;

// 创建房间vc使用
@property (nonatomic, assign) BOOL usedByCreateRoomVC;

@end

NS_ASSUME_NONNULL_END
