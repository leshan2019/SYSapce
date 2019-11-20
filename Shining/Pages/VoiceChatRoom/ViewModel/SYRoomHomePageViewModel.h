//
//  SYVideoRoomHomeViewModel.h
//  Shining
//
//  Created by leeco on 2019/9/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYVideoRoomFocusJumpTypeUnknown,
    SYVideoRoomFocusJumpTypeWeb = 1,
    SYVideoRoomFocusJumpTypeRoom = 2,
} SYVideoRoomFocusJumpType;
@interface SYRoomHomePageViewModel : NSObject
@property (nonatomic, assign, readonly) NSInteger categoryId;

- (instancetype)initWithCategoryId:(NSInteger)categoryId;

- (NSInteger)focusListCount;
- (NSString *)focusImageURLAtIndex:(NSInteger)index;
- (NSString *)focusJumpURLAtIndex:(NSInteger)index;
- (NSString *)focusTitleAtIndex:(NSInteger)index;
- (void)requestPageType:(FirstCategoryType)type andFocusListWithBlock:(void(^)(BOOL))block;
- (void)requestPageType:(FirstCategoryType)type andRoomListWithBlock:(void(^)(BOOL))block;
- (void)requestPageType:(FirstCategoryType)type andLoadMoreRoomListWithBlock:(void(^)(BOOL))block;
- (void)requestPageType:(FirstCategoryType)type andUserRightWithBlock:(void(^)(BOOL))block;

- (SYVideoRoomFocusJumpType)focusJumpTypeAtIndex:(NSInteger)index;

- (NSInteger)roomListCount;
- (NSInteger)roomTypeAtIndex:(NSInteger)index;
- (NSString *)roomNameAtIndex:(NSInteger)index;
- (NSString *)roomIconAtIndex:(NSInteger)index;
- (NSString *)roomDescAtIndex:(NSInteger)index;
- (NSString *)roomIdAtIndex:(NSInteger)index;
- (NSString *)roomCategoryNameAtIndex:(NSInteger)index;
- (NSString *)roomCategoryColorAtIndex:(NSInteger)index;
- (BOOL)roomIsLockedAtIndex:(NSInteger)index;
- (NSInteger)roomScoreAtIndex:(NSInteger)index;
- (NSString *)roomCategoryIconAtIndex:(NSInteger)index;

- (BOOL)canEnterMyChannel;

- (NSArray *)roomIDList;
@end

