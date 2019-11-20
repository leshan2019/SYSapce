//
//  SYVoiceMatchUserModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYSoundtoneModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceMatchUserModel : NSObject
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *em_username;
@property(nonatomic,strong)NSString *avatar_imgurl;
@property(nonatomic,strong)NSString *voice_url;
@property(nonatomic,strong)NSString *is_concern;
@property(nonatomic,strong)NSString *background_imgurl;
@property(nonatomic,strong)NSString *soundtone_word;
@property(nonatomic,strong)NSArray *soundtone_list;
@end

NS_ASSUME_NONNULL_END
