//
//  SYVoiceChatRoomManagerCell.h
//  Shining
//
//  Created by 杨玄 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomManagerCell : UITableViewCell

- (void)updateCellWithHeadImageUrl:(NSString *)imageUrl
                          withName:(NSString *)name
                        withGender:(NSString *)gender
                           withAge:(NSUInteger)age
                            withId:(NSString *)idText
                     showSpaceLine:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
