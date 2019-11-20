//
//  IMBaseTableViewCell.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMBaseTableCellDelegate;
@interface IMBaseTableViewCell : UITableViewCell
{
    UILongPressGestureRecognizer *_headerLongPress;
}

@property (weak, nonatomic) id<IMBaseTableCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UIView *bottomLineView;
@property (strong, nonatomic) NSString *username;

@end

@protocol IMBaseTableCellDelegate <NSObject>

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
