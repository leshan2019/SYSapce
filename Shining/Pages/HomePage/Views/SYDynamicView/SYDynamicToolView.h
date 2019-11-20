//
//  SYDynamicToolView.h
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

// like = yes : 点赞； like = no : 取消点赞
typedef void(^ClickLikeBlock)(BOOL like);
// 评论
typedef void(^ClickCommentBlock)(void);
// 打招呼
typedef void(^ClickGreetBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SYDynamicToolView : UIView

- (instancetype)initSYDynamicToolViewWithFrame:(CGRect)frame
                                     likeBlock:(ClickLikeBlock)likeBlock
                                  commentBlock:(ClickCommentBlock)commentBlock
                                   greentBlock:(ClickGreetBlock)greetBlock;

// 更新是否已经点过赞了
- (void)updateIfHasClickLikeBtn:(BOOL)hasLike;

// 更新点赞数
- (void)updateLikeNum:(NSInteger)likeNum;

// 更新评论数
- (void)updateCommentNum:(NSInteger)commentNum;

// 更新打招呼按钮的显示状态
- (void)showGreetBtn:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
