//
//  SYLiveRoomFansHeaderView.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYLiveRoomFansViewInfoModel;
NS_ASSUME_NONNULL_BEGIN
typedef enum:NSInteger{
    LiveRoomFansViewHeaderStatus_firstLevel_guest,
    LiveRoomFansViewHeaderStatus_firstLevel_host,
    LiveRoomFansViewHeaderStatus_secondLevel_guest,
    LiveRoomFansViewHeaderStatus_secondLevel_host,
    LiveRoomFansViewHeaderStatus_secondLevel_help
}LiveRoomFansViewHeaderStatus;
@protocol LiveRoomFansHeaderViewDelegate <NSObject>

-(void)liveRoomFansHeaderView_help;
-(void)liveRoomFansHeaderView_edit;
-(void)liveRoomFansHeaderView_avatorClick;
-(void)liveRoomFansHeaderView_memberList;
-(void)liveRoomFansHeaderView_back;
@end
@interface SYLiveRoomFansHeaderView : UIView
@property(nonatomic,weak)id<LiveRoomFansHeaderViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame andStatus:(LiveRoomFansViewHeaderStatus)status;
-(void)setHeaderInfo:(id)infoModel andStatus:(LiveRoomFansViewHeaderStatus)status;
@end

NS_ASSUME_NONNULL_END
