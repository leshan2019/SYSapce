//
//  SYVoiceChatRoomManagerVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomManagerVC.h"
#import "SYVoiceChatRoomManagerCell.h"
#import "SYVoiceChatRoomManagerViewModel.h"
#import "SYVoiceRoomInputUserIdView.h"

#define SYVoiceChatRoomManagerCellID @"SYVoiceChatRoomManagerCellID"

@interface SYVoiceChatRoomManagerVC ()<SYCommonTopNavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, SYVoiceRoomInputUserIdViewDelegate, SYVoiceChatRoomManagerViewModelDelegate, SYNoNetworkViewDelegate>

@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) SYVoiceChatRoomManagerViewModel *viewModel;
@property (nonatomic, strong) SYVoiceRoomInputUserIdView *inputIdView;

@property (nonatomic, strong) UIView *loadingBaseView;              // 放loading的view
@property (nonatomic, strong) SYNoNetworkView *noNetworkView;       // 无网提示view
@property (nonatomic, strong) SYDataEmptyView *noDataView;          // 无数据view
@end

@implementation SYVoiceChatRoomManagerVC

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAdministerList];
}

#pragma mark - Private

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

- (void)requestAdministerList {
    [self hideNoNetworkView];
    [self hideDataEmptyView];
    self.listView.hidden = YES;
    if (![SYNetworkReachability isNetworkReachable]) {
        [self showNoNetworkView];
        return;
    }else {
        BOOL hasData = [self.viewModel hasAdministerListData];
        if (hasData) {
            self.listView.hidden = NO;
        } else {
            [self showLoadingView];
        }
    }
    [self.viewModel requestAdministerListWithChannelID:self.channelId page:1];
}

#pragma mark - SYVoiceChatRoomManagerViewModelDelegate

- (void)getAdministerListDataSuccess:(BOOL)success withDataCount:(NSInteger)count {
    [self hideLoadingView];
    if (success && count > 0) {
        self.listView.hidden = NO;
        [self.listView reloadData];
    } else {
        self.listView.hidden = YES;
        [self showDataEmptyView];
    }
}

- (void)addAdministerSuccess:(BOOL)success uid:(nonnull NSString *)uid errorCode:(NSInteger)errorCode {
    if (self.inputIdView && self.inputIdView.superview) {
        [self.inputIdView removeFromSuperview];
        self.inputIdView = nil;
    }
    if (success) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomInfoDidAddAdminister:)]) {
            [self.delegate voiceRoomInfoDidAddAdminister:uid];
        }
        [SYToastView showToast:@"添加管理员成功"];
    } else {
        if (errorCode == 4040) {
            [SYToastView showToast:@"您设置的管理员个数超过了上限"];
        } else if (errorCode == 4030) {
            [SYToastView showToast:@"该用户已经是管理员了"];
        } else if (errorCode == 2050) {
            [SYToastView showToast:@"您不能添加自己为管理员"];
        } else if (errorCode == 4021) {
            [SYToastView showToast:@"该用户不是公会成员"];
        } else if (errorCode == 4020) {
            [SYToastView showToast:@"该用户不存在"];
        } else {
            [SYToastView showToast:@"添加管理员失败"];
        }
    }
}

- (void)deleteAdministerSuccess:(BOOL)success uid:(nonnull NSString *)uid errorCode:(NSInteger)errorCode {
    if (success) {
        [self.listView reloadData];
        [SYToastView showToast:@"删除管理员成功"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomInfoDidDeleteAdminister:)]) {
            [self.delegate voiceRoomInfoDidDeleteAdminister:uid];
        }
    } else {
        [SYToastView showToast:@"删除管理员失败"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceChatRoomManagerCell *cell = (SYVoiceChatRoomManagerCell *)[tableView dequeueReusableCellWithIdentifier:SYVoiceChatRoomManagerCellID];
    if (!cell) {
        cell = [[SYVoiceChatRoomManagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SYVoiceChatRoomManagerCellID];
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
        NSString *userId = [self.viewModel userIdWithIndexPath:indexPath];
        [self.viewModel requestDeleteAdministerWithChannelID:self.channelId uid:userId];
    }
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleAddBtnClick {
    if (self.inputIdView) {
        [self.inputIdView removeFromSuperview];
        self.inputIdView = nil;
    }
    self.inputIdView = [[SYVoiceRoomInputUserIdView alloc]initWithFrame:CGRectZero];
    self.inputIdView.delegate = self;
    [self.view addSubview:self.inputIdView];
    [self.inputIdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - SYVoiceRoomInputUserIdViewDelegate

- (void)handleInputUserIdViewCancelBtnClick {
    if (self.inputIdView && self.inputIdView.superview) {
        [self.inputIdView removeFromSuperview];
        self.inputIdView = nil;
    }
}

- (void)handleInputUserIdViewAddBtnClick {
    [self.viewModel requestAddAdministerWithChannelID:self.channelId uid:self.inputIdView.userId];
}

#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络连接~"];
        return;
    }
    [self requestAdministerList];
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"管理员列表" rightTitle:@"" hasAddBtn:YES];
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

- (SYVoiceChatRoomManagerViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYVoiceChatRoomManagerViewModel new];
        _viewModel.channelId = self.channelId;
        _viewModel.delegate = self;
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
                                                  withTipStr:@"还没有管理员，快去添加吧~"];
        _noDataView.hidden = YES;
    }
    return _noDataView;
}

@end
