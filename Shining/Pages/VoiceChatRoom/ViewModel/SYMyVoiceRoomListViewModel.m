//
//  SYMyVoiceRoomListViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMyVoiceRoomListViewModel.h"
#import "SYVoiceChatNetManager.h"

@interface SYMyVoiceRoomListViewModel ()

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isReachEnd; // 到底了
@property (nonatomic, strong) SYVoiceRoomUserRightModel *userRightModel;

@end

@implementation SYMyVoiceRoomListViewModel

- (void)requestRoomListWithPage:(NSInteger)page
                          block:(void(^)(BOOL success, BOOL emptyData))block {
    if (self.listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    self.currentPage = page;
    if (self.currentPage ==1 && self.listArray.count>0) {
        [self.listArray removeAllObjects];
    }
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    [netManager requestMyChannelListWithPage:page
                                     success:^(id  _Nullable response) {
                                         if ([response isKindOfClass:[SYVoiceRoomListModel class]]) {
                                             SYVoiceRoomListModel *listModel = (SYVoiceRoomListModel *)response;
                                             self.isReachEnd = (listModel.page >= listModel.pageCount);
                                             
                                             [self.listArray addObjectsFromArray:listModel.data];
                                             if (block) {
                                                 block(YES, [self.listArray count] == 0);
                                             }
                                         }
                                     } failure:^(NSError * _Nullable error) {
                                         if (block) {
                                             block(NO, YES);
                                         }
                                     }];
}

- (void)requestUserRightWithBlock:(void(^)(BOOL))block {
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    [netManager requestUserChannelRightWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYVoiceRoomUserRightModel class]]) {
            self.userRightModel = (SYVoiceRoomUserRightModel *)response;
            if (block) {
                block(YES);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}

- (void)requestUserCreateRoomTypesWithBlock:(void (^)(BOOL living, BOOL voice))block {
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    [netManager requestUserCreateRoomTypeWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSArray class]]) {
            if (block) {
                NSArray *listArr = (NSArray *)response;
                BOOL canCreateLiving = NO;
                BOOL canCreateVoice = NO;
                SYRoomCreateTypeModel *tempModel;
                for (int i = 0; i < listArr.count; i++) {
                    tempModel = [listArr objectAtIndex:i];
                    if (tempModel.id == 2) {            // 直播
                        canCreateLiving = tempModel.can_create == 1;
                    } else if (tempModel.id == 1) {     // 聊天室
                        canCreateVoice = tempModel.can_create == 1;
                    }
                }
                block(canCreateLiving,canCreateVoice);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO,NO);
        }
    }];
}

- (BOOL)canCreateChannel {
    if (self.userRightModel) {
        if (self.userRightModel.canCreateRoomNum >= 0) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)roomListCount {
    return [self.listArray count];
}

- (NSString *)roomNameAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.name;
}

- (NSString *)roomIconAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.icon;
}

- (NSString *)roomDescAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.desc;
}

- (NSString *)roomIdAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.id;
}

- (NSInteger)roomCategoryIdAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.category;
}

- (NSInteger)myRoomRoleAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.role;
}

- (NSInteger)roomUserNumAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.concurrentUser;
}

- (NSInteger)roomTypeAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.type;
}

- (BOOL)isRoomOpenAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return (model.status == 0);
}

- (BOOL)isLastPage {
    return self.isReachEnd;
}
@end
