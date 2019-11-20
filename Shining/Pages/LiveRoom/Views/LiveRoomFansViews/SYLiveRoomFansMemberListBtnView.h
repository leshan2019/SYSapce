//
//  SYLiveRoomFansMemberListBtnView.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LiveRoomFansMemberListBtnViewDelegate <NSObject>
-(void)liveRoomFansMemberListBtnView_clickActionBtn;
@end
@interface SYLiveRoomFansMemberListBtnView : UIView
@property(nonatomic,weak)id<LiveRoomFansMemberListBtnViewDelegate> delegate;
-(void)setupAvators:(NSArray*)arr;
@end

NS_ASSUME_NONNULL_END
