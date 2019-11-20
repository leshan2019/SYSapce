//
//  SYVoiceRoomSendRedpacketVC.h
//  Shining
//
//  Created by yangxuan on 2019/9/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomSendRedpacketVC : UIViewController

@property (nonatomic, copy) void (^sendSuccess)(BOOL needOverScreen);

@property (nonatomic, strong) NSString *roomId;

@end

NS_ASSUME_NONNULL_END
