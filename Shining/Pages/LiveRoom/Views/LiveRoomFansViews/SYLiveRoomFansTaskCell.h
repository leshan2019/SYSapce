//
//  SYLiveRoomFansTaskCell.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LiveRoomFansTaskDelegate <NSObject>
-(void)liveRoomFansTask_clickActionBtn:(NSString*)actionId;
@end
@interface SYLiveRoomFansTaskCell : UITableViewCell
@property(nonatomic,weak)id<LiveRoomFansTaskDelegate> delegate;
-(void)setCellInfo:(id)info;
@end

NS_ASSUME_NONNULL_END
