//
//  SYPersonHomepageVC.h
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomepageAttentionBlock)(NSString * _Nonnull userId, NSString * _Nonnull userName);

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页
 */
@interface SYPersonHomepageVC : UIViewController

// 传入用户id即可
@property (nonatomic, copy) NSString *userId;

// 关注成功回调
@property (nonatomic, copy) HomepageAttentionBlock attentionBlock;
// 取消关注回调
@property (nonatomic, copy) HomepageAttentionBlock cancelAttentionBlock;

@end

NS_ASSUME_NONNULL_END
