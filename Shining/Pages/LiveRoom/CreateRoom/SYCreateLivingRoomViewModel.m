//
//  SYCreateLivingRoomViewModel.m
//  Shining
//
//  Created by yangxuan on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateLivingRoomViewModel.h"
#import "SYVoiceChatNetManager.h"
#import "SYUserServiceAPI.h"
#import "SYAPPServiceAPI.h"

@interface SYCreateLivingRoomViewModel ()

@property (nonatomic, strong) NSMutableArray *categoryArray;

@end

@implementation SYCreateLivingRoomViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _categoryArray = [NSMutableArray new];
    }
    return self;
}

- (void)requestCategoryListWithBlock:(void(^)(BOOL success))block {
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    [netManager requestRoomNewCategoryListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *listArr = (NSArray *)response;
            SYCreateRoomCategorySectionModel *livingModel;
            for (int i = 0; i < listArr.count; i++) {
                livingModel = [listArr objectAtIndex:i];
                if (livingModel.type == 2) {
                    break;
                }
            }
            if (livingModel) {
                NSArray *videoArr = livingModel.data;
                for (int i = 0; i < videoArr.count; i++) {
                    SYCreateRoomCategoryModel *model = [videoArr objectAtIndex:i];
                    if ([model.micConfig count] > 0) {
                        [self.categoryArray addObject:model];
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

- (void)requestValidContent:(NSString *)content
                      block:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestValidateText:content
                                                   success:^(id  _Nullable response) {
                                                       if ([response isKindOfClass:[NSDictionary class]]) {
                                                           if (block) {
                                                               block([response[@"validate"] boolValue]);
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

- (void)requestValidateImageData:(NSData *)data block:(void (^)(BOOL))block {
    [[SYAPPServiceAPI sharedInstance] requestValidateImage:data success:^(id  _Nullable response) {
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}

- (NSInteger)categoryCount {
    return [self.categoryArray count];
}

- (NSString *)categoryStringAtIndex:(NSInteger)index {
    SYCreateRoomCategoryModel *model = [self.categoryArray objectAtIndex:index];
    return model.name;
}

- (NSArray *)micCountArrayAtIndex:(NSInteger)index {
    SYCreateRoomCategoryModel *model = [self.categoryArray objectAtIndex:index];
    return model.micConfig;
}

- (NSInteger)categoryIDAtIndex:(NSInteger)index {
    SYCreateRoomCategoryModel *model = [self.categoryArray objectAtIndex:index];
    return model.id;
}

@end
