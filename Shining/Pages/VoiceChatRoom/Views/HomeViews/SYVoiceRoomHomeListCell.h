//
//  SYVoiceRoomHomeListCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYVoiceRoomHomeListCellIdentifier @"SYVoiceRoomHomeListCellIdentifier"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomHomeListCell : UICollectionViewCell

+ (CGSize)cellSizeWithWidth:(CGFloat)width;

- (void)showWithTitle:(NSString *)title
            avatarURL:(NSString *)avatarURL;

@end

NS_ASSUME_NONNULL_END
