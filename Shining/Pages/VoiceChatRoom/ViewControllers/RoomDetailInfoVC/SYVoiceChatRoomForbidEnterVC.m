//
//  SYVoiceChatRoomForbidEnterVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomForbidEnterVC.h"
//#import <Masonry.h>
#import "SYCommonTopNavigationBar.h"
#import "SYVoiceChatRoomForbidEnterViewModel.h"
#import "SYVoiceChatRoomManagerCell.h"

#define SYVoiceChatRoomForBidEnterCellID @"SYVoiceChatRoomForBidEnterCellID"

@interface SYVoiceChatRoomForbidEnterVC ()<SYCommonTopNavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, SYNoNetworkViewDelegate>

@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) SYVoiceChatRoomForbidEnterViewModel *viewModel;

@property (nonatomic, strong) UIView *loadingBaseView;              // 放loading的view
@property (nonatomic, strong) SYNoNetworkView *noNetworkView;       // 无网提示view
@property (nonatomic, strong) SYDataEmptyView *noDataView;          // 无数据view
@property (nonatomic, assign) BOOL isLoadMoreData;                  // 是否正在请求更多数据

@end

@implementation SYVoiceChatRoomForbidEnterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    [self.view addSubview:self.loadingBaseView];
    [self.view addSubview:self.noNetworkView];
    [self.view addSubview:self.noDataView];
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.listView];
    [self.topNavBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -34 : 0);
    }];
    __weak typeof(self) weakSelf = self;
    self.listView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!weakSelf.isLoadMoreData) {
            weakSelf.isLoadMoreData = YES;
            [weakSelf requestMoreData];
        }
    }];
    self.listView.mj_footer.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestFirstPageData];
}

#pragma mark - Private

// 请求第一页数据
- (void)requestFirstPageData {
    [self hideDataEmptyView];
    [self hideNoNetworkView];
    [self hideLoadingView];
    self.listView.hidden = YES;
    if (![SYNetworkReachability isNetworkReachable]) {
        [self showNoNetworkView];
        return;
    }else {
        [self showLoadingView];
    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestForbidEnterUserListWithChannelID:self.channelId page:1 success:^(BOOL success, NSInteger pageSize) {
        weakSelf.isLoadMoreData = NO;
        [weakSelf hideLoadingView];
        [weakSelf.listView.mj_footer endRefreshing];
        if (success && pageSize > 0) {
            weakSelf.listView.hidden = NO;
            [weakSelf.listView reloadData];
            BOOL hasMore = [weakSelf.viewModel hasMoreData];
            weakSelf.listView.mj_footer.hidden = !hasMore;
        } else {
            weakSelf.listView.hidden = YES;
            weakSelf.listView.mj_footer.hidden = YES;
            [weakSelf showDataEmptyView];
        }
    }];
}

// 请求更多页数据
- (void)requestMoreData {
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestMoreForbidEnterUserListWithChannelId:self.channelId success:^(BOOL success, NSInteger pageSize) {
        weakSelf.isLoadMoreData = NO;
        [weakSelf.listView.mj_footer endRefreshing];
        if (success) {
            [weakSelf.listView reloadData];
        }
        BOOL hasMore = [weakSelf.viewModel hasMoreData];
        weakSelf.listView.mj_footer.hidden = !hasMore;
    }];
}

// 删除禁入人
- (void)deleteForbidEnterListWithChannelId:(NSString *)channelId withUid:(NSString *)uid withIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestCancelForbidUserEnterWithChannelID:channelId withUid:uid withIndexPath:indexPath success:^(BOOL success) {
        if (success) {
            [weakSelf.listView reloadData];
            [SYToastView showToast:@"删除成功"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomInfoDidRemoveForbiddenEnterUser:)]) {
                [self.delegate voiceRoomInfoDidRemoveForbiddenEnterUser:uid];
            }
        } else {
            [SYToastView showToast:@"删除失败"];
        }
    }];
}

- (void)showNoNetworkView {
    self.noNetworkView.hidden = NO;
}

- (void)hideNoNetworkView {
    self.noNetworkView.hidden = YES;
}

- (void)showDataEmptyView {
    self.noDataView.hidden = NO;
}

- (void)hideDataEmptyView {
    self.noDataView.hidden = YES;
}

- (void)showLoadingView {
    [MBProgressHUD showHUDAddedTo:self.loadingBaseView animated:NO];
}

- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self.loadingBaseView animated:NO];
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络连接~"];
        return;
    }
    [self requestFirstPageData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceChatRoomManagerCell *cell = (SYVoiceChatRoomManagerCell *)[tableView dequeueReusableCellWithIdentifier:SYVoiceChatRoomForBidEnterCellID];
    if (!cell) {
        cell = [[SYVoiceChatRoomManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYVoiceChatRoomForBidEnterCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *headImage = [self.viewModel headIconUrlWithIndexPath:indexPath];;
    NSString *name = [self.viewModel nameWithIndexPath:indexPath];
    NSString *gender = [self.viewModel genderWithIndexPath:indexPath];
    NSInteger age = [self.viewModel ageWithIndexPath:indexPath];
    NSString *userId = [self.viewModel userIdWithIndexPath:indexPath];
    NSString *bestId = [self.viewModel bestIdWithIndexPath:indexPath];
    NSString *showId = [bestId integerValue] > 0 ? bestId : userId;
    BOOL showSpaceLine = [self.viewModel showSpaceLineWithIndexPath:indexPath];
    [cell updateCellWithHeadImageUrl:headImage withName:name withGender:gender withAge:age withId:showId showSpaceLine:showSpaceLine];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"移除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *userid = [self.viewModel userIdWithIndexPath:indexPath];
        [self deleteForbidEnterListWithChannelId:self.channelId withUid:userid withIndexPath:indexPath];
    }
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"禁入名单" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _listView;
}

- (SYVoiceChatRoomForbidEnterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYVoiceChatRoomForbidEnterViewModel new];
        _viewModel.channelId = self.channelId;
    }
    return _viewModel;
}

- (UIView *)loadingBaseView {
    if (!_loadingBaseView) {
        _loadingBaseView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingBaseView.backgroundColor = [UIColor clearColor];
    }
    return _loadingBaseView;
}

- (SYNoNetworkView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
        _noNetworkView.hidden = YES;
    }
    return _noNetworkView;
}

- (SYDataEmptyView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[SYDataEmptyView alloc] initWithFrame:self.view.bounds
                                                withTipImage:@""
                                                  withTipStr:@"禁入列表暂无数据~"];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

@end
