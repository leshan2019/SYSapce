//
//  SYMineSettingListCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMineSettingViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  设置 - CustomCell
 */
@interface SYMineSettingListCell : UICollectionViewCell

- (void)updateSettingListCellWithType:(SYMineSettingCellType)type withTitle:(NSString *)title withSubTitle:(NSString *)subTitle withOpenMessageNotify:(BOOL)open withShowBottomLine:(BOOL)show;

- (void)updateCellSubtitle:(NSString *)subTitle;


/**
 显示未读红点
 */
- (void)showUnreadRedPoint:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
