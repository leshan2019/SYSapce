//
//  SYLiveRoomFansMemberTableViewCell.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomFansMemberCell : UITableViewCell
-(void)isSectionLabelCell:(BOOL)hide;
-(void)setSectionLabelCellText:(NSString*)title isHost:(BOOL)ishost;
-(void)setCellInfos:(id)info isHost:(BOOL)ishost count:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
