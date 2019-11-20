//
//  SYLiveRoomBossView.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomBossView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomBossView : UIView

@property (nonatomic, weak) id <SYVoiceRoomBossViewDelegate> delegate;

- (void)showWithBossViewModel:(SYVoiceRoomBossViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
