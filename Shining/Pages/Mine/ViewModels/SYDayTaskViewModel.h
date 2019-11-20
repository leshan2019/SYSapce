//
//  SYDayTaskViewModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYDayTaskItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYDayTaskViewModel : NSObject

@property (nonatomic, strong) NSArray *listArray;

- (NSInteger)numberOfRows;
- (NSString *)leftIconForIndexPath:(NSIndexPath *)indexPath;    // 图片
- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath;   // 标题
- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)progressForIndexPath:(NSIndexPath *)indexPath;
- (SYDayTaskItemStatus)getStatusForIndexPath:(NSIndexPath *)indexPath;

- (void)updateListData:(void(^)(BOOL))finishBlock;

- (void)getReward:(NSString *)taskid finish:(void(^)(BOOL))finishBlock;
@end

NS_ASSUME_NONNULL_END
