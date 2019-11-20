//
//  SYMyVoiceRoomListViewCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMyVoiceRoomListViewCell : UICollectionViewCell

- (void)showCellWithRoomName:(NSString *)roomName
                    roomIcon:(NSString *)roomIcon
                     userNum:(NSInteger)userNum
                        role:(NSInteger)role
                      isOpen:(BOOL)isOpen;
@end

NS_ASSUME_NONNULL_END
