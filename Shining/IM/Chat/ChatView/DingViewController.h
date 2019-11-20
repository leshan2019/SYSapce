//
//  DingViewController.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DingViewController : UIViewController

- (instancetype)initWithConversationId:(NSString *)aConversationId
                                    to:(NSString *)aTo
                              chatType:(EMChatType)aChatType
                      finishCompletion:(void (^)(EMMessage *aMessage))aCompletion;

@end

NS_ASSUME_NONNULL_END
