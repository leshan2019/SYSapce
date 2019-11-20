//
//  SYMineAboutUsViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYMineAboutUsCellType_Community = 0,        // 社区规范
    SYMineAboutUsCellType_UserAgreement = 1,    // 用户协议
    SYMineAboutUsCellType_ServiceQQ = 2,        // 客服QQ
    SYMineAboutUsCellType_Unknown               // 未知
} SYMineAboutUsCellType;

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人中心 - 关于我们
 */
@interface SYMineAboutUsViewModel : NSObject

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)mainTitleForIndexPath:(NSIndexPath *)indexPath;   // 标题
- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath;    // 副标题
- (SYMineAboutUsCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
