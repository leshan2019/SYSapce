//
//  SYRoomCategoryViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYRoomCategoryViewModel : NSObject
//
- (NSInteger)first_categoryCount;
- (NSInteger)first_categoryTypeIndex:(NSInteger)index;
- (NSString*)first_categoryTitleIndex:(NSInteger)index;
- (NSArray*)first_categoryTitlesArray;
//
- (NSInteger)categoryCountWithType:(FirstCategoryType)categoryType;
- (NSString *)categoryNameAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType;
- (NSInteger)categoryIdAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType;
- (NSString *)categoryIconAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType;
- (NSString *)categoryHighlightedIconAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType;
- (CGSize)getCategoryTabSize:(CGFloat)tabHeight andIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType;
- (NSInteger)first_categoryTitleSepCount;

- (void)requestCategoryListWithBlock:(void(^)(BOOL success))block;

@end

NS_ASSUME_NONNULL_END
