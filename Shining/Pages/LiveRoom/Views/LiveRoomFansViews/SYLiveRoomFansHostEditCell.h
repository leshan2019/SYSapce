//
//  SYLiveRoomFansHostEditCell.h
//  Shining
//
//  Created by leeco on 2019/11/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomFansHostEditCell : UITableViewCell
-(void)setEditCellText:(NSString*)text;
-(void)cellResignFirstResponder;
-(NSString*)getEditCellText;
@end

NS_ASSUME_NONNULL_END
