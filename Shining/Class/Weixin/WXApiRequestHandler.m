//
//  WXApiRequestHandler.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/3.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WXApi.h"
#import "SYUserServiceAPI.h"
//#import "FlientViewController.h"

@implementation WXApiRequestHandler

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
            InViewController:(UIViewController *)viewController
                 finishBlock:(void(^)(NSString *_Nullable))finishBlock{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    
    BOOL isSucess = [WXApi sendAuthReq:req
                        viewController:viewController
                              delegate:[WXApiManager sharedManager]];
//    if ([viewController isKindOfClass:[FlientViewController class]]) {
//        FlientViewController *vc = (FlientViewController *)viewController;
//        vc.wxFinishBlock = finishBlock;
//    }
    return isSucess;
}

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    
    return [WXApi sendReq:req];
}

// 会话列表
+ (BOOL)shareToWXSessionWithTitle:(NSString *)title description:(NSString *)description withThumbImage:(UIImage *)image withUrl:(NSString *)url {
    // 网页链接 - 未确定，需要找产品确定
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    message.mediaObject = webObj;
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession; 
    return [WXApi sendReq:req];
}

+ (void)shareToWXSessionWithThumb:(NSData *)data
                           roomId:(NSString *)roomId
                         roomName:(NSString *)roomName {
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = @"";
    object.userName = @"gh_46610cc5271d";
    object.path = [NSString stringWithFormat:@"/pages/index/index?roomId=%@", roomId];
    object.hdImageData = data;
    object.withShareTicket = YES;
    // TODO: 上线需要改成正式
    object.miniProgramType = WXMiniProgramTypeRelease;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = roomName;
//    message.description = @"小程序描述";
    message.thumbData = nil;  //兼容旧版本节点的图片，小于32KB，新版本优先
    //使用WXMiniProgramObject的hdImageData属性
    message.mediaObject = object;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;  //目前只支持会话
    [WXApi sendReq:req];
}

// 朋友圈
+ (BOOL)shareToWXTimelineWithTitle:(NSString *)title description:(NSString *)description withThumbImageName:(NSString *)image withUrl:(NSString *)url {
    // 网页链接 - 未确定，需要找产品确定
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed_sy:image]];
    message.mediaObject = webObj;
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    return [WXApi sendReq:req];
}


+ (BOOL)shareToWXTimelineWithTitle:(NSString *)title description:(NSString *)description withThumbImage:(UIImage *)image withUrl:(NSString *)url {
    // 网页链接 - 未确定，需要找产品确定
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    message.mediaObject = webObj;
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    return [WXApi sendReq:req];
}


+ (BOOL)shareToWXSpecifiedSessionWithTitle:(NSString *)title description:(NSString *)description withThumbImage:(UIImage *)image withUrl:(NSString *)url {
    // 网页链接 - 未确定，需要找产品确定
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = url;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    message.mediaObject = webObj;
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSpecifiedSession;
    return [WXApi sendReq:req];
}

@end
