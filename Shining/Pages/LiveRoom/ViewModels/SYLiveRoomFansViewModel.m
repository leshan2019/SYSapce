//
//  SYLiveRoomFansViewModel.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansViewModel.h"
#import "SYUserServiceAPI.h"
#import "SYLiveRoomFansViewInfoModel.h"
@interface SYLiveRoomFansViewModel()
@property(nonatomic,strong)SYLiveRoomFansViewInfoModel*infoModel;
@property(nonatomic,strong)SYLiveRoomFansViewMemberListModel*memberListModel;
@property(nonatomic,strong)SYLiveRoomFansViewLevelInfoModel*levelInfoModel;
@end
@implementation SYLiveRoomFansViewModel
- (void)requestFansViewInfoWithUid:(NSString *)uid
                       andAnchorid:(NSString *)anchorid
                             block:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestFansViewInfoWithUid:uid andAnchorid:anchorid success:^(id  _Nullable response) {
        self.infoModel = [SYLiveRoomFansViewInfoModel yy_modelWithDictionary:response];
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
- (void)requestFansViewMemberlistWithAnchorid:(NSString *)anchorid block:(void (^)(BOOL))block{
    [[SYUserServiceAPI sharedInstance] requestFansViewMemberListWithAnchorid:anchorid success:^(id  _Nullable response) {
        self.memberListModel = [SYLiveRoomFansViewMemberListModel yy_modelWithDictionary:response];
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
- (void)openFansRightWithUid:(NSString *)uid
                 andAnchorid:(NSString *)anchorid
                  fansloveid:(NSString *)fansloveid
                   pricetype:(NSString *)pricetype
                       block:(void(^)(BOOL success))block{
    [[SYUserServiceAPI sharedInstance] openFansRightWithUid:uid andAnchorid:anchorid fansloveid:fansloveid pricetype:pricetype success:^(id  _Nullable response) {
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
- (void)requestFansViewLevelWithUid:(NSString *)uid
                        andAnchorid:(NSString *)anchorid
                              block:(void(^)(BOOL success))block{
    [[SYUserServiceAPI sharedInstance] requestFansViewLevelWithUid:uid andAnchorid:anchorid success:^(id  _Nullable response) {
        self.levelInfoModel = [SYLiveRoomFansViewLevelInfoModel yy_modelWithDictionary:response];
        if (block) {
            block(YES);
        }
        
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
- (void)editFansGroupNameWithGroupId:(NSString *)groupId
                         andAnchorid:(NSString *)anchorid
                                name:(NSString *)name
                               block:(void(^)(BOOL success))block{
    [[SYUserServiceAPI sharedInstance] editFansGroupNameWithGroupId:groupId andAnchorid:anchorid name:name success:^(id  _Nullable response) {
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
-(NSInteger)getFansHeaderInfoStatus{
    return [self.infoModel.status integerValue];
}
-(NSArray*)getFansCombo{
    return self.infoModel.pricing_list;
}
-(SYLiveRoomFansViewInfoModel*)getHeaderInfo{
    
    if (self.infoModel) {
        return self.infoModel;
    } else{
        SYLiveRoomFansViewInfoModel*tmpInfoModel = [SYLiveRoomFansViewInfoModel new];
        tmpInfoModel.name = self.memberListModel.name;
        tmpInfoModel.image = self.memberListModel.image;
        return tmpInfoModel;
    }
    
}
-(NSArray*)getComboArr{
    NSMutableArray*arr= @[].mutableCopy;
    for (SYLiveRoomFansViewInfoPricingListModel *tmp in self.infoModel.pricing_list) {
        if (![NSString sy_isBlankString:tmp.name]) {
            [arr addObject:tmp.name];
        }
    }
    return arr;
}
- (NSArray *)getMembersList{
    return self.memberListModel.fans_list;
}
-(NSArray *)getTaskList{
    return self.levelInfoModel.task_list;
}
- (SYLiveRoomFansViewMemberModel *)getUserFansInfo{
    return self.memberListModel.fansinfo;
}
-(NSString*)getFansGroupID{
    return self.infoModel.id;
}
- (SYLiveRoomFansViewLevelInfoModel *)getUserFansLevel{
    return self.levelInfoModel;
}
-(NSString*)getExpiredDate{
    return self.levelInfoModel.expired_time;
}
- (NSString *)host_getGroupScore{
    return self.memberListModel.jifen;
}
@end
