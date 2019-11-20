//
//  SYSystemMsgViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYSystemMsgViewController.h"
#import "SYSystemMsgTableViewCell.h"
#import "SYGlobalDefines.h"
#import "SYUserServiceAPI.h"
#import "SYAPPServiceAPI.h"
#import "SYSystemMsgModel.h"
#import "SYWebViewController.h"

#define CustomSystemMsgCellID @"CustomSystemMsgCellID"

@interface SYSystemMsgViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *msgList;
@end

@implementation SYSystemMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    self.msgList = [NSMutableArray array];
    [self _setupBarButtonItem];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(iPhoneX ? 88 : 64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    __weak typeof(self) weakSelf = self;

    [[SYAPPServiceAPI sharedInstance]requestSystemMsgList:^(NSArray * _Nullable list) {
        if ([NSObject sy_empty:list]  || list.count == 0) {
            [weakSelf.tableView reloadData];
            return;
        }
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<list.count; i++) {
            NSDictionary *dict =  list[i];
             SYSystemMsgModel *model = [SYSystemMsgModel yy_modelWithDictionary:dict];
            [array addObject:model];
        }
        weakSelf.msgList = [NSMutableArray arrayWithArray:array];
        [weakSelf.tableView reloadData];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)_setupBarButtonItem
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

#pragma mark UITableviewDelegate & UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYSystemMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomSystemMsgCellID];
    if (!cell) {
        cell = [[SYSystemMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomSystemMsgCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.avatarView.image = [UIImage imageNamed_sy:@"im_systemMsg"];
    if (self.msgList.count>0 && indexPath.row<self.msgList.count) {
        SYSystemMsgModel *model = self.msgList[indexPath.row];
        cell.titleLabel.text = model.message;
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:model.create_time];
        cell.timeLabel.text = [date formattedTime];
        
        cell.linkBtn.hidden = [NSString sy_isBlankString:model.jump_url];
        cell.linkBtn.tag = 1000+ indexPath.row;
        [cell.linkBtn addTarget:self action:@selector(jumpToUrl:) forControlEvents:UIControlEventTouchUpInside];
        if (!cell.linkBtn.hidden) {
            cell.titleLabel.numberOfLines = 2;
        }else{
            cell.titleLabel.numberOfLines = 3;
        }

        [cell reloadTitleLabelSize:cell.linkBtn.hidden];
    }
    
   
    return cell;
}

- (void)jumpToUrl:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag- 1000;
    if (index>=0 && index< self.msgList.count) {
        SYSystemMsgModel *model = self.msgList[index];
        SYWebViewController *webView = [[SYWebViewController alloc] initWithURL:model.jump_url];
        [self.navigationController pushViewController:webView animated:YES];
    }
}
@end
