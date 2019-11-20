//
//  SYCommentCell.h
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCommentCell : UICollectionViewCell

- (void)configueSYCommentCell:(NSString *)avatarUrl
                         name:(NSString *)name
                       gender:(NSString *)gender
                          age:(NSInteger)age
                      content:(NSString *)content
                         time:(NSString *)time;

+ (CGFloat)calculateSYCommentCellHeightWithTitleWidth:(CGFloat)width
                                             content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
