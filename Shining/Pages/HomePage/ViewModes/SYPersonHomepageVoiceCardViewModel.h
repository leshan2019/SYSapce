//
//  SYPersonHomepageVoiceCardViewModel.h
//  Shining
//
//  Created by leeco on 2019/10/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYVoiceCardWordModel;
@class SYMyVoiceCardSoundModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^uploadVoiceSuccess)(BOOL success);
typedef void(^deleteVoiceSuccess)(BOOL success);
@interface SYPersonHomepageVoiceCardViewModel : NSObject
// 上传录音文件
- (void)requestUploadVoice:(NSString *)voiceUrl duration:(NSInteger)duration success:(nonnull uploadVoiceSuccess)result;
//声鉴题词版
-(void)requestVoiceCardWordsListWithBlock:(void(^)(BOOL))block;
//提交声鉴
-(void)uploadVoiceCardWithWordId:(NSString*)wordid withBlock:(void(^)(BOOL))block;
//查询声鉴结果
-(void)requestVoiceCardResultWithBlock:(void(^)(BOOL))block;
//声鉴个人名片（增加userid可查询他人）
-(void)requestVoiceCardWithUserId:(NSString*)userid withBlock:(void(^)(BOOL))block;
//保存个人声鉴题词版
-(void)saveVoiceCardWithWithWordId:(NSString*)wordid withBlock:(void(^)(BOOL))block;
//用户匹配
-(void)matchVoiceCardOtherUserWithBlock:(void(^)(BOOL))block;
//刷新个人信息
-(void)refreshUserInfo:(void(^)(BOOL))block;
/////////
-(void)setNewCurrentWord:(SYVoiceCardWordModel*)word;
-(SYVoiceCardWordModel*)changeCurrentWord;
-(SYMyVoiceCardSoundModel*)getMyVoiceCardData;
-(NSArray*)getCategorysNames;
-(NSString*)getCurrentWordId;
-(NSArray*)getSeletedCategoryArrayWithName:(NSString*)title;
-(NSArray*)getSoundTypeArr;
@end

NS_ASSUME_NONNULL_END
