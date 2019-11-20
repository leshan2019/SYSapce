//
//  SYPopBeeview.h
//  Shining
//
//  Created by leeco on 2019/8/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYGiftListModel.h"
NS_ASSUME_NONNULL_BEGIN

// 采蜜说明
@interface PopBeeExplainview : UIView

@end

// 当前游戏获得礼物
@interface PopBeeCurrentGiftview : UIView

@property (nonatomic, strong)SYGiftListModel *giftListModel;

@end

NS_ASSUME_NONNULL_END
