//
//  SYCreateActivityVC.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendSuccessBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SYCreateActivityVC : UIViewController

// 新增发送成功回调
- (instancetype)initCreateActivityVCWithBlock:(SendSuccessBlock)block;

@end

NS_ASSUME_NONNULL_END
