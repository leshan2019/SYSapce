//
//  ChatViewController.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "EaseMessageViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天页面
 */
@interface SYChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

// 此vc被用于"私信"功能
@property (nonatomic, assign) BOOL usedByPrivateMessage;

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;


- (instancetype)initWithUserProfileEntity:(UserProfileEntity *)userInfo;
@end

NS_ASSUME_NONNULL_END
