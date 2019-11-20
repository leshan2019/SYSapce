//
//  SYVoiceRoomBossView.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomBossViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomBossViewDelegate <NSObject>

- (void)voiceRoomBossViewDidClicked;

@end

@interface SYVoiceRoomBossView : UIView

@property (nonatomic, weak) id <SYVoiceRoomBossViewDelegate> delegate;

- (void)showWithBossViewModel:(SYVoiceRoomBossViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
