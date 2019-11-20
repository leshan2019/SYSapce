//
//  SYVideoRoomHomeViewModel.m
//  Shining
//
//  Created by leeco on 2019/9/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRoomHomePageViewModel.h"
#import "SYVoiceChatNetManager.h"
#import "SYVoiceRoomListModel.h"

@interface SYRoomHomePageViewModel ()

@property (nonatomic, strong) NSArray *focusArray;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *listdIdsArray;//房间id数组 去重用的
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isReachEnd;
@property (nonatomic, strong) SYVoiceRoomUserRightModel *userRightModel;

@end
@implementation SYRoomHomePageViewModel
- (instancetype)init {
    return [self initWithCategoryId:0];
}

- (instancetype)initWithCategoryId:(NSInteger)categoryId {
    self = [super init];
    if (self) {
        _categoryId = categoryId;
        _netManager = [[SYVoiceChatNetManager alloc] init];
        _listArray = [NSMutableArray new];
        _listdIdsArray = [NSMutableArray new];
    }
    return self;
}
- (void)requestPageType:(FirstCategoryType)type andFocusListWithBlock:(void (^)(BOOL))block{
    [self.netManager requestHomeFocusListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSArray class]]) {
            self.focusArray = (NSArray *)response;
        }
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    } categoryType:type];
}
- (void)requestPageType:(FirstCategoryType)type andRoomListWithBlock:(void (^)(BOOL))block{
    if (self.isLoading) {
        if (block) {
            block(NO);
        }
        return;
    }
    self.currentPage = 1;
    [self.netManager requestHomeChannelListWithCategoryId:self.categoryId
                                                  success:^(id  _Nullable response) {
                                                      self.isLoading = NO;
                                                      if ([response isKindOfClass:[SYVoiceRoomHomeListModel class]]) {
                                                          SYVoiceRoomHomeListModel *listModel = (SYVoiceRoomHomeListModel *)response;
                                                          self.listArray = [NSMutableArray arrayWithArray:listModel.page.data];
                                                          for (SYVoiceRoomHomeManualModel *room in listModel.maunal) {
                                                              if (room.posId <= [self.listArray count]) {
                                                                  [self.listArray insertObject:room.roomInfo
                                                                                       atIndex:room.posId];
                                                              }
                                                          }
                                                          [self.listdIdsArray removeAllObjects];
                                                          for (SYChatRoomModel *model in self.listArray) {
                                                              if (![NSString sy_isBlankString:model.id]&&![self.listdIdsArray containsObject:model.id]) {
                                                                  [self.listdIdsArray addObject:model.id];
                                                              }
                                                          }
                                                          if (block) {
                                                              block(YES);
                                                          }
                                                          self.isReachEnd = (listModel.page.page >= listModel.page.pageCount);
                                                      }
                                                  } failure:^(NSError * _Nullable error) {
                                                      if (block) {
                                                          block(NO);
                                                      }
                                                  }];
}
- (void)requestPageType:(FirstCategoryType)type andLoadMoreRoomListWithBlock:(void (^)(BOOL))block{
    if (self.isLoading || self.isReachEnd) {
        if (block) {
            block(NO);
        }
        return;
    }
    self.currentPage ++;
    [self.netManager requestChannelListWithPage:self.currentPage
                                     categoryId:self.categoryId
                                        success:^(id  _Nullable response) {
                                            self.isLoading = NO;
                                            if ([response isKindOfClass:[SYVoiceRoomListModel class]]) {
                                                SYVoiceRoomListModel *listModel = (SYVoiceRoomListModel *)response;
//                                                [self.listArray addObjectsFromArray:listModel.data];
                                                for (SYChatRoomModel *model in listModel.data) {
                                                    if (![self.listdIdsArray containsObject:model.id]) {
                                                        [self.listArray addObject:model];
                                                        if (![NSString sy_isBlankString:model.id]) {
                                                            [self.listdIdsArray addObject:model.id];
                                                        }
                                                    }
                                                }
                                                
                                                if (block) {
                                                    block(YES);
                                                }
                                                self.isReachEnd = (listModel.page >= listModel.pageCount);
                                            }
                                        } failure:^(NSError * _Nullable error) {
                                            self.isLoading = NO;
                                            if (block) {
                                                block(NO);
                                            }
                                        }];
}
- (void)requestPageType:(FirstCategoryType)type andUserRightWithBlock:(void (^)(BOOL))block{
    [self.netManager requestUserChannelRightWithSuccess:^(id  _Nullable response) {
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

- (NSInteger)focusListCount {
    return [self.focusArray count];
}

- (NSString *)focusImageURLAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.focusArray count]) {
        SYRoomHomeFocusModel *model = [self.focusArray objectAtIndex:index];
        return model.image;
    }
    return nil;
}

- (NSString *)focusJumpURLAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.focusArray count]) {
        SYRoomHomeFocusModel *model = [self.focusArray objectAtIndex:index];
        return model.jump;
    }
    return nil;
}

- (NSString *)focusTitleAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.focusArray count]) {
        SYRoomHomeFocusModel *model = [self.focusArray objectAtIndex:index];
        return model.title;
    }
    return nil;
}

- (SYVideoRoomFocusJumpType)focusJumpTypeAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.focusArray count]) {
        SYRoomHomeFocusModel *model = [self.focusArray objectAtIndex:index];
        return (SYVideoRoomFocusJumpType)model.type;
    }
    return SYVideoRoomFocusJumpTypeUnknown;
}

- (BOOL)canEnterMyChannel {
    if (self.userRightModel) {
        if ((self.userRightModel.canAdminRoomNum > 0) ||
            (self.userRightModel.canAdminRoomNum == 0 && self.userRightModel.canCreateRoomNum > 0)) {
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

- (NSString *)roomCategoryNameAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.categoryName;
}

- (NSString *)roomCategoryColorAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.categoryColor;
}

- (BOOL)roomIsLockedAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.lock;
}

- (NSInteger)roomScoreAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.score;
}
- (NSString *)roomCategoryIconAtIndex:(NSInteger)index {
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.iconOnlineLeft;
}
- (NSInteger)roomTypeAtIndex:(NSInteger)index{
    SYChatRoomModel *model = [self.listArray objectAtIndex:index];
    return model.type;
}

- (NSArray *)roomIDList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.listArray count]];
    for (SYChatRoomModel *model in self.listArray) {
        if (model.id) {
            [array addObject:model.id];
        }
    }
    return array;
}

@end
