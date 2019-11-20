//
//  SYDayTaskItemModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYDayTaskItemStatus_Unknown,
    SYDayTaskItemStatus_Default = 1,   // 未完成
    SYDayTaskItemStatus_Done_unReceived = 2,  // 已完成未领取
    SYDayTaskItemStatus_Done_Received = 3   // 已完成已领取
} SYDayTaskItemStatus;

NS_ASSUME_NONNULL_BEGIN

@interface SYDayTaskItemModel : NSObject <YYModel>
@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, copy) NSString *iconUrl;        // 图标
@property (nonatomic, copy) NSString *title;   //任务标题
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) NSInteger currentProgress; //当前进度
@property (nonatomic, assign) NSInteger allProgress; //总任务进度
@property (nonatomic, assign) SYDayTaskItemStatus status; //当前任务状态
@end

NS_ASSUME_NONNULL_END
