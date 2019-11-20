//
//  SYDynamicViewCell.h
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDynamicViewProtocol.h"

// 动态cell
@interface SYDynamicViewCell : UICollectionViewCell

@property (nonatomic, weak) id <SYDynamicViewProtocol> delegate;

// 配置个人主页cell
- (void)configueHomepageDynamicCell:(NSString *)momentId
                             userId:(NSString *)userId
                             avatar:(NSString *)avatarUrl
                               name:(NSString *)name
                             gender:(NSString *)gender
                                age:(NSInteger)age
                      showDeleteBtn:(BOOL)showDelete
                              title:(NSString *)title
                           photoArr:(NSArray *)photoArr
                           videoDic:(NSDictionary *)videoDic
                           location:(NSString *)location
                               time:(NSString *)time
                       hasClickLike:(BOOL)like
                            likeNum:(NSInteger)likeNum
                         commentNum:(NSInteger)commentNum;
// 配置广场cell
- (void)configueSquareDynamicCell:(NSString *)momentId
                           userId:(NSString *)userId
                           avatar:(NSString *)avatarUrl
                             name:(NSString *)name
                           gender:(NSString *)gender
                              age:(NSInteger)age
                           roomId:(NSString *)roomId
                     hasAttention:(BOOL)attention
                            title:(NSString *)title
                         photoArr:(NSArray *)photoArr
                         videoDic:(NSDictionary *)videoDic
                         location:(NSString *)location
                             time:(NSString *)time
                     hasClickLike:(BOOL)like
                          likeNum:(NSInteger)likeNum
                       commentNum:(NSInteger)commentNum
                        userModel:(UserProfileEntity *)usermodel
                     showGreetBtn:(BOOL)show
                      isUserSelf:(BOOL)isSelf;

// 计算cell高度
+ (CGFloat)calculateDynamicViewCellHeightByCellWidth:(CGFloat)width
                                               title:(NSString *)title
                                            photoArr:(NSArray *)photoArr
                                            videoDic:(NSDictionary *)videoDic
                                            location:(NSString *)location;

@end

