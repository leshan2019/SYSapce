//
//  SYGiveFriendGiftsVC.h
//  Shining
//
//  Created by 杨玄 on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GiveFriendBlock)(NSString * _Nonnull userId);

NS_ASSUME_NONNULL_BEGIN

/**
 *  赠送好友选择VC - 赠送头像框或者坐骑
 */
@interface SYGiveFriendGiftsVC : UIViewController

@property (nonatomic, copy) GiveFriendBlock ensureBlock;

@end

NS_ASSUME_NONNULL_END
