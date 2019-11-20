//
//  SYPersonHomepageEnterRoomView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/24.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页 - 进入房间
 */
@interface SYPersonHomepageEnterRoomView : UIButton

- (void)updateHomepageEnterRoomViewWithRoomIcon:(NSString *)roomIcon
                                       roomName:(NSString *)roomName;

// 动画
- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
