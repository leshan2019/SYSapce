//
//  SYVoiceRoomGetRedPacketUserCell.h
//  Shining
//
//  Created by yangxuan on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGetRedPacketUserCell : UICollectionViewCell

- (void)configueData:(NSString *)userIcon
                name:(NSString *)userName
           coinCount:(NSInteger)coinCount
             getTime:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
