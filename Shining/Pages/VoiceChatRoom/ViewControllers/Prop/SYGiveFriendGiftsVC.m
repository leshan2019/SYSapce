//
//  SYGiveFriendGiftsVC.m
//  Shining
//
//  Created by 杨玄 on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiveFriendGiftsVC.h"
#import "ConversationAttentionView.h"
#import "SYUserServiceAPI.h"
#import "SYGiveFriendGiftCell.h"
#import "SYCommonTopNavigationBar.h"

#define SYGiveFriendGiftCellId @"SYGiveFriendGiftCellId"

@interface SYGiveFriendGiftsVC ()<UITableViewDelegate, UITableViewDataSource, SYNoNetworkViewDelegate, SYCommonTopNavigationBarDelegate>

// 导航条
@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
// 放loading的view
@property (nonatomic, strong) UIView *loadingBaseView;
// 关注列表
@property (nonatomic, strong) UITableView *attentionListView;
// 无关注提示
@property (nonatomic, strong) SYDataEmptyView *noAttentionView;
// 无网提示view
@property (nonatomic, strong) SYNoNetworkView *noNetworkView;
// 关注列表原始数据
@property (nonatomic, strong) NSArray<UserProfileEntity *> *attentionSourceData;
// 关注列表排序后的数据
@property (nonatomic, strong) NSMutableArray *sortedAttentionListData;
// 当前选择的index
@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation SYGiveFriendGiftsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.currentSelectIndex = -1;
    [self refreshAttentionListViewData];
}

#pragma mark - Private

- (void)setUpNavigationBarItems {
    // title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.font = [UIFont systemFontOfSize:16];
    title.text = @"我的关注";
    title.textColor = RGBACOLOR(11,11,11,1);
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;

    // 返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed_sy:@"back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];

    // 确定按钮
    UIButton *ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:RGBACOLOR(68,68,68,1) forState:UIControlStateNormal];
    ensureBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
    [ensureBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ensureItem = [[UIBarButtonItem alloc] initWithCustomView:ensureBtn];
    [self.navigationItem setRightBarButtonItem:ensureItem];

}

- (void)addSubviews {
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.loadingBaseView];
    [self.view addSubview:self.noAttentionView];
    [self.view addSubview:self.noNetworkView];
    [self.view addSubview:self.attentionListView];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.attentionListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 64 + 24 : 64);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.noAttentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 64 + 24 : 64);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)showLoadingView {
    [MBProgressHUD showHUDAddedTo:self.loadingBaseView animated:NO];
}

- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self.loadingBaseView animated:NO];
}

#pragma mark - DataGet

- (void)refreshAttentionListViewData {
    [self showLoadingView];
    // 获取关注列表
    __weak typeof(self)weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestFollowOrFansList:YES success:^(id  _Nullable response) {
        [weakSelf hideLoadingView];
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
        [weakSelf hideLoadingView];
        weakSelf.attentionSourceData = nil;
        weakSelf.sortedAttentionListData = nil;
        [weakSelf updateNoAttentionViewHidden];
    }];
}

- (void)sortAttentionListViewData:(NSArray *)dataArr {
    NSMutableArray *sortedArr = [self sortListData:dataArr];
    self.sortedAttentionListData = sortedArr;
    [self.attentionListView reloadData];
}

// 对关注列表中的数据进行排序
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

    // 不需要分组
    NSMutableArray *finalArr = [NSMutableArray array];
    NSDictionary *tempDic;
    NSArray *tempArr;
    for (int i = 0; i < sortedArr.count; i++) {
        tempDic = [sortedArr objectAtIndex:i];
        tempArr = [tempDic.allValues objectAtIndex:0];
        [finalArr addObjectsFromArray:tempArr];
    }
    return finalArr;
}

// 更新无关注view提示的显隐状态
- (void)updateNoAttentionViewHidden
{
    self.noAttentionView.hidden = self.sortedAttentionListData.count > 0;
    self.attentionListView.hidden = self.sortedAttentionListData.count == 0;

    if (![SYNetworkReachability isNetworkReachable]) {
        self.noAttentionView.hidden = YES;
        self.attentionListView.hidden = YES;
        self.noNetworkView.hidden = NO;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentSelectIndex != -1) {
        SYGiveFriendGiftCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectIndex inSection:0]];
        [cell updateSyGiveFriendCellSelectState:NO];
    }
    SYGiveFriendGiftCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell updateSyGiveFriendCellSelectState:YES];
    self.currentSelectIndex = indexPath.row;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sortedAttentionListData) {
        return self.sortedAttentionListData.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYGiveFriendGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:SYGiveFriendGiftCellId];
    if (!cell) {
        cell = [[SYGiveFriendGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYGiveFriendGiftCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger item = indexPath.row;
    UserProfileEntity *model = [self.sortedAttentionListData objectAtIndex:item];
    NSInteger age = [SYUtil ageWithBirthdayString:model.birthday];
    [cell updateCellWithHeaderImage:model.avatar_imgurl withName:model.username withGender:model.gender withAge:age withId:model.userid];
    BOOL select = item == self.currentSelectIndex;
    [cell updateSyGiveFriendCellSelectState:select];
    return cell;
}

#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    if ([SYNetworkReachability isNetworkReachable]) {
        self.noNetworkView.hidden = YES;
        [self refreshAttentionListViewData];
    } else {
        self.noNetworkView.hidden = NO;
        [SYToastView showToast:@"网络异常,请检查网络设置~"];
        return;
    }
}

#pragma mark -
- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSaveBtnClick {
    if (self.currentSelectIndex == -1) {
        [SYToastView showToast:@"请选择要赠送的好友"];
        return;
    }
    if (self.ensureBlock) {
        UserProfileEntity *model = [self.sortedAttentionListData objectAtIndex:self.currentSelectIndex];
        if (model && model.userid) {
            self.ensureBlock(model.userid);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazyload

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"我的关注" rightTitle:@"确定" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UITableView *)attentionListView {
    if (!_attentionListView) {
        _attentionListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];;
        _attentionListView.delegate = self;
        _attentionListView.dataSource = self;
        _attentionListView.showsVerticalScrollIndicator = NO;
        _attentionListView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _attentionListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _attentionListView.hidden = YES;
    }
    return _attentionListView;
}

- (SYDataEmptyView *)noAttentionView {
    if (!_noAttentionView) {
        _noAttentionView = [[SYDataEmptyView alloc] initWithFrame:CGRectZero
                                                     withTipImage:@"chat_no_attention"
                                                       withTipStr:@"你还没有关注任何人哦，赶紧去关注一下吧～"];
        _noAttentionView.hidden = YES;
    }
    return _noAttentionView;
}

- (SYNoNetworkView *)noNetworkView {
    if (!_noNetworkView) {
        CGFloat y = iPhoneX ? 64 + 24 : 64;
        CGRect frame = CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y);
        _noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:frame
                                                                  withDelegate:self];
        _noNetworkView.hidden = YES;
    }
    return _noNetworkView;
}

- (UIView *)loadingBaseView {
    if (!_loadingBaseView) {
        CGFloat y = iPhoneX ? 64 + 24 : 64;
        CGRect frame = CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y);
        _loadingBaseView = [[UIView alloc] initWithFrame:frame];
        _loadingBaseView.backgroundColor = [UIColor clearColor];
    }
    return _loadingBaseView;
}

@end
