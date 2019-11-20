//
//  SYGamebeeView.h
//  DemobeeOC
//
//  Created by leeco on 2019/8/14.
//  Copyright © 2019 JiangYue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BeeBucketType) {
    
    BeeBucketType_small = 1,
    
    BeeBucketType_middle = 2,
    
    BeeBucketType_big = 3,
    
};

typedef NS_ENUM(NSInteger, BeeBucketColorType) {
    
    BeeBucketColorType_default = 0,
    
    BeeBucketColorType_silvery = 1,
    
    BeeBucketColorType_gold = 2,
    
};

@protocol SYGameBeeViewDelegate <NSObject>
/**
 * 礼物列表
 */
- (void)gameBeeGiftList;

/**
 * 玩法说明
 */
- (void)gameBeeExplain;

/**
 * 进入收银台
 */
- (void)gameBeeInCashierDesk;

/**
 * 开始采蜜
 */
- (void)startBee:(BeeBucketType)beeBucketType;

@end

@interface SYGameBeeView : UIView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SYGameBeeViewDelegate>)delegate;

@property (nonatomic, weak) id <SYGameBeeViewDelegate> delegate;
// 采蜜状态
@property (nonatomic, assign, readonly) BOOL beeStatus;
// 采蜜桶数
@property (nonatomic, assign, readonly) BeeBucketType beeBucketType;
/**
 * 更新蜜豆数量
 */
- (void)stopBeeAnimation;
- (void)updateBeeCoin:(NSInteger )num;
- (NSInteger)getCurrentBucketid;
@end

NS_ASSUME_NONNULL_END
