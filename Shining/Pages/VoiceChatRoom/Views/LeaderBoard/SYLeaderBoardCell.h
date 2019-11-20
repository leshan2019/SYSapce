//
//  SYLeaderBoardCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLeaderBoardCell : UICollectionViewCell

- (void)showWithName:(NSString *)name
              avatar:(NSString *)avatar
           avatarBox:(NSString *)avatarBox
                 vip:(NSInteger)vip
       isBroadcaster:(NSInteger)isBroadcaster
    broadcasterLevel:(NSInteger)broadcasterLevel
              gender:(NSString *)gender
                 age:(NSInteger)age
                 sum:(NSString *)sum
               index:(NSInteger)index
         needShowVip:(BOOL)needShowVip;

@end

NS_ASSUME_NONNULL_END
