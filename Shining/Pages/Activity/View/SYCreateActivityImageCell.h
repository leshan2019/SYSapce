//
//  SYCreateActivityImageCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYCreateActivityImageCell;

@protocol SYCreateActivityImageCellDelegate <NSObject>

- (void)createActivityImageCellDidCancelWithCell:(SYCreateActivityImageCell *)cell;

@end

@interface SYCreateActivityImageCell : UICollectionViewCell

@property (nonatomic, weak) id <SYCreateActivityImageCellDelegate> delegate;

- (void)showWithImageData:(NSData *)data
               plusButton:(BOOL)plusButton;

- (UIImageView *)getClickImageView;

@end

NS_ASSUME_NONNULL_END
