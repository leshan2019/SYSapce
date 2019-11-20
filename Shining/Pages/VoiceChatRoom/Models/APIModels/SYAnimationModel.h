//
//  SYAnimationModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/30.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomUser.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SYAnimationType) {
    SYAnimationType_Unknown,
    SYAnimationType_Gift,                     //礼物
    SYAnimationType_Driver                    //座驾
};

@interface SYAnimationModel : NSObject
@property(nonatomic,assign)SYAnimationType animationType;
@property(nonatomic,assign)NSInteger animationId;
@property(nonatomic,strong)SYVoiceRoomUser *user;   //礼物发送者或者坐骑主人
@property(nonatomic,assign)BOOL isRandomGift;
@property (nonatomic, strong) NSArray *randomGiftArray;
@property(nonatomic,strong)SYVoiceRoomUser *recieverUser;  //礼物接收者
@end

NS_ASSUME_NONNULL_END
