//
//  SYDayTaskListCell.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDayTaskItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYDayTaskListCell : UITableViewCell
- (void)updateMyneListCellwithIcon:(NSString *)icon
                             title:(NSString *)title
                     progressTitle:(NSString *)progressTitle
                          subTitle:(NSString *)subTitle;

- (void)changeRightBtnByStatus:(SYDayTaskItemStatus)status;
- (void)updateUI:(BOOL)isHasSubtitle;
- (UIButton *)getRightBtn;
@end

NS_ASSUME_NONNULL_END
