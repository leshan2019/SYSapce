//
//  SYPersonHomepageEditViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageEditViewModel.h"
#import "SYUserServiceAPI.h"

@interface SYPersonHomepageEditViewModel ()

@property (nonatomic, strong) UserProfileEntity *userModel;
@property (nonatomic, strong) SYUserAttentionModel *attentionModel;     // 用户关注和粉丝model

@end

@implementation SYPersonHomepageEditViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userModel = [UserProfileEntity getUserProfileEntity];
        self.attentionModel = nil;
    }
    return self;
}

#pragma mark - 网络请求

- (void)requestHomepageData:(getHomepageDataSuccess)result {
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
        weakSelf.userModel = [UserProfileEntity getUserProfileEntity];
        result(success);
    }];
}

// 请求用户粉丝和关注数
- (void)requestHomepageUserAttentionAndFansCount:(getHomepageDataSuccess)result {
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestUserAttentionAndFansCountWithUserid:self.userModel.userid success:^(id  _Nullable response) {
        SYUserAttentionModel *attentionModel = (SYUserAttentionModel *)response;
        weakSelf.attentionModel = attentionModel;
        if (attentionModel) {
            result(YES);
        } else {
            result(NO);
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.attentionModel = nil;
        result(NO);
    }];
}

// 上传形象照
- (void)requestUploadPhoto:(UIImage *)photo success:(uploadPhotoSuccess)result {
    if (photo) {
        NSData *imageData = UIImageJPEGRepresentation(photo, 1.0f);
        NSString *photo1 = self.userModel.photo_imgurl1;
        NSString *photo2 = self.userModel.photo_imgurl2;
        NSString *photo3 = self.userModel.photo_imgurl3;
        NSData *photoData1 = [NSData data];
        NSData *photoData2 = [NSData data];
        NSData *photoData3 = [NSData data];
        if ([NSString sy_isBlankString:photo1]) {
            photoData1 = imageData;
        } else if ([NSString sy_isBlankString:photo2]) {
            photoData2 = imageData;
        } else if ([NSString sy_isBlankString:photo3]) {
            photoData3 = imageData;
        }
        [[SYUserServiceAPI sharedInstance] requestUpdateUserExtraInfoWithPhotoUrl1:photo1 photoData1:photoData1 photoUrl2:photo2 photoData2:photoData2 photoUrl3:photo3 photoData3:photoData3 voiceUrl:self.userModel.voice_url voiceData:[NSData data] voiceDuration:self.userModel.voice_duration success:^(BOOL success) {
            result(success);
        }];
    } else {
        result(NO);
    }
}

// 删除形象照
- (void)requestDeletePhoto:(SYHomepagePhotoType)type success:(deletePhotoSuccess)result {
    if (type == SYHomepagePhotoType_Unknown) {
        result(NO);
        return;
    }
    NSString *photo1 = self.userModel.photo_imgurl1;
    NSString *photo2 = self.userModel.photo_imgurl2;
    NSString *photo3 = self.userModel.photo_imgurl3;
    NSData *photoData1 = [NSData data];
    NSData *photoData2 = [NSData data];
    NSData *photoData3 = [NSData data];
    if (type == SYHomepagePhotoType_First) {
        photo1 = @"";
    } else if (type == SYHomepagePhotoType_Second) {
        photo2 = @"";
    } else if (type == SYHomepagePhotoType_Third) {
        photo3 = @"";
    }
    [[SYUserServiceAPI sharedInstance] requestUpdateUserExtraInfoWithPhotoUrl1:photo1 photoData1:photoData1 photoUrl2:photo2 photoData2:photoData2 photoUrl3:photo3 photoData3:photoData3 voiceUrl:self.userModel.voice_url voiceData:[NSData data] voiceDuration:self.userModel.voice_duration success:^(BOOL success) {
        result(success);
    }];
}

// 上传录音文件
- (void)requestUploadVoice:(NSString *)voiceUrl duration:(NSInteger)duration success:(nonnull uploadVoiceSuccess)result {
    if ([NSString sy_isBlankString:voiceUrl]) {
        result(NO);
        return;
    }
    NSString *photo1 = self.userModel.photo_imgurl1;
    NSString *photo2 = self.userModel.photo_imgurl2;
    NSString *photo3 = self.userModel.photo_imgurl3;
    NSData *voiceData = [NSData dataWithContentsOfFile:voiceUrl];
    [[SYUserServiceAPI sharedInstance] requestUpdateUserExtraInfoWithPhotoUrl1:photo1 photoData1:[NSData data] photoUrl2:photo2 photoData2:[NSData data] photoUrl3:photo3 photoData3:[NSData data] voiceUrl:@"" voiceData:voiceData voiceDuration:duration success:^(BOOL success) {
        result(success);
    }];
}

// 删除录音文件
- (void)requestDeleteVoice:(deleteVoiceSuccess)result {
    NSString *photo1 = self.userModel.photo_imgurl1;
    NSString *photo2 = self.userModel.photo_imgurl2;
    NSString *photo3 = self.userModel.photo_imgurl3;
    [[SYUserServiceAPI sharedInstance] requestUpdateUserExtraInfoWithPhotoUrl1:photo1 photoData1:[NSData data] photoUrl2:photo2 photoData2:[NSData data] photoUrl3:photo3 photoData3:[NSData data] voiceUrl:@"" voiceData:[NSData data] voiceDuration:0 success:^(BOOL success) {
        result(success);
    }];
}

#pragma mark - 提供数据

- (UserProfileEntity *)getHomepageUserModel {
    return self.userModel;
}

// 关注数
- (NSInteger)getUserAttentionCount {
    if (self.attentionModel) {
        return self.attentionModel.concern_total;
    }
    return 0;
}

// 粉丝数
- (NSInteger)getUserFansCount {
    if (self.attentionModel) {
        return self.attentionModel.fans_total;
    }
    return 0;
}

- (NSString *)getVoiceUrl {
    if (self.userModel) {
        return self.userModel.voice_url;
    }
    return @"";
}

- (NSInteger)getVoiceDuration {
    if (self.userModel) {
        return self.userModel.voice_duration;
    }
    return 0;
}

@end
