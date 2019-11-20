//
//  SYLiveRoomPlayListViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/11/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomPlayListViewModel : NSObject

- (instancetype)initWithChannelIDList:(NSArray *)channelIDList
                     initialChannelID:(NSString *)initialChannelID
                           categoryID:(NSInteger)categoryID;

- (NSInteger)initialIndex;

- (NSInteger)channelCount;
- (NSString *)channelIDAtIndex:(NSInteger)index;
- (NSString *)channelCoverImageURLAtIndex:(NSInteger)index;

- (void)fetchAllLiveRoomWithBlock:(void(^)(BOOL success))block;

@end

NS_ASSUME_NONNULL_END
