//
//  HeziSDKWebViewDefine.h
//  ActivityBox
//
//  Created by Kelicheng on 2019/9/24.
//  Copyright © 2019 sunnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeziShareModel.h"
#import <WebKit/WebKit.h>
#define HeziSDKScreenWith [UIScreen mainScreen].bounds.size.width
#define HeziSDKScreenHeight [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSUInteger, HeziSDKWebViewType) {
    HeziSDKWebViewTypeFull,
    HeziSDKWebViewTypeHalf,
};

NS_ASSUME_NONNULL_BEGIN

//HZSDKWKWebview 用来获取分享模型的方法名
extern NSString * HeziSDKWebViewMethod_hzGetShareModel;
//HZSDKWKWebview 用来做分享动作的方法名
extern NSString * HeziSDKWebViewMethod_hzDoShareAction;

@interface HeziSDKWebViewDefine : NSObject

//= @[HeziSDKWebViewMethod_hzGetShareModel,HeziSDKWebViewMethod_hzDoShareAction]
@property (class,nonatomic,strong,readonly) NSArray<NSString *> * defaultScriptMessageNames;

//开发者可以使用这个参数加入自己的方法名
@property (nonatomic,strong) NSMutableArray <NSString *> * otherScriptMessageNames;

//开发者可以使用这个参数加入自己的脚本,HZSDKWKWebview在初始化的时候会调用去注册
@property (nonatomic,strong) NSMutableArray <WKUserScript *> * userScripts;


//HZSDKWKWebview在初始化的时候会调用这个方法去注册方法名
//= HeziSDKWebViewDefine.defaultScriptMessageNames + [[HeziSDKWebViewDefine share] otherScriptMessageNames]
- (NSArray<NSString *> *)scriptMessageNames;



+(instancetype)share;

@end




@class HZSDKWKWebview;
@protocol HZSDKWKWebviewDelegate <NSObject>

@optional
//---------------------------------------- protocol Message Handle ----------------------------------------

//didReceiveScriptMessage(系统) ----> shouldHandleInnerMessageWithUserContentController() --true--> 内部先处理消息(包括生成分享模型) ----> didReceiveScriptMessage(外部代理)
//didReceiveScriptMessage(系统) ----> shouldHandleInnerMessageWithUserContentController() --false--> return

//JS发来的消息由外界根据message的内容来决定是否处理,返回true 才会调用后续方法，默认是会处理消息
- (BOOL)hzWb:(HZSDKWKWebview *)view shouldHandleMessageWithUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

//JS发来的内部消息会先处理。最后才会调用该方法
- (void)hzWb:(HZSDKWKWebview *)view userContentController:(WKUserContentController *)userContentController
        didReceiveScriptMessage:(WKScriptMessage *)message;


/**
 外界可以监听这个方法来获取,分享的模型.
 分享完整的模型都是等网页加载完后生成的.由JS主动通知HZSDKWKWebview去处理message
 @param model 分享的模型
 */
- (void)hzWb:(HZSDKWKWebview *)view didCatchShareContent:(HeziShareModel *)model;






//---------------------------------------- protocol Navigation ----------------------------------------

//注意需要调用decisionHandler
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
//注意需要调用decisionHandler
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
//注意需要调用completionHandler
- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;
- (void)hzWb:(HZSDKWKWebview *)view webViewWebContentProcessDidTerminate:(WKWebView *)webView;




//---------------------------------------- protocol UI ----------------------------------------
- (nullable WKWebView *)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;

- (void)hzWb:(HZSDKWKWebview *)view webViewDidClose:(WKWebView *)webView;

- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;

- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;

- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler;

//default false
- (BOOL)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo;

//default nil
- (nullable UIViewController *)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions;

- (void)hzWb:(HZSDKWKWebview *)view webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController;


@end

NS_ASSUME_NONNULL_END
