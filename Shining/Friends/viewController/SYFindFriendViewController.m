//
//  SYFindFriendViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYFindFriendViewController.h"
#import "SYVoiceCardView.h"
#import "SYAPPServiceAPI.h"
#import "ShiningSdkManager.h"
#import "SYVoiceCardGroupView.h"
#import "SYUserServiceAPI.h"
#import "SYChatViewController.h"
#import "ChatHelper.h"
#import "SYPersonHomepageVoiceCardVC.h"
#import "SYNeedLoginView.h"
#import "SYPersonHomepageVC.h"

@interface SYFindFriendViewController () <SYVoiceCardGroupViewDelegate, SYVoiceCardGroupViewDataSource>
@property (nonatomic, strong)UIImageView *bgView;
@property (nonatomic, strong)UILabel *leftNavLabel;
@property (nonatomic, strong)UIButton *rightNavBtn;
@property (nonatomic, strong)SYVoiceCardGroupView *voiceCardGroupView;
@property (nonatomic, strong)SYDataEmptyView *noDataTipView;
@property (nonatomic, strong)SYNeedLoginView *needLoginTipView;
@property (nonatomic, strong)NSMutableArray *voiceCardList;
@property (nonatomic, strong)NSArray *prepareVoiceCardList; //预备的下一组卡片组数据
@property (nonatomic, assign)NSInteger currentIndex;
@property(nonatomic,strong)  AVAudioPlayer *audioPlayer ;
// SDK - 新增返回按钮
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation SYFindFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIndex = 0;
    [self addNotification];
    float scaleHeight = __MainScreen_Height/896;

    [self.view addSubview:self.bgView];

    [self.view addSubview:self.leftNavLabel];
    [self.view addSubview:self.rightNavBtn];
    [self.view addSubview:self.voiceCardGroupView];
    [self.view addSubview:self.noDataTipView];
    [self.view addSubview:self.needLoginTipView];

    #ifdef ShiningSdk
        [self.view addSubview:self.backBtn];
    #endif

    [self.noDataTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset((iPhoneX ? 88 : 64));
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.needLoginTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
#ifdef ShiningSdk
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 28));
        make.left.equalTo(self.view).with.offset(7);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 24+28 : 28);
    }];
    [self.leftNavLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.view).with.offset((iPhoneX ? 44 : 20)+8);
       make.left.equalTo(self.backBtn.mas_right).with.offset(8);
       make.size.mas_equalTo(CGSizeMake(88, 26));
    }];
#else
    [self.leftNavLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset((iPhoneX ? 44 : 20)+8);
        make.left.equalTo(self.view).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(88, 26));
    }];
#endif
    
    [self.rightNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset((iPhoneX ? 44 : 20)+15);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(88, 30));
    }];
    
    [self.voiceCardGroupView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightNavBtn.mas_bottom).with.offset(31*scaleHeight);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-106+ (iPhoneX ? -34 : 0));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([NSString sy_isBlankString:[SYSettingManager accessToken]]){
        self.needLoginTipView.hidden =NO;
        self.voiceCardList = nil;
        self.noDataTipView.hidden = YES;
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateHighlighted];
    }else{
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateHighlighted];
        self.needLoginTipView.hidden = YES;
        [self requestVociCardList];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    self.voiceCardList = nil;
}

- (void)dealloc {
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    [self removeNotification];
}


#pragma mark - layz load
- (UILabel *)leftNavLabel {
    if (!_leftNavLabel) {
        _leftNavLabel = [UILabel new];
        _leftNavLabel.textColor = [UIColor whiteColor];
        _leftNavLabel.text = @"找朋友";
        _leftNavLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
    }
    return _leftNavLabel;
}

- (UIButton *)rightNavBtn {
    if (!_rightNavBtn) {
        _rightNavBtn = [UIButton new];
        [_rightNavBtn setBackgroundImage:[UIImage imageNamed_sy:@"myvoicecard_btn_bg"] forState:UIControlStateNormal];
        [_rightNavBtn setTitle:@"我的名片" forState:UIControlStateNormal];
        _rightNavBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_rightNavBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightNavBtn addTarget:self action:@selector(goToMyVoiceCard) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightNavBtn;
}

- (UIImageView *)bgView {
    if(!_bgView){
        _bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _bgView.image = [UIImage imageNamed_sy:@"findfrend_bg"];
    }
    return _bgView;
}

- (SYVoiceCardGroupView *)voiceCardGroupView {
    if (!_voiceCardGroupView) {
        _voiceCardGroupView = [[SYVoiceCardGroupView alloc] initWithFrame:CGRectMake(20, (iPhoneX ? 44 : 20)+76, self.view.sy_width-40, self.view.sy_height-(iPhoneX ? 88 : 64)- 20- 44 -90)];
        _voiceCardGroupView.backgroundColor = [UIColor clearColor];
        _voiceCardGroupView.delegate = self;
        _voiceCardGroupView.dataSource = self;
    }
    return _voiceCardGroupView;
}

- (SYDataEmptyView *)noDataTipView {
    if (!_noDataTipView) {
        _noDataTipView = [[SYDataEmptyView alloc] initWithFrame:CGRectZero
                                                   withTipImage:@"voicecard_network_error"
                                                     withTipStr:@"别紧张，请检查网络后刷新页面"];
        _noDataTipView.backgroundColor = [UIColor clearColor];
        [_noDataTipView updataForBtn:self action:@selector(requestVociCardList)];

        _noDataTipView.hidden =YES;
        
    }
    return _noDataTipView;
}

- (SYNeedLoginView *)needLoginTipView {
    if (!_needLoginTipView) {
        _needLoginTipView = [[SYNeedLoginView alloc] initWithFrame:CGRectZero
                                                   withTipImage:@"friend_needlogin"
                                                     withTipStr:@"您需要登录，才可以为您匹配合适的小伙伴哦～"];
//        _noDataTipView.backgroundColor = [UIColor clearColor];
        [_needLoginTipView updateForLoginTip:self action:@selector(login)];
        _needLoginTipView.hidden =YES;
        
    }
    return _needLoginTipView;
}

- (NSMutableArray *)voiceCardList {
    if (!_voiceCardList) {
        _voiceCardList = [NSMutableArray array];
    }
    return _voiceCardList;
}

- (NSArray *)prepareVoiceCardList {
    if (!_prepareVoiceCardList) {
        _prepareVoiceCardList = [NSArray array];
    }
    return _prepareVoiceCardList;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(handleBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
#pragma mark -notification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusChanged:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)loginStatusChanged:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    BOOL login = [noti.object boolValue];
    if (!login) {
        self.needLoginTipView.hidden =NO;
        self.voiceCardList = nil;
        self.noDataTipView.hidden = YES;
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateHighlighted];
    }else{
        self.needLoginTipView.hidden = YES;
        [self requestVociCardList];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateHighlighted];
    }
}

#pragma mark -private
- (void)requestVociCardList
{
    if (![SYNetworkReachability isNetworkReachable]) {
        self.voiceCardList = nil;
        [self.voiceCardGroupView reloadData];
        [self refreshNoDataTip];
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.currentIndex = 0;
    [[SYAPPServiceAPI sharedInstance]requestSoundMatch:^(NSArray * _Nullable list) {
        if ([NSObject sy_empty:list]  || list.count == 0) {
            //TODO
            self.voiceCardList = nil;
            [weakSelf refreshNoDataTip];
            return;
        }
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<list.count; i++) {
            NSDictionary *dict =  list[i];
            SYVoiceMatchUserModel *model = [SYVoiceMatchUserModel yy_modelWithDictionary:dict];
            [array addObject:model];
        }
        if (weakSelf.voiceCardList.count>0) {
            weakSelf.prepareVoiceCardList = [NSMutableArray arrayWithArray:array];
        }else{
            weakSelf.voiceCardList = [NSMutableArray arrayWithArray:array];
            [weakSelf.voiceCardGroupView reloadData];
        }
       
        [weakSelf refreshNoDataTip];


    } failure:^(NSError * _Nullable error) {
        [self refreshNoDataTip];
    }];
}

- (void)refreshNoDataTip
{
    if (self.voiceCardList.count <=0) {
        self.noDataTipView.hidden = NO;
    }else{
        self.noDataTipView.hidden = YES;
    }
}

- (void)login
{
    [ShiningSdkManager checkLetvAutoLogin:self];
}

- (void)goToMyVoiceCard
{
    SYPersonHomepageVoiceCardVC* vc = [[SYPersonHomepageVoiceCardVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToChatVC:(SYVoiceMatchUserModel *)model
{
    if (!model) {
        return;
    }
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    
    UserProfileEntity *toUser = [UserProfileEntity new];
    toUser.userid = model.userid;
    toUser.em_username = model.em_username;
    
    UIViewController *chatController = [[SYChatViewController alloc] initWithUserProfileEntity:toUser];
    chatController.title = model.username;
    [self.navigationController pushViewController:chatController animated:YES];
    
    NSString *userInfoStr =  [user yy_modelToJSONString];
    [[ChatHelper shareHelper]sendMessage:@"很喜欢你的声音哦～期待认识你" type:EMChatTypeChat fromId:user.em_username toId:toUser.em_username ext:@{extSyUserInfo:userInfoStr}];
   
}

- (void)startPlayNewVoice:(NSString *)voiceUrl{
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }

    UIViewController *currentVC =[self currentViewController];
    if (![currentVC isKindOfClass:[SYFindFriendViewController class]]) {
        return;
    }
    
    if ([NSString sy_isBlankString:voiceUrl]) {
        return;
    }
    

    NSURL *urlFile = [NSURL URLWithString:voiceUrl];
    NSData *data=[[NSData alloc]initWithContentsOfURL:urlFile];
    NSError *error;
    @try {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    }@catch(id anException){
    }
    if (self.audioPlayer) {
        self.audioPlayer.numberOfLoops = -1;
        self.audioPlayer.enableRate = NO; // 设置为 YES 可以控制播放速率
        self.audioPlayer.volume = 1;
        if ([self.audioPlayer prepareToPlay])
        {
            [self.audioPlayer play];
        }
        
    }else {
        NSLog(@"创建播放器出错 error: %@",[error localizedDescription]);
    }
}

- (void)showDialog {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"录制自己的声音名片，才可以和小伙伴打招呼哦～"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        [self goToMyVoiceCard];
                                                    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - SYVoiceCardGroupViewDelegate
- (NSInteger)numberOfItemViewsInCardView:(SYVoiceCardGroupView *)cardView {
    return self.voiceCardList.count;
}

- (SYVoiceCardView *)cardView:(SYVoiceCardGroupView *)cardView itemViewAtIndex:(NSInteger)index {
    SYVoiceCardView *itemView = [[SYVoiceCardView alloc] initWithFrame:cardView.bounds];
    if (self.voiceCardList.count>index) {
        SYVoiceMatchUserModel *model = self.voiceCardList[index];
        [itemView updateUIByUser:model];
        
    }
   
    return itemView;
}

- (void)cardViewNeedMoreData:(SYVoiceCardGroupView *)cardView {
    if (self.prepareVoiceCardList.count>0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.prepareVoiceCardList];
        SYVoiceCardView *itemView = (SYVoiceCardView *)cardView.subviews.lastObject;
        NSInteger index = itemView.tag -1 ;
        if (self.voiceCardList.count > index) {
            SYVoiceMatchUserModel *model = self.voiceCardList[index];
            if (model) {
                [array insertObject:model atIndex:0];
            }
        }
        self.voiceCardList = [NSMutableArray arrayWithArray:array];
        self.prepareVoiceCardList = nil;
        [self.voiceCardGroupView reloadData];
        [self refreshNoDataTip];
    }else{
        [self requestVociCardList];
    }
}

- (void)showCurrentCardItem:(SYVoiceCardView *)cardItemView index:(NSInteger)index
{
    if (self.voiceCardList.count>index && self.voiceCardList.count>0) {
        SYVoiceMatchUserModel *model = self.voiceCardList[index];
        [self startPlayNewVoice:model.voice_url];
        [cardItemView showAnimationPlayer];
    }
}

// select
- (void)cardView:(SYVoiceCardGroupView *)cardView didClickItemAtIndex:(NSInteger)index {
    
}

- (void)attentionUser:(SYVoiceCardView *)cardItemView {
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    if ([NSString sy_isBlankString: user.voice_url]) {
        [self showDialog];
        return;
    }
    NSInteger index = cardItemView.tag -1;
    if (self.voiceCardList.count>index && self.voiceCardList.count>0){
          SYVoiceMatchUserModel *model = self.voiceCardList[index];
        if ([model.is_concern isEqualToString:@"1"]) {
            [[SYUserServiceAPI sharedInstance] requestCancelFollowUserWithUid:model.userid
                                                                success:^(id  _Nullable response) {
                                                                    model.is_concern = @"0";
                                                                    [cardItemView updateUIByUser:model];
                                                                    [SYToastView showToast:@"取消关注"];
                                                                } failure:^(NSError * _Nullable error) {
                                                                    
                                                                }];

        }else{
            [[SYUserServiceAPI sharedInstance] requestFollowUserWithUid:model.userid
                                                                success:^(id  _Nullable response) {
                                                                    model.is_concern = @"1";
                                                                    [cardItemView updateUIByUser:model];
                                                                    [SYToastView showToast:@"关注成功"];
                                                                } failure:^(NSError * _Nullable error) {
                                                                    
                                                                }];
        }
      
    }
   
}
- (void)contact:(SYVoiceCardView *)cardItemView {
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    if ([NSString sy_isBlankString: user.voice_url]) {
        [self showDialog];
        return;
    }
    NSInteger index = cardItemView.tag -1;
    if (self.voiceCardList.count>index && self.voiceCardList.count>0){
        SYVoiceMatchUserModel *model = self.voiceCardList[index];
        [self goToChatVC:model];

    }
}

- (void)gotoUserinfo:(SYVoiceCardView *)cardItemView
{
    NSInteger index = cardItemView.tag -1;
    NSString *uid = @"";
    if (self.voiceCardList.count<=index){
        return;
    }
    SYVoiceMatchUserModel *model = self.voiceCardList[index];
    uid = model.userid;
    
    SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
    vc.userId = uid;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

// 返回
- (void)handleBackBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
