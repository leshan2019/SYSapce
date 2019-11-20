//
//  WXApiRequestHandler.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/3.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXApiRequestHandler : NSObject<WXApiDelegate>

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
            InViewController:(UIViewController *)viewController
                 finishBlock:(void(^)(NSString *_Nullable))finishBlock;

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state;

/**
 *  微信分享 - 会话好友
 */
+ (BOOL)shareToWXSessionWithTitle:(NSString *)title description:(NSString *)description withThumbImage:(UIImage *)image withUrl:(NSString *)url;

/**
 *  微信分享 - 指定好友
 */
+ (BOOL)shareToWXSpecifiedSessionWithTitle:(NSString *)title description:(NSString *)description withThumbImage:(UIImage *)image withUrl:(NSString *)url;

/**
 *  微信分享 - 分享聊天室到微信
 */
+ (void)shareToWXSessionWithThumb:(NSData *)data
                           roomId:(NSString *)roomId
                         roomName:(NSString *)roomName;
//

/**
 *  微信分享 - 朋友圈
 */
+ (BOOL)shareToWXTimelineWithTitle:(NSString *)title description:(NSString *)description withThumbImageName:(NSString *)image withUrl:(NSString *)url;


/**
 *  微信分享 - 朋友圈
 */
+ (BOOL)shareToWXTimelineWithTitle:(NSString *)title description:(NSString *)description withThumbImage:(UIImage *)image withUrl:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
