//
//  SYCommentOnlyKeyboardView.h
//  Shining
//
//  Created by yangxuan on 2019/10/31.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateCommentBlock)(NSInteger totalNum);

NS_ASSUME_NONNULL_BEGIN

@interface SYCommentOnlyKeyboardView : UIView

- (instancetype)initWithFrame:(CGRect)frame momentId:(NSString *)momentId block:(nonnull UpdateCommentBlock)updateBlock;

@end

NS_ASSUME_NONNULL_END
