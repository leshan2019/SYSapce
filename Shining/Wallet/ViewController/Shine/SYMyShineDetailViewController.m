//
//  SYMyShineDetailViewController.m
//  Shining
//
//  Created by letv_lzb on 2019/3/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMyShineDetailViewController.h"
#import "MyShineDetailTopBarView.h"
#import "MyShineDetailTableViewCell.h"
#import "MyShineDetailViewModel.h"
#import "SYShineDetailIncomeListModel.h"
#import "SYShineDetailIncomeModel.h"

@interface SYMyShineDetailViewController ()<MyShineDetailTopBarViewDelegate,UITableViewDelegate,UITableViewDataSource,SYCommonTopNavigationBarDelegate>
@property (nonatomic, strong) MyShineDetailTopBarView *topBarView;//顶部栏
@property (nonatomic, strong) UITableView *tableView;//incomeList
@property (nonatomic, strong) UITableView *consumeTableView;//consumeList

@property (nonatomic, strong) MyShineDetailViewModel *viewModel;
@property (nonatomic, strong) SYDataEmptyView *emptyView;

@property (nonatomic, assign) BOOL showRefreshHeader;
@property (nonatomic, assign) BOOL showRefreshFooter;

@property (nonatomic, assign) BOOL showConsumeRefreshHeader;
@property (nonatomic, assign) BOOL showConsumeRefreshFooter;

@property (nonatomic, strong)SYCommonTopNavigationBar *topNavBar;

@end

@implementation SYMyShineDetailViewController

- (void)viewDidLoad {
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
    [self sy_configDataInfoPageName:SYPageNameType_Shining_Detailed];
    self.showRefreshHeader = YES;
    self.showConsumeRefreshHeader = YES;
    if (!_viewModel) {
        _viewModel = [[MyShineDetailViewModel alloc] init];
    }
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"蜜糖明细" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

#pragma mark - SYCommonTopNavigationBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setShowConsumeRefreshHeader:(BOOL)showConsumeRefreshHeader {
    if (_showConsumeRefreshHeader != showConsumeRefreshHeader) {
        _showConsumeRefreshHeader = showConsumeRefreshHeader;
        if (_showConsumeRefreshHeader) {
            __weak typeof(self) weakSelf = self;
            self.consumeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
            }];
            self.consumeTableView.mj_header.accessibilityIdentifier = @"consume_refresh_header";
        }
        else{
            [self.consumeTableView setMj_header:nil];
        }
    }
}


- (void)setShowConsumeRefreshFooter:(BOOL)showConsumeRefreshFooter {
    if (_showConsumeRefreshFooter != showConsumeRefreshFooter) {
        _showConsumeRefreshFooter = showConsumeRefreshFooter;
        if (_showConsumeRefreshFooter) {
            __weak typeof(self) weakSelf = self;

            self.consumeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerFooterRefresh];
            }];
            self.consumeTableView.mj_footer.accessibilityIdentifier = @"comsume_refresh_footer";
        }
        else{
            [self.consumeTableView setMj_footer:nil];
        }
    }
}

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak typeof(self) weakSelf = self;
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
            }];
            self.tableView.mj_header.accessibilityIdentifier = @"income_refresh_header";
        }
        else{
            [self.tableView setMj_header:nil];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak typeof(self) weakSelf = self;
            self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerFooterRefresh];
            }];
            self.tableView.mj_footer.accessibilityIdentifier = @"income_refresh_footer";
        }
        else{
            [self.tableView setMj_footer:nil];
        }
    }
}

/**
 view 创建
 */
- (void)setUpView {
    if (!_topBarView) {
        _topBarView = [[MyShineDetailTopBarView alloc] init];
        _topBarView.delegate = self;
    }
    if (!_topBarView.superview) {
        [self.view addSubview:_topBarView];
        [_topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);

            make.top.mas_equalTo(iPhoneX ? 88 : 64);
            make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, 40));
        }];
        [_topBarView setSelectedControl:0];
    }

    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    if (!_tableView.superview) {
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.top.mas_equalTo(self.topBarView.mas_bottom);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }
    if (!_consumeTableView) {
        _consumeTableView = [[UITableView alloc] init];
        _consumeTableView.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];
        _consumeTableView.dataSource = self;
        _consumeTableView.delegate = self;
        _consumeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _consumeTableView.hidden = YES;
    }
    if (!_consumeTableView.superview) {
        [self.view addSubview:_consumeTableView];
        [_consumeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.top.mas_equalTo(self.topBarView.mas_bottom);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
    }
}


/**
 无数据View

 @return view
 */
- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SYDataEmptyView alloc] initWithFrame:CGRectZero withTipImage:@"shine_empty" withTipStr:@"暂无记录哦～"];
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

#pragma MyShineDetailTopBarViewDelegate

- (void)handleConversationControlLeftClickEvent {
    if ([self.viewModel isIncomeEmptyData]) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
        self.consumeTableView.hidden = YES;
        [self.tableView reloadData];
    }
}


- (void)handleConversationControlRightClickEvent {
    if ([self.viewModel isConsumeEmptyData]) {
        [self.consumeTableView.mj_header beginRefreshing];
    }else{
        self.tableView.hidden = YES;
        self.consumeTableView.hidden = NO;
        self.emptyView.hidden = YES;
        [self.consumeTableView reloadData];
    }
}


#pragma  tableViewDlegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyShineDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyShineDetailTableViewCell"];
    if (!cell) {
        cell = [[MyShineDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyShineDetailTableViewCell"];
    }
    if (self.topBarView.selectedControl == 0) {
        if (![self.viewModel isIncomeEmptyData]) {
            SYShineDetailIncomeModel *model = [self.viewModel.listModel.list objectAtIndex:indexPath.row];
            [cell bindData:model];
        }
        return cell;
    }else{
        if (![self.viewModel isConsumeEmptyData]) {
            SYShineDetailIncomeModel *model = [self.viewModel.consumeListModel.list objectAtIndex:indexPath.row];
            [cell bindData:model];
        }
        return cell;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.topBarView.selectedControl == 0) {
        if ([self.viewModel isIncomeEmptyData]) {
            return 0;
        }else{
            return self.viewModel.listModel.list.count;
        }
    }else{
        if ([self.viewModel isConsumeEmptyData]) {
            return 0;
        }else{
            return self.viewModel.consumeListModel.list.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.topBarView.selectedControl == 0) {
        return 90;
    }else{
        return 90;
    }
}


#pragma mark - public refresh

- (void)autoTriggerHeaderRefresh {
    if (self.topBarView.selectedControl == 0) {
        if (self.showRefreshHeader) {
            [self tableViewDidTriggerHeaderRefresh];
        }
    } else {
        if (self.showConsumeRefreshHeader) {
            [self tableViewDidTriggerHeaderRefresh];
        }
    }
}

- (void)tableViewDidTriggerHeaderRefresh {
    if (self.topBarView.selectedControl == 0) {
        [self.viewModel getShineIncomeList:^(BOOL isSuccess) {
            if (isSuccess) {
                if (![self.viewModel isIncomeEmptyData]) {
                    self.emptyView.hidden = YES;
                    self.tableView.hidden = NO;
                    self.consumeTableView.hidden = YES;
                    self.showRefreshFooter = [self.viewModel isIncomeHasNextPage];
                }
            }
            if ([self.viewModel isIncomeEmptyData]) {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
                self.consumeTableView.hidden = YES;
                self.showRefreshFooter = NO;
            }
            [self tableViewDidFinishTriggerHeader:YES reload:YES];
        }];
    }else {
        [self.viewModel getShineConsumeList:^(BOOL isSuccess) {
            if (isSuccess) {
                if (![self.viewModel isConsumeEmptyData]) {
                    self.emptyView.hidden = YES;
                    self.consumeTableView.hidden = NO;
                    self.tableView.hidden = YES;
                    self.showConsumeRefreshFooter = [self.viewModel isConsumeHasNextPage];
                }
            }
            if ([self.viewModel isConsumeEmptyData]) {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
                self.consumeTableView.hidden = YES;
                self.showConsumeRefreshFooter = NO;
            }
            [self tableViewDidFinishTriggerHeader:YES reload:YES];
        }];
    }
}

- (void)tableViewDidTriggerFooterRefresh {
    if (self.topBarView.selectedControl == 0) {
        [self.viewModel getIncomeNextPage:^(BOOL isSuccess) {
            if (isSuccess) {
                if (![self.viewModel isIncomeEmptyData]) {
                    self.emptyView.hidden = YES;
                    self.tableView.hidden = NO;
                    self.consumeTableView.hidden = YES;
                    self.showRefreshFooter = [self.viewModel isIncomeHasNextPage];
                }
            }
            if ([self.viewModel isIncomeEmptyData]) {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
                self.tableView.hidden = YES;
                self.showRefreshFooter = NO;
            }
            [self tableViewDidFinishTriggerHeader:NO reload:YES];
        }];
    }else {
        [self.viewModel getConsumeNextPage:^(BOOL isSuccess) {
            if (isSuccess) {
                if (![self.viewModel isConsumeEmptyData]) {
                    self.emptyView.hidden = YES;
                    self.tableView.hidden = YES;
                    self.consumeTableView.hidden = NO;
                    self.showConsumeRefreshFooter = [self.viewModel isConsumeHasNextPage];
                }
            }
            if ([self.viewModel isConsumeEmptyData]) {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
                self.consumeTableView.hidden = YES;
                self.showConsumeRefreshFooter = NO;
            }
            [self tableViewDidFinishTriggerHeader:NO reload:YES];
        }];
    }
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload {
    __weak typeof(self) weakSelf = self;
    if (self.topBarView.selectedControl == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reload) {
                [weakSelf.tableView reloadData];
            }

            if (isHeader) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reload) {
                [weakSelf.consumeTableView reloadData];
            }

            if (isHeader) {
                [weakSelf.consumeTableView.mj_header endRefreshing];
            }
            else{
                [weakSelf.consumeTableView.mj_footer endRefreshing];
            }
        });
    }
}

@end
