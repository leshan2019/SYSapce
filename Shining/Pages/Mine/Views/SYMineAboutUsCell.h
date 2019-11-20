//
//  SYMineAboutUsCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMineAboutUsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMineAboutUsCell : UICollectionViewCell

- (void)updateCellWithType:(SYMineAboutUsCellType)type withTitle:(NSString *)title withSubtitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END
