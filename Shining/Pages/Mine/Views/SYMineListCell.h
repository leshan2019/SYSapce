//
//  SYMineListCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMineViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人中心 - CustomCell
 */
@interface SYMineListCell : UICollectionViewCell

- (void)updateMyneListCellWithType:(SYMineListCellType)type withIcon:(NSString *)icon title:(NSString *)title userLevel:(NSInteger)level;

- (void)showUnreadRedPoint:(BOOL)isShow;
@end

NS_ASSUME_NONNULL_END
