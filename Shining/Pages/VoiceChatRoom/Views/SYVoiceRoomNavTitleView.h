//
//  SYVoiceRoomNavTitleView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomNavTitleView : UIView

- (void)setTitle:(NSString *)title
            type:(NSString *)type
          roomID:(NSString *)roomID
             hot:(NSString *)hot;

- (void)updateHot:(NSInteger)hot;

@end

NS_ASSUME_NONNULL_END
