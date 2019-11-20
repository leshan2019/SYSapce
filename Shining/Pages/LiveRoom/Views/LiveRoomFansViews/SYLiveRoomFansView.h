//
//  SYLiveRoomFansView.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger{
    LiveRoomFansViewStatus_unJoined,
    LiveRoomFansViewStatus_joined
}LiveRoomFansViewStatus;
@protocol LiveRoomFansViewDelegate <NSObject>
-(void)liveRoomFansView_help;
-(void)liveRoomFansView_memberList;
-(void)liveRoomFansView_openFansRights;

@end
@interface SYLiveRoomFansView : UIView
- (instancetype)initWithFrame:(CGRect)frame isHost:(BOOL)isHost roomData:(NSDictionary*)infoDic;
@end
@interface SYLiveRoomFansEmptyView : UIView
@property(nonatomic,strong)UIImageView*img;
@property(nonatomic,strong)UILabel*titleLabel;
//
@end
