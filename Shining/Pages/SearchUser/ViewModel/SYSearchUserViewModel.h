//
//  SYSearchUserViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/9/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SearchBlock)(BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface SYSearchUserViewModel : NSObject

- (void)searchUserByKeyword:(NSString *)keyword
                    success:(SearchBlock)success;

- (NSInteger)numberOfRows;
- (NSString *)headUrl:(NSIndexPath *)indexPath;
- (NSString *)name:(NSIndexPath *)indexPath;
- (NSString *)gender:(NSIndexPath *)indexPath;
- (NSInteger)age:(NSIndexPath *)indexPath;
- (NSString *)userId:(NSIndexPath *)indexPath;
- (NSString *)bestId:(NSIndexPath *)indexPath;
- (NSInteger)level:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
