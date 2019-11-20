//
//  SYDayTaskViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDayTaskViewController.h"
#import "SYDayTaskViewModel.h"
#import "SYMineListCell.h"
#import "SYDayTaskListCell.h"
//#import "HeziSDK.h"
#import "SYPopDayTaskReceiveView.h"

@interface SYDayTaskViewController ()<SYCommonTopNavigationBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SYDayTaskViewModel *viewModel;   // ViewModel
@property (nonatomic, strong)SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SYPopDayTaskReceiveView *dialogView;
@end

@implementation SYDayTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];
    [self.view addSubview:self.topNavBar];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.dialogView];
    
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel updateListData:^(BOOL isSuccess) {
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
    
    [self.dialogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.dialogView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatelistData];
}

- (void)updatelistData
{
    __weak typeof(self) weakSelf = self;
    [self.viewModel updateListData:^(BOOL isSuccess) {
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - LazyLoad

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (SYDayTaskViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYDayTaskViewModel new];
    }
    return _viewModel;
}

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"每日任务" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (SYPopDayTaskReceiveView *)dialogView {
    if (!_dialogView) {
        _dialogView = [[SYPopDayTaskReceiveView alloc]initWithFrame:CGRectZero];
    
    }
    return _dialogView;
}

#pragma mark - SYCommonTopNavigationBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableviewDelegate & UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYDayTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYDayTaskCellIdentifier"];
    if (!cell) {
        cell = [[SYDayTaskListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYDayTaskCellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString *icon = [self.viewModel leftIconForIndexPath:indexPath];
    NSString *title = [self.viewModel mainTitleForIndexPath:indexPath];
    NSString *subTitle = [self.viewModel subTitleForIndexPath:indexPath];
    NSString *progressTitle = [self.viewModel progressForIndexPath:indexPath];
    NSInteger status = [self.viewModel getStatusForIndexPath:indexPath];
    
    [cell updateMyneListCellwithIcon:icon title:title progressTitle:progressTitle subTitle:subTitle];
    [cell changeRightBtnByStatus:status];
    BOOL isHasSubTitle = (![NSString sy_isBlankString:subTitle] || ![NSString sy_isBlankString:progressTitle]);
    [cell updateUI:isHasSubTitle];
    [[cell getRightBtn]addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell getRightBtn].tag = indexPath.row;
    
    return cell;
}

- (void)rightBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    [self doTaskWithIndex:index];
}

- (void)doTaskWithIndex:(NSInteger)index
{
    if (index == 0) {
        //签到
        [self triggerWithEvent:@"checkin"];
    }else{
        NSInteger realIndex = index -1;
        SYDayTaskItemModel *model = [self.viewModel.listArray objectAtIndex:realIndex];
        SYDayTaskItemStatus status = model.status;
        if (status == SYDayTaskItemStatus_Default) {
            //跳聊天室首页
            if (gMainController) {
                [gMainController jumpToVoiceRoomHome];
            }
        }else if (status == SYDayTaskItemStatus_Done_unReceived){
            //领取奖品
            __weak typeof(self) weakSelf = self;
            [self.viewModel getReward:[NSString stringWithFormat:@"%d", model.taskId] finish:^(BOOL isSuccess) {
                [weakSelf showDialog:isSuccess];
                [weakSelf updatelistData];
            }];
        }
    }
}

-(void)triggerWithEvent:(NSString *)event
{
//    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
//    NSString *mobile = ![NSString sy_isBlankString: user.mobile]?user.mobile:@"13800138000";
//    [HeziTrigger trigger:event userInfo:@{@"username":user.userid?:@"",@"mobile":mobile}  showIconInView:self.view rootController:self delegate:self shareBlock:^(HeziShareModel *sharemodel) {
//    }];
    
}

- (void)showDialog:(BOOL)isSucess
{
    self.dialogView.hidden = NO;
    [self.dialogView updateUI:isSucess];
}
@end
