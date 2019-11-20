//
//  SYPersonHomepageIntroView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页 - 个人简介
 */
@interface SYPersonHomepageIntroView : UIView

// 刷新姓名，性别，年龄，vip等级
- (void)updateHomepageIntroViewWithName:(NSString *)name
                                 gender:(NSString *)gender
                                    age:(NSInteger)age
                               viplevel:(NSInteger)viplevel
                       broadCasterLevel:(NSInteger)broadCasterLevel
                          isBroadcaster:(NSInteger)isBroadcaster
                           signatureStr:(NSString *)signatureStr
                           isSuperAdmin:(NSInteger)isSuperAdmin;

// 刷新关注和粉丝数
- (void)updateHomepageIntrolViewWithAttentionCount:(NSInteger)attentionCount
                                         fansCount:(NSInteger)fansCount;

@end

NS_ASSUME_NONNULL_END
