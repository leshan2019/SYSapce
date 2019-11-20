//
//  SYVoiceRoomRedpacketCell.h
//  Shining
//
//  Created by yangxuan on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYRoomRedpacketState_Can_Get,       // 可以领取了
    SYRoomRedpacketState_Cannot_Get     // 时间未到，不可以领取
} SYRoomRedpacketState;

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomRedpacketCellDelegate <NSObject>

// 领取红包
- (void)SYVoiceRoomRedpackeCellClickGetBtn:(id)model;

// 获取数据开始刷新listView开始计时的时间
- (NSInteger)hasPassedTime;

@end

@interface SYVoiceRoomRedpacketCell : UICollectionViewCell

@property (nonatomic, weak) id <SYVoiceRoomRedpacketCellDelegate> delegate;

- (void)configueModel:(id)model;

- (void)releaseTimer;

@end

NS_ASSUME_NONNULL_END
