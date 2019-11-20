//
//  SYVoiceRoomMusicCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomMusicCell : UITableViewCell

- (void)showWithTitle:(NSString *)title
             fileSize:(long long)fileSize
            isPlaying:(BOOL)isPlaying;

@end

NS_ASSUME_NONNULL_END
