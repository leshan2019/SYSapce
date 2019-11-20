//
//  SYPersonHomepageVoiceCardVC.h
//  Shining
//
//  Created by leeco on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSInteger {
    VoiceCardVCState_self_alloc, //创建新名片
    VoiceCardVCState_self_show,  //展示已创建的名片
    VoiceCardVCState_other_show  //展示他人的名片
    
} VoiceCardVCState;
@interface SYPersonHomepageVoiceCardVC : UIViewController
- (instancetype)initWithUserid:(NSString* )userid;
@end

NS_ASSUME_NONNULL_END
