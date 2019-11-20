//
//  ChatViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYChatViewController.h"
#import "ChatHelper.h"
#import "IMDingMessageHelper.h"
#import "DingViewController.h"
#import "DingAcksViewController.h"
#import "EMDemoOptions.h"
#import "SYChatUserInfoView.h"
#import "SYMessageCell.h"
#import "SYUserServiceAPI.h"
//#import "FlutterManager.h"
#import "SYPersonHomepageVC.h"
#import "SYSystemPhotoManager.h"
#import <Photos/PHPhotoLibrary.h>
#import "SYAppServiceAPI.h"
#import "SYTransferPaymentModel.h"
#import "SYTransferPaymentVC.h"
#import "EaseMessageReadManager.h"
#import "SYNavigationController.h"

@interface SYChatViewController ()<EMClientDelegate,UIScrollViewDelegate,SYTransferPaymentVCProtocol>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
}

@property (nonatomic, assign) BOOL isPlayingAudio;

@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
@property (nonatomic, strong)SYChatUserInfoView *userInfoView;
@property (nonatomic, strong)UserProfileEntity *recieverUserInfo;
@property (nonatomic, assign)BOOL isReceiverInBlackList;
@property (nonatomic, assign)BOOL isSenderInBlackList;
@end

@implementation SYChatViewController

- (instancetype)initWithUserProfileEntity:(UserProfileEntity *)userInfo
{
    if (!userInfo) {
        return nil;
    }
    self = [super initWithConversationChatter:userInfo.em_username conversationType:EMConversationTypeChat];
    if(self){
        self.recieverUserInfo = userInfo;
        [UserProfileEntity saveOtherUserInfo:userInfo];
        self.isReceiverInBlackList = NO;
        self.isSenderInBlackList = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.usedByPrivateMessage) {
        self.tableView.autoresizingMask = UIViewAutoresizingNone;
        [(EaseChatToolbar *)self.chatToolbar setUsedByPrivateMessage:self.usedByPrivateMessage];
    }

    if([NSObject sy_empty: self.recieverUserInfo]){
        UserProfileEntity *user = [UserProfileEntity getUserProfileEntityByEMUserName:self.conversation.conversationId];
        if(user){
            self.recieverUserInfo = user;
        }
    }
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[[UIImage imageNamed_sy:@"chat_sender_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] stretchableImageWithLeftCapWidth:5 topCapHeight:15]];
    
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed_sy:@"chat_receiver_bg"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
//    [[EaseBaseMessageCell appearance] setAvatarSize:38.f];//设置头像大小
    [[EaseBaseMessageCell appearance] setVoiceCellWidth:104.f*[UIScreen mainScreen].bounds.size.width/375];
  

    // Do any additional setup after loading the view.
    [ChatHelper shareHelper].chatVC = self;
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
#ifdef ShiningSdk
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
    self.tableView.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
#else
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];
    self.tableView.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];
#endif
    self.tableView.delaysContentTouches = NO;
    [self _setupBarButtonItem];
    [self addRedPacketBtn];
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor sy_colorWithHexString:@"#F5F6F7"]];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed_sy:@"chatBar_moreView_photo"] highlightedImage:[UIImage imageNamed_sy:@"chatBar_moreView_photo"] title:@"相册" atIndex:0];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed_sy:@"chatBar_moreView_camera"] highlightedImage:[UIImage imageNamed_sy:@"chatBar_moreView_camera"] title:@"拍照" atIndex:2];
    [self.chatBarMoreView removeItematIndex:4];
    [self.chatBarMoreView removeItematIndex:3];
    [self.chatBarMoreView removeItematIndex:1];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitChat) name:@"ExitChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dingAction) name:kNotification_DingAction object:nil];
    
    
    if (self.conversation.type == EMConversationTypeChat) {
        self.isTyping = [EMDemoOptions sharedOptions].isChatTyping;
        if (self.isTyping) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
    }
    [self sy_configDataInfoPageName:SYPageNameType_IM_Chat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    if (self.usedByPrivateMessage) {
        CGFloat normalHeight = iPhoneX ? 331+34 : 331;
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = normalHeight - 44 - self.chatToolbar.frame.size.height - iPhoneX_BOTTOM_HEIGHT;
        self.tableView.frame = tableFrame;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    __weak typeof(self) weakSelf = self;
    [self isInBlackList:self.recieverUserInfo.em_username finishBlock:^(BOOL inBlackList) {
         weakSelf.isReceiverInBlackList = inBlackList;
        if (inBlackList) {
            [SYToastView showToast:@"您拉黑了该用户，不能收到对方消息"];
        }
    }];
    [self refreshReciverUserInfo:self.recieverUserInfo.userid];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
    if (self.usedByPrivateMessage) {
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 10) {
            CGRect navFrame = self.navigationController.navigationBar.frame;
            navFrame.origin.y = 0;
            self.navigationController.navigationBar.frame = navFrame;
            self.navigationController.navigationBar.clipsToBounds = YES;
        }
    }
}

- (void)tableViewDidTriggerHeaderRefresh
{
    if ([EMDemoOptions sharedOptions].isPriorityGetMsgFromServer) {
        NSString *startMessageId = nil;
        if ([self.messsagesSource count] > 0) {
            startMessageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
        }
        
        NSLog(@"startMessageID ------- %@",startMessageId);
        [EMClient.sharedClient.chatManager asyncFetchHistoryMessagesFromServer:self.conversation.conversationId
                                                              conversationType:self.conversation.type
                                                                startMessageId:startMessageId
                                                                      pageSize:10
                                                                    completion:^(EMCursorResult *aResult, EMError *aError)
         {
             [super tableViewDidTriggerHeaderRefresh];
         }];
        
    } else {
        [super tableViewDidTriggerHeaderRefresh];
    }
}

- (void)refreshReciverUserInfo:(NSString *)uid
{
    if ([NSString sy_isBlankString:uid]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestOtherUserInfo:uid success:^(id  _Nullable response) {
        UserProfileEntity *userInfo = (UserProfileEntity *)response;
        if (userInfo) {
            weakSelf.recieverUserInfo = userInfo;
            [UserProfileEntity saveOtherUserInfo:userInfo];
        }
    } failure:^(NSError * _Nullable error) {
    }];
}

#pragma mark - RedPacket功能

- (void)addRedPacketBtn {
    UserProfileEntity *mySelfUser = [UserProfileEntity getUserProfileEntity];
    BOOL showRedPacketBtn = mySelfUser.level >= [SYSettingManager redPacketCapacityMaxLevel];
    if (showRedPacketBtn) {
        [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed_sy:@"redPackageBtn"] highlightedImage:[UIImage imageNamed_sy:@"redPackageBtn"] title:@"红包"];
    }
}

#pragma mark - setup subviews

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
    if (self.usedByPrivateMessage) {
        // title
        UILabel *label = [UILabel new];
        label.text = [NSString sy_safeString:self.recieverUserInfo.username];
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        label.textColor = RGBACOLOR(11,11,11,1);
        label.bounds = CGRectMake(0, 0, 56, 20);
        self.navigationItem.titleView = label;

        // "X"按钮
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [clearButton setImage:[UIImage imageNamed_sy:@"voiceroom_privateMessageClose"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(closePrivateMessageView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
        return;
    }
    //单聊
    if (self.conversation.type == EMConversationTypeChat) {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        clearButton.accessibilityIdentifier = @"im_user";
        [clearButton setImage:[UIImage imageNamed_sy:@"im_user"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(gotoOtherPersonHomePage) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }

}

- (void)closePrivateMessageView {
    [ChatHelper shareHelper].chatVC = nil;
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [UIView setAnimationsEnabled:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EaseChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView
{
    __weak typeof(self) weakself = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            //允许访问
            dispatch_async(dispatch_get_main_queue(), ^{
                // Hide the keyboard
                [weakself.chatToolbar endEditing:YES];
                
                // Pop image picker
                weakself.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                weakself.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage/*,(NSString *)kUTTypeMovie*/];
                weakself.imagePicker.allowsEditing = YES;
                weakself.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakself presentViewController:self.imagePicker animated:YES completion:NULL];
                
                weakself.isViewDidAppear = NO;
                [[EaseSDKHelper shareHelper] setIsShowingimagePicker:YES];
            });
            
        }
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            //不允许
            [SYSystemPhotoManager showPermissionDenyAlert:self isCameraOrPhoto:NO];
        }
        
    }];
    
}

- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView
{
    BOOL isAlbumPermission = [SYSystemPhotoManager checkCameraPermission];
    if (!isAlbumPermission) {
        [SYSystemPhotoManager showPermissionDenyAlert:self isCameraOrPhoto:YES];
        return;
    }
    [super moreViewTakePicAction:moreView];
}

- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatToolbar endEditing:YES];
    });
    if (index == 2) {//转账
        SYTransferPaymentVC *paymentVC = [[SYTransferPaymentVC alloc] initWithUserInfo:self.recieverUserInfo delegate:self];
        SYNavigationController *newViewController = [[SYNavigationController alloc] initWithRootViewController:paymentVC];
        newViewController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
        newViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:newViewController animated:YES completion:^{

        }];
    }
}

#pragma mark - EaseMessageCellDelegate

- (void)messageCellSelected:(id<IMessageModel>)model
{
    if (self.usedByPrivateMessage) {
        switch (model.bodyType) {
            case EMMessageBodyTypeText:
                break;
            default:
            {
                [super messageCellSelected:model];
            }
                break;
        }
    } else {
        EMMessage *message = model.message;
        if (model.isDing) {
            DingAcksViewController *controller = [[DingAcksViewController alloc] initWithMessage:message];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [super messageCellSelected:model];
        }
    }
}

#pragma mark - EMChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    if (self.usedByPrivateMessage) {
        CGFloat animationTime = 0.3;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat normalHeight = (iPhoneX ? 331+34 : 331);
        CGFloat inputBarHeight = [(EaseChatToolbar *)self.chatToolbar getInputBarHeight];
        [UIView animateWithDuration:animationTime animations:^{
            SYShowKeyboardType type = [(EaseChatToolbar *)self.chatToolbar keyboardType];
            if (type == SYShowKeyboardType_System || type == SYShowKeyboardType_Custom) {
                CGFloat navHeight = normalHeight + toHeight - inputBarHeight;
                if (navHeight > (screenSize.height - 20)) { // 针对iphone5机型适配
                    navHeight = screenSize.height - 20;
                }
                CGFloat tableViewHeight = navHeight - 44 - toHeight - iPhoneX_BOTTOM_HEIGHT;
                CGRect rect = self.tableView.frame;
                rect.origin.y = 0;
                rect.size.height = tableViewHeight;
                self.tableView.frame = rect;
            } else {
                CGFloat tableViewHeight = normalHeight - 44 - toHeight - iPhoneX_BOTTOM_HEIGHT;
                CGRect rect = self.tableView.frame;
                rect.origin.y = 0;
                rect.size.height = tableViewHeight;
                self.tableView.frame = rect;
            }
        } completion:^(BOOL finished) {
            [self scrollToBottom:NO];
        }];
    } else {
        [super chatToolbarDidChangeFrameToHeight:toHeight];
    }
}

- (void)willShowCustomKeyboard:(BOOL)show withHeight:(CGFloat)height {
    if (self.usedByPrivateMessage) {
        if (show) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYChatViewControllerWillShowCustomKeyboardNotification" object:@(height)];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYChatViewControllerWillhideShowCustomKeyboardNotification" object:nil];
        }
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    NSDictionary *ext = messageModel.message.ext;
    if ([ext objectForKey:@"em_recall"]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *recallCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (recallCell == nil) {
            recallCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            recallCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        EMTextMessageBody *body = (EMTextMessageBody*)messageModel.message.body;
        recallCell.title = body.text;
        return recallCell;
    }
    NSString *CellIdentifier = [SYMessageCell cellIdentifierWithModel:messageModel];
    
    SYMessageCell *sendCell = (SYMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    // Configure the cell...
    if (sendCell == nil) {
        sendCell = [[SYMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:messageModel];
        sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    sendCell.messageNameIsHidden = YES;
    sendCell.avatarSize = 38.f;
    sendCell.avatarCornerRadius = 19;
    sendCell.model = messageModel;
    if (messageModel.isSender) {
        [[EaseBaseMessageCell appearance] setMessageVoiceDurationColor:[UIColor whiteColor]];
    }else{
        [[EaseBaseMessageCell appearance] setMessageVoiceDurationColor:[UIColor sy_colorWithHexString:@"#444444"]];
    }
    return sendCell;

}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    NSDictionary *ext = messageModel.message.ext;
    if ([ext objectForKey:@"em_recall"]) {
        return self.timeCellHeight;
    }
    return [SYMessageCell cellHeightWithModel:messageModel];
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[EaseMessageCell class]]) {
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    if (self.usedByPrivateMessage) {
        return;
    }
    [self gotoPersonHomePage:messageModel.isSender];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
    didSelectCallMessageModel:(id<IMessageModel>)messageModel
{

}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed_sy:@"voiceroom_placeholder"];
    if (message.direction == EMMessageDirectionSend) {
        UserProfileEntity *profileEntity = [UserProfileEntity getUserProfileEntity];
        if (![NSString sy_isBlankString:profileEntity.avatar_imgurl]) {
            model.avatarURLPath = profileEntity.avatar_imgurl;
        }
        if (self.isSenderInBlackList) {
            model.isSenderInBlackList = YES;
        }
        return model;
    }

    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.nickname];
    if (profileEntity) {
        model.avatarURLPath = profileEntity.avatar_imgurl;
        model.nickname = profileEntity.nickname?profileEntity.nickname:profileEntity.username;
    }
    model.failImageName = @"imageDownloadFail";
    
    if (![NSObject sy_empty:self.recieverUserInfo]) {
        model.avatarURLPath = self.recieverUserInfo.avatar_imgurl;
        model.nickname = self.recieverUserInfo.username;
    }
    
    
    model.isDing = [IMDingMessageHelper isDingMessage:message];
    model.dingReadCount = [[IMDingMessageHelper sharedHelper] dingAckCount:message];
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed_sy:temp.emotionId]];
    
    return @[managerDefault];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    
    EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - EMChatManagerDelegate

- (void)messagesDidReceive:(NSArray *)aMessages
{
    [super messagesDidReceive:aMessages];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - KeyBoard

- (void)keyBoardWillHide:(NSNotification *)note
{
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"TypingEnd"];
    body.isDeliverOnlineOnly = YES;
//    UserProfileEntity *entity = [UserProfileEntity getUserProfileEntity];
//    NSDictionary *dict = [entity yy_modelToJSONObject];
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.conversation.conversationId body:body ext:nil];
    [[EMClient sharedClient].chatManager sendMessage:msg progress:nil completion:nil];
}

#pragma mark - action

- (void)backAction
{
    if (self.usedByPrivateMessage) {
        [UIView setAnimationsEnabled:YES];
        if ([(EaseChatToolbar *)self.chatToolbar keyboardType] == SYShowKeyboardType_Custom) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYChatViewControllerWillhideShowCustomKeyboardNotification" object:nil];
        }
    }
    [ChatHelper shareHelper].chatVC = nil;
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dingAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
    });

    DingViewController *controller = [[DingViewController alloc] initWithConversationId:self.conversation.conversationId to:self.conversation.conversationId chatType:EMChatTypeGroupChat finishCompletion:^(EMMessage *aMessage) {
        [self sendMessage:aMessage isNeedUploadFile:NO];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)deleteAllMessages:(id)sender
{
    [[IMDingMessageHelper sharedHelper] deleteConversation:self.conversation.conversationId];
    
    if (self.dataArray.count == 0) {
        [self showHint:[NSBundle sy_localizedStringForKey:@"message.noMessage" value:@"no messages"]];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:[NSBundle sy_localizedStringForKey:@"message.noMessage" value:@"no messages"]];
        }
    }
}


- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        [[IMDingMessageHelper sharedHelper] deleteConversation:self.conversation.conversationId message:model.message.messageId];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView reloadData];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

- (void)gotoPersonHomePage:(BOOL)isSender
{
    SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
    if (isSender) {
        UserProfileEntity *profileEntity = [UserProfileEntity getUserProfileEntity];
        vc.userId = profileEntity.userid;
    }else{
        vc.userId = self.recieverUserInfo.userid;
    }
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)gotoOtherPersonHomePage
{
    [self gotoPersonHomePage:NO];
}

#pragma mark - NSNotification

- (void)exitChat
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:[NSBundle sy_localizedStringForKey:@"delete" value:@"no Delete"] action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
         _copyMenuItem = [[UIMenuItem alloc] initWithTitle:[NSBundle sy_localizedStringForKey:@"copy" value:@"no Copy"] action:@selector(copyMenuAction:)];
    }
    
    
    NSMutableArray *items = [NSMutableArray array];
    
    if (messageType == EMMessageBodyTypeText) {
        [items addObject:_copyMenuItem];
        [items addObject:_deleteMenuItem];
    } else if (messageType == EMMessageBodyTypeImage || messageType == EMMessageBodyTypeVideo) {
        [items addObject:_deleteMenuItem];
    } else {
        [items addObject:_deleteMenuItem];
    }
    
    [self.menuController setMenuItems:items];
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}


#pragma mark

- (void)isInBlackList:(NSString *)em_username finishBlock:(void (^)(BOOL inBlackList))finishblock
{
    if ([NSString sy_isBlankString:em_username]) {
        return;
    }

    __block BOOL isInBlackList = NO;
    [[EMClient sharedClient].contactManager getBlackListFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (aList && aList.count>0) {
            for(NSString *username in aList){
                if ([em_username isEqualToString:username]) {
                    isInBlackList = YES;
                    break;
                }
            }
        }
        finishblock(isInBlackList);
    }];
}


- (void)sendTransferMessage:(NSString *)transferCount {
    UserProfileEntity *entity =  [UserProfileEntity getUserProfileEntity];
    NSString *userInfoStr =  [entity yy_modelToJSONString];
    SYTransferPaymentModel *payModel = [SYTransferPaymentModel new];
    payModel.userInfo = self.recieverUserInfo;
    payModel.acount = transferCount;
    payModel.transferStyle = @"normal";
    NSString *redPacketStr = [payModel yy_modelToJSONString];
    NSDictionary* ext = @{extSyUserInfo:userInfoStr,extRedPacket:redPacketStr};
    EMMessage *message = [EaseSDKHelper getTextMessage:@"【收到红包，请更新最新版本查看】" to:self.conversation.conversationId messageType:EMChatTypeChat messageExt:ext];
    [self sendMessage:message isNeedUploadFile:NO];
}


#pragma SYTransferPaymentVCProtocol

- (void)didSendRedpackage:(UserProfileEntity *)user beeCount:(NSString *)count {
    [self sendTransferMessage:count];
}

#pragma mark 覆盖父类方法
- (void)sendMessage:(EMMessage *)message isNeedUploadFile:(BOOL)isUploadFile
{
    if (self.conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    else if (self.conversation.type == EMConversationTypeChatRoom){
        message.chatType = EMChatTypeChatRoom;
    }
    if ([NSObject sy_empty:message.ext]) {
        UserProfileEntity *entity =  [UserProfileEntity getUserProfileEntity];
        NSString *userInfoStr =  [entity yy_modelToJSONString];
//         message.ext = [entity yy_modelToJSONObject];
        message.ext = @{extSyUserInfo:userInfoStr};
    }
    __weak typeof(self) weakself = self;

    if (message.body.type == EMMessageBodyTypeText && [NSString sy_empty:[message.ext objectForKey:extRedPacket]]) {
        EMTextMessageBody *body = (EMTextMessageBody *)message.body;

        [self filterText:body.text block:^(NSString *resultStr) {
            if (![body.text isEqualToString:resultStr]) {
                EMTextMessageBody *newbody = [[EMTextMessageBody alloc] initWithText:resultStr];
                message.body = newbody;
                if ([SYNetworkReachability isNetworkReachable]) {
                    NSDictionary *pubParam = @{@"keyword":body.text,@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"im"};
//                    [MobClick event:@"textPorn" attributes:pubParam];
//                    [SYToastView showToast:@"消息含有敏感信息!!!"];
                }
            }
           
            [weakself sendMessageMethod:message isNeedUploadFile:isUploadFile];

        }];
    }else {
        [weakself sendMessageMethod:message isNeedUploadFile:isUploadFile];
    }
    
   
}

- (void)sendImageMessageWithData:(NSData *)imageData
{
    if ([SYNetworkReachability isNetworkReachable]) {
        UIImage *img = [UIImage imageWithData:imageData];
        img = [SYUtil compressImage:img withTargetSize:CGSizeMake(500, 500)];

        NSData *validateImgData = UIImageJPEGRepresentation(img, 0.5);
        [[SYAPPServiceAPI sharedInstance] requestValidateImage:validateImgData success:^(id  _Nullable response) {
            [super sendImageMessageWithData:imageData];
        } failure:^(NSError * _Nullable error) {
            NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"im"};
//            [MobClick event:@"imagePorn" attributes:pubParam];
            [SYToastView showToast:@"照片包含敏感信息，请重新发送~"];
        }];
    }else{
        [super sendImageMessageWithData:imageData];
    }
}

//重写该系统方法，否则底部控件的touchDown事件有延迟
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return UIRectEdgeBottom;
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chatToolbar endEditing:YES];
        });
    }
}

- (void)sendMessageMethod:(EMMessage *)message isNeedUploadFile:(BOOL)isUploadFile
{
    __weak typeof(self) weakself = self;
    if (!([EMClient sharedClient].options.isAutoTransferMessageAttachments) && isUploadFile) {
        //TODO
    } else {
        [weakself addMessageToDataSource:message
                            progress:nil];
        
        [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
            if (weakself.dataSource && [weakself.dataSource respondsToSelector:@selector(messageViewController:updateProgress:messageModel:messageBody:)]) {
                [weakself.dataSource messageViewController:weakself updateProgress:progress messageModel:nil messageBody:message.body];
            }
        } completion:^(EMMessage *aMessage, EMError *aError) {
            if (aError!=NULL && aError.code == EMErrorUserPermissionDenied) {
                weakself.isSenderInBlackList = YES;
            }else{
                weakself.isSenderInBlackList = NO;
            }
            
            [weakself reloadMessageToDataSource:message];
        }];
    }
}

// 文字鉴黄
- (void)requestValidContent:(NSString *)content
                      block:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestValidateText:content
                                                   success:^(id  _Nullable response) {
                                                       if ([response isKindOfClass:[NSDictionary class]]) {
                                                           if (block) {
                                                               block([response[@"validate"] boolValue]);
                                                           }
                                                       } else {
                                                           if (block) {
                                                               block(NO);
                                                           }
                                                       }
                                                   } failure:^(NSError * _Nullable error) {
                                                       if (block) {
                                                           block(NO);
                                                       }
                                                   }];
}

- (void)filterText:(NSString *)content
             block:(void(^)(NSString *resultStr))block
{
    [[SYUserServiceAPI sharedInstance] requestFilterText:content uid:self.recieverUserInfo.userid
                                                 success:^(id  _Nullable response) {
                                                     if ([response isKindOfClass:[NSString class]]) {
                                                         NSString *str = (NSString *)response;
                                                         if (block) {
                                                             block(str);
                                                         }
                                                     }
                                                 } failure:^(NSError * _Nullable error) {
                                                     if (block) {
                                                         block(content);
                                                     }
                                                 }];
}

@end
