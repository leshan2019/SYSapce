//
//  SYTestWebViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/5/31.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYTestWebViewController.h"
#import <WebKit/WebKit.h>
#import "SYGameJSApi.h"

@interface SYTestWebViewController ()
@property (nonatomic, strong) NSString *initialURL;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) DWKWebView * dwebview;
@end

@implementation SYTestWebViewController

- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _initialURL = url;
        if(![NSString sy_isBlankString:title] ){
            self.title = title;
        }
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)title andRoomId:(NSString *)roomId
{
    self = [super init];
    if (self) {
        _initialURL = url;
        _roomId = roomId;
        if(![NSString sy_isBlankString:title]){
            self.title = title;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back:)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed_sy:@"voiceroom_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect bounds=self.view.bounds;
    self.dwebview=[[DWKWebView alloc] initWithFrame:/*CGRectMake(0, 0, bounds.size.width, bounds.size.height)*/bounds];
    [self.view addSubview:self.dwebview];
    
    // register api object without namespace
    [self.dwebview addJavascriptObject:[[SYGameJSApi alloc] initWithWebVC:self andRoomId:self.roomId] namespace:nil];
    
//    [dwebview setDebugMode:true];
    
    [self.dwebview disableJavascriptDialogBlock:YES];
    
    self.dwebview.navigationDelegate=self;
    
    NSURL *url = [[NSURL alloc] initWithString:_initialURL/*@"https://mp.le.com/sy/w/jsbridge"*/];
    [self.dwebview loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0]];

}


- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rechargeCallbackMethod {
    if (self.dwebview) {
        [self.dwebview callHandler:@"rechargeCallback"  completionHandler:^(NSDictionary * _Nullable value) {
            NSLog(@"rechargeCallback: %@",value);
        }];
    }
}
@end
