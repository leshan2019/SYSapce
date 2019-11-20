//
//  SYDynamicDeleteView.h
//  Shining
//
//  Created by yangxuan on 2019/10/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteBlock)(void);
typedef void(^CancelBlock)(void);

NS_ASSUME_NONNULL_BEGIN

// 动态 - 删除弹窗
@interface SYDynamicDeleteView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  deleteBlock:(DeleteBlock)delete
                  cancelBlock:(CancelBlock)cancel;

@end

NS_ASSUME_NONNULL_END
