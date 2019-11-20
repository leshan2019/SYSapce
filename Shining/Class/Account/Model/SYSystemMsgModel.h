//
//  SYSystemMsgModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYSystemMsgModel : NSObject

@property(nonatomic,assign)NSInteger id;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *jump_type; //跳转类型 0-无 1-内跳webview 2-外跳浏览器
@property(nonatomic,strong)NSString *jump_url;
@property(nonatomic,strong)NSString *create_time;

@end

NS_ASSUME_NONNULL_END
