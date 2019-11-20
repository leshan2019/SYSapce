//
//  SYVoiceRoomOnlineListModel.h
//  Shining
//
//  Created by 杨玄 on 2019/4/24.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomOnlineListModel : NSObject

@property (nonatomic, assign) NSInteger total;      // 总人数
@property (nonatomic, assign) NSInteger page;       // 当前页数
@property (nonatomic, assign) NSInteger pageSize;   // 单页最多
@property (nonatomic, assign) NSInteger pageCount;  // 一共多少页
@property (nonatomic, strong) NSArray * data;       

@end

NS_ASSUME_NONNULL_END
