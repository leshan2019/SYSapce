//
//  SYLiveUserToolItemCell.h
//  Shining
//
//  Created by letv_lzb on 2019/10/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveUserToolItemCell : UICollectionViewCell
- (void)setIcon:(UIImage*)image andTitle:(NSString*)title;
- (void)setIcon:(UIImage*)image andTitle:(NSString*)title showRedIcon:(BOOL)isShowRedIcon;
- (void)setPKing:(BOOL)pking;
- (void)updateRedState:(BOOL)isShowRedIcon;
@end

NS_ASSUME_NONNULL_END
