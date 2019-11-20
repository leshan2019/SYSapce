//
//  LetvLBZManager.h
//  LetvIphoneClient
//
//  Created by leeco on 2018/4/27.
//  Copyright © 2018年 LeEco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//乐聊事件
//重新获取ticket
typedef void (^ShanYinRegainTicketResponseCallback)(NSString* ticket);
typedef void (^ShanYinRegainTicketHandler)(id data, ShanYinRegainTicketResponseCallback ticketCallback);
//支付
typedef void (^ShanYinPayResponseCallback)(NSString* orderId,BOOL payResult);
typedef void (^ShanYinPayHandler)(id data, ShanYinPayResponseCallback payCallback);
//
@interface LetvLBZManager : NSObject
//
@property (nonatomic, strong) NSString* webUrlStr;
//
+ (LetvLBZManager *)shareInstance;
//
-(void)interLbzViewControllerWithSdkTargetURL:(NSString*)urlStr
                                andUserTicket:(NSString*)ticket
                                       andUid:(NSString*)uid
                           reginTicketHandler:(ShanYinRegainTicketHandler)reginTicketHandler
                                   PayHandler:(ShanYinPayHandler)PayHandler
                        currentViewController:(UIViewController*)currentVc;
@end

