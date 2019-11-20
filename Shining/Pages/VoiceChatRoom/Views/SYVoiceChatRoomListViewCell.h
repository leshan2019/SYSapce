//
//  SYVoiceChatRoomListViewCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomListViewCell : UICollectionViewCell

- (void)showCellWithName:(NSString *)name
                    icon:(NSString *)icon
                    desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
