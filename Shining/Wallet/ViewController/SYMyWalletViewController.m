//
//  SYMyWalletViewController.m
//  Shining
//
//  Created by letv_lzb on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMyWalletViewController.h"
#import "MyWalletTableViewCell.h"
#import "SYWalletViewModel.h"
#import "SYMyShineViewController.h"
#import "SYMyCoinViewController.h"

@interface SYMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,SYNoNetworkViewDelegate,SYCommonTopNavigationBarDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)SYWalletViewModel *viewModel;
@property (nonatomic, strong)SYNoNetworkView *noNetworkView;
@property (nonatomic, strong)SYDataEmptyView *emptyView;
@property (nonatomic, strong)SYCommonTopNavigationBar *topNavBar;
@property(nonatomic, strong)MBProgressHUD *loadingView;
@end

@implementation SYMyWalletViewController


- (void)removeNoNetworkView {
    if (_noNetworkView) {
        [_noNetworkView removeFromSuperview];
    }
    _noNetworkView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];
    [self.view addSubview:self.topNavBar];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self setUpView];
    [self.view sendSubviewToBack:self.tableView];
    [self sy_configDataInfoPageName:SYPageNameType_Wallet];
    if (!_viewModel) {
        _viewModel = [[SYWalletViewModel alloc] init];
    }
}

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"我的钱包" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

#pragma mark - SYCommonTopNavigationBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self requestWalletList];
}

- (void)requestWalletList {
    if ([self.viewModel isEmptyData]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        hud.opacity = 0.7;
        hud.removeFromSuperViewOnHide = YES;
        [self.view insertSubview:hud belowSubview:self.topNavBar];
        [hud mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(64 + (iPhoneX ? 24 : 0));
        }];
        self.loadingView = hud;
        [self.loadingView show:YES];
    }
    [self.viewModel getWalletList:^(BOOL isSuccess) {
        if ([self.viewModel isEmptyData]) {
            if (![SYNetworkReachability isNetworkReachable]) {
                [SYToastView showToast:@"网络异常"];
                self.noNetworkView.hidden = NO;
                self.tableView.hidden = YES;
                self.emptyView.hidden = YES;
            }else {
                self.noNetworkView.hidden = YES;
                self.tableView.hidden = YES;
                self.emptyView.hidden = NO;
            }
        }else {
            self.emptyView.hidden = YES;
            self.noNetworkView.hidden = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }
        if (self.loadingView) {
            [self.loadingView hide:YES];
            self.loadingView = nil;
        }
    }];
}

- (void)setUpView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    if (!_tableView.superview) {
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.topNavBar.mas_bottom);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).with.offset(iPhoneX ? -34 : 0);
        }];
    }
}

/**
 无数据View

 @return view
 */
- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SYDataEmptyView alloc] initWithFrame:CGRectZero withTipImage:@"myWalletEmpty" withTipStr:@"暂无记录哦～"];
        _emptyView.hidden = YES;
    }
    if (!_emptyView.superview) {
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(280, 124));
        }];
    }
    return _emptyView;
}

- (SYNoNetworkView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
    }
    if (!_noNetworkView.superview) {
        [self.view addSubview:_noNetworkView];
        _noNetworkView.hidden = YES;
        [_noNetworkView mas_makeConstraints:^(MASConstraintMaker    *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(iPhoneX ? 88 : 64);
            make.bottom.equalTo(self.view);
        }];
    }
    return _noNetworkView;
}

#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    [self requestWalletList];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYMyWalletModel *model = [self.viewModel.listModel.data objectAtIndex:indexPath.row];
    if (model.type == 1) {
        SYMyCoinViewController *coin = [[SYMyCoinViewController alloc] init];
        coin.coin = model.number;
        [self.navigationController pushViewController:coin animated:YES];
    }else if(model.type == 2){
        SYMyShineViewController *shine = [[SYMyShineViewController alloc] init];
        shine.shineValue = model.number;
        [self.navigationController pushViewController:shine animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWalletTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyWalletTableViewCell"];
    if (!cell) {
        cell = [[MyWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyWalletTableViewCell"];
    }
    if (self.viewModel.listModel) {
        SYMyWalletModel *model = [self.viewModel.listModel.data objectAtIndex:indexPath.row];
        [cell bindData:model];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.listModel.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (void)dealloc {
    [self removeNoNetworkView];
}


@end
