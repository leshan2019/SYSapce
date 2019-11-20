//
//  SYPersonHomeRecordControl.h
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYRecordControlType_Prepare,        // 点击录制
    SYRecordControlType_Recording,      // 录音中
    SYRecordControlType_Finished,       // 录音完成
    SYRecordControlType_Listening,      // 试听中
    SYRecordControlType_ListenPause,    // 试听暂停
    SYRecordControlType_ListenFinish,   // 试听结束
    SYRecordControlType_Unknown         // 未知状态
} SYRecordControlType;

@protocol SYPersonHomeRecordControlDelegate <NSObject>

// 引导用户开通录音权限
- (void)SYPersonHomeRecordControlLeadUserToOpenRecordPermission;

// 删除录音
- (void)SYPersonHomeRecordControl:(UIView *)view deleteCurrentRecordAudioPath:(NSString *)audioPath;

// 保存录音
- (void)SYPersonHomeRecordControl:(UIView *)view saveCurrentRecordAudioPath:(NSString *)audioPath recordDuration:(NSInteger)duration;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页编辑 - 录音控件
 */
@interface SYPersonHomeRecordControl : UIView

@property (nonatomic, weak) id <SYPersonHomeRecordControlDelegate> delegate;
@property (nonatomic, assign,readonly) SYRecordControlType recordType;   // 当前录音状态

// 更新控件状态
- (void)updateRecordControlStateWithType:(SYRecordControlType)type;

@end

NS_ASSUME_NONNULL_END
