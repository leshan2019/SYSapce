//
//  HZSDKWKWebview.h
//  ActivityBox
//
//  Created by Kelicheng on 2019/9/24.
//  Copyright © 2019 sunnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeziSDKWebViewDefine.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZSDKWKWebview : UIView

//----------------------------------------Properties--------------------------------------------------------
@property (weak,nonatomic) id<HZSDKWKWebviewDelegate> delegate;
@property (strong, nonatomic) WKWebView * webView;
@property (strong, nonatomic) UIImageView *navigationBar;
@property (strong, nonatomic) UIButton *backButton; //回退按钮
@property (strong, nonatomic) UIButton * closeButton;// 导航关闭按钮
@property (strong, nonatomic) UIButton * closeHalfButton;// 半屏关闭按钮
@property (strong, nonatomic) UILabel * titleLabel; //
//刷新功能按钮
@property(strong,nonatomic) UIButton *reflushButton;
//分享按钮,假如没有获取到能分享的数据,内置的分享按钮是hidden状态
@property (strong, nonatomic) UIButton *shareButton;
/**
 分享按钮(内置的)点击后,会触发该回调.
  假如没有获取到能分享的数据,内置的分享按钮是hidden状态
 */
@property (copy, nonatomic) void(^shareBlock)(HeziShareModel *shareContent);
/*内置关闭按钮会触发该回调*/
@property (copy, nonatomic) void(^closeBlock)();
//新增判断是否是 vewicontroller 过来的
@property (assign,nonatomic)BOOL isViewController;


//----------------------------------------Methods--------------------------------------------------------

- (void)loadUrlString:(NSString *)urlString;

- (instancetype)initWithFrame:(CGRect)frame type:(HeziSDKWebViewType)type;
    
@end

NS_ASSUME_NONNULL_END
