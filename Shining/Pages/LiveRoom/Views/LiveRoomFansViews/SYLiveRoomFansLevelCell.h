//
//  SYLiveRoomFansLevelCell.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomFansLevelCell : UITableViewCell
-(void)resetFansLevelCellInfo:(id)info;
@end
@interface SYLiveRoomFansProgressView : UIView
-(void)setProgressViewInfo:(NSString*)info;
@end
NS_ASSUME_NONNULL_END
