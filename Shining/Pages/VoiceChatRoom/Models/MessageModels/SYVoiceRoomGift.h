//
//  SYVoiceRoomGift.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGift : NSObject <YYModel>

@property (nonatomic, assign) NSInteger giftid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSArray *extraGifts; // 随机礼物giftId数组
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger randomGiftId; // 随机礼物id
@property (nonatomic, assign) NSInteger extraPrice; // 飘屏礼物价格
@property (nonatomic, assign) NSInteger nums; // 礼物背包礼物数量；送礼物数量

@end

NS_ASSUME_NONNULL_END
