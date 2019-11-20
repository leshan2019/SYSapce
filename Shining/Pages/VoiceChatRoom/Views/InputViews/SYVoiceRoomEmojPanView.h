//
//  SYVoiceRoomEmojPanView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomEmojPanView : UIView

@property (nonatomic, copy) void(^emojBlock)(NSString *emoj);

@end

NS_ASSUME_NONNULL_END
