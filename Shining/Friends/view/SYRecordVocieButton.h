//
//  SYRecordVocieButton.h
//  Shining
//
//  Created by letv_lzb on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYRecordVocieButton;

@protocol SYRecordVocieButtonDelegate <NSObject>
/**
 开始录制（按钮按下）

 @param button 按钮实例
 */
- (void)sy_didBeginRecordWithButton:(SYRecordVocieButton *)button;

/**
 录制中（按钮长按中）

 @param button 按钮实例
 */
- (void)sy_continueRecordingWithButton:(SYRecordVocieButton *)button;

/**
 将要退出录制（手指将要滑出了按钮区域 cancel）

 @param button 按钮实例
 */
- (void)sy_willCancelRecordWithButton:(SYRecordVocieButton *)button;

/**
 结束录制(按钮抬起)

 @param button 按钮实例
 @param audioLocalPath 录音文件路径
 */
- (void)sy_didFinishedRecordWithButton:(SYRecordVocieButton *)button audioLocalPath:(NSString *)audioLocalPath;

/**
 退出录制（手指滑出按钮区域并抬出了手指）

 @param button 按钮实例
 */
- (void)sy_didCancelRecordWithButton:(SYRecordVocieButton *)button;

/**
 录制中

 @param button button
 @param time 当前已经录制时间
 @param duration 总时间(如果录制的时候有设定最长录制时间)
 */
- (void)sy_didRecordingWithButton:(SYRecordVocieButton *)button recordTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;
@end

@interface SYRecordVocieButton : UIButton

/**
 代理
 */
@property (nonatomic, weak)id<SYRecordVocieButtonDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
