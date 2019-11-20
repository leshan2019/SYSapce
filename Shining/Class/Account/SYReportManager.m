//
//  SYReportManager.m
//  Shining
//
//  Created by 杨玄 on 2019/5/10.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//
/*
#import "SYReportManager.h"
#import "SYNavigationController.h"

@implementation SYReportManager

static SYReportManager *sharedInstance = nil;


+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {}
    return self;
}

- (void)SYReportVC:(UIViewController *)VC withVisit:(NSString *)visitPath withReporterId:(NSString *)userid {

    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.feedbackKit.extInfo];

    if (![NSString sy_isBlankString:userid]) {
        [dic setObject:userid forKey:@"reporterId"];
    }
    if (![NSString sy_isBlankString:visitPath]) {
        [dic setObject:visitPath forKey:@"visitPath"];
    }

    self.feedbackKit.extInfo = dic;

    __block UIViewController *weakVc = VC;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            SYNavigationController *nav = [[SYNavigationController alloc] initWithRootViewController:viewController];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakVc presentViewController:nav animated:YES completion:nil];
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            [SYToastView showToast:title];
        }
    }];
}

- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        // 请从控制台下载AliyunEmasServices-Info.plist配置文件，并正确拖入工程
        _feedbackKit = [[YWFeedbackKit alloc] autoInit];
        UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
        [_feedbackKit setNickName:user.username];
        [_feedbackKit setUserNick:user.username];
        _feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"我的->设置->用户反馈",
                                 @"userid":user.userid,
                                 @"username":user.username,
                                 @"deviceid":[SYSettingManager deviceUUID],
                                 @"mobile":user.mobile};
    }
    return _feedbackKit;
}

@end
 */
