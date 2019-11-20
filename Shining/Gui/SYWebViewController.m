//
//  SYWebViewController.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYWebViewController.h"
#import <WebKit/WebKit.h>
#import "SYGameJSApi.h"
#import "dsbridge.h"
#import "ShiningSdkManager.h"
#import "SYPersonHomepageVC.h"
#import "SYGiftNetManager.h"

@interface SYWebViewController () <WKNavigationDelegate,SYCommonTopNavigationBarDelegate>

@property (nonatomic, strong) NSString *initialURL;
@property (nonatomic, strong) DWKWebView *dwebview;
@property (nonatomic, strong) NSString *roomId;

@property (nonatomic, strong)SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, copy) NSString *webTitle;

@property (nonatomic, strong) UIView *progressBaseView;
@property (nonatomic, strong) CAGradientLayer *progressLayer;

@end

@implementation SYWebViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.dwebview removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _initialURL = url;
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)webtitle{
    self = [super init];
    if (self) {
        _initialURL = url;
        if (![NSString sy_isBlankString:webtitle]) {
            self.webTitle = webtitle;
        }
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)title andRoomId:(NSString *)roomId {
    self = [super init];
    if (self) {
        _initialURL = url;
        _roomId = roomId;
        if(![NSString sy_isBlankString:title]){
            self.webTitle = title;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];

    [self.view addSubview:self.topNavBar];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.view addSubview:self.progressBaseView];

    CGFloat y = (iPhoneX ? 88.f : 64.f) + 1;
    self.dwebview=[[DWKWebView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y)];
    [self.view addSubview:self.dwebview];
    
    // register api object without namespace
    [self.dwebview addJavascriptObject:[[SYGameJSApi alloc] initWithWebVC:self andRoomId:self.roomId] namespace:nil];
    
    //    [dwebview setDebugMode:true];
    
    [self.dwebview disableJavascriptDialogBlock:YES];
    
    self.dwebview.navigationDelegate=self;
    
    NSURL *url = [[NSURL alloc] initWithString:_initialURL/*@"https://mp.le.com/sy/w/jsbridge"*/];
    [self.dwebview loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0]];
    
    [self.dwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //解决 iOS 11 屏幕顶部显示不全
    if (@available(iOS 11.0, *)) {
        self.dwebview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:KNOTIFICATION_USERINFOREADY
                                               object:nil];
}

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:[NSString sy_safeString:self.webTitle] rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UIView *)progressBaseView {
    if (!_progressBaseView) {
        _progressBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, iPhoneX ? 88.f : 64.f, self.view.sy_width, 1)];
        _progressBaseView.backgroundColor = RGBACOLOR(242,242,242,1);
        [_progressBaseView.layer addSublayer:self.progressLayer];
    }
    return _progressBaseView;
}

- (CAGradientLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAGradientLayer layer];
        _progressLayer.frame = CGRectMake(0, 0, 0, 1);
        _progressLayer.startPoint = CGPointMake(0, 0);
        _progressLayer.endPoint = CGPointMake(1, 0);
        _progressLayer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#B44BFF"].CGColor,(__bridge id)[UIColor sy_colorWithHexString:@"#D375FF"].CGColor];
    }
    return _progressLayer;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        if ([change[@"new"] floatValue] <[change[@"old"] floatValue]) {
            return;
        }
        CGFloat progress = [change[@"new"] floatValue];
        [self updateLoadUrlRequestProgress:progress];
    }
}
    
- (void)updateLoadUrlRequestProgress:(CGFloat)progress {
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    self.progressLayer.frame = CGRectMake(0, 0, self.view.sy_width * progress, 1);
    if (progress == 1.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressLayer.opacity = 0;
            self.progressLayer.frame = CGRectMake(0, 0, 0, 1);
        });
    }
}

#pragma mark - SYCommonTopNavigationBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.navigationController.viewControllers count] == 1 && self == self.navigationController.topViewController) {
        [self.navigationController dismissViewControllerAnimated:YES
                                                      completion:nil];
    }
}

- (void)rechargeCallbackMethod {
    if (self.dwebview) {
        [self.dwebview callHandler:@"rechargeCallback"  completionHandler:^(NSDictionary * _Nullable value) {
            NSLog(@"rechargeCallback: %@",value);
        }];
    }
}

- (void)checkLogin {
    __weak typeof(self) weakSelf = self;
    void (^block)(BOOL) = ^ (BOOL success){
        if (success) {
            [MBProgressHUD showHUDAddedTo:weakSelf.dwebview animated:YES];
        } else {
            if (weakSelf.dwebview) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": @(1),@"msg":@"error"} options:0 error:nil];
                NSString *jsonString;
                if (jsonData) {
                    jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                }
                if (jsonString) {
                    [weakSelf.dwebview callHandler:@"loginCallback" arguments:@[jsonString]];
                }
            }
        }
    };
    [ShiningSdkManager checkLetvAutoLogin:self.navigationController
                              finishBlock:^(BOOL success) {
                                  block(success);
                              }];
}

- (void)loginSuccess:(id)sender {
    [MBProgressHUD hideAllHUDsForView:self.dwebview animated:YES];
    if (self.dwebview) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": @(0),@"msg":@"success"} options:0 error:nil];
        NSString *jsonString;
        if (jsonData) {
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        if (jsonString) {
            [self.dwebview callHandler:@"loginCallback" arguments:@[jsonString]];
        }
    }
}

- (void)openUserPageWithUid:(NSString *)uid {
    SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
    vc.userId = uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)receiveBeansWithBlock:(void (^)(BOOL, NSInteger))block {
    __weak typeof(self) weakSelf = self;
    SYGiftNetManager *giftManager = [SYGiftNetManager new];
    [giftManager requestGetCoinWithSuccess:^(id  _Nullable response) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"蜜豆领取成功啦~"
                                                                                 message:@"回到乐视视频点击底部Bee语音，去看看有哪些小姐姐吧~" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:ok];
        [weakSelf presentViewController:alertController
                               animated:YES
                             completion:nil];
        if (block) {
            block(YES, 0);
        }
    } failure:^(NSError * _Nullable error) {
        NSString *title = @"";
        if (error.code == 4022) {
            title = @"你已经领取过了哦~";
        } else if (error.code == 4023) {
            title = @"今天的蜜豆已经抢完啦~\n明天再来吧~";
        } else {
            title = @"领取失败";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:ok];
        [weakSelf presentViewController:alertController
                               animated:YES
                             completion:nil];
        if (block) {
            block(NO, error.code);
        }
    }];
}

#pragma mark -

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = (url) ? url.absoluteString : @"";
    
    // iTunes: App Store link
    // 例如，微信的下载链接: https://itunes.apple.com/cn/app/id414478124?mt=8
    if ([urlString containsString:@"//itunes.apple.com/"] ||
        [urlString containsString:@"//apps.apple.com/"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    } else if (url.scheme && ![url.scheme hasPrefix:@"http"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
