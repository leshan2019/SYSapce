//
//  ConversationListController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYConversationListController.h"
#import "RobotManager.h"
#import "IMDingMessageHelper.h"
#import "RobotChatViewController.h"
#import "SYChatViewController.h"
#import "ChatHelper.h"
#import "ConversationListCell.h"
#import "ConversationAttentionCell.h"
#import "ConversationAttentionView.h"
#import "SYUserServiceAPI.h"
#import "SYContactViewController.h"
#import "SYSystemMsgViewController.h"
#import "SYAPPServiceAPI.h"
#import "NSMutableAttributedString+SYAttrStr.h"
#import "SYSystemMsgModel.h"
#import "ShiningSdkManager.h"

// 消息模块 - 聊天列表CellID
#define CustomConversationCellID @"CustomConversationCellID"

static NSString *kWelComCoversastion = @"小闪";

@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:self.conversationId]) {
            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.conversationId];
        }
        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.conversationId];
    } else if (self.type == EMConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"subject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"subject"];
        }
    }
    return self.conversationId;
}

@end

@interface SYConversationListController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource>

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, assign) NSInteger systemMsgCount;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SYDataEmptyView *noDataTipView;
@end

@implementation SYConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);

        if (self.usedByPrivateMessage) {
            make.top.equalTo(self.view).with.offset(44);
        } else {
            if (@available(iOS 11.0, *)){
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);//约束留出导航栏 11之后
            }else{
                make.top.equalTo(self.view).with.offset(iPhoneX ? 88 : 64);
            }
        }

        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;

    [self networkStateView];
    [self setupBarButtonItem];
    [self.view addSubview:self.noDataTipView];
    [self.noDataTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        if (self.usedByPrivateMessage) {
            make.top.equalTo(self.view).with.offset(44);
        } else {
            make.top.equalTo(self.view).with.offset((iPhoneX ? 88 : 64)+72);
        }
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.noDataTipView updateForNoImage];
    
    [self removeEmptyConversationsFromDB];
    [self setupSystemMsgView];
    
#ifdef ShiningSdk
    [ChatHelper shareHelper].conversationListVC = self;
#endif
    [self sy_configDataInfoPageName:SYPageNameType_IM_ConversationList];
}

- (void)setupSystemMsgView
{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 83)];
    self.headerView.backgroundColor = [UIColor sy_colorWithHexString:@"#f5f6f7"];
    
    ConversationListCell *cell = [[ConversationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemMsgCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.avatarView.image = [UIImage imageNamed_sy:@"im_systemMsg"];
    cell.titleLabel.text = @"系统消息";
    cell.detailLabel.text = @"0条通知";
    cell.badgeView.hidden = YES;
    cell.tag = 777;
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 72);
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(systemMsgTapAction:)];
    [cell addGestureRecognizer:tapGesturRecognizer];
    
    [self.headerView addSubview:cell];

    if (self.usedByPrivateMessage) {
        self.tableView.tableHeaderView = nil;
    } else {
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)systemMsgTapAction:(id)sender
{
    SYSystemMsgViewController *vc = [[SYSystemMsgViewController alloc] init];
//    FlientViewController *vc = [[FlutterManager shareManager]initialSystemMsg_FlutterViewController];
//#ifdef ShiningSdk
//    [self presentViewController:vc animated:YES completion:nil];
//#else
    [self.navigationController pushViewController:vc animated:YES];
//#endif
}

- (void)setupBarButtonItem
{
    if (self.usedByPrivateMessage) {
        UILabel *label = [UILabel new];
        label.text = @"最近聊天";
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        label.textColor = RGBACOLOR(11,11,11,1);
        label.bounds = CGRectMake(0, 0, 56, 20);
        self.navigationItem.titleView = label;
        return;
    }
    UIButton *contanctButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    contanctButton.accessibilityIdentifier = @"clear_message";
    [contanctButton setImage:[UIImage imageNamed_sy:@"im_contact"] forState:UIControlStateNormal];
    [contanctButton addTarget:self action:@selector(gotoContactAction) forControlEvents:UIControlEventTouchUpInside];
    contanctButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    contanctButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:contanctButton];
#ifdef ShiningSdk
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 100, 28)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
    [btn addTarget:self action:@selector(handleBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateHighlighted];
    UIBarButtonItem*back = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.tabBarController.navigationItem.leftBarButtonItem = back;
#endif
}


// 返回
- (void)handleBackBtn {
#ifdef ShiningSdk
    [[ShiningSdkManager shareShiningSdkManager] exitShiningAppMainView:^{

    }];
#else
    [self.navigationController popViewControllerAnimated:YES];
#endif
}

- (void)gotoContactAction
{
    UIViewController *chatController = [[SYContactViewController alloc] init];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    [self tableViewDidTriggerHeaderRefresh];
    [self.navigationController setNavigationBarHidden:NO];
#ifdef ShiningSdk
    self.navigationController.navigationBar.backgroundColor = RGBACOLOR(245, 246, 247, 1);
#endif
    [self setupBarButtonItem];
    [self refresh];
    if (self.usedByPrivateMessage) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 10) {
            CGRect navFrame = self.navigationController.navigationBar.frame;
            navFrame.origin.y = 0;
            self.navigationController.navigationBar.frame = navFrame;
            self.navigationController.navigationBar.clipsToBounds = YES;
        }
    }
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
                RobotChatViewController *chatController = [[RobotChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
                [self.navigationController pushViewController:chatController animated:YES];
            } else {
                UserProfileEntity *user = nil;
                NSDictionary *dict =  conversation.lastReceivedMessage.ext;
                if (![NSObject sy_empty:dict]) {
                    NSString *userInfoStr = dict[@"syUserInfo"];
                    
                    NSDictionary *tempDict = [NSString sy_dictionaryWithJsonString:userInfoStr];
                    if (![NSObject sy_empty:tempDict]) {
                        user = [UserProfileEntity yy_modelWithDictionary:tempDict];
                    }
                }
                if (!user) {
                    user = [UserProfileEntity getUserProfileEntityByEMUserName:conversation.conversationId];
                }

                if (user) {
                    SYChatViewController *chatController = [[SYChatViewController alloc] initWithUserProfileEntity:user];
                    chatController.usedByPrivateMessage = self.usedByPrivateMessage;
                    if (!self.usedByPrivateMessage) {
                        chatController.title = user.username;
                    }
                    [self.navigationController pushViewController:chatController animated:YES];
                }else{
                    SYChatViewController *chatController = [[SYChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:EMConversationTypeChat];
                    chatController.usedByPrivateMessage = self.usedByPrivateMessage;
                    chatController.title = conversation.conversationId;
                    [self.navigationController pushViewController:chatController animated:YES];
                }
               
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        if ([[RobotManager sharedInstance] isRobotWithUsername:conversation.conversationId]) {
            model.title = [[RobotManager sharedInstance] getRobotNickWithUsername:conversation.conversationId];
        } else {
            UserProfileEntity *profileEntity = [UserProfileEntity getUserProfileEntityByEMUserName:conversation.conversationId];
            if (profileEntity){
                model.title = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
                model.avatarURLPath = profileEntity.avatar_imgurl;
                if ([NSString sy_isBlankString:model.avatarURLPath]) {
                    model.avatarImage = [UIImage imageNamed_sy:@"voiceroom_placeholder"];
                }
                NSString *age = [NSString stringWithFormat:@"%lu",(unsigned long)[SYUtil ageWithBirthdayString:profileEntity.birthday]] ;
                if (![NSString sy_isBlankString:age] && ![NSString sy_isBlankString:profileEntity.gender])
                {
                    model.conversation.ext = @{@"age":age,@"gender":profileEntity.gender};
                }
            }else{
                NSDictionary *dict =  model.conversation.lastReceivedMessage.ext;
                if (![NSObject sy_empty:dict]) {
                    NSString *userInfoStr = dict[@"syUserInfo"];
                    
                    NSDictionary *tempDict = [NSString sy_dictionaryWithJsonString:userInfoStr];
                    if (![NSObject sy_empty:tempDict]) {
                        UserProfileEntity *entity = [UserProfileEntity yy_modelWithDictionary:tempDict];
                        if([conversation.conversationId isEqualToString:entity.em_username]){
                            model.title = entity.nickname == nil ? entity.username : entity.nickname;
                            model.avatarURLPath = entity.avatar_imgurl;
                            if ([NSString sy_isBlankString:model.avatarURLPath]) {
                                model.avatarImage = [UIImage imageNamed_sy:@"voiceroom_placeholder"];
                            }
                            NSString *age = [NSString stringWithFormat:@"%lu",(unsigned long)[SYUtil ageWithBirthdayString:entity.birthday]] ;
                            if (![NSString sy_isBlankString:age] && ![NSString sy_isBlankString:entity.gender]) {
                                model.conversation.ext = @{@"age":age,@"gender":entity.gender};
                            }
                        }
                        
                    }
                   
                }
            }
        }
    } else {
        return nil;
    }
    return model;
}

- (NSAttributedString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@""];
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        NSString *latestMessageTitle = @"";
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
                if ([lastMessage.ext objectForKey:extRedPacket]) {
                    latestMessageTitle = @"[红包]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[音频]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
        
        if (lastMessage.direction == EMMessageDirectionReceive) {
            NSString *from = lastMessage.from;
            
            UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:from];
            if (profileEntity) {
                from = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
            }
//            latestMessageTitle = [NSString stringWithFormat:@"%@: %@", from, latestMessageTitle];
        }
        
        NSDictionary *ext = conversationModel.conversation.ext;
        if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtAllMessage) {
            NSString *allMsg = @"[有全体消息]";
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@", allMsg, latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, allMsg.length)];
            
        }
        else if (ext && [ext[kHaveUnreadAtMessage] intValue] == kAtYouMessage) {

            NSString* groupStr = [NSBundle sy_localizedStringForKey:@"group.atMe" value:@"[Somebody @ me]"];
            latestMessageTitle = [NSString stringWithFormat:@"%@ %@",groupStr , latestMessageTitle];
            attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
           [attributedStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:.0 blue:.0 alpha:0.5]} range:NSMakeRange(0, groupStr.length)];
        }
        else {
            NSString *msgStatusImgName = @"";
            if (lastMessage.status == EMMessageStatusFailed || lastMessage.status == EMMessageStatusDelivering) {
                msgStatusImgName = (lastMessage.status == EMMessageStatusDelivering)?@"msgSend_Delivering":@"EaseUIResource.bundle/messageSendFail";
                 attributedStr = [NSMutableAttributedString attributedWithImageName:msgStatusImgName andStringWithContentString:latestMessageTitle andWithAttributedInsertType:SYAttributedInsertTypeFirst andLabel:nil];
            }else{
                 attributedStr = [[NSMutableAttributedString alloc] initWithString:latestMessageTitle];
            }
           
        }
    }
    
    return attributedStr;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return latestMessageTime;
}


#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
    [self refreshSystemMsg];
    [self refreshNoDataTip];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
    [self refreshNoDataTip];
}

- (void)refreshSystemMsg
{
    __weak typeof(self) weakSelf = self;
    [[SYAPPServiceAPI sharedInstance]requestSystemMsgList:^(NSArray * _Nullable list) {
        NSInteger systemCount = ![NSObject sy_empty:list]?list.count:0;
        weakSelf.systemMsgCount = systemCount;
        NSString *lastestTime = @"";
        if ([list isKindOfClass:[NSArray class]] && list.count>0) {
            NSDictionary *dict = list[0];
            SYSystemMsgModel *model = [SYSystemMsgModel yy_modelWithDictionary:dict];
            lastestTime = model.create_time;
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
            NSDate *date=[formatter dateFromString:lastestTime];
            lastestTime = [date formattedTime];
        }
        ConversationListCell *cell = [weakSelf.tableView.tableHeaderView viewWithTag:777];
        if ([cell isKindOfClass:[ConversationListCell class]]) {
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld条通知",(long)weakSelf.systemMsgCount];
            cell.timeLabel.text =  lastestTime;
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)refreshNoDataTip
{
    if (self.dataArray.count <=0) {
        self.noDataTipView.hidden = NO;
        self.tableView.scrollEnabled =NO;
    }else{
        self.noDataTipView.hidden = YES;
        self.tableView.scrollEnabled =YES;
    }
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = self.headerView;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)deleteCellAction:(NSIndexPath *)aIndexPath
{
    EaseConversationModel *model = [self.dataArray objectAtIndex:aIndexPath.row];
    [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        });
    }];

    [self.dataArray removeObjectAtIndex:aIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:aIndexPath] withRowAnimation:UITableViewRowAnimationFade];

    [[IMDingMessageHelper sharedHelper] deleteConversation:model.conversation.conversationId];
    
    [self.tableView reloadData];
    [self refresh];
}

#pragma mark - Override UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 聊天
    ConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomConversationCellID];
    if (!cell) {
        cell = [[ConversationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomConversationCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if ([self.dataArray count] <= indexPath.row) {
        return cell;
    }

    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;

    if ([self respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        NSMutableAttributedString *attributedText = [[self conversationListViewController:self latestMessageTitleForConversationModel:model] mutableCopy];
        [attributedText addAttributes:@{NSFontAttributeName : cell.detailLabel.font} range:NSMakeRange(0, attributedText.length)];
        cell.detailLabel.attributedText =  attributedText;
    }

    if ([self respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [self conversationListViewController:self latestMessageTimeForConversationModel:model];
    }
    return cell;
}

#pragma mark - LazyLoad

- (UIView *)networkStateView {
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed_sy:@"EaseUIResource.bundle/messageSendFail"];
        [_networkStateView addSubview:imageView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        NSString *tstr = [NSBundle sy_localizedStringForKey:@"network.disconnection" value:@"Network disconnection"];
        label.text = tstr;
        [_networkStateView addSubview:label];
    }
    return _networkStateView;
}

- (SYDataEmptyView *)noDataTipView {
    if (!_noDataTipView) {
        _noDataTipView = [[SYDataEmptyView alloc] initWithFrame:CGRectZero
                                                     withTipImage:@""
                                                       withTipStr:@"快去找喜欢的主播聊天吧～"];

    }
    return _noDataTipView;
}
- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
@end
