//
//  SYVoiceRoomDetailInfoCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYVoiceChatRoomDetailInfoCellDelegate <NSObject>

- (void)SYVoiceChatRoomDetailInfoCellOpenUISwitchBtn:(BOOL)open;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomDetailInfoCell : UICollectionViewCell

@property (nonatomic, weak) id <SYVoiceChatRoomDetailInfoCellDelegate> delegate;

- (void)updateCellTitle:(NSString *)title SubTitle:(NSString *)subTitle SubImage:(NSString *)imageUrl showBottomLine:(BOOL) show withSwitchBtn:(BOOL)hasSwitch subImage_16_9:(BOOL) imageIs_16_9;

// 更新subImage
- (void)updateImage:(UIImage *)image;

// 打开UISwitchBtn
- (void)openUISwitBtn:(BOOL)open;

@end

NS_ASSUME_NONNULL_END
