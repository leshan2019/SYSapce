//
//  SYLetterIndexerView.h
//  Shining
//
//  Created by 杨玄 on 2019/3/20.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYLetterIndexerViewDelegate <NSObject>

@optional
- (void)handleSYLetterIndexerScrollWithIndex:(NSUInteger)index;     // 字母索引点击或者手势滑动回调
@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  字母索引控件 - 仿微信通讯录右侧字母索引
 */
@interface SYLetterIndexerView : UIView

@property (nonatomic, weak) id <SYLetterIndexerViewDelegate> delegate;

/**
 *  更新数据源
 */
- (void)updateIndexerViewWithLetters:(NSArray *)array;

/**
 *  更新选中字母索引
 *  0-25
 */
- (void)updateSelectedIndexWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
