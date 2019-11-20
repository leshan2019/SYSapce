//
//  SYVoiceCardSoundResultModel.h
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYVoiceCardSoundResultModel;
NS_ASSUME_NONNULL_BEGIN
@interface SYMyVoiceCardSoundModel : NSObject<YYModel>
@property(nonatomic,strong)NSString*userid;
@property(nonatomic,strong)NSString*username;
@property(nonatomic,strong)NSString*em_username; //环信用户名
@property(nonatomic,strong)NSString*avatar_imgurl;
@property(nonatomic,strong)NSString*voice_url;
@property(nonatomic,assign)BOOL is_concern;
@property(nonatomic,strong)NSString*background_imgurl;
@property(nonatomic,strong)NSString*soundtone_word;
@property(nonatomic,strong)NSArray<SYVoiceCardSoundResultModel*>*soundtone_list;
@end
@interface SYVoiceCardSoundResultModel : NSObject<YYModel>
@property(nonatomic,assign)NSInteger score;
@property(nonatomic,strong)NSString*sound_type;
@end

NS_ASSUME_NONNULL_END
