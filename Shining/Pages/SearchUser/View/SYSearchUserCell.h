//
//  SYSearchUserCell.h
//  Shining
//
//  Created by 杨玄 on 2019/9/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYSearchUserCell : UICollectionViewCell

- (void)updateSYSearchUserViewWithHeaderUrl:(NSString *)imageUrl
                                       name:(NSString *)name
                                     gender:(NSString *)gender
                                        age:(NSUInteger)age
                                     userId:(NSString *)userId
                                      level:(NSUInteger)level;
@end

NS_ASSUME_NONNULL_END
