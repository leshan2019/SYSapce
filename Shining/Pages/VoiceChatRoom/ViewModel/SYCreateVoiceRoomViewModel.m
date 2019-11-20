//
//  SYCreateVoiceRoomViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateVoiceRoomViewModel.h"
#import "SYVoiceChatNetManager.h"
#import "SYUserServiceAPI.h"
#import "SYAPPServiceAPI.h"

@interface SYCreateVoiceRoomViewModel ()

@property (nonatomic, strong) NSMutableArray *categoryArray;

@end

@implementation SYCreateVoiceRoomViewModel

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
            SYCreateRoomCategorySectionModel *voiceRoomModel;
            for (int i = 0; i < listArr.count; i++) {
                voiceRoomModel = [listArr objectAtIndex:i];
                if (voiceRoomModel.type == 1) {
                    break;
                }
            }
            if (voiceRoomModel) {
                NSArray *typeArr = voiceRoomModel.data;
                for (int i = 0; i < typeArr.count; i++) {
                    SYCreateRoomCategoryModel *model = [typeArr objectAtIndex:i];
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
//    [[SYUserServiceAPI sharedInstance] requestFilterText:content
//                                                 success:^(id  _Nullable response) {
//                                                     if ([response isKindOfClass:[NSString class]]) {
//                                                         if (block) {
//                                                             block([content isEqualToString:response]);
//                                                         }
//                                                     }
//                                                 } failure:^(NSError * _Nullable error) {
//                                                     if (block) {
//                                                         block(NO);
//                                                     }
//                                                 }];
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
