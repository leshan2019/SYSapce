//
//  SYCommentView.h
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDynamicViewProtocol.h"

typedef void(^UpdateCommentBlock)(NSInteger totalNum);

NS_ASSUME_NONNULL_BEGIN

// 评论view
@interface SYCommentView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     momentId:(NSString *)momentId
                     mySelfid:(NSString *)mySelfId
                        block:(UpdateCommentBlock)updateBlock;

@end

NS_ASSUME_NONNULL_END
