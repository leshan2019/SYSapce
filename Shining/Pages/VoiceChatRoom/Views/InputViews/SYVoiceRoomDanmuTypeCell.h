//
//  SYVoiceRoomDanmuTypeCell.h
//  Shining
//
//  Created by 杨玄 on 2019/4/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYVoiceRoomDanmuType_Unknown    = 0,    // 未定义
    SYVoiceRoomDanmuType_Normal     = 1,    // 普通弹幕
    SYVoiceRoomDanmuType_Colorful   = 2,    // 炫彩弹幕
    SYVoiceRoomDanmuType_Vip        = 3,    // Vip弹幕
} SYVoiceRoomDanmuType;

NS_ASSUME_NONNULL_BEGIN

/**
 * 聊天室 - 弹幕类型cell
 */
@interface SYVoiceRoomDanmuTypeCell : UICollectionViewCell

/**
 *  更新弹幕显示文本
 */
- (void)updateDanmuTypeCellWithName:(NSString *)name withPrice:(NSInteger)price;

/**
 *  更新弹幕选中状态
 */
- (void)updateDanmuTypeCellSelectState:(BOOL)selected withVipDanmu:(BOOL)vip canBeSend:(BOOL)canBeSend vipLevel:(NSInteger)vipLevel;

@end

NS_ASSUME_NONNULL_END
