//
//  SYVoiceRoomOnlineListCell.h
//  Shining
//
//  Created by 杨玄 on 2019/4/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomOnlineListCell : UICollectionViewCell

- (void)updateCellWithHeaderImage:(NSString *)imageUrl
                         withName:(NSString *)name
                       withGender:(NSString *)gender
                          withAge:(NSUInteger)age
                           withId:(NSString *)idText
                        withLevel:(NSUInteger)level;

@end

NS_ASSUME_NONNULL_END
