//
//  PopBeeGiftListviewModel.h
//  Shining
//
//  Created by leeco on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define PagesSize   30

@protocol PopBeeGiftListDelegate <NSObject>
/**
 * 礼物更新
 */
- (void)gameBeeGiftListUpdate;

/**
 * 分页加载 暂不使用
 */
//- (void)gameBeeGiftListInsert;

/**
 * 礼物为空
 */
- (void)gameBeeGiftListEmpty;

/**
 * 没有更多
 */
- (void)gameBeeGiftListNoMoreData;

/**
 * 遇到错误
 */
- (void)gameBeeGiftListError:(NSString *)error;


@end

@interface PopBeeGiftListviewModel : NSObject

@property (nonatomic, strong, readwrite) NSString *channelID;
@property (nonatomic, weak) id <PopBeeGiftListDelegate> delegate;
@property (nonatomic, strong,readonly) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isLoadMoreData;

- (void)requestListData;

@end

NS_ASSUME_NONNULL_END
