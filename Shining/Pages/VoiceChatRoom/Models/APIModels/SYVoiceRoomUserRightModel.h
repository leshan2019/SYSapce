//
//  SYVoiceRoomUserRightModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomUserRightModel : NSObject

@property (nonatomic, assign) NSInteger canAdminRoomNum; //-1 查询错误，0 无可管理房间，>0 可管理房间数
@property (nonatomic, assign) NSInteger canCreateRoomNum; //-1 禁止创建，0 已达最大可创建房间数量，>0 还可创建房间数

@end

@interface SYRoomCreateTypeModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger can_create;

@end

NS_ASSUME_NONNULL_END
