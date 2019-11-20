//
//  SYCreateRoomCategoryModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCreateRoomCategoryModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *micConfig;
@property (nonatomic, strong) NSString *icon; // normal icon
@property (nonatomic, strong) NSString *iconChecked; // highlighted icon

@end

@interface SYCreateRoomCategorySectionModel : NSObject
@property (nonatomic, strong) NSString *title;      // @"聊天室" | @"直播"
@property (nonatomic, assign) NSInteger type;       // 1 | 2
@property (nonatomic, strong) NSArray<SYCreateRoomCategoryModel *> *data;
@end

NS_ASSUME_NONNULL_END
