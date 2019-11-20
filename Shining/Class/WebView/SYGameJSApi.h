//
//  SYGameJSApi.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/5/31.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SYJSCallback)(NSDictionary * _Nullable dict,BOOL complete);

NS_ASSUME_NONNULL_BEGIN

@interface SYGameJSApi : NSObject

- (instancetype)initWithWebVC:(UIViewController *)vc andRoomId:(NSString *)roomId;

- (NSString *) openRechargeWin: (NSDictionary *) msg;
- (NSDictionary *) openWebView: (NSDictionary *) msg;

@end

NS_ASSUME_NONNULL_END
