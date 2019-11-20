//
//  SYVoiceRoomPropCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomPropCell : UICollectionViewCell

- (void)showWithIcon:(NSString *)icon;

- (void)setDefaultPrice:(NSInteger)price durationTime:(NSString *)durationTime;
- (void)setVipLevel:(NSInteger)vipLevel durationTime:(NSString *)durationTime;
- (void)setIsInUseWithExpireTime:(NSString *)expireTime;
- (void)setIsMineWithExpireTime:(NSString *)expireTime;

@end

NS_ASSUME_NONNULL_END
