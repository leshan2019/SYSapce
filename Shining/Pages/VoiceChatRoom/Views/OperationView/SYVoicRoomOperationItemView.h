//
//  SYVoicRoomOperationItemView.h
//  Shining
//
//  Created by 杨玄 on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomOperationViewModel.h"

typedef void(^operationClick)(SYVoiceRoomOperationViewModel * _Nullable model);

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天室 - 单个横滑view
 */
@interface SYVoicRoomOperationItemView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                    withItems:(NSArray *)items
               withClickBlock:(operationClick)click;

@end

NS_ASSUME_NONNULL_END
