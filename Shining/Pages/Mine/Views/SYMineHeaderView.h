//
//  SYMineHeaderView.h
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYMineHeaderViewDelegate <NSObject>

- (void)clickAvatar;
- (void)editPersonalInformation;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人中心 - Header
 */
@interface SYMineHeaderView : UIView

@property (nonatomic, weak) id <SYMineHeaderViewDelegate> delegate;

// 更新头像，姓名，主播等级，id
- (void)updateHeaderViewWithAvatar:(NSString *)avatar name:(NSString *)name idNumber:(NSString *)idNum withBroadCasterLevel:(NSInteger)broadCasterLevel isBroadcaster:(NSInteger)isBroadcaster isSuperAdmin:(NSInteger)isSuperAdmin bestId:(NSString *)bestId;

@end

NS_ASSUME_NONNULL_END
