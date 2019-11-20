//
//  SYSearchUserViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/9/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSearchUserViewModel.h"
#import "SYAPPServiceAPI.h"

@interface SYSearchUserViewModel ()

@property (nonatomic, strong) NSArray *searchResultArr;

@end

@implementation SYSearchUserViewModel

- (void)searchUserByKeyword:(NSString *)keyword success:(SearchBlock)success {
    [[SYAPPServiceAPI sharedInstance] requestSearchUserWithKeyword:keyword success:^(id  _Nullable response) {
        self.searchResultArr = (NSArray *)response;
        if (self.searchResultArr && self.searchResultArr.count > 0) {
            success(YES);
        } else {
            success(NO);
        }
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}

- (NSInteger)numberOfRows {
    if (self.searchResultArr) {
        return self.searchResultArr.count;
    }
    return 0;
}

- (NSString *)headUrl:(NSIndexPath *)indexPath {
    UserProfileEntity *model = [self userModel:indexPath];
    return model.avatar_imgurl;
}
- (NSString *)name:(NSIndexPath *)indexPath {
    UserProfileEntity *model = [self userModel:indexPath];
    return model.username;
}
- (NSString *)gender:(NSIndexPath *)indexPath {
    UserProfileEntity *model = [self userModel:indexPath];
    return model.gender;
}
- (NSInteger)age:(NSIndexPath *)indexPath {
    UserProfileEntity *model = [self userModel:indexPath];
    return [SYUtil ageWithBirthdayString:model.birthday];
}
- (NSString *)userId:(NSIndexPath *)indexPath {
    UserProfileEntity *model = [self userModel:indexPath];
    return model.userid;
}
- (NSString *)bestId:(NSIndexPath *)indexPath {
    UserProfileEntity *model = [self userModel:indexPath];
    return model.bestid;
}
- (NSInteger)level:(NSIndexPath *)indexPath {
    UserProfileEntity *model = [self userModel:indexPath];
    return model.level;
}

- (UserProfileEntity *)userModel:(NSIndexPath *)indexPath {
    if (self.searchResultArr) {
        return (UserProfileEntity *)[self.searchResultArr objectAtIndex:indexPath.item];
    }
    return nil;
}
@end
