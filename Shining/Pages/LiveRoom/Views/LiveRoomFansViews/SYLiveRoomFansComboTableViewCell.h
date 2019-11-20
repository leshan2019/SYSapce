//
//  SYLiveRoomFansComboTableViewCell.h
//  Shining
//
//  Created by leeco on 2019/11/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LiveRoomFansComboTableViewCellDelegate <NSObject>

-(void)liveRoomFansComboTableViewCell_openFansRights:(NSString*)priceType;
@end
@interface SYLiveRoomFansComboTableViewCell : UITableViewCell
@property(nonatomic,weak)id<LiveRoomFansComboTableViewCellDelegate>delegate;
-(void)resetFansLevelCellInfo:(id)info andExpiredDate:(NSString*)date;
@end

NS_ASSUME_NONNULL_END
