//
//  SYLiveRoomFansView.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansView.h"
#import "SYLiveRoomFansOperationCell.h"
#import "SYLiveRoomFansMemberCell.h"
#import "SYLiveRoomFansHeaderView.h"
#import "SYLiveRoomFansFooterView.h"
#import "SYLiveRoomFansUserInfoView.h"
#import "SYLiveRoomFansLevelCell.h"
#import "SYLiveRoomFansTaskCell.h"
#import "SYLiveRoomFansComboTableViewCell.h"
#import "SYLiveRoomFansHostScoreCell.h"
#import "SYLiveRoomFansHostEditCell.h"
#import "SYLiveRoomFansHostEditBtnView.h"
#import "SYLiveRoomFansViewModel.h"
#import "SYLiveRoomFansViewInfoModel.h"
#import <WebKit/WebKit.h>
@interface SYLiveRoomFansView()<
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate,
LiveRoomFansHeaderViewDelegate,
LiveRoomFansFooterViewDelegate,WKUIDelegate,LiveRoomFansHostEditBtnDelegate,LiveRoomFansComboTableViewCellDelegate>
@property(nonatomic,strong)UIView*groundBgView;
@property(nonatomic,strong)UIView*tableViewBgView;
@property(nonatomic,strong)UITableView*mainTableView;
@property(nonatomic,assign)LiveRoomFansViewHeaderStatus headerStatus;
@property(nonatomic,assign)LiveRoomFansViewStatus fansStatus;
@property(nonatomic,strong)WKWebView*webView;
@property(nonatomic,assign)BOOL isHost;
@property(nonatomic,strong)SYLiveRoomFansViewModel*viewModel;
//
@property(nonatomic,strong)NSString*uid;
@property(nonatomic,strong)NSString*anchorId;
@property(nonatomic,strong)NSArray<SYLiveRoomFansViewMemberModel*>*memberlist;
@property(nonatomic,strong)NSArray<SYLiveRoomFansViewTaskModel*>*tasklist;
@end
@implementation SYLiveRoomFansView
- (instancetype)initWithFrame:(CGRect)frame isHost:(BOOL)isHost roomData:(NSDictionary*)infoDic{
    self = [super initWithFrame:frame];
    if (self) {
        self.isHost = isHost;
        self.uid = [infoDic objectForKey:@"uid"];
        self.anchorId = [infoDic objectForKey:@"anchorid"];
        [self setupSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    self.viewModel = [[SYLiveRoomFansViewModel alloc]init];
    self.headerStatus = self.isHost? LiveRoomFansViewHeaderStatus_firstLevel_host:LiveRoomFansViewHeaderStatus_firstLevel_guest;
    self.fansStatus = LiveRoomFansViewStatus_unJoined;
    [self addSubview:self.groundBgView];
    [self addSubview:self.tableViewBgView];
    [self addSubview:self.mainTableView];
    if (self.isHost) {
        [self requestFansList];
    }else{
        [self requestFansInfo];
    }
}
-(void)requestFansInfo{
    [MBProgressHUD showHUDAddedTo:self animated:NO];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestFansViewInfoWithUid:self.uid andAnchorid:self.anchorId block:^(BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf animated:NO];
        if (success) {
            weakSelf.fansStatus = [weakSelf.viewModel getFansHeaderInfoStatus];
            if (weakSelf.fansStatus == LiveRoomFansViewStatus_joined) {
                [weakSelf requestFansLevel];
            }else{
            [weakSelf.mainTableView reloadData];
            }
        }
        
    }];
}
-(void)requestFansList{
    [MBProgressHUD showHUDAddedTo:self animated:NO];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestFansViewMemberlistWithAnchorid:self.anchorId block:^(BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf animated:NO];
        if (success) {
            weakSelf.memberlist = [weakSelf.viewModel getMembersList];
            [weakSelf.mainTableView reloadData];
            if (weakSelf.memberlist.count==0) {
                [weakSelf showEmptyView];
            }
        }else{
            [weakSelf showEmptyView];
        }
    }];
}
-(void)openFansRightSuccessReloadData{
    self.fansStatus = LiveRoomFansViewStatus_joined;
    [self requestFansLevel];
}
-(void)requestFansLevel{
    [MBProgressHUD showHUDAddedTo:self animated:NO];
    [self.viewModel requestFansViewLevelWithUid:self.uid andAnchorid:self.anchorId block:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self animated:NO];
        if (success) {
            self.tasklist = [self.viewModel getTaskList];
            [self.mainTableView reloadData];
        }
    }];
}
-(void)tapBlankView{
    [self removeFromSuperview];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.groundBgView.frame = self.bounds;
    self.mainTableView.sy_left = 0;
    self.mainTableView.sy_bottom = self.sy_bottom;
    self.tableViewBgView.sy_height = self.mainTableView.sy_height - 30;
    self.tableViewBgView.sy_left = 0;
    self.tableViewBgView.sy_bottom = self.sy_bottom;
}
-(void)showEmptyView{
    SYLiveRoomFansEmptyView*view = [self viewWithTag:99];
    [view removeFromSuperview];
    SYLiveRoomFansEmptyView*empty = [[SYLiveRoomFansEmptyView alloc]initWithFrame:CGRectMake(0, 0, 110, 143)];
    empty.center = self.mainTableView.center;
    empty.tag = 99;
    [self addSubview:empty];
}
-(void)hideEmptyView{
    SYLiveRoomFansEmptyView*view = [self viewWithTag:99];
    [view removeFromSuperview];
}
-(void)showHostEditBtnView{
    SYLiveRoomFansHostEditBtnView*view = [self viewWithTag:98];
    [view removeFromSuperview];
    SYLiveRoomFansHostEditBtnView*editBtnView= [[SYLiveRoomFansHostEditBtnView alloc]initWithFrame:CGRectMake(0, self.mainTableView.frame.origin.y+104, self.mainTableView.sy_width, self.mainTableView.sy_height-104)];
    editBtnView.tag = 98;
    editBtnView.delegate = self;
    [self addSubview:editBtnView];
}
-(void)hideHostEditBtnView{
    SYLiveRoomFansHostEditBtnView*view = [self viewWithTag:98];
    [view removeFromSuperview];
}
-(void)resignEditCellFirstResponder{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UITableViewCell*tmp = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([tmp isKindOfClass:[SYLiveRoomFansHostEditCell class]]) {
        SYLiveRoomFansHostEditCell*cell = (SYLiveRoomFansHostEditCell*)tmp;
        [cell cellResignFirstResponder];
    }
}
#pragma mark ------tableView delegate -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_guest ) {
        if (self.fansStatus == LiveRoomFansViewStatus_joined) {
            return 2+self.tasklist.count;
        }else {
            return 3;
        }
    }else if(self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host){
        return 2+self.memberlist.count;
    }else if(self.headerStatus == LiveRoomFansViewHeaderStatus_secondLevel_host){
        return 1;
    }
    NSInteger count = 1+self.memberlist.count;
    if (self.memberlist.count < 4){
        count = 1+4;
    }else{
        count = 1+self.memberlist.count;
    }
    return count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_guest) {
        if (self.fansStatus == LiveRoomFansViewStatus_joined) {
            if (indexPath.row == 0) {
                return 108;
            } else if (indexPath.row == 4){
                return 152;
            }else {
                return 70;
            }
        }else {
            return (self.sy_width - 2*20)*77/335.0+10;
        }
    }else if (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host){
        if (indexPath.row == 0) {
            return 85;
        }else if (indexPath.row == 1){
            return 52;
        }else{
            return 66;
        }
    }else if (self.headerStatus == LiveRoomFansViewHeaderStatus_secondLevel_host){
        return 52;
    }else{
        if (indexPath.row == 0) {
            return 52;
        }
        return 66;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_guest) {
        if (self.fansStatus == LiveRoomFansViewStatus_joined) {
            if (indexPath.row == 0) {
                static NSString *cellind = @"cellind0";
                SYLiveRoomFansLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
                if (!cell) {
                    cell = [[SYLiveRoomFansLevelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell resetFansLevelCellInfo:[self.viewModel getUserFansLevel]];
                return cell;
            }else if (indexPath.row == 4){
                static NSString *cellind = @"cellind1";
                SYLiveRoomFansComboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
                if (!cell) {
                    cell = [[SYLiveRoomFansComboTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.delegate= self;
                [cell resetFansLevelCellInfo:[self.viewModel getComboArr] andExpiredDate:[self.viewModel getExpiredDate]];
                return cell;
            } else {
                static NSString *cellind = @"cellind2";
                SYLiveRoomFansTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
                if (!cell) {
                    cell = [[SYLiveRoomFansTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell setCellInfo:[self.tasklist objectAtIndex:indexPath.row-1]];
                return cell;
            }
            
        }else{
            static NSString *cellind = @"cellind3";
            SYLiveRoomFansOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
            if (!cell) {
                cell = [[SYLiveRoomFansOperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell loadCellData:[NSString stringWithFormat:@"liveRoom_fans_operation_%ld",indexPath.row+1]];
            return cell;
        }
        
    }else if (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host){
        if (indexPath.row == 0) {
            
            static NSString *cellind = @"cellind4";
            SYLiveRoomFansHostScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
            if (!cell) {
                cell = [[SYLiveRoomFansHostScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setHostFansGroupScore:[self.viewModel host_getGroupScore]];
            return cell;
        }else{
            static NSString *cellind = @"cellind5";
            SYLiveRoomFansMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
            if (!cell) {
                cell = [[SYLiveRoomFansMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell isSectionLabelCell:indexPath.row ==1];
            if (indexPath.row == 1) {
                [cell setSectionLabelCellText:[NSString stringWithFormat:@"%ld",self.memberlist.count] isHost:self.isHost];
            }
            if (indexPath.row>1) {
                [cell setCellInfos:[self.memberlist objectAtIndex:indexPath.row-2] isHost:self.isHost count:self.memberlist.count];
                
            }
            return cell;
        }
    }else if (self.headerStatus == LiveRoomFansViewHeaderStatus_secondLevel_host){
        static NSString *cellind = @"cellind6";
        SYLiveRoomFansHostEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
        if (!cell) {
            cell = [[SYLiveRoomFansHostEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setEditCellText:@"天天团"];
        return cell;
    }else{
        static NSString *cellind = @"cellind7";
        SYLiveRoomFansMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
        if (!cell) {
            cell = [[SYLiveRoomFansMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.memberlist.count >0) {
            [cell isSectionLabelCell:indexPath.row ==0];
            if (indexPath.row == 0) {
                [cell setSectionLabelCellText:[NSString stringWithFormat:@"%ld",self.memberlist.count] isHost:self.isHost];
            }
            if (indexPath.row>0) {
                [cell setCellInfos:[self.memberlist objectAtIndex:indexPath.row-1] isHost:self.isHost count:self.memberlist.count];
            }
        }
        
        
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_guest || self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host)? 100:54;
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.fansStatus == LiveRoomFansViewStatus_unJoined&&(self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_guest )) {
        return 120;
    }else if (self.fansStatus == LiveRoomFansViewStatus_joined&&( self.headerStatus == LiveRoomFansViewHeaderStatus_secondLevel_guest)){
        return 74;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat height = (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_guest || self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host) ? 100:54;
    SYLiveRoomFansHeaderView*view = [[SYLiveRoomFansHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, height) andStatus:self.headerStatus];
    view.backgroundColor = [UIColor clearColor];
    view.delegate = self;
    [view setHeaderInfo: [self.viewModel getHeaderInfo] andStatus :self.headerStatus];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ((self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_guest) && self.fansStatus == LiveRoomFansViewStatus_unJoined) {
        SYLiveRoomFansFooterView*view = [[SYLiveRoomFansFooterView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 120)];
        view.backgroundColor = [UIColor clearColor];
        [view resetFooterInfo:[self.viewModel getComboArr]];
        view.delegate = self;
        return view;
    }else if ((self.headerStatus == LiveRoomFansViewHeaderStatus_secondLevel_guest) && self.fansStatus == LiveRoomFansViewStatus_joined){
        SYLiveRoomFansUserInfoView*view =[[SYLiveRoomFansUserInfoView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 74)];
        [view setUserInfos:[self.viewModel getUserFansInfo]];
        return view;
    }else{
        return nil;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark ------other delegate -----
- (void)liveRoomFansHostEditBtn_clickBlankView{
    [self resignEditCellFirstResponder];
}
- (void)liveRoomFansHostEditBtn_clickSureBtn{
    UITableViewCell*tmp = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([tmp isKindOfClass:[SYLiveRoomFansHostEditCell class]]) {
        SYLiveRoomFansHostEditCell*cell = (SYLiveRoomFansHostEditCell*)tmp;
        [cell cellResignFirstResponder];
        NSString*groupTitle = [cell getEditCellText];
        if (groupTitle.length>3) {
            [SYToastView sy_showToast:@"团名称仅限3个字符"];
        }else if([NSString sy_isBlankString:groupTitle]){
            [SYToastView sy_showToast:@"团名称不能为空"];
        }else{
            [self.viewModel editFansGroupNameWithGroupId:[self.viewModel getFansGroupID] andAnchorid:self.anchorId name:groupTitle block:^(BOOL success) {
                if (success) {
                    [SYToastView sy_showToast:@"修改成功"];
                }else{
                    [SYToastView sy_showToast:@"修改失败"];
                }
            }];
        }
    }
}
- (void)liveRoomFansComboTableViewCell_openFansRights:(NSString *)priceType{
    [MBProgressHUD showHUDAddedTo:self animated:NO];
    __weak typeof(self) weakSelf = self;
    [self.viewModel openFansRightWithUid:self.uid andAnchorid:self.anchorId fansloveid:[self.viewModel getFansGroupID] pricetype:priceType block:^(BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf animated:NO];
        if (success) {
            [weakSelf openFansRightSuccessReloadData];
        }
    }];
}
#pragma mark ------header delegate -----
- (void)liveRoomFansHeaderView_help{
    self.headerStatus = LiveRoomFansViewHeaderStatus_secondLevel_help;
    [self.mainTableView reloadData];
    [self addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.le.com/web/sy/zatgz"]]];
}
- (void)liveRoomFansHeaderView_memberList{
    self.headerStatus = self.isHost ?LiveRoomFansViewHeaderStatus_secondLevel_host: LiveRoomFansViewHeaderStatus_secondLevel_guest;;
    [self.mainTableView reloadData];
    [self requestFansList];
}
- (void)liveRoomFansHeaderView_avatorClick{
    
}
- (void)liveRoomFansHeaderView_edit{
    self.headerStatus = self.isHost ?LiveRoomFansViewHeaderStatus_secondLevel_host: LiveRoomFansViewHeaderStatus_secondLevel_guest;;
    [self.mainTableView reloadData];
    [self showHostEditBtnView];
}
- (void)liveRoomFansHeaderView_back{
    [self hideEmptyView];
    [self hideHostEditBtnView];
    [self resignEditCellFirstResponder];
    self.headerStatus = self.isHost ?LiveRoomFansViewHeaderStatus_firstLevel_host: LiveRoomFansViewHeaderStatus_firstLevel_guest;
    [self.mainTableView reloadData];
    [self.webView removeFromSuperview];
}
#pragma mark ------footer delegate -----
- (void)liveRoomFansFooterView_openFansRights:(NSString *)priceType{
    [MBProgressHUD showHUDAddedTo:self animated:NO];
    __weak typeof(self) weakSelf = self;
    [self.viewModel openFansRightWithUid:self.uid andAnchorid:self.anchorId fansloveid:[self.viewModel getFansGroupID] pricetype:priceType block:^(BOOL success) {
        [MBProgressHUD hideHUDForView:weakSelf animated:NO];
        if (success) {
            [weakSelf openFansRightSuccessReloadData];
        }
    }];
}

#pragma mark ------lazy load -----

-(UIView*)groundBgView{
    if (!_groundBgView) {
        UIView*view = [[UIView alloc]initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tapBlankView)];
        [view addGestureRecognizer:tap];
        _groundBgView = view;
    }
    return _groundBgView;
}
- (UIView *)tableViewBgView{
    if (!_tableViewBgView) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 0)];
        view.backgroundColor = [UIColor whiteColor];
        _tableViewBgView = view;
    }
    return _tableViewBgView;
}
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        UITableView*tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 420) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        _mainTableView = tableView;
    }
    return _mainTableView;
}
- (WKWebView *)webView {
    if (!_webView) {
        NSMutableString *script = [[NSMutableString alloc] init];
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:script
                                                              injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                           forMainFrameOnly:NO];
        [userContentController addUserScript:cookieInScript];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContentController;
        //
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.mainTableView.sy_top+54, self.sy_width, 420-54) configuration:config];
        _webView.allowsBackForwardNavigationGestures = NO;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.scrollView.bounces = NO;
        [_webView setOpaque:NO];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.UIDelegate = self;
    }
    return _webView;
}

@end

@implementation SYLiveRoomFansEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    self.clipsToBounds = YES;
    [self addSubview:self.img];
    [self addSubview:self.titleLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.img.sy_top = 0;
    self.img.sy_left = 0;
    self.titleLabel.sy_top = self.img.sy_bottom+12;
    self.titleLabel.sy_centerX = self.img.sy_centerX;
}
- (UIImageView *)img{
    if (!_img) {
        UIImageView*img = [[UIImageView alloc]initWithImage:[UIImage imageNamed_sy:@"liveRoom_fans_empty"]];
        img.backgroundColor = [UIColor clearColor];
        img.frame = CGRectMake(0, 0, 110, 110);
        _img = img;
    }
    return _img;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        lab.text = @"暂无团成员";
        [lab sizeToFit];
        _titleLabel = lab;
    }
    return _titleLabel;
}
@end
