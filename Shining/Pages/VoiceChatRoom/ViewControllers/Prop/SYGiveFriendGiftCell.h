//
//  SYGiveFriendGiftCell.h
//  Shining
//
//  Created by 杨玄 on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYGiveFriendGiftCell : UITableViewCell

- (void)updateCellWithHeaderImage:(NSString *)imageUrl
                         withName:(NSString *)name
                       withGender:(NSString *)gender
                          withAge:(NSUInteger)age
                           withId:(NSString *)idText;

- (void)updateSyGiveFriendCellSelectState:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
