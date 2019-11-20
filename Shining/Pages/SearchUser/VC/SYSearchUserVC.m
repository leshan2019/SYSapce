//
//  SYSearchUserVC.m
//  Shining
//
//  Created by 杨玄 on 2019/9/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSearchUserVC.h"
#import "SYSearchUserCell.h"
#import "SYSearchUserViewModel.h"
#import "SYPersonHomepageVC.h"
#import "SYNavigationController.h"

#define HistoryMaxCount 6
#define HistoryCellTitleTag 123
#define HistoryCellBottomLineTag 456
#define SearchUserCellId @"SearchUserCellId"

@interface SYSearchUserVC ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UITextFieldDelegate>

// SearchBar
@property (nonatomic, strong) UIView *searchBarBg;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelSearchBtn;

@property (nonatomic, strong) UIView *loadingBaseView;              // 放loading的view
@property (nonatomic, strong) UIButton *cancelBtn;                  // 取消
@property (nonatomic, strong) UILabel *tipLabel;                    // 没有搜索到相关信息
// 搜索历史
@property (nonatomic, strong) UILabel *historyHeadLabel;            // 搜索历史
@property (nonatomic, strong) UIButton *historyCleanBtn;            // @“清空搜索历史”
@property (nonatomic, strong) UICollectionView *historyListView;    // 搜索历史列表
@property (nonatomic, strong) NSArray *historyDatas;                // 搜索历史data
// 搜索用户
@property (nonatomic, strong) UILabel *userHeadLabel;               // 用户&搜索历史
@property (nonatomic, strong) UICollectionView *userListView;       // 搜索结果列表
// Viewmodel
@property (nonatomic, strong) SYSearchUserViewModel *viewModel;     // ViewModel

@end

@implementation SYSearchUserVC

- (void)dealloc {
    [self removeNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.searchBar.text.length == 0) {
        [self showUserAboutView:NO];
        [self updateHistoryView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

#pragma mark - **Private**

- (void)initSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBarBg];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.userHeadLabel];
    [self.view addSubview:self.userListView];
    [self.view addSubview:self.historyHeadLabel];
    [self.view addSubview:self.historyCleanBtn];
    [self.view addSubview:self.historyListView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.loadingBaseView];
    [self mas_makeContraints];
    [self addTextFieldChangeNotification];
}

- (void)mas_makeContraints {
    [self.searchBarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(13);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 26 + 24 : 26);
        make.height.mas_equalTo(32);
        make.right.equalTo(self.view).with.offset(-68);
    }];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBarBg).with.offset(6);
        make.centerY.equalTo(self.searchBarBg);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.cancelSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchBarBg).with.offset(-10);
        make.centerY.equalTo(self.searchBarBg);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchIcon.mas_right).with.offset(8);
        make.centerY.equalTo(self.searchBarBg);
        make.height.mas_equalTo(32);
        make.right.equalTo(self.cancelSearchBtn.mas_left);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-20);
        make.centerY.equalTo(self.searchBarBg);
        make.size.mas_equalTo(CGSizeMake(28, 17));
    }];
    [self.userHeadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBarBg.mas_bottom).with.offset(6);
        make.left.equalTo(self.view).with.offset(13);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.userListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.userHeadLabel.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -34 : 0);
    }];
    [self.historyHeadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBarBg.mas_bottom).with.offset(6);
        make.left.equalTo(self.view).with.offset(13);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.historyCleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.historyHeadLabel);
        make.right.equalTo(self.view).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.historyListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.historyHeadLabel.mas_bottom);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(126, 17));
        make.top.equalTo(self.searchBarBg.mas_bottom).with.offset(78);
    }];
    [self.loadingBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(iPhoneX ? (24 + 64) : 64);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -34 : 0);
    }];
}

- (void)clickCancelBtn {
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearSearchBarContents {
    [self.searchBar becomeFirstResponder];
    self.searchBar.text = @"";
    [self searchBarTextDidChange];
}

- (void)addTextFieldChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchBarTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - *UITextFieldDelegate**

- (void)searchBarTextDidChange{
    self.tipLabel.hidden = YES;
    if (self.searchBar.text.length > 0) {
        self.cancelSearchBtn.hidden = NO;
        [self showHistoryAboutView:NO];
        self.tipLabel.hidden = YES;
    } else {
        self.cancelSearchBtn.hidden = YES;
        [self updateHistoryView];
        [self showUserAboutView:NO];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.cancelSearchBtn.hidden = !(textField.text.length > 0);
    return YES;
}
// 搜索按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *searchText = textField.text;
    if (searchText.length == 0) {
        [SYToastView showToast:@"请输入用户ID或昵称"];
        return NO;
    }
    [self searchUserByKeyword:searchText];
    return YES;
}

#pragma mark - **搜索结果**

- (void)searchUserByKeyword:(NSString *)keyword {
    [self saveSearchUserId:keyword];
    __weak typeof(self)weakSelf = self;
    [self showLoadingView];
    [self.viewModel searchUserByKeyword:keyword success:^(BOOL success) {
        [weakSelf hideLoadingView];
        if (success) {
            [weakSelf.searchBar resignFirstResponder];
            [weakSelf showUserAboutView:YES];
            [weakSelf showHistoryAboutView:NO];
            weakSelf.tipLabel.hidden = YES;
            [weakSelf.userListView reloadData];
        } else {
            [weakSelf showHistoryAboutView:NO];
            [weakSelf showUserAboutView:NO];
            weakSelf.tipLabel.hidden = NO;
        }
    }];
}

- (void)showUserAboutView:(BOOL)show {
    self.userHeadLabel.hidden = !show;
    self.userListView.hidden = !show;
}

#pragma mark - **搜索历史**

- (void)updateHistoryView {
    BOOL hasHistory = [self hasSearchHistory];
    [self showHistoryAboutView:hasHistory];
    if (hasHistory) {
        NSInteger count = self.historyDatas.count;
        [self.historyListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(count > HistoryMaxCount ? HistoryMaxCount *44 : count*44);
        }];
        [self.historyListView reloadData];
    }
}

- (void)saveSearchUserId:(NSString *)userId{
    [SYSettingManager saveSearchHistoryUserId:userId];
}

- (BOOL)hasSearchHistory {
    NSArray *historys = [SYSettingManager getSearchHistoryUserIds];
    self.historyDatas = [historys mutableCopy];
    return self.historyDatas.count > 0;
}

- (void)clickCleanHistornBtn {
    [SYSettingManager cleanSearchHistroy];
    [self updateHistoryView];
}

- (void)showHistoryAboutView:(BOOL)show {
    self.historyHeadLabel.hidden = !show;
    self.historyCleanBtn.hidden = !show;
    self.historyListView.hidden = !show;
}

#pragma mark - **LoadingView**

- (void)showLoadingView {
    self.loadingBaseView.hidden = NO;
    [MBProgressHUD showHUDAddedTo:self.loadingBaseView animated:NO];
}

- (void)hideLoadingView {
    self.loadingBaseView.hidden = YES;
    [MBProgressHUD hideHUDForView:self.loadingBaseView animated:NO];
}

#pragma mark - **UIScrollViewDelegate**

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.userListView) {
        if (self.searchBar.isFirstResponder) {
            [self.searchBar resignFirstResponder];
        }
    }
}

#pragma mark - **UICollectionViewDelegate**

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    if (collectionView == self.historyListView) {
        NSString *searchText = [self.historyDatas objectAtIndex:indexPath.item];
        self.searchBar.text = searchText;
        [self searchUserByKeyword:searchText];
        self.cancelSearchBtn.hidden = NO;
    } else {
        NSString *userId = [self.viewModel userId:indexPath];
#ifdef ShinigSdk
        SYPersonHomepageVC *vc = [SYPersonHomepageVC new];
        vc.userId = userId;
        SYNavigationController *nvigaton = [[SYNavigationController alloc] initWithRootViewController:vc];
        [self.navigationController pushViewController:nvigaton animated:YES];
#else
        SYPersonHomepageVC *vc = [SYPersonHomepageVC new];
        vc.userId = userId;
        [self.navigationController pushViewController:vc animated:YES];
#endif

    }
}

#pragma mark - **UICollectionViewDatasource**

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.historyListView) {
        if (self.historyDatas && self.historyDatas.count > 0) {
            return self.historyDatas.count;
        }
    } else {
        return [self.viewModel numberOfRows];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.historyListView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SYSearchHistoryCellId" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [cell viewWithTag:HistoryCellTitleTag];
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] initWithFrame:
                          CGRectMake(13, 13, 200, 17)];
            titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
            titleLabel.textColor = RGBACOLOR(11,11,11,1);
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.tag = HistoryCellTitleTag;
            [cell.contentView addSubview:titleLabel];
        }
        titleLabel.text = [self.historyDatas objectAtIndex:indexPath.item];
        UIView *bottomLine = [cell viewWithTag:HistoryCellBottomLineTag];
        if (!bottomLine) {
            bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, self.view.sy_width, 0.5)];
            bottomLine.backgroundColor = RGBACOLOR(0,0,0,0.08);
            bottomLine.tag = HistoryCellBottomLineTag;
            [cell.contentView addSubview:bottomLine];
        }
        return cell;
    } else {
        SYSearchUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SearchUserCellId forIndexPath:indexPath];
        NSString *headUrl = [self.viewModel headUrl:indexPath];;
        NSString *name = [self.viewModel name:indexPath];
        NSString *gender = [self.viewModel gender:indexPath];
        NSInteger age = [self.viewModel age:indexPath];
        NSString *userId = [self.viewModel userId:indexPath];
        NSString *bestId = [self.viewModel bestId:indexPath];
        NSInteger level = [self.viewModel level:indexPath];
        NSString *showId = [bestId integerValue] > 0 ? bestId : userId;
        [cell updateSYSearchUserViewWithHeaderUrl:headUrl name:name gender:gender age:age userId:showId level:level];
        return cell;
    }
}

#pragma mark - **Lazyload**

- (UIView *)searchBarBg {
    if (!_searchBarBg) {
        _searchBarBg = [UIView new];
        _searchBarBg.backgroundColor = RGBACOLOR(247,247,247,1);
        _searchBarBg.layer.cornerRadius = 16;
        [_searchBarBg addSubview:self.searchIcon];
        [_searchBarBg addSubview:self.searchBar];
        [_searchBarBg addSubview:self.cancelSearchBtn];
    }
    return _searchBarBg;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [UIImageView new];
        _searchIcon.image = [UIImage imageNamed_sy:@"sy_search_icon"];
    }
    return _searchIcon;
}

- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [UITextField new];
        _searchBar.placeholder = @"请输入用户ID或昵称";
        _searchBar.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _searchBar.textColor = RGBACOLOR(11,11,11,1);
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIButton *)cancelSearchBtn {
    if (!_cancelSearchBtn) {
        _cancelSearchBtn = [UIButton new];
        [_cancelSearchBtn setImage:[UIImage imageNamed_sy:@"sy_search_cancel_icon"] forState:UIControlStateNormal];
        [_cancelSearchBtn addTarget:self action:@selector(clearSearchBarContents) forControlEvents:UIControlEventTouchUpInside];
        _cancelSearchBtn.hidden = YES;
    }
    return _cancelSearchBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBACOLOR(11,11,11,1) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"没有搜索到相关信息";
        _tipLabel.textColor = RGBACOLOR(153,153,153,1);
        _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

- (UILabel *)userHeadLabel {
    if (!_userHeadLabel) {
        _userHeadLabel = [UILabel new];
        _userHeadLabel.text = @"用户";
        _userHeadLabel.textColor = RGBACOLOR(11,11,11,1);
        _userHeadLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _userHeadLabel.textAlignment = NSTextAlignmentLeft;
        _userHeadLabel.hidden = YES;
    }
    return _userHeadLabel;
}

- (UICollectionView *)userListView {
    if (!_userListView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(self.view.sy_width, 72);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _userListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _userListView.delegate = self;
        _userListView.dataSource = self;
        _userListView.backgroundColor = [UIColor whiteColor];
        [_userListView registerClass:[SYSearchUserCell class] forCellWithReuseIdentifier:SearchUserCellId];
        _userListView.alwaysBounceVertical = YES;
    }
    return _userListView;
}

- (UILabel *)historyHeadLabel {
    if (!_historyHeadLabel) {
        _historyHeadLabel = [UILabel new];
        _historyHeadLabel.text = @"搜索历史";
        _historyHeadLabel.textColor = RGBACOLOR(11,11,11,1);
        _historyHeadLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _historyHeadLabel.textAlignment = NSTextAlignmentLeft;
        _historyHeadLabel.hidden = YES;
    }
    return _historyHeadLabel;
}

- (UIButton *)historyCleanBtn {
    if (!_historyCleanBtn) {
        _historyCleanBtn = [UIButton new];
        [_historyCleanBtn setImage:[UIImage imageNamed_sy:@"sy_search_clean_history"] forState:UIControlStateNormal];
        [_historyCleanBtn addTarget:self action:@selector(clickCleanHistornBtn) forControlEvents:UIControlEventTouchUpInside];
        _historyCleanBtn.hidden = YES;
    }
    return _historyCleanBtn;
}

- (UICollectionView *)historyListView {
    if (!_historyListView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(self.view.sy_width, 44);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _historyListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _historyListView.delegate = self;
        _historyListView.dataSource = self;
        _historyListView.backgroundColor = [UIColor whiteColor];
        [_historyListView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SYSearchHistoryCellId"];
    }
    return _historyListView;
}

- (SYSearchUserViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYSearchUserViewModel new];
    }
    return _viewModel;
}

- (UIView *)loadingBaseView {
    if (!_loadingBaseView) {
        _loadingBaseView = [UIView new];
        _loadingBaseView.backgroundColor = [UIColor clearColor];
        _loadingBaseView.hidden = YES;
    }
    return _loadingBaseView;
}

@end
