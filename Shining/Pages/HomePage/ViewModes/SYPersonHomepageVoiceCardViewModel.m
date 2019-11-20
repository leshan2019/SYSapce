//
//  SYPersonHomepageVoiceCardViewModel.m
//  Shining
//
//  Created by leeco on 2019/10/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVoiceCardViewModel.h"
#import "SYAPPServiceAPI.h"
#import "SYUserServiceAPI.h"
#import "SYVoiceCardWordModel.h"
#import "SYVoiceCardSoundResultModel.h"
@interface SYPersonHomepageVoiceCardViewModel ()
@property(nonatomic,strong)NSArray<SYVoiceCardWordModel*>*wordsList;
@property(nonatomic,strong)NSArray<SYVoiceCardSoundResultModel*>*searchResultModel;
@property(nonatomic,strong)NSArray*categoryArr;
@property(nonatomic,strong)SYVoiceCardWordModel * currentWord;
@property(nonatomic,strong)SYMyVoiceCardSoundModel * myVoiceCard;
@end
@implementation SYPersonHomepageVoiceCardViewModel
-(SYVoiceCardWordModel*)changeCurrentWord{
    NSInteger i = arc4random()%self.wordsList.count;
    self.currentWord = self.wordsList [i];
    return self.currentWord;
}
- (void)setNewCurrentWord:(SYVoiceCardWordModel *)word{
    self.currentWord = word;
}
- (NSArray *)getCategorysNames{
    return self.categoryArr;
}
- (NSString *)getCurrentWordId{
    return self.currentWord.id;
}
-(NSArray*)getSeletedCategoryArrayWithName:(NSString*)title{
    NSMutableArray*result = @[].mutableCopy;
    for (SYVoiceCardWordModel *wordModel in self.wordsList) {
        if ([wordModel.category isEqualToString:title]) {
            [result addObject:wordModel];
        }
    }
    return result;
}

// 上传录音文件
- (void)requestUploadVoice:(NSString *)voiceUrl duration:(NSInteger)duration success:(nonnull uploadVoiceSuccess)result {
    
    if ([NSString sy_isBlankString:voiceUrl]) {
        result(NO);
        return;
    }
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];

    NSString *photo1 = userInfo.photo_imgurl1;
    NSString *photo2 = userInfo.photo_imgurl2;
    NSString *photo3 = userInfo.photo_imgurl3;
    NSData *voiceData = [NSData dataWithContentsOfFile:voiceUrl];
    [[SYUserServiceAPI sharedInstance] requestUpdateUserExtraInfoWithPhotoUrl1:photo1 photoData1:[NSData data] photoUrl2:photo2 photoData2:[NSData data] photoUrl3:photo3 photoData3:[NSData data] voiceUrl:@"" voiceData:voiceData voiceDuration:duration success:^(BOOL success) {
        result(success);
    }];
}
//声鉴题词版
-(void)requestVoiceCardWordsListWithBlock:(void(^)(BOOL))block{
    [[SYAPPServiceAPI sharedInstance] requestVoiceCardWordsListWithSuccess:^(id  _Nullable response) {
        NSLog(@"%@",response);
        SYVoiceCardWordsListModel*wordsListModel = [SYVoiceCardWordsListModel yy_modelWithDictionary:response];
        self.wordsList = wordsListModel.word_list;
        NSMutableArray*titleArr = @[].mutableCopy;
        for (SYVoiceCardWordModel *wordModel in wordsListModel.word_list) {
            NSString *category = wordModel.category;
            if (![titleArr containsObject:category]) {
                [titleArr addObject:category];
            }
            self.categoryArr = titleArr;
        }
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
//提交声鉴
-(void)uploadVoiceCardWithWordId:(NSString*)wordid withBlock:(void(^)(BOOL))block{
    [[SYAPPServiceAPI sharedInstance] uploadVoiceCardWithWordId:wordid Success:^(id  _Nullable response) {
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
- (NSArray *)getSoundTypeArr{
    return self.searchResultModel;
}
//查询声鉴结果
-(void)requestVoiceCardResultWithBlock:(void(^)(BOOL))block{
    [[SYAPPServiceAPI sharedInstance] requestVoiceCardResultWithSuccess:^(id  _Nullable response) {
        SYMyVoiceCardSoundModel*model = [SYMyVoiceCardSoundModel yy_modelWithDictionary:response];
        self.searchResultModel = [model.soundtone_list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            SYVoiceCardSoundResultModel *model1 = (SYVoiceCardSoundResultModel *)obj1;
            SYVoiceCardSoundResultModel *model2 = (SYVoiceCardSoundResultModel *)obj2;
            if (model1.score < model2.score) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
//声鉴个人名片（增加userid可查询他人）
-(void)requestVoiceCardWithUserId:(NSString *)userid withBlock:(void (^)(BOOL))block{
    [[SYAPPServiceAPI sharedInstance] requestVoiceCardWithUserId:userid Success:^(id  _Nullable response) {
        SYMyVoiceCardSoundModel*voiceCard = [SYMyVoiceCardSoundModel yy_modelWithDictionary:response];
        self.myVoiceCard = voiceCard;
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
- (void)refreshUserInfo:(void (^)(BOOL))block{
    [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
        if (block) {
            block(YES);
        }
    }];
}
- (id)getMyVoiceCardData{
    return self.myVoiceCard;
}
//用户匹配
-(void)matchVoiceCardOtherUser{
    
}
@end
