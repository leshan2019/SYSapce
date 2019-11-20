//
//  SYMineVerifyIDCardPicCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYMineVerifyIDCardViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYMineVerifyIDCardPicCell : UICollectionViewCell

- (void)updateCellWithType:(SYMineVerifyIDCardCellType)type withTitle:(NSString *)title withSubtitle:(NSString *)subTitle showBottomLine:(BOOL)show;

- (void)updateCellImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
