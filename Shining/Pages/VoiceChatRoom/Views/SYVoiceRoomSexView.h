//
//  SYVoiceRoomSexView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomSexView : UIView

- (void)setSex:(BOOL)isGirl
           age:(NSInteger)age;
/**
 *  Bee语音SDK使用
 *  sexString: @"male", @"female", @"unknown"
 */
- (void)setSex:(NSString *)sexString
        andAge:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
