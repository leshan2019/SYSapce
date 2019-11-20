//
//  SYPersonHomepageVoiceCardVC.m
//  Shining
//
//  Created by leeco on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVoiceCardVC.h"
#import "SYPersonHomepageVoiceCardShowView.h"
#import "SYPersonHomepageVoiceCardAllocView.h"
#import "SYPersonHomeRecordControl.h"
#import "SYPersonHomepageVoiceCardViewModel.h"
#import "SYVoiceCardWordModel.h"
#import "SYVoiceCardWordsListVC.h"
@interface SYPersonHomepageVoiceCardVC ()<
SYNoNetworkViewDelegate,
SYPopUpWindowsDelegate,
SYPersonHomepageVoiceCardAllocViewDelegate,
SYPersonHomepageVoiceCardShowViewDelegate,
SYVoiceCardWordsListVCDelegate
>
@property (nonatomic, strong) SYNoNetworkView *noNetworkView;

@property(nonatomic,assign)VoiceCardVCState state;
@property(nonatomic,strong)UIImageView*bgImageView;
@property(nonatomic,strong)UIButton*backBtn;
@property(nonatomic,strong)UILabel*titleLabel;
//
@property(nonatomic,strong)SYPersonHomepageVoiceCardShowView*myCardView;
@property (nonatomic, copy) NSString *userid;

//
@property(nonatomic,strong)SYPersonHomepageVoiceCardAllocView*allocCardView;
//
@property(nonatomic,strong)SYPersonHomepageVoiceCardViewModel*viewModel;
@property (nonatomic, copy) NSString *localVoiceUrl;                        // 本地录制的声音

@property(nonatomic,strong)UITextView *myTextView;
@property(nonatomic,strong)UIButton*changeBtn;
@property(nonatomic,strong)UICollectionView*categoryCollectionView;
@property(nonatomic,strong)SYPersonHomeRecordControl*recodeControl;
@end

@implementation SYPersonHomepageVoiceCardVC
- (instancetype)initWithUserid:(NSString *)userid {
    self = [super init];
    if (self) {
        self.userid = userid;
    }
    return self;
}
-(void)requestMyVoiceCard{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestVoiceCardWithUserId:self.userid withBlock:^(BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (success) {
            [weakSelf.myCardView resetViewInfos:[weakSelf.viewModel getMyVoiceCardData]];
        }
    }];
}
-(void)requestWords{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestVoiceCardWordsListWithBlock:^(BOOL result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        if (result) {
            [weakSelf reloadDataForView];
        }
    }];
}
-(void)reloadDataForView{
    if (self.state == VoiceCardVCState_self_show) {
        
        
    }else if (self.state == VoiceCardVCState_self_alloc) {
        SYVoiceCardWordModel*model = [self.viewModel changeCurrentWord];
        NSString*text = [model.word stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        [self.allocCardView resetAllocView_WordInfo:text];
        NSArray*arr = [self.viewModel getCategorysNames];
        [self.allocCardView resetAllocView_categoryInfo:arr];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSString sy_isBlankString:self.userid]) {
        UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
        self.state = [NSString sy_isBlankString:user.voice_url]?VoiceCardVCState_self_alloc:VoiceCardVCState_self_show;
    }else{
        self.state = VoiceCardVCState_other_show;
    }
    
    self.viewModel = [[SYPersonHomepageVoiceCardViewModel alloc]init];
    
    //
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.sy_centerX = self.view.sy_centerX;
    self.titleLabel.sy_centerY = self.backBtn.sy_centerY;
    //
    [self.view addSubview:self.myCardView];
    [self.view addSubview:self.allocCardView];
    
    [self setupViews];
    if (self.state == VoiceCardVCState_self_alloc) {
        [self requestWords];
    }else {
        [self requestMyVoiceCard];
    }
}
-(void)setupViews{
    if (self.state == VoiceCardVCState_self_alloc) {
        [self.allocCardView resetViewState:NO];
        self.allocCardView.sy_top = self.titleLabel.sy_bottom+43*dp;
        self.allocCardView.sy_height = __MainScreen_Height - (self.titleLabel.sy_bottom+43*dp);
    }else {
        if (self.state == VoiceCardVCState_self_show) {
            [self.myCardView resetViewState:NO andHideRecodeBtn:NO];
            
        }else{
            [self.myCardView resetViewState:NO andHideRecodeBtn:YES];
            
        }
        self.myCardView.sy_top = self.titleLabel.sy_bottom+43*dp;
        self.myCardView.sy_height = __MainScreen_Height - (self.titleLabel.sy_bottom+43*dp);
    }
}
#pragma mark ---------- alloc delegate -----------

// 删除本地录音文件
- (void)allocView_voiceViewDeleteLocalVoice:(NSString *)localVoiceUrl {
    self.localVoiceUrl = localVoiceUrl;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView*view = [window viewWithTag:1001];
    [view removeFromSuperview];
    
    SYPopUpWindows*popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    popupWindow.delegate = self;
    popupWindow.tag = 1001;
    [popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:@"是否放弃当前录音" withSubTitle:@"" withBtnTexts:@[@"取消",@"放弃"] withBtnTextColors:@[RGBACOLOR(123,64,255,1),RGBACOLOR(123,64,255,1)]];
    [window addSubview:popupWindow];
    [popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

// 上传本地录音文件
- (void)allocView_voiceViewSaveLocalVoice:(NSString *)localVoiceUrl voiceDuration:(NSInteger)duration{
    [self.allocCardView resetAllocView_showLoadingView];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestUploadVoice:localVoiceUrl duration:duration success:^(BOOL success) {
        if (success) {
            [SYToastView showToast:@"保存录音成功!"];
            [weakSelf.allocCardView resetAllocView_recodeControl];
            [weakSelf updateUserVoiceViewAfterUploadVoice];
        } else {
            [weakSelf.allocCardView resetAllocView_hideLoadingView];
            [weakSelf.allocCardView resetAllocView_showFailView];
            [SYToastView showToast:@"保存录音失败，请重试!"];
        }
    }];
}
// 提交声鉴请求
- (void)updateUserVoiceViewAfterUploadVoice {
    
    NSString*wordid = [self.viewModel getCurrentWordId];
    __weak typeof(self) weakSelf = self;
    [self.viewModel uploadVoiceCardWithWordId:wordid withBlock:^(BOOL result) {
        if (result) {
            [weakSelf searchVoiceCardResult];
        }else {
            [weakSelf.allocCardView resetAllocView_hideLoadingView];
            [weakSelf.allocCardView resetAllocView_showFailView];
            [SYToastView showToast:@"提交声鉴失败"];
        }
    }];
}
//查询声鉴结果
-(void)searchVoiceCardResult{
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendRequest) userInfo:nil repeats:NO];
}
-(void)sendRequest{
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestVoiceCardResultWithBlock:^(BOOL success) {
        if (success) {
            [weakSelf.allocCardView resetAllocView_hideLoadingView];
            [weakSelf.allocCardView resetAllocView_showSuccessView:[weakSelf.viewModel getSoundTypeArr]];
            [weakSelf.viewModel refreshUserInfo:^(BOOL result) {
                NSLog(@"创建声鉴后，刷新用户信息");
            }];
        }else{
            [weakSelf.allocCardView resetAllocView_hideLoadingView];
            [weakSelf.allocCardView resetAllocView_showFailView];
            [SYToastView showToast:@"查询声鉴结果失败"];
        }
    }];
}
-(void)showLoadingView{
    [self.allocCardView resetAllocView_showLoadingView];
}
// 打开录音权限
- (void)allocView_leadUserToOpenRecordPermission {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您没有麦克风权限"
                                                                   message:@"请开启麦克风权限"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开启"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}
- (void)allocView_refreshWord{
    SYVoiceCardWordModel*model = [self.viewModel changeCurrentWord];
    NSString*text = [model.word stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [self.allocCardView resetAllocView_WordInfo:text];
    
}
- (void)allocView_clickCategory:(NSString *)str{
    NSArray*arr = [self.viewModel getSeletedCategoryArrayWithName:str];
    NSDictionary*dic = @{@"title":str,@"list":arr};
    SYVoiceCardWordsListVC*vc = [[SYVoiceCardWordsListVC alloc]initWithState:dic];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)allocView_clickFinish{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.myCardView resetViewState:NO andHideRecodeBtn:NO];
    [self.allocCardView resetViewState:YES];
    self.state = VoiceCardVCState_self_show;
    [self setupViews];
    [self requestMyVoiceCard];
}
- (void)wordsListVC_selectNewWord:(SYVoiceCardWordModel *)model{
    NSString*text = [model.word stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [self.viewModel setNewCurrentWord:model];
    [self.allocCardView resetAllocView_WordInfo:text];
}
#pragma mark - show delegate----
- (void)showView_retryRecode{
    [self.myCardView resetViewState:YES andHideRecodeBtn:NO];
    [self.allocCardView resetViewState:NO];
    [self.allocCardView resetAllocViewWithStatus:SYVoiceCardAllocViewStatus_prepare];
    self.state = VoiceCardVCState_self_alloc;
    [self setupViews];
    [self requestWords];
    
}

#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsLeftBtnClickEvent {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView*view = [window viewWithTag:1001];
    [view removeFromSuperview];
}

- (void)handlePopUpWindowsRightBtnClickEvent {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView*view = [window viewWithTag:1001];
    [view removeFromSuperview];
    
    [self.allocCardView resetAllocView_recodeControl];
    if (![NSString sy_isBlankString:self.localVoiceUrl]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        [fm removeItemAtPath:self.localVoiceUrl error:&error];
        if (error == nil) {
            NSLog(@"录音文件删除成功，path：%@",self.localVoiceUrl);
        }
    }
}
#pragma mark -----------private method-------------

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addNoNetworkView {
    [self removeNoNetworkView];
    
    self.noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.noNetworkView];
}
- (void)SYNoNetworkViewClickRefreshBtn {
    [self removeNoNetworkView];
}
- (void)removeNoNetworkView {
    if (self.noNetworkView) {
        [self.noNetworkView removeFromSuperview];
    }
    self.noNetworkView = nil;
}
#pragma mark -----------lazy load -------------
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:self.view.bounds];
        img.image = [UIImage imageNamed_sy:@"voiceCard_bg"];
        _bgImageView = img;
    }
    return _bgImageView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        CGFloat y = iPhoneX ? (24+20) : 20;
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(6, y, 36, 44)];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed_sy:@"voiceroom_back"] forState:UIControlStateHighlighted];
        _backBtn = btn;
    }
    return _backBtn;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectZero];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"声音名片";
        lab.font = [UIFont systemFontOfSize:17];
        lab.textColor = [UIColor whiteColor];
        [lab sizeToFit];
        _titleLabel = lab;
    }
    return _titleLabel;
}
- (SYPersonHomepageVoiceCardShowView *)myCardView{
    if (!_myCardView) {
        SYPersonHomepageVoiceCardShowView*view = [[SYPersonHomepageVoiceCardShowView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0)];
        view.backgroundColor = [UIColor clearColor];
        view.delegate = self;
        view.hidden = YES;
        _myCardView = view;
    }
    return _myCardView;
}
- (SYPersonHomepageVoiceCardAllocView *)allocCardView{
    if (!_allocCardView) {
        SYPersonHomepageVoiceCardAllocView*view = [[SYPersonHomepageVoiceCardAllocView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0)];
        view.delegate = self;
        view.hidden = YES;
        view.backgroundColor = [UIColor clearColor];
        _allocCardView = view;
    }
    return _allocCardView;
}


@end
