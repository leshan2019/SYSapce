//
//  SYRoomCategoryViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRoomCategoryViewModel.h"
#import "SYVoiceChatNetManager.h"


@interface SYRoomCategoryViewModel ()
//一级分类title
@property (nonatomic, strong) NSArray *categorySectionArr;
//分类信息
@property (nonatomic, strong) NSMutableDictionary *categoryDic;// key: type value: list
@property (nonatomic, strong) NSMutableDictionary *categorySizeDic;// key: type value: tab size arr
@end

@implementation SYRoomCategoryViewModel

- (void)requestCategoryListWithBlock:(void(^)(BOOL success))block {
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    [netManager requestRoomNewCategoryListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSArray class]]) {
            self.categorySectionArr = (NSArray *)response;
            SYCreateRoomCategorySectionModel *roomModel;
            NSArray *listArr = (NSArray *)response;
            self.categoryDic = @{}.mutableCopy;
            self.categorySizeDic = @{}.mutableCopy;
            for (int i = 0; i < listArr.count; i++) {
                roomModel = [listArr objectAtIndex:i];
                if (roomModel.data && roomModel.type != 0) {
                    NSString*key = [NSString stringWithFormat:@"%ld",(long)roomModel.type];
                    [self.categoryDic setValue:roomModel.data forKey:key];
                    NSMutableArray*sizeArr = @[].mutableCopy;
                    for (int i = 0; i<roomModel.data.count; i++) {
                        CGSize size = CGSizeMake(64*dp, 26*dp);;
                        NSString*url = roomModel.data[i].icon;
                        if (![NSString sy_isBlankString:url]) {
                            size = [UIImage getImageSizeWithURL:url];
                        }
                        
                        [sizeArr addObject:NSStringFromCGSize(size)];
                    }
                    [self.categorySizeDic setValue:sizeArr forKey:key];
                }
                    
               
            }
            
            if (block) {
                block(YES);
            }

        } else {
            if (block) {
                block(NO);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}
- (CGSize)getCategoryTabSize:(CGFloat)tabHeight andIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType{
    NSString*key = [NSString stringWithFormat:@"%ld",(long)categoryType];
    if (self.categorySizeDic[key]) {
        NSArray*arr = self.categorySizeDic[key];
        if (index < arr.count) {
            CGSize size = CGSizeFromString(arr[index]);
            CGFloat height = tabHeight*dp;
            CGFloat x = size.height/height;
            if (x <= 0) {
                return CGSizeMake(64*dp, 26*dp);
            }
            CGFloat width = size.width/x;
            return CGSizeMake(width, height);
        }
    }
    return CGSizeZero;
}
- (NSInteger)first_categoryCount{
    return self.categorySectionArr.count;
}
- (NSInteger)first_categoryTypeIndex:(NSInteger)index{
    SYCreateRoomCategorySectionModel *roomModel = self.categorySectionArr[index];
    return roomModel.type;
}
- (NSString*)first_categoryTitleIndex:(NSInteger)index{
    SYCreateRoomCategorySectionModel *roomModel = self.categorySectionArr[index];
    return roomModel.title;
}
- (NSInteger)first_categoryTitleSepCount{
    NSInteger count = 0;
    for (int i = 0; i<self.categorySectionArr.count;i++) {
            SYCreateRoomCategorySectionModel *roomModel = self.categorySectionArr[i];
        count += roomModel.title.length;
    }
    return count;
}
-(NSArray*)first_categoryTitlesArray{
    NSMutableArray*arr = @[].mutableCopy;
    for (int i = 0; i<self.categorySectionArr.count;i++) {
            SYCreateRoomCategorySectionModel *roomModel = self.categorySectionArr[i];
        [arr addObject: roomModel.title];
    }
    return arr;
}
- (NSInteger)categoryCountWithType:(FirstCategoryType)categoryType {
     NSString*key = [NSString stringWithFormat:@"%ld",(long)categoryType];
       if (self.categoryDic[key]) {
           NSArray*arr = self.categoryDic[key];
           return arr.count;
       }
    return 0;
}

- (NSString *)categoryNameAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType {
    return [self categoryModelAtIndex:index categoryType:categoryType].name;
}

- (NSInteger)categoryIdAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType{
    return [self categoryModelAtIndex:index categoryType:categoryType].id;
}

- (NSString *)categoryIconAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType {
    return [self categoryModelAtIndex:index categoryType:categoryType].icon;
}

- (NSString *)categoryHighlightedIconAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType{
    return [self categoryModelAtIndex:index categoryType:categoryType].iconChecked;
}

- (SYCreateRoomCategoryModel *)categoryModelAtIndex:(NSInteger)index categoryType:(FirstCategoryType)categoryType{
     NSString*key = [NSString stringWithFormat:@"%ld",(long)categoryType];
       if (self.categoryDic[key]) {
           NSArray*arr = self.categoryDic[key];
           if (index < arr.count) {
               return arr[index];
           }
       }
    return nil;
}
@end
