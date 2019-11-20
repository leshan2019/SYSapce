//
//  SYMineVerifyIDCardViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYMineVerifyIDCardCellType_IDCard_Name = 0,     // 姓名
    SYMineVerifyIDCardCellType_IDCard_Number = 1,   // 身份证号
    SYMineVerifyIDCardCellType_IDCard_Front = 2,    // 身份证正面照
    SYMineVerifyIDCardCellType_IDCard_Reverse = 3,  // 身份证反面照
    SYMineVerifyIDCardCellType_IDCard_HandSelf = 4, // 手持身份证
    SYMineVerifyIDCardCellType_Unknow               // 未知
} SYMineVerifyIDCardCellType;

NS_ASSUME_NONNULL_BEGIN

@interface SYMineVerifyIDCardViewModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath;   // 标题
- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath;    // 副标题
- (SYMineVerifyIDCardCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath;
- (BOOL)showBottomLine:(NSIndexPath *)indexPath;                // 是否展示分割线

@end

NS_ASSUME_NONNULL_END
