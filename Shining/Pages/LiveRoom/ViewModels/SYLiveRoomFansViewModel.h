//
//  SYLiveRoomFansViewModel.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYLiveRoomFansViewInfoModel;
@class SYLiveRoomFansViewMemberModel;
@class SYLiveRoomFansViewLevelInfoModel;
NS_ASSUME_NONNULL_BEGIN
@interface SYLiveRoomFansViewModel : NSObject
-(NSInteger)getFansHeaderInfoStatus;
-(SYLiveRoomFansViewInfoModel*)getHeaderInfo;
-(NSArray*)getComboArr;
-(NSArray*)getMembersList;
-(SYLiveRoomFansViewMemberModel*)getUserFansInfo;
-(SYLiveRoomFansViewLevelInfoModel*)getUserFansLevel;
-(NSArray *)getTaskList;
-(NSString*)getFansGroupID;
-(NSString*)getExpiredDate;
-(NSString*)host_getGroupScore;
- (void)requestFansViewInfoWithUid:(NSString *)uid
                       andAnchorid:(NSString *)anchorid
                             block:(void(^)(BOOL success))block;
- (void)requestFansViewMemberlistWithAnchorid:(NSString *)anchorid
                                        block:(void(^)(BOOL success))block;
- (void)openFansRightWithUid:(NSString *)uid
                 andAnchorid:(NSString *)anchorid
                  fansloveid:(NSString *)fansloveid
                   pricetype:(NSString *)pricetype
                       block:(void(^)(BOOL success))block;
- (void)requestFansViewLevelWithUid:(NSString *)uid
                       andAnchorid:(NSString *)anchorid
                             block:(void(^)(BOOL success))block;
- (void)editFansGroupNameWithGroupId:(NSString *)groupId
                         andAnchorid:(NSString *)anchorid
                                name:(NSString *)name
                               block:(void(^)(BOOL success))block;
@end

NS_ASSUME_NONNULL_END
