//
//  SYVideoRoomHomeRoomCell.h
//  Shining
//
//  Created by leeco on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVideoRoomHomeRoomCell : UICollectionViewCell
+ (CGSize)cellSizeWithWidth:(CGFloat)width;

- (void)showWithTitle:(NSString *)title
            avatarURL:(NSString *)avatarURL
                score:(NSInteger)score
             roomType:(NSInteger)type
         roomTypeIcon:(NSString *)typeUrl
             isLocked:(BOOL)isLocked;
@end

NS_ASSUME_NONNULL_END
