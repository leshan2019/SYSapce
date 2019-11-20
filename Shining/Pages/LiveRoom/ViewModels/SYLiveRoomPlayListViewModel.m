//
//  SYLiveRoomPlayListViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/11/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomPlayListViewModel.h"
#import "SYVoiceChatNetManager.h"

#define SYLiveRoomPlayListPageSize 20

@interface SYLiveRoomPlayListViewModel ()

@property (nonatomic, strong) NSMutableArray *channelList;
@property (nonatomic, strong) NSString *initialChannelID;
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation SYLiveRoomPlayListViewModel

- (instancetype)initWithChannelIDList:(NSArray *)channelIDList
                     initialChannelID:(NSString *)initialChannelID
                           categoryID:(NSInteger)categoryID {
    self = [super init];
    if (self) {
        _channelList = [NSMutableArray array];
        _initialChannelID = initialChannelID;
        _categoryID = categoryID;
        _isLoading = NO;
        _hasMore = YES;
    }
    return self;
}

- (NSInteger)initialIndex {
    for (int i = 0; i < [self.channelList count]; i ++) {
        SYChatRoomModel *channel = [self.channelList objectAtIndex:i];
        if ([channel.id isEqualToString:self.initialChannelID]) {
            return i;
        }
    }
    return NSNotFound;
}

- (NSInteger)channelCount {
    return [self.channelList count];
}

- (NSString *)channelIDAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.channelList count]) {
        SYChatRoomModel *channel = [self.channelList objectAtIndex:index];
        return channel.id;
    }
    return nil;
}

- (NSString *)channelCoverImageURLAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.channelList count]) {
        SYChatRoomModel *channel = [self.channelList objectAtIndex:index];
        return channel.icon;
    }
    return nil;
}

- (void)fetchAllLiveRoomWithBlock:(void(^)(BOOL success))block {
    [self fetchLiveRoomWithPage:0
                          block:^(BOOL success) {
        if (block) {
            block(success);
        };
    }];
}

- (void)fetchLiveRoomWithPage:(NSInteger)page
                        block:(void(^)(BOOL success))block {
    page += 1;
    if (self.hasMore) {
        __weak typeof(self) weakSelf = self;
        [[SYVoiceChatNetManager new] requestChannelListWithPage:page
                                                     categoryId:self.categoryID
                                                        success:^(id  _Nullable response) {
            if ([response isKindOfClass:[SYVoiceRoomListModel class]]) {
                                                        SYVoiceRoomListModel *listModel = (SYVoiceRoomListModel *)response;
                                                        for (SYChatRoomModel *model in listModel.data) {
                                                            if (![NSString sy_isBlankString:model.id] &&
                                                                model.type == 2) {
                                                                [weakSelf.channelList addObject:model];
                                                            }
                                                        }
                                                        weakSelf.hasMore = (listModel.page < listModel.pageCount);
                [weakSelf fetchLiveRoomWithPage:page
                                          block:block];
                                                    }
        } failure:^(NSError * _Nullable error) {
            if (block) {
                block(YES);
            }
        }];
    } else {
        if (block) {
            block(YES);
        }
    }
}

@end
