//
//  PopBeeGiftListviewModel.m
//  Shining
//
//  Created by leeco on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "PopBeeGiftListviewModel.h"
#import "SYGiftNetManager.h"
@interface PopBeeGiftListviewModel()

@property (nonatomic, strong) SYGiftNetManager *netManager;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentSize;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PopBeeGiftListviewModel

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray array];
        self.currentPage = 0;
        self.currentSize = PagesSize;
        self.isLoadMoreData = NO;
    }
    return self;
}

// 请求更多页数据
- (void)requestListData {
    
    if (self.isLoadMoreData) {
        return ;
    }
    
    self.currentPage += 1;
    self.isLoadMoreData = YES;
    __weak typeof(self) weakSelf = self;
    [self.netManager requestBeeWithRoomId:self.channelID pagenum:self.currentPage pagesize:self.currentSize success:^(id  _Nullable response) {
        weakSelf.isLoadMoreData = NO;
        if ([response isKindOfClass:[SYGiftListModel class]]) {
            SYGiftListModel *giftListModel = (SYGiftListModel *)response;
            if ( giftListModel.list && giftListModel.list.count > 0) {
                [weakSelf.dataSource addObjectsFromArray:giftListModel.list];
            }
            if ( weakSelf.dataSource.count <= 0) {
                if ([weakSelf.delegate respondsToSelector:@selector(gameBeeGiftListEmpty)]) {
                    [weakSelf.delegate gameBeeGiftListEmpty];
                }
            }
            if ( giftListModel.list.count > 0) {
                if ([weakSelf.delegate respondsToSelector:@selector(gameBeeGiftListUpdate)]) {
                    [weakSelf.delegate gameBeeGiftListUpdate];
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.isLoadMoreData = NO;
        if ([weakSelf.delegate respondsToSelector:@selector(gameBeeGiftListError:)]) {
            [weakSelf.delegate gameBeeGiftListError:error.domain];
        }
    }];
}

- (SYGiftNetManager *)netManager {
    if (!_netManager) {
        _netManager = [[SYGiftNetManager alloc] init];
    }
    return _netManager;
}

@end
