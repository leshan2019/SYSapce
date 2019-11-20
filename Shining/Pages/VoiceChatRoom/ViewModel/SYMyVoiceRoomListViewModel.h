//
//  SYMyVoiceRoomListViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMyVoiceRoomListViewModel : NSObject

- (void)requestRoomListWithPage:(NSInteger)page
                          block:(void(^)(BOOL success, BOOL emptyData))block;
- (void)requestUserRightWithBlock:(void(^)(BOOL))block;
- (void)requestUserCreateRoomTypesWithBlock:(void(^)(BOOL living, BOOL voice))block;

- (NSInteger)roomListCount;
- (NSString *)roomNameAtIndex:(NSInteger)index;
- (NSString *)roomIconAtIndex:(NSInteger)index;
- (NSString *)roomDescAtIndex:(NSInteger)index;
- (NSString *)roomIdAtIndex:(NSInteger)index;
- (NSInteger)roomCategoryIdAtIndex:(NSInteger)index;
- (NSInteger)myRoomRoleAtIndex:(NSInteger)index; // 1房主 2管理员
- (NSInteger)roomUserNumAtIndex:(NSInteger)index; // 房间人数
- (NSInteger)roomTypeAtIndex:(NSInteger)index; // 房间类型
- (BOOL)isRoomOpenAtIndex:(NSInteger)index; // 房间是否开启
- (BOOL)canCreateChannel;
- (BOOL)isLastPage;

@end

NS_ASSUME_NONNULL_END
