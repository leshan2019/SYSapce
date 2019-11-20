//
//  SYContactViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYContactViewController.h"
#import "ConversationAttentionView.h"
#import "SYSwitchPagesControl.h"
#import "ConversationAttentionCell.h"
#import "ConversationAttentionView.h"
#import "SYUserServiceAPI.h"
#import "SYChatViewController.h"
#import "SYPersonHomepageVC.h"
#import "SYVoiceChatRoomManager.h"

@interface SYContactViewController ()<SYSwitchPagesControlDelegate, ConversationAttentionViewDelegate,SYNoNetworkViewDelegate>

// 聊天&关注 - 控件
@property (nonatomic, strong) SYSwitchPagesControl *topControl;
// 关注列表
@property (nonatomic, strong) ConversationAttentionView *attentionListView;
// 粉丝列表
@property (nonatomic, strong) ConversationAttentionView *fansListView;
// 无关注提示
@property (nonatomic, strong) SYDataEmptyView *noAttentionView;

// 关注列表原始数据
@property (nonatomic, strong) NSArray<UserProfileEntity *> *attentionSourceData;
// 关注列表排序后的数据
@property (nonatomic, strong) NSMutableArray *sortedAttentionListData;

// 粉丝列表原始数据
@property (nonatomic, strong) NSArray<UserProfileEntity *> *fansSourceData;
// 粉丝列表排序后的数据
@property (nonatomic, strong) NSMutableArray *sortedfansListData;

@property (nonatomic, strong) SYNoNetworkView *noNetworkView;       // 无网提示view

@end

@implementation SYContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:SYNetworkingReachabilityDidChangeNotification
                                               object:nil];
    [self seupBarButtonItem];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    self.title = @"通讯录";
    
    [self.view addSubview:self.topControl];
    [self.view addSubview:self.attentionListView];
    [self.view addSubview:self.noAttentionView];
    [self.view addSubview:self.fansListView];
    [self.view addSubview:self.noNetworkView];
    
    self.fansListView.hidden = YES;
    self.attentionListView.hidden = NO;
    self.noNetworkView.hidden = YES;
    
    [self.topControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(iPhoneX ? 88 : 64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.attentionListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topControl.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.noAttentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topControl.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.fansListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topControl.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self sy_configDataInfoPageName:SYPageNameType_IM_Contact];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(245, 246, 247, 1);
    [self refreshView];
}

- (void)setSelectPage:(NSInteger)selectIndex {
    self.topControl.selectedControl = selectIndex;
}

- (void)networkChanged:(id)sender {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络中断，请检查网络"];
        //TODO:显示无网页面
//        self.fansListView.hidden = YES;
//        self.attentionListView.hidden = YES;
        if (!self.noAttentionView.hidden) {
            self.noAttentionView.hidden = YES;
            self.noNetworkView.hidden = NO;
            [self.view bringSubviewToFront:self.topControl];
        }
       
    } else {
        self.noNetworkView.hidden = YES;
        [self refreshView];
    }
    
}

- (void)seupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed_sy:@"back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (SYSwitchPagesControl *)topControl {
    if (!_topControl) {
        _topControl = [[SYSwitchPagesControl alloc] initWithFrame:CGRectZero];
        _topControl.delegate = self;
        _topControl.selectedControl = 0;
        [_topControl configueCustomUIWithTitle:@[@"关注",@"粉丝"] withNormalColors:nil withSelectedColors:nil];
    }
    return _topControl;
}

- (ConversationAttentionView *)attentionListView {
    if (!_attentionListView) {
        _attentionListView = [[ConversationAttentionView alloc] initWithFrame:CGRectZero];
        _attentionListView.delegate = self;
    }
    return _attentionListView;
}

- (ConversationAttentionView *)fansListView {
    if (!_fansListView) {
        _fansListView = [[ConversationAttentionView alloc] initWithFrame:CGRectZero];
        _fansListView.delegate = self;
    }
    return _fansListView;
}

- (SYDataEmptyView *)noAttentionView {
    if (!_noAttentionView) {
        _noAttentionView = [[SYDataEmptyView alloc] initWithFrame:CGRectZero
                                                     withTipImage:@"chat_no_attention"
                                                       withTipStr:@"你还没有关注任何人哦，赶紧去关注一下呗～"];
    }
    return _noAttentionView;
}

- (SYNoNetworkView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.topControl.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.topControl.frame))
                                                                  withDelegate:self];
    }
    return _noNetworkView;
}


#pragma mark - 关注列表

- (void)refreshAttentionListViewData {
    // 获取关注列表
    __weak typeof(self)weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestFollowOrFansList:YES success:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYUserListModel class]]) {
            SYUserListModel *listModel = (SYUserListModel *)response;
            self.attentionSourceData = listModel.Users;
            if (self.attentionSourceData.count > 0) {
                [weakSelf sortAttentionListViewData:self.attentionSourceData];
            } else {
                weakSelf.attentionSourceData = nil;
                weakSelf.sortedAttentionListData = nil;
            }
            [weakSelf updateNoAttentionViewHidden];
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.attentionSourceData = nil;
        weakSelf.sortedAttentionListData = nil;
        [weakSelf updateNoAttentionViewHidden];
    }];
}

// 对关注列表中的数据进行排序-分组-得到最终要的数据结构
- (NSMutableArray *)sortListData:(NSArray *)dataArr{
    NSMutableArray *sortedArr = [NSMutableArray array];
    NSMutableArray *unknowArr = [NSMutableArray array];         // "#" 存放姓名异常的model
    
    // UserProfileEntity
    NSMutableDictionary *sourceDic = [NSMutableDictionary dictionary];
    // 26英文字母
    NSArray *letterArr = @[@"A",@"B",@"C",@"D",@"E",
                           @"F",@"G",@"H",@"I",@"J",
                           @"K",@"L",@"M",@"N",@"O",
                           @"P",@"Q",@"R",@"S",@"T",
                           @"U",@"V",@"W",@"X",@"Y",
                           @"Z"];
    // 初始化数据源
    for (int i = 0; i < letterArr.count; i++) {
        NSMutableArray *tempArr = [NSMutableArray array];
        NSString *tempKey = [letterArr objectAtIndex:i];
        [sourceDic setValue:tempArr forKey: tempKey];
    }
    
    // 筛选数据
    for (int i = 0; i < dataArr.count; i++) {
        UserProfileEntity *model = [dataArr objectAtIndex:i];
        NSString *initalNum = [model firstLetterWithUserName];
        if ([letterArr containsObject:initalNum]) {
            NSMutableArray *tempArr = [sourceDic valueForKey:initalNum];
            [tempArr addObject:model];
        } else {
            [unknowArr addObject:model];
        }
    }
    
    // 得到最终数据
    [sourceDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *tempKey = (NSString *)key;
        NSMutableArray *tempArr = (NSMutableArray *)obj;
        if (tempArr.count > 0) {
            NSDictionary *tempDic = [NSDictionary dictionaryWithObject:tempArr forKey:tempKey];
            [sortedArr addObject:tempDic];
        }
    }];
    
    // 排序
    [sortedArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *dic1 = (NSDictionary *)obj1;
        NSString *str1 = [dic1.allKeys objectAtIndex:0];
        NSInteger asciiCode1 = [str1 characterAtIndex:0];
        NSDictionary *dic2 = (NSDictionary *)obj2;
        NSString *str2 = [dic2.allKeys objectAtIndex:0];
        NSInteger asciiCode2 = [str2 characterAtIndex:0];
        return asciiCode1 > asciiCode2;
    }];
    
    // 姓名异常处理 - 可能为空，可能都是笑脸等
    if (unknowArr.count > 0) {
        NSDictionary *unknownDic = [NSDictionary dictionaryWithObject:unknowArr forKey:@"#"];
        [sortedArr addObject:unknownDic];
    }
    return sortedArr;
}

- (void)sortAttentionListViewData:(NSArray *)dataArr {
    NSMutableArray *sortedArr = [self sortListData:dataArr];
    
    self.sortedAttentionListData = sortedArr;
    [self.attentionListView reloadAttentionViewWithDataSource:sortedArr];
}

// 更新无关注view提示的显隐状态
- (void)updateNoAttentionViewHidden
{
    if (self.topControl.selectedControl == 0) {
        self.noAttentionView.hidden = (self.sortedAttentionListData.count>0);
        
        self.attentionListView.hidden = !self.noAttentionView.hidden;
        self.fansListView.hidden =YES;
    }else{
        self.noAttentionView.hidden = (self.sortedfansListData.count>0);
        
        self.attentionListView.hidden = YES;
        self.fansListView.hidden = !self.noAttentionView.hidden;
    }
    
    if (![SYNetworkReachability isNetworkReachable] && !self.noAttentionView.hidden) {
        self.noAttentionView.hidden = YES;
        self.attentionListView.hidden = YES;
        self.fansListView.hidden =YES;
        self.noNetworkView.hidden = NO;
        [self.view bringSubviewToFront:self.topControl];
    }
    
    if (!self.noAttentionView.hidden) {
        [self.noAttentionView updateTipText:(self.topControl.selectedControl == 0)?@"你还没有关注任何人哦，赶紧去关注一下呗～":@"提高您的活跃度，能给您带来粉丝哦"];
    }
}

- (void)refreshfansListViewData
{
    // 获取粉丝列表
    __weak typeof(self)weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestFollowOrFansList:NO success:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYUserListModel class]]) {
            SYUserListModel *listModel = (SYUserListModel *)response;
            weakSelf.fansSourceData = listModel.Users;
            if (weakSelf.fansSourceData.count > 0) {
                [weakSelf sortfansListViewData:self.fansSourceData];
            } else {
                weakSelf.fansSourceData = nil;
                weakSelf.sortedfansListData = nil;
            }
            [weakSelf updateNoAttentionViewHidden];
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.fansSourceData = nil;
        weakSelf.sortedfansListData = nil;
        [weakSelf updateNoAttentionViewHidden];
    }];
}

- (void)sortfansListViewData:(NSArray *)dataArr {
    NSMutableArray *sortedArr = [self sortListData:dataArr];
    
    self.sortedfansListData = sortedArr;
    [self.fansListView reloadAttentionViewWithDataSource:sortedArr];
}

- (void)refreshView
{
    if(self.topControl.selectedControl == 0){
        [self refreshAttentionListViewData];
    }else{
        [self refreshfansListViewData];
    }
}

#pragma mark - SYSwitchPagesControlDelegate

- (void)handleSwitchPagesControlLeftBtnClickEvent {
    self.attentionListView.hidden = NO;
    self.fansListView.hidden =YES;
//    [self updateNoAttentionViewHidden];
    [self refreshAttentionListViewData];
}

- (void)handleSwitchPagesControlRightBtnClickEvent {
    self.attentionListView.hidden = YES;
    self.fansListView.hidden =NO;
//    [self updateNoAttentionViewHidden];

    [self refreshfansListViewData];
}

#pragma mark - ConversationAttentionViewDelegate

- (void)conversationAttentionView:(ConversationAttentionView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sortedArray = [NSArray arrayWithArray:self.sortedAttentionListData];
    if (view == self.fansListView) {
        sortedArray = [NSArray arrayWithArray:self.sortedfansListData];
    }
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    UserProfileEntity *clickModel = nil;
    if (sortedArray && section < sortedArray.count) {
        NSDictionary *tempDic = [sortedArray objectAtIndex:section];
        NSMutableArray *subArr = [tempDic.allValues objectAtIndex:0];
        if (subArr.count > 0 && item < subArr.count) {
            clickModel = [subArr objectAtIndex:item];
        }
    }
    // 处理用户点击关注列表单个cell事件
    if (clickModel && clickModel.userid) {
        SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
        vc.userId = clickModel.userid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)conversationAttentionView:(ConversationAttentionView *)view enterChatRoomWithRoomId:(NSString *)roomId {
    if ([NSString sy_isBlankString:roomId]) {
        [SYToastView showToast:@"房间信息获取失败"];
        return;
    }
    [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:roomId from:SYVoiceChatRoomFromTagAttentionList];
}

#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    if ([SYNetworkReachability isNetworkReachable]) {
        self.noNetworkView.hidden = YES;
        [self refreshView];
    } else {
        self.noNetworkView.hidden = NO;
        [SYToastView showToast:@"网络异常~"];
        return;
    }
}

@end
