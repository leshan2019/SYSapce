//
//  SYVoiceRoomBossPopView.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomBossViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomBossPopViewDelegate <NSObject>

- (void)voiceRoomBossPopViewDidShowGift;
- (void)voiceRoomBossPopViewDidShowPersonPageWithUid:(NSString *)uid;

@end

@interface SYVoiceRoomBossPopView : UIView

@property (nonatomic, weak) id <SYVoiceRoomBossPopViewDelegate> delegate;

- (void)showWithBossViewModel:(SYVoiceRoomBossViewModel *)viewModel;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
