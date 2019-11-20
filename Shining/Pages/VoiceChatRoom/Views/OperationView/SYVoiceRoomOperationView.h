//
//  SYVoiceRoomOperationView.h
//  Shining
//
//  Created by 杨玄 on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoicRoomOperationItemView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天室 - 运营位view
 */
@interface SYVoiceRoomOperationView : UIView

// initWithClickBlock
- (instancetype)initWithFrame:(CGRect)frame clickBlock:(operationClick)clickBlock;

// updateData
- (void)updateOperationDatas:(NSArray *)datas;

@end

NS_ASSUME_NONNULL_END
