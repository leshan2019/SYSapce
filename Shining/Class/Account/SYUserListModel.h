//
//  SYUserListModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUserListModel : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSArray *Users;

@end

NS_ASSUME_NONNULL_END
