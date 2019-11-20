//
//  SYVoiceChatRoomBackdropCell.h
//  Shining
//
//  Created by 杨玄 on 2019/4/17.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomBackdropCell : UICollectionViewCell

// 数据刷新cell
- (void)updateBackdropCellWithImage:(NSString *)imageUrl withSelect:(BOOL)selected withName:(NSString *)name;

// 更新选中态和未选中态
- (void)updateSelectedImageWithSelect:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
