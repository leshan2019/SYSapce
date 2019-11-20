//
//  SYShineDetailIncomeModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYShineDetailIncomeModel : NSObject<YYModel>

/*
 shines: 18, //蜜糖
 stype: 1, //类型id
 stype_name: "送礼物", //类型名称
 relate_userid: "1000001", //关联用户
 relate_username: "user_测试卞丽", //关联用户名
 create_time: "2019-03-18 16:24:48", //发生时间
 */
@property (nonatomic, copy) NSString *shines;
@property (nonatomic, copy) NSString *stype;
@property (nonatomic, copy) NSString *stype_name;
@property (nonatomic, copy) NSString *relate_userid;
@property (nonatomic, copy) NSString *relate_username;
@property (nonatomic, copy) NSString *create_time;

@end

NS_ASSUME_NONNULL_END
