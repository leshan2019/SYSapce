//
//  SYVoiceChatRoomViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomViewModel.h"
#import "SYMessageManager.h"
#import "SYVoiceChatNetManager.h"
#import "SYSettingManager.h"
#import "SYVoiceRoomText.h"
#import "SYVoiceRoomGift.h"
#import "SYVoiceRoomUser.h"
#import "SYVoiceRoomMessage.h"
#import "SYVoiceRoomUserModel.h"
#import "SYVoiceRoomPlayerListModel.h"
#import "SYGiftInfoManager.h"
#import "SYUserServiceAPI.h"
#import "SYVoiceRoomGameManager.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "SYVoiceRoomPKListModel.h"
#import "SYGiftNetManager.h"
#import "SYWalletNetWorkManager.h"
#import "SYRoomGroupRedpacketModel.h"

#define SYRoomShareUrl  [SYSettingManager syIsTestApi] ? @"https://mp.le.com/web/sy/share?roomid=%@&pcode=%@" : @"https://mp-cdn.le.com/web/sy/share?roomid=%@&pcode=%@"

@interface SYVoiceChatRoomViewModel () <SYMessageManagerDelegate, WXApiManagerDelegate>

@property (nonatomic, strong) NSTimer *heartBeatTimer;
@property (nonatomic, strong) NSTimer *updateRoleListTimer;
@property (nonatomic, strong) NSTimer *liveInterruptedTimer;
@property (nonatomic, strong) NSTimer *bossTimer;
@property (nonatomic, strong) SYMessageManager *messageManager;
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, strong) SYVoiceRoomGameManager *gameManager;
@property (nonatomic, strong) SYWalletNetWorkManager *saleManager;
@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *guestUserId;
@property (nonatomic, strong) NSString *guestUserName;

@property (nonatomic, strong) SYVoiceChatUserViewModel *ownerViewModel;
@property (nonatomic, strong) SYVoiceRoomUser *myselfModel;
@property (nonatomic, strong) SYChatRoomModel *roomModel;
@property (nonatomic, strong) NSMutableDictionary *usersInMicDict; // key:position, value:user
@property (nonatomic, strong) NSMutableArray *usersInApplyMicArray;
@property (nonatomic, strong) NSMutableArray *textMessageArray;
@property (nonatomic, strong) NSArray *operationList;

/*******红包属性Begin*******/
@property (nonatomic, strong) NSArray *redPacketList;
@property (nonatomic, assign) NSInteger assistTime;
@property (nonatomic, strong) NSTimer *assistTimer;
/*******红包属性End************/

@property (nonatomic, strong) SYVoiceRoomPKListModel *pkListModel;
@property (nonatomic, strong) SYVoiceRoomKingModel *bossModel;

@property (nonatomic, assign) SYChatRoomUserRole initialRole; // 初始角色
@property (nonatomic, assign) BOOL isForbiddenChat; // 是否被禁言

@property (nonatomic, assign) BOOL isChangingHostRole; // 正在变换host

@property (nonatomic, assign) BOOL isPKing;
@property (nonatomic, assign) BOOL isBossAvailable; // 老板位上有人

@property (nonatomic, assign) BOOL hasUnreadMessage;

@property (nonatomic, assign) NSTimeInterval lastBreakEggTimeStamp; // 砸蛋时间戳
@property (nonatomic, assign) NSTimeInterval lastBeeHoneyTimeStamp; // 采蜜时间戳

@property (nonatomic, copy) void(^networkErrorBlock)(NSError *error);

@property (nonatomic, strong) SYVoiceChatUserViewModel *liveRoomHost;

@property (nonatomic, assign) CFTimeInterval joinRoomTime;
@property (nonatomic, assign) BOOL hasDailyTaskUpload;
@property (nonatomic, assign) BOOL rolesListNeedUpdate;
@end

@implementation SYVoiceChatRoomViewModel

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithChannelID:(NSString *)channelID
                         password:(NSString *)password {
    self = [super init];
    if (self) {
        _channelID = channelID;
        _messageManager = [[SYMessageManager alloc] initWithChannelID:channelID];
        _messageManager.delegate = self;
        _netManager = [[SYVoiceChatNetManager alloc] init];
        _textMessageArray = [NSMutableArray new];
        _isForbiddenChat = NO;
        _password = password;
        _lastBreakEggTimeStamp = 0;
        _lastBeeHoneyTimeStamp = 0;
        _isBossAvailable = NO;
        _rolesListNeedUpdate = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gameFloatScreen:)
                                                     name:@"SYGameJSAPI_playGameMsg"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(webConnectionReceived:)
                                                     name:SYWebConnectionNotification
                                                   object:nil];

    }
    return self;
}

- (SYWalletNetWorkManager *)saleManager {
    if (!_saleManager) {
        _saleManager = [SYWalletNetWorkManager new];
    }
    return _saleManager;
}

- (BOOL)isMyselfLogin {
    return ![NSString sy_isBlankString:self.currentUser.userid];
}

- (UserProfileEntity *)currentUser {
//    return [SYSettingManager userInfo];
    return [UserProfileEntity getUserProfileEntity];
}

- (SYVoiceChatRoomInfoViewModel *)roomInfo {
    return [[SYVoiceChatRoomInfoViewModel alloc] initWithRoomModel:self.roomModel];
}

- (SYVoiceChatUserViewModel *)usersInMicAtPosition:(NSInteger)position {
    SYVoiceRoomUser *user = self.usersInMicDict[@(position)];
    if (!user) {
        return nil;
    }
    NSInteger beans = [self beanValueWithUserId:user.uid];
    SYVoiceChatUserViewModel *userViewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:user
                                                                                     isMuted:user.isMuted
                                                                                     isPKing:self.isPKing beanValue:beans];
    if ( userViewModel.uid) {
        userViewModel.isMaxPKBeans = [[self maxPKBeansUserId] isEqualToString:userViewModel.uid];
        userViewModel.isMinPKBeans = [[self minPKBeansUserId] isEqualToString:userViewModel.uid];
    }
    return userViewModel;
}

- (void)changeUserInfoAtPosition:(NSInteger)position
                       isFromMic:(BOOL)isFromMic
                             uid:(NSString *)uid
                        username:(NSString *)username
                          avatar:(NSString *)avatar
                       avatarBox:(NSInteger)avatarBox
                broadcasterLevel:(NSInteger)broadcasterLevel
                   isBroadcaster:(NSInteger)isBroadcaster
                    isSuperAdmin:(NSInteger)isSuperAdmin
{
    if ([uid isEqualToString:self.myselfModel.uid]) {
        self.myselfModel.username = username;
        self.myselfModel.icon = avatar;
        self.myselfModel.avatarBox = avatarBox;
        self.myselfModel.streamer_level = broadcasterLevel;
        self.myselfModel.is_streamer = isBroadcaster;
        self.myselfModel.is_super_admin = isSuperAdmin;
    }
    if (!isFromMic) {
        return;
    }
    SYVoiceRoomUser *user = self.usersInMicDict[@(position)];
    if (!user || ![user.uid isEqualToString:uid]) {
        return;
    }
    user.username = username;
    user.icon = avatar;
    user.avatarBox = avatarBox;
    user.streamer_level = broadcasterLevel;
    user.is_streamer = isBroadcaster;
    user.is_super_admin = isSuperAdmin;
}

- (NSInteger)usersCountInApplyMicList {
    return [self.usersInApplyMicArray count];
}

- (SYVoiceChatUserViewModel *)usersInApplyMicListAtIndex:(NSInteger)position {
    SYVoiceRoomUser *user = self.usersInApplyMicArray[position];
    return [[SYVoiceChatUserViewModel alloc] initWithUser:user
                                                  isMuted:NO];
}

- (SYVoiceChatUserViewModel *)roomOwner {
    return self.ownerViewModel;
}

- (SYVoiceChatUserViewModel *)myself {
    return [[SYVoiceChatUserViewModel alloc] initWithUser:self.myselfModel
                                                  isMuted:self.myselfModel.isMuted];
}

- (BOOL)isMyselfContainsInApplyMicList {
    return ([self userInApplyMicListWithUid:self.currentUser.userid
                             isReverseCheck:YES]);
}

- (NSInteger)myselfIndexInApplyMicList {
    SYVoiceRoomUser *user = [self userInApplyMicListWithUid:self.currentUser.userid
                                             isReverseCheck:YES];
    if (user) {
        return [self.usersInApplyMicArray indexOfObject:user];
    }
    return NSNotFound;
}

- (BOOL)isMyselfAtMicPosition:(NSInteger)micPosition; {
    SYVoiceRoomUser *user = self.usersInMicDict[@(micPosition)];
    return ([user.uid isEqualToString:self.myselfModel.uid]);
}

- (NSInteger)textMessageListCount {
    return [self.textMessageArray count];
}

- (SYVoiceTextMessageViewModel *)textMessageViewModelAtIndex:(NSInteger)index {
    SYVoiceRoomMessage *message = [self.textMessageArray objectAtIndex:index];
    return [[SYVoiceTextMessageViewModel alloc] initWithMessage:message];
}

- (BOOL)isMyselfForbiddenChat {
    return self.isForbiddenChat;
}

- (NSArray *)operationViewModels {
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableArray *subArr;
    if (self.operationList && self.operationList.count > 0) {
        NSArray *tempArr;
        for (NSInteger i = self.operationList.count - 1; i >= 0; i--) {
            tempArr = [self.operationList objectAtIndex:i];
            subArr = [NSMutableArray new];
            for (int j = 0; j < tempArr.count; j++) {
                SYVoiceRoomOperationModel *operationModel = [tempArr objectAtIndex:j];
                SYVoiceRoomOperationViewModel *viewModel = [[SYVoiceRoomOperationViewModel alloc] initWithOperation:operationModel];
                if (viewModel.operationType < SYVoiceRoomOperationTypeEnd) {
                    [subArr addObject:viewModel];
                }
            }
            if (subArr.count > 0) {
                [arr addObject:subArr];
            }
        }
    }
    return arr;
}

#pragma mark - 红包逻辑

- (NSArray *)redPacketCanGetListData {
    return self.redPacketList;
}

- (NSInteger)redPacketCanGetTime {
    NSArray *redpackets = [self redPacketCanGetListData];
    BOOL canGetRedpacketNow = NO;
    NSMutableArray *timeArr = [NSMutableArray array];
    SYRoomGroupRedpacketModel *model;
    NSInteger startDiffTime;
    NSInteger minTime;
    for (int i = 0; i < redpackets.count; i++) {
        model = [redpackets objectAtIndex:i];
        startDiffTime = model.start_time_now_diff;
        if (startDiffTime <= 0) {
            canGetRedpacketNow = YES;
            break;
        } else {
            // 最近的时间在数组最前方
            if (timeArr.count == 0) {
                [timeArr addObject:@(startDiffTime)];
            } else {
                minTime = [[timeArr firstObject] integerValue];
                if (startDiffTime < minTime) {
                    [timeArr insertObject:@(startDiffTime) atIndex:0];
                } else {
                    [timeArr addObject:@(startDiffTime)];
                }
            }
        }
    }
    if (canGetRedpacketNow) {
        return 0;
    }
    if (timeArr.count > 0) {
        NSInteger recentTime = [[timeArr firstObject] integerValue];
        return recentTime;
    }
    return 0;
}

- (NSInteger)getHasPassedTimeAfterGetRedPacketListData {
    return self.assistTime;
}

// 刷新聊天室内群红包列表
- (void)refreshRoomGroupRedpacketList {
    [self.saleManager requestRoomGroupRedPacketListWithRoomid:self.channelID success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSArray *listArr = [response objectForKey:@"list"];
            self.redPacketList = [NSArray yy_modelArrayWithClass:[SYRoomGroupRedpacketModel class]
                                                            json:listArr];
            if (self.redPacketList.count > 0) {
                self.assistTime = 0;
                [self startAssistTimer];
            }
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomRefreshGroupRedPacketData)]) {
                [self.delegate voiceChatRoomRefreshGroupRedPacketData];
            }
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)requestGetRoomGroupRedpacket:(NSString *)redPacketId success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self.saleManager requestGetGroupRedPacketResult:self.channelID redPacketId:redPacketId success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            SYRoomGroupRedpacketGetResultModel *model = [SYRoomGroupRedpacketGetResultModel yy_modelWithJSON:response];
            if (model && success) {
                success(model);
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)sendGetRoomGroupRedpacketSignalling:(NSString *)userId userName:(NSString *)userName redPacketSenderId:(NSString *)senderId redPacketSenderName:(NSString *)senderName getCoinCount:(NSInteger)coinCount {
    // 红包领取人
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = userId;
    user.username= userName;
    // 红包发送人
    SYVoiceRoomUser *fromUser = [SYVoiceRoomUser new];
    fromUser.uid = senderId;
    fromUser.username = senderName;
    SYVoiceRoomBoonModel *fromUserModel = [SYVoiceRoomBoonModel new];
    fromUserModel.count = coinCount;
    fromUserModel.user = fromUser;
    [self.messageManager sendGetGroupRedPacketKing:user fromUserModel:fromUserModel];
}

- (void)sendRoomGroupRedpacketHasGetedEmpty:(NSString *)redPacketId roomid:(NSString *)roomId ownerId:(NSString *)ownerId {
    SYVoiceRoomBoomEmptyModel *model = [SYVoiceRoomBoomEmptyModel new];
    model.redbag_id = redPacketId;
    model.room_id = roomId;
    model.owner_id = ownerId;
    [self.messageManager sendGetGroupRedpacketEmptyKing:model];
}

- (void)sendRoomGroupRedpacketSignalling {
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    // 红包发送人
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = userInfo.userid;
    user.icon = userInfo.avatar_imgurl;
    user.username = userInfo.username;
    user.gender = userInfo.gender;
    user.birthday = userInfo.birthday;
    user.age = [SYUtil ageWithBirthdayString:userInfo.birthday];
    user.avatarBox = userInfo.avatarbox;
    user.level = userInfo.level;
    user.streamer_level = userInfo.streamer_level;
    user.is_streamer = userInfo.is_streamer;
    [self.messageManager sendGroupRedPacketKing:user];
}

- (void)sendOverScreenGroupRedpacketSignalling {
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    // 红包发送人
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = userInfo.userid;
    user.icon = userInfo.avatar_imgurl;
    user.username = userInfo.username;
    user.gender = userInfo.gender;
    user.birthday = userInfo.birthday;
    user.age = [SYUtil ageWithBirthdayString:userInfo.birthday];
    user.avatarBox = userInfo.avatarbox;
    user.level = userInfo.level;
    user.streamer_level = userInfo.streamer_level;
    user.is_streamer = userInfo.is_streamer;
    user.is_super_admin = userInfo.is_super_admin;
    [self.messageManager sendOverScreenGroupRedPacketMessage:user roomid:self.channelID];
}




- (void)startAssistTimer {
    [self stopAssistTimer];
    self.assistTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(addAssistTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.assistTimer forMode:NSRunLoopCommonModes];
}

- (void)stopAssistTimer {
    if (self.assistTimer && self.assistTimer.isValid) {
        [self.assistTimer invalidate];
    }
    self.assistTimer = nil;
}

- (void)addAssistTime {
    self.assistTime += 1;
}

#pragma mark ---

- (SYVoiceRoomBossViewModel *)bossViewModel {
    return [[SYVoiceRoomBossViewModel alloc] initWithBossModel:self.bossModel];
}

- (void)startProcess {
    __weak typeof(self) weakSelf = self;
    self.networkErrorBlock = ^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
            if (error.code == 2040) {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorAuthority];
            } else if (error.code == 4060) {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorRoomLocked];
            } else if (error.code == 4101) {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorDownloadOtherApp];
            } else {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorNetwork];
            }
        }
    };
    [self.netManager requestJoinChannelWithChannelID:self.channelID
                                                 uid:self.currentUser.userid
                                            password:self.password
                                             success:^(id  _Nonnull response) {
                                                 [self handleJoinChannelData:response];
                                             } failure:^(NSError * _Nonnull error) {
                                                 if (self.networkErrorBlock) {
                                                     self.networkErrorBlock(error);
                                                 }
                                                 if ([self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                                                     [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorJoinChannelFailed];
                                                 }
                                             }];
}

- (void)joinLiveRoom {
    __weak typeof(self) weakSelf = self;
    self.networkErrorBlock = ^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
            if (error.code == 2040) {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorAuthority];
            } else if (error.code == 4060) {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorRoomLocked];
            } else if (error.code == 4101) {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorDownloadOtherApp];
            } else {
                [weakSelf.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorNetwork];
            }
        }
    };
    [self.netManager requestJoinChannelWithChannelID:self.channelID
                                                 uid:self.currentUser.userid
                                            password:self.password
                                             success:^(id  _Nonnull response) {
                                                 [self handleJoinLiveChannelData:response];
                                             } failure:^(NSError * _Nonnull error) {
                                                 if (self.networkErrorBlock) {
                                                     self.networkErrorBlock(error);
                                                 }
                                                 if ([self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                                                     [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorJoinChannelFailed];
                                                 }
                                             }];
}

- (void)updateMyselfUserInfo {
    if (![NSString sy_isBlankString:self.myselfModel.uid]) {
        return;
    }
    [self getMyselfInfo];
    
    [self.netManager requestJoinChannelWithChannelID:self.channelID
                                                 uid:self.myselfModel.uid
                                            password:self.password
                                             success:^(id  _Nonnull response) {
                                                 [self handleLoginJoinChannelData:response];
                                             } failure:^(NSError * _Nonnull error) {
                                                 if (self.networkErrorBlock) {
                                                     self.networkErrorBlock(error);
                                                 }
                                                 if ([self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                                                     [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorJoinChannelFailed];
                                                 }
                                             }];
}

- (void)updateRoomInfo {
    [self.messageManager sendUpdateChannel];
}

- (void)applyMic {
    NSInteger pos = [self userMicPositionInMicListWithUid:self.myselfModel.uid];
    if (pos != NSNotFound) {
        [SYToastView showToast:@"您已在麦上"];
        return;
    }
    [self.netManager requestApplyMicWithChannelID:self.channelID
                                              uid:self.currentUser.userid
                                          success:^(id  _Nonnull response) {
                                              [self handleApplyMicData:response];
                                          } failure:^(NSError * _Nonnull error) {
                                              if (error.code != 4085) {
                                                  if (self.networkErrorBlock) {
                                                      self.networkErrorBlock(error);
                                                  }
                                              }
                                          }];
}
- (void)cancelApplyMic {
    [self.netManager requestCancelApplyMicWithChannelID:self.channelID
                                                    uid:self.currentUser.userid
                                                success:^(id  _Nonnull response) {
                                                    [self handleCancelApplyMicData:response];
                                                } failure:^(NSError * _Nonnull error) {
                                                    if (error.code != 4086) {
                                                        if (self.networkErrorBlock) {
                                                            self.networkErrorBlock(error);
                                                        }
                                                    }
                                                }];
}

- (void)confirmMyselfHost {
    [self.netManager requestConfirmHostWithChannelID:self.channelID
                                                 uid:self.myselfModel.uid
                                             success:^(id  _Nullable response) {
                                                 [self handleConfirmHostMicData:response
                                                                           user:self.myselfModel
                                                                       position:0];
                                             } failure:^(NSError * _Nullable error) {
                                                 if (self.networkErrorBlock) {
                                                     self.networkErrorBlock(error);
                                                 }
                                             }];
}

- (void)changeMyselfFromOtherToHost {
    self.isChangingHostRole = YES;
    NSInteger position = [self userMicPositionInMicListWithUid:self.myselfModel.uid];
    if (position != NSNotFound) {
        [self kickMicAtMicPostion:position];
        return;
    }
    BOOL inApplyList = [self isMyselfContainsInApplyMicList];
    if (inApplyList) {
        [self cancelApplyMic];
    }
}

- (void)kickHost {
    SYVoiceRoomUser *user = self.usersInMicDict[@(0)];
    [self.netManager requestKickHostWithChannelID:self.channelID
                                              uid:user.uid?:@"0"
                                          success:^(id  _Nullable response) {
                                              [self handleKickHostMicData:response
                                                                     user:user
                                                                 position:0];
                                          } failure:^(NSError * _Nullable error) {
                                              if (self.networkErrorBlock) {
                                                  self.networkErrorBlock(error);
                                              }
                                          }];
}

- (void)confirmMicAtIndex:(NSInteger)index
               micPostion:(NSInteger)micPosition {
    SYVoiceRoomUser *user = self.usersInApplyMicArray[index];
    [self.netManager requestConfirmMicWithChannelID:self.channelID
                                                uid:user.uid?:@"0"
                                           position:micPosition-1
                                            success:^(id  _Nonnull response) {
                                                [self handleConfirmMicData:response
                                                                      user:user
                                                                  position:micPosition];
                                            } failure:^(NSError * _Nonnull error) {
                                                if (self.networkErrorBlock) {
                                                    self.networkErrorBlock(error);
                                                }
                                            }];
}

- (void)kickMicAtMicPostion:(NSInteger)micPosition {
    SYVoiceRoomUser *user = self.usersInMicDict[@(micPosition)];
    [self.netManager requestKickMicWithChannelID:self.channelID
                                             uid:user.uid?:@"0"
                                        position:micPosition-1
                                         success:^(id  _Nonnull response) {
                                             [self handleKickMicData:response
                                                                user:user
                                                            position:micPosition];
                                         } failure:^(NSError * _Nonnull error) {
                                             if (self.networkErrorBlock) {
                                                 self.networkErrorBlock(error);
                                             }
                                         }];
}

- (void)muteMyself {
    [self.messageManager muteUserLocalAudioStream:YES];
    NSInteger position = [self userMicPositionInMicListWithUid:self.currentUser.userid];
    if (position != NSNotFound) {
        if (position == 0) {
            [self muteHostMicAtMicPostion:position];
        } else {
            [self muteMicAtMicPostion:position];
        }
    }
}

- (void)cancelMuteMyself {
    [self.messageManager muteUserLocalAudioStream:NO];
    NSInteger position = [self userMicPositionInMicListWithUid:self.currentUser.userid];
    if (position != NSNotFound) {
        if (position == 0) {
            [self cancelMuteHostMicAtMicPosition:position];
        } else {
            [self cancelMuteMicAtMicPosition:position];
        }
    }
}

- (void)muteMicAtMicPostion:(NSInteger)micPosition {
    SYVoiceRoomUser *user = self.usersInMicDict[@(micPosition)];
    [self.netManager requestMuteMicWithChannelID:self.channelID
                                             uid:user.uid?:@"0"
                                        position:micPosition-1
                                         success:^(id  _Nonnull response) {
                                             [self handleMuteMicData:response
                                                                user:user
                                                            position:micPosition];
                                         } failure:^(NSError * _Nonnull error) {
                                             if (self.networkErrorBlock) {
                                                 self.networkErrorBlock(error);
                                             }
                                         }];
}

- (void)cancelMuteMicAtMicPosition:(NSInteger)micPosition {
    SYVoiceRoomUser *user = self.usersInMicDict[@(micPosition)];
    [self.netManager requestCancelMuteMicWithChannelID:self.channelID
                                                   uid:user.uid?:@"0"
                                              position:micPosition-1
                                               success:^(id  _Nonnull response) {
                                                   [self handleCancelMuteMicData:response
                                                                            user:user
                                                                        position:micPosition];
                                               } failure:^(NSError * _Nonnull error) {
                                                   if (self.networkErrorBlock) {
                                                       self.networkErrorBlock(error);
                                                   }
                                               }];
}

- (void)muteHostMicAtMicPostion:(NSInteger)micPosition {
    if (micPosition == 0) {
        SYVoiceRoomUser *user = self.usersInMicDict[@(micPosition)];
        [self.netManager requestMuteHostMicWithChannelID:self.channelID
                                                     uid:user.uid?:@"0"
                                                position:micPosition
                                                 success:^(id  _Nullable response) {
                                                     [self handleMuteHostMicData:response
                                                                            user:user
                                                                        position:micPosition];
                                                 } failure:^(NSError * _Nullable error) {
                                                     if (self.networkErrorBlock) {
                                                         self.networkErrorBlock(error);
                                                     }
                                                 }];
    }
}

- (void)cancelMuteHostMicAtMicPosition:(NSInteger)micPosition {
    if (micPosition == 0) {
        SYVoiceRoomUser *user = self.usersInMicDict[@(micPosition)];
        [self.netManager requestCancelMuteHostMicWithChannelID:self.channelID
                                                           uid:user.uid?:@"0"
                                                      position:micPosition
                                                       success:^(id  _Nullable response) {
                                                           [self handleCancelMuteHostMicData:response
                                                                                        user:user
                                                                                    position:micPosition];
                                                       } failure:^(NSError * _Nullable error) {
                                                           if (self.networkErrorBlock) {
                                                               self.networkErrorBlock(error);
                                                           }
                                                       }];
    }
}

- (void)sendTextMessage:(NSString *)text {
    if (self.isForbiddenChat) {
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
            [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorForbiddenChat];
        }
        return; // 禁言不能发言
    }
    
    [[SYUserServiceAPI sharedInstance] requestFilterText:text uid:@"0"
                                                 success:^(id  _Nullable response) {
                                                     if ([response isKindOfClass:[NSString class]]) {
                                                         SYVoiceRoomText *msg = [SYVoiceRoomText new];
                                                         msg.msg = response;
                                                         [self.messageManager sendTextMessage:msg user:self.myselfModel];
                                                     }
                                                 } failure:^(NSError * _Nullable error) {
                                                     if (error) {
                                                         if (self.networkErrorBlock) {
                                                             self.networkErrorBlock(error);
                                                         }
                                                     } else {
                                                         [SYToastView showToast:@"含有敏感信息，请重新输入"];
                                                     }
                                                 }];
    
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.myselfModel.uid?:@"", @"msgType": @(0)};
//    [MobClick event:@"roomMsgSend" attributes:dict];
}

- (void)sendDanmaku:(NSString *)danmaku danmukuId:(NSInteger)danmakuId {
    if (self.isForbiddenChat) {
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
            [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorForbiddenChat];
        }
        return; // 禁言不能发言
    }
    [[SYUserServiceAPI sharedInstance] requestFilterText:danmaku uid:@"0"
                                                 success:^(id  _Nullable response) {
                                                     if ([response isKindOfClass:[NSString class]]) {
                                                         SYVoiceRoomText *msg = [SYVoiceRoomText new];
                                                         msg.msg = response;
                                                         [self.messageManager sendDanmaku:msg
                                                                                danmukuId:danmakuId
                                                          user:self.myselfModel];
                                                     }
                                                 } failure:^(NSError * _Nullable error) {
                                                     if (error) {
                                                         if (self.networkErrorBlock) {
                                                             self.networkErrorBlock(error);
                                                         }
                                                     } else {
                                                         [SYToastView showToast:@"含有敏感信息，请重新输入"];
                                                     }
                                                 }];
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.myselfModel.uid?:@"", @"msgType": @(danmakuId+10)};
//    [MobClick event:@"roomMsgSend" attributes:dict];
}

- (void)sendGiftMessageWithReceiver:(SYVoiceChatUserViewModel *)receiver
                             giftID:(NSInteger)giftID
                       randomGiftID:(NSInteger)randomGiftID
                               nums:(NSInteger)nums {
    SYVoiceRoomGift *gift = [[SYVoiceRoomGift alloc] init];
    gift.giftid = giftID;
    SYGiftModel *giftModel = [[SYGiftInfoManager sharedManager] giftWithGiftID:giftID];
    gift.name = giftModel.name;
    gift.icon = giftModel.icon;
    gift.category_id = giftModel.category_id;
    gift.price = giftModel.price;
    gift.randomGiftId = randomGiftID;
    gift.nums = nums;
    [self.messageManager sendGiftMessage:gift toUser:receiver.user myself:self.myselfModel];
    NSInteger overScreenTrigger = [SYSettingManager internalFloatScreenTrigger];
    if (overScreenTrigger == 0) {
        overScreenTrigger = 500;
    }
    if (giftModel.price >= overScreenTrigger) {
        [self.messageManager sendOverScreenGiftMessage:gift
                                                toUser:receiver.user
                                                myself:self.myselfModel
                                                roomId:self.channelID];
    }
}

- (void)sendRandomGiftMessageWithGiftIDs:(NSArray *)giftIDs
                                  giftID:(NSInteger)giftID {
    SYVoiceRoomGift *gift = [[SYVoiceRoomGift alloc] init];
    SYGiftModel *giftModel = [[SYGiftInfoManager sharedManager] giftWithGiftID:giftID];
    gift.giftid = giftID;
    gift.category_id = giftModel.category_id;
    gift.extraGifts = giftIDs;
    [self.messageManager sendRandomGiftMessage:gift myself:self.myselfModel];
}

- (void)leaveChannel {
    [self stopBossTimer];
    [self stopTimer];
    [self stopAssistTimer];
    [self.messageManager leaveVoiceEngine];
    BOOL isGuest = [NSString sy_isBlankString:self.currentUser.userid];
    NSString *uid = isGuest ? self.guestUserId : self.currentUser.userid;
    [self.netManager requestLeaveChannelWithChannelID:self.channelID
                                                  uid:uid
                                              isGuest:isGuest
                                              success:^(id  _Nonnull response) {
                                                  [self.messageManager leaveChannelWithUser:self.myselfModel];
                                                  [self.messageManager leaveSignaling];
                                                  [self.messageManager leaveEM];
                                              } failure:^(NSError * _Nonnull error) {
                                                  [self.messageManager leaveSignaling];
                                                  [self.messageManager leaveEM];
//                                                  [self.messageManager leaveChannel];
//                                                  if (self.networkErrorBlock) {
//                                                      self.networkErrorBlock(error);
//                                                  }
                                              }];
}

- (void)forbidUserChatWithUser:(SYVoiceChatUserViewModel *)user {
    [self.netManager requestForbidUserChatWithChannelID:self.channelID
                                                    uid:user.uid
                                                success:^(id  _Nullable response) {
                                                    [self handleForbidUserChatData:response
                                                                              user:user.user];
                                                } failure:^(NSError * _Nullable error) {
                                                    if (self.networkErrorBlock) {
                                                        self.networkErrorBlock(error);
                                                    }
                                                }];
}

- (void)cancelForbidUserChatWithUser:(SYVoiceChatUserViewModel *)user {
    [self.netManager requestCancelForbidUserChatWithChannelID:self.channelID
                                                          uid:user.uid
                                                      success:^(id  _Nullable response) {
                                                          [self handleCancelForbidUserChatData:response
                                                                                          user:user.user];
                                                      } failure:^(NSError * _Nullable error) {
                                                          if (self.networkErrorBlock) {
                                                              self.networkErrorBlock(error);
                                                          }
                                                      }];
}

- (void)forbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user {
    [self.netManager requestForbidUserEnterWithChannelID:self.channelID
                                                     uid:user.uid
                                                 success:^(id  _Nullable response) {
                                                     [self handleForbidUserEnterData:response
                                                                                user:user.user];
                                                 } failure:^(NSError * _Nullable error) {
                                                     if (self.networkErrorBlock) {
                                                         self.networkErrorBlock(error);
                                                     }
                                                 }];
}

- (void)cancelForbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user {
    [self.netManager requestCancelForbidUserEnterWithChannelID:self.channelID
                                                           uid:user.uid
                                                       success:^(id  _Nullable response) {
                                                           [self handleCancelForbidUserEnterData:response
                                                                                            user:user.user];
                                                       } failure:^(NSError * _Nullable error) {
                                                           if (self.networkErrorBlock) {
                                                               self.networkErrorBlock(error);
                                                           }
                                                       }];
}

- (void)sendFollowUserMessageWithUser:(SYVoiceChatUserViewModel *)user {
    [self.messageManager sendFollowUserWithUser:self.myselfModel
                                       followee:user.user];
}

- (void)sendFollowUserMessageWithUserId:(NSString *)uid
                               username:(NSString *)username {
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = uid;
    user.username = username;
    [self.messageManager sendFollowUserWithUser:self.myselfModel
                                       followee:user];
}

- (void)closeChannel {
    [self.netManager requestCloseChannelWithChannelID:self.channelID
                                              success:^(id  _Nullable response) {
                                                  [self handleCloseChannelData:response];
                                              } failure:^(NSError * _Nullable error) {
                                                  if (self.networkErrorBlock) {
                                                      self.networkErrorBlock(error);
                                                  }
                                              }];
}

- (void)startPK {
    [self.netManager requestStartPKWithChannelId:self.channelID
                                         success:^(id  _Nullable response) {
                                             [self handleStartPKData:response];
                                         } failure:^(NSError * _Nullable error) {
                                             if (self.networkErrorBlock) {
                                                 self.networkErrorBlock(error);
                                             }
                                         }];
}

- (void)stopPK {
    if (self.pkListModel) {
        [self.netManager requestStopPKWithPKId:self.pkListModel.id
                                       success:^(id  _Nullable response) {
                                           [self handleStopPKData:response];
                                       } failure:^(NSError * _Nullable error) {
                                           if (self.networkErrorBlock) {
                                               self.networkErrorBlock(error);
                                           }
                                       }];
    }
}

- (void)refreshPKInfo {
    [self.netManager requestPKInfoWithChannelId:self.channelID
                                        success:^(id  _Nullable response) {
                                            if ([response isKindOfClass:[SYVoiceRoomPKListModel class]]) {
                                                SYVoiceRoomPKListModel *pkListModel = (SYVoiceRoomPKListModel *)response;
                                                [self messageManagerDidReceiveSyncPKList:pkListModel];
                                                [self.messageManager sendSyncPK:pkListModel];
                                            }
                                        } failure:^(NSError * _Nullable error) {
                                            
                                        }];
}

- (void)clearPublicScreen {
    [self.messageManager clearPublicScreen];
}

- (void)refreshBossInfo {
    [self.netManager requestRoomKingWithChannelId:self.channelID
                                          success:^(id  _Nullable response) {
                                              if ([response isKindOfClass:[SYVoiceRoomKingModel class]]) {
                                                  [self.messageManager sendSyncRoomKing:response];
                                              }
                                          } failure:^(NSError * _Nullable error) {
                                              
                                          }];
}

- (void)openChannel {
    [self.netManager requestOpenChannelWithChannelID:self.channelID
                                             success:^(id  _Nullable response) {
                                                 [self handleOpenChannelData:response];
                                             } failure:^(NSError * _Nullable error) {
                                                 if (self.networkErrorBlock) {
                                                     self.networkErrorBlock(error);
                                                 }
                                            }];
}

- (void)sendGameMessageWithGame:(SYVoiceRoomGameType)game
                         isHost:(BOOL)isHost {
    if (!self.gameManager) {
        self.gameManager = [[SYVoiceRoomGameManager alloc] init];
    }
    NSInteger position = 0;
    if (!isHost) {
        position = [self userMicPositionInMicListWithUid:self.myselfModel.uid];
        if (position == NSNotFound) {
            return;
        }
        position -= 1;
    }
    __weak typeof(self) weakSelf = self;
    [self.gameManager playGameWithGame:game
                            startBlock:^(SYVoiceRoomGame * _Nonnull gameModel) {
                                if (gameModel) {
                                    [weakSelf.messageManager sendGameMessageWithGame:gameModel
                                                                                user:weakSelf.myselfModel
                                                                            position:position
                                                                              isHost:isHost];
                                }
                            } endBlock:^(SYVoiceRoomGame * _Nonnull gameModel) {
                            }];
}

- (void)sendExpressionWithExpressionID:(NSInteger)expressionID {
    SYVoiceRoomExpression *expression = [[SYGiftInfoManager sharedManager] expressionWithExpressionID:expressionID];
    if (expression) {
        if (self.usersInMicDict) {
            NSInteger _position = -1;
            for (NSNumber *position in self.usersInMicDict.allKeys) {
                SYVoiceRoomUser *user = self.usersInMicDict[position];
                if ([position integerValue] == 0) {
                    if ([user.uid isEqualToString:self.myselfModel.uid]) {
                        [self.messageManager sendHostExpression:expression
                                                           user:self.myselfModel];
                        return;
                    }
                } else {
                    if ([user.uid isEqualToString:self.myselfModel.uid]) {
                        _position = [position integerValue] - 1;
                        break;
                    }
                }
            }
            
            [self.messageManager sendExpression:expression
                                           user:self.myselfModel
                                       position:_position];
        }
    }
}

- (void)sendBeeHoneyMessageWithGiftName:(NSString *)giftName
                                  price:(NSInteger)price
                                 giftId:(NSInteger)giftId
                               giftIcon:(NSString *)giftIcon
                               gameName:(NSString *)gameName {
    SYVoiceRoomGift *gift = [SYVoiceRoomGift new];
    gift.giftid = giftId;
    gift.name = giftName;
    gift.extraPrice = price;
    gift.price = 0;
    gift.icon = giftIcon;
    NSInteger trigger = [SYSettingManager beeGameInternalFloatScreenTrigger];
    if (gift.extraPrice >= trigger) {
        [self.messageManager sendOverScreenBeeGameMessage:gift
                                                   myself:self.myselfModel
                                                   roomId:self.channelID
                                                 gameName:gameName];
    }
    if ([self canBeeHoneyMessageBeSend]) {
        [self.messageManager sendBeeHoneyWithGift:gift
                                             user:self.myselfModel
                                         gameName:gameName];
    }
}

- (void)shareRoomToWeixin {
    [WXApiManager sharedManager].delegate = self;
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.roomModel.icon]
                                                          options:0
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [WXApiRequestHandler shareToWXSessionWithThumb:data
                                                                                                        roomId:weakSelf.roomModel.id
                                                                                                      roomName:weakSelf.roomModel.name];
                                                                
                                                                SYGiftNetManager *netManager = [SYGiftNetManager new];
                                                                [netManager dailyTaskLog:4];
                                                            });
                                                        }];
}



-  (void)shareRoomToWeixinSession {
    [WXApiManager sharedManager].delegate = self;
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.roomModel.icon]
                                                          options:0
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                NSString *url = [NSString stringWithFormat:SYRoomShareUrl,weakSelf.roomModel.id,SHANYIN_PCODE]; [WXApiRequestHandler shareToWXSessionWithTitle:weakSelf.roomModel.name description:@"快来围观吧~~" withThumbImage:image withUrl:url];
                                                                SYGiftNetManager *netManager = [SYGiftNetManager new];
                                                                [netManager dailyTaskLog:4];
                                                            });
                                                        }];
}


- (void)shareRoomToWeixinTimeLine {
    [WXApiManager sharedManager].delegate = self;
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.roomModel.icon]
                                                          options:0
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                NSString *url = [NSString stringWithFormat:SYRoomShareUrl,weakSelf.roomModel.id,SHANYIN_PCODE]; [WXApiRequestHandler shareToWXTimelineWithTitle:weakSelf.roomModel.name description:@"快来围观吧~~" withThumbImage:image withUrl:url];
                                                            });
                                                        }];
}

- (void)liveStreamStarted {
    [self stopLiveInterruptedTimer];
}

- (void)liveStreamInterrupted {
    [self startLiveInterruptedTimer];
}


- (void)startLiveStreaming:(NSString *)userId userName:(NSString *)userName {
    if (nil == userId ) {
        [self.messageManager sendStartStreamingMessageWithUser:self.myselfModel];
    }else {
        SYVoiceRoomUser *user = [SYVoiceRoomUser new];
        user.uid = userId;
        user.username= userName;
        [self.messageManager sendStartStreamingMessageWithUser:user];
    }
}

- (void)disableUpdateRolesList {
    self.rolesListNeedUpdate = NO;
}

#pragma mark - bgm

- (id <SYVoiceRoomPlayerControlProtocol>)playControlInstance {
    return [self.messageManager playControlInstance];
}

- (id <SYVoiceRoomAudioEffectProtocol>)audioEffectPlayer {
    return [self.messageManager audioEffectPlayer];
}

#pragma mark - process method

- (void)handleOperationData:(id)data {
    /**
     *  因为新增了老板位，在iPhone5机型上，因为屏幕尺寸较小，如果配置了运营位，运营位和老板位就会重叠;
     *  产品确认：iPhone5机型，即使配置了运营位数据，也不展示。
     */
    if (iPhone5) {
        return;
    }
    if ([data isKindOfClass:[NSArray class]]) {
        self.operationList = [NSArray arrayWithArray:data];
    }
    
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomOperationDataReady)]) {
        [self.delegate voiceChatRoomOperationDataReady];
    }

    // 运营位数据曝光
    NSArray *tempArr;
    for (int i = 0; i < [self.operationList count]; i ++) {
        tempArr = [self.operationList objectAtIndex:i];
        for (int j = 0; j < tempArr.count; j++) {
            SYVoiceRoomOperationModel *operation = [tempArr objectAtIndex:j];
            NSDictionary *dict = @{@"position": @(operation.position), @"destination": operation.jumplink?:@"",
                                   @"name": operation.title?:@"", @"type": @(operation.type)};
//            [MobClick event:@"roomOpExposure" attributes:dict];
        }
    }
}

// 处理获取的红包列表数据
- (void)handleRedpacketData:(id)data {
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSArray *listArr = [data objectForKey:@"list"];
        self.redPacketList = [NSArray yy_modelArrayWithClass:[SYRoomGroupRedpacketModel class]
                                                        json:listArr];
        if (self.redPacketList.count > 0) {
            self.assistTime = 0;
            [self startAssistTimer];
        }
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomRedpacketDataReady)]) {
            [self.delegate voiceChatRoomRedpacketDataReady];
        }
    }
}

- (void)handleReJoinChanelData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomJoinModel class]]) {
        SYVoiceRoomJoinModel *model = (SYVoiceRoomJoinModel *)data;
        SYChatRoomUserRole role = SYChatRoomUserRoleAudience;
        switch (model.identity) {
            case 1:
            {
                role = SYChatRoomUserRoleHomeOwner;
            }
                break;
            case 2:
            {
                role = SYChatRoomUserRoleAdminister;
            }
                break;
            case 3:
            {
                role = SYChatRoomUserRoleCommunity;
            }
                break;
            default:
                break;
        }
        self.initialRole = role;
        
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomUpdateToolBar)]) {
            [self.delegate voiceChatRoomUpdateToolBar];
        }
    }
}

- (void)handleLoginJoinChannelData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomJoinModel class]]) {
        SYVoiceRoomJoinModel *model = (SYVoiceRoomJoinModel *)data;
        if (model.disJoin) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorForbiddenEnter];
            }
            return;
        }
        if (model.roomStatus == 1 && model.identity == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorRoomClosed];
            }
            return;
        }
        SYChatRoomUserRole role = SYChatRoomUserRoleAudience;
        switch (model.identity) {
            case 1:
            {
                role = SYChatRoomUserRoleHomeOwner;
            }
                break;
            case 2:
            {
                role = SYChatRoomUserRoleAdminister;
            }
                break;
            case 3:
            {
                role = SYChatRoomUserRoleCommunity;
            }
                break;
            default:
                break;
        }
        self.initialRole = role;
        self.isForbiddenChat = model.disSay;
        // 假设拿到了用户角色是audience
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
            [self.delegate voiceChatRoomDidGetMyRole:role];
        }
        self.messageManager.needSendToEM = ![NSString sy_isBlankString:self.currentUser.userid];
        [self.messageManager reJoinEMWithEMUserId:self.currentUser.em_username];
        
        [self.messageManager reJoinVoiceRoomWithUserId:self.myselfModel.uid
                                            mediaToken:model.mtToken];
        
        if (self.usersInMicDict) {
            for (NSNumber *position in self.usersInMicDict.allKeys) {
                SYVoiceRoomUser *user = self.usersInMicDict[position];
                if ([position integerValue] == 0) {
                    if ([user.uid isEqualToString:self.myselfModel.uid]) {
                        SYChatRoomUserRole role = SYChatRoomUserRoleHost;
                        [self.messageManager changeUserRoleWithRole:role];
                        [self.messageManager muteUserLocalAudioStream:user.isMuted];
                        self.myselfModel.isMuted = user.isMuted;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                            [self.delegate voiceChatRoomDidGetMyRole:role];
                        }
                        [self refreshAgoraTokenWithUserId:0];
                        break;
                    }
                } else {
                    if ([user.uid isEqualToString:self.myselfModel.uid]) {
                        SYChatRoomUserRole role = SYChatRoomUserRoleBroadcaster;
                        [self.messageManager changeUserRoleWithRole:role];
                        [self.messageManager muteUserLocalAudioStream:user.isMuted];
                        self.myselfModel.isMuted = user.isMuted;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                            [self.delegate voiceChatRoomDidGetMyRole:role];
                        }
                        [self refreshAgoraTokenWithUserId:0];
                        break;
                    }
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomUpdateToolBar)]) {
                [self.delegate voiceChatRoomUpdateToolBar];
            }
        }
    }
}

- (void)handleJoinChannelData:(id)data {
    //每日任务上报埋点
    self.joinRoomTime = CACurrentMediaTime();
    self.hasDailyTaskUpload = NO;
    if ([data isKindOfClass:[SYVoiceRoomJoinModel class]]) {
        SYVoiceRoomJoinModel *model = (SYVoiceRoomJoinModel *)data;
        if (model.disJoin) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorForbiddenEnter];
            }
            return;
        }
        if (model.roomStatus == 1 && model.identity == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorRoomClosed];
            }
            return;
        }
        SYChatRoomUserRole role = SYChatRoomUserRoleAudience;
        switch (model.identity) {
            case 1:
            {
                role = SYChatRoomUserRoleHomeOwner;
            }
                break;
            case 2:
            {
                role = SYChatRoomUserRoleAdminister;
            }
                break;
            case 3:
            {
                role = SYChatRoomUserRoleCommunity;
            }
                break;
            default:
                break;
        }
        self.initialRole = role;
        self.isForbiddenChat = model.disSay;
        // 假设拿到了用户角色是audience
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
            [self.delegate voiceChatRoomDidGetMyRole:role];
        }
        BOOL isGuest = [NSString sy_isBlankString:self.currentUser.userid];
        if (isGuest) {
            self.guestUserId = model.userId;
            self.guestUserName = model.userInfo.username;
        }
        NSString *userId = isGuest ? model.userId : self.currentUser.userid;
        self.messageManager.needSendToEM = ![NSString sy_isBlankString:self.currentUser.userid];
        BOOL needVoiceSDK = YES;
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomNeedVoiceSDK)]) {
            needVoiceSDK = [self.delegate voiceChatRoomNeedVoiceSDK];
        }
        self.messageManager.voiceEngineEnabled = needVoiceSDK;
        [self.messageManager startProcessWithUserRole:role
                                               userId:userId
                                       signalingToken:model.rtmToken
                                           mediaToken:model.mtToken
                                              groupId:model.roomInfo.groupId
                                             emUserId:self.currentUser.em_username];
        [self handleChannelInfoData:model.roomInfo];
    }
}

- (void)handleJoinLiveChannelData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomJoinModel class]]) {
        SYVoiceRoomJoinModel *model = (SYVoiceRoomJoinModel *)data;
        if (model.disJoin) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorForbiddenEnter];
            }
            return;
        }
        if (model.roomStatus == 1 && model.identity == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
                [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorRoomClosed];
            }
            return;
        }
        
        SYChatRoomUserRole role = SYChatRoomUserRoleAudience;
        switch (model.identity) {
            case 1:
            {
                role = SYChatRoomUserRoleHomeOwner;
            }
                break;
            case 2:
            {
                role = SYChatRoomUserRoleAdminister;
            }
                break;
            case 3:
            {
                role = SYChatRoomUserRoleCommunity;
            }
                break;
            default:
                break;
        }
        
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
            [self.delegate voiceChatRoomDidGetMyRole:role];
        }
        
        BOOL isRoomOpen = !(BOOL)model.roomStatus;
        [self.netManager requestRolesListWithChannelID:self.channelID
                                               success:^(id  _Nullable response) {
                                                   if ([response isKindOfClass:[SYVoiceRoomPlayerListModel class]]) {
                                                       SYVoiceRoomPlayerListModel *list = (SYVoiceRoomPlayerListModel *)response;
                                                       NSString *hostID = nil;
                                                       SYVoiceRoomPlayerModel *player0 = [list.jockeyList firstObject];
                                                       if (player0) {
                                                           hostID = player0.userId;
                                                       }
                                                       if ([self.delegate respondsToSelector:@selector(liveRoomHostDidJoinRoomWithRoomOpenState:hostID:role:)]) {
                                                           [self.delegate liveRoomHostDidJoinRoomWithRoomOpenState:isRoomOpen
                                                                                                            hostID:hostID role:role];
                                                       }
                                                   }
                                               } failure:^(NSError * _Nullable error) {
                                                   
                                               }];
    }
}

- (void)handleChannelInfoData:(id)data {
    if ([data isKindOfClass:[SYChatRoomModel class]]) {
        SYChatRoomModel *roomModel = (SYChatRoomModel *)data;
        self.roomModel = roomModel;
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomInfoDataReady)]) {
            [self.delegate voiceChatRoomInfoDataReady];
        }
        
        __weak typeof(self) weakSelf = self;
        void (^block)(NSString *post) = ^(NSString *post) {
            SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
            SYVoiceRoomText *text = [SYVoiceRoomText new];
            text.msg = post;
            text.type = 6;
            message.msg = text;
            [weakSelf reloadPublicScreenMessageWithMessage:message];
            
            message = [SYVoiceRoomMessage new];
            message.msg = [SYVoiceRoomText new];
            message.msg.type = 3;
            message.msg.msg = [NSString stringWithFormat:@"欢迎语：%@", weakSelf.roomModel.greeting];
            [weakSelf reloadPublicScreenMessageWithMessage:message];
        };
        
        // 取完运营位信息取聊天室公告
        [self.netManager requestVoiceRoomPostWithSuccess:^(id  _Nullable response) {
            if ([response isKindOfClass:[NSString class]]) {
                block(response);
            }
        } failure:^(NSError * _Nullable error) {
            block(@"欢迎来到聊天室，Bee语音努力营造绿色健康的直播环境，对直播内容进行24小时巡查，任何传播违法、违规、低俗、暴力等不良信息的行为，一经发现，均会被封停账号。");
        }];
    }
}

- (void)handleRolesListData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomPlayerListModel class]]) {
        
        self.usersInMicDict = [NSMutableDictionary new];
        SYVoiceRoomPlayerListModel *list = (SYVoiceRoomPlayerListModel *)data;
        SYVoiceRoomPlayerModel *player0 = [list.jockeyList firstObject];
        if (player0) {
            SYVoiceRoomUser *user = [self userWithUserAPIModel:player0.userInfo];
            user.isMuted = (player0.status == 1);
            [self.usersInMicDict setObject:user forKey:@(0)];
            self.liveRoomHost = [[SYVoiceChatUserViewModel alloc] initWithUser:user
                                                                       isMuted:user.isMuted];
            
            if ([user.uid isEqualToString:self.myselfModel.uid]) {
                SYChatRoomUserRole role = SYChatRoomUserRoleHost;
                [self.messageManager changeUserRoleWithRole:role];
                [self.messageManager muteUserLocalAudioStream:user.isMuted];
                self.myselfModel.isMuted = user.isMuted;
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                    [self.delegate voiceChatRoomDidGetMyRole:role];
                }
                [self refreshAgoraTokenWithUserId:0];
            }
        }
        
        for (SYVoiceRoomPlayerModel *player in list.playList) {
            SYVoiceRoomUser *user = [self userWithUserAPIModel:player.userInfo];
            user.isMuted = (player.status == 1);
            [self.usersInMicDict setObject:user forKey:@(player.position+1)];
            
            if ([user.uid isEqualToString:self.myselfModel.uid]) {
                SYChatRoomUserRole role = SYChatRoomUserRoleBroadcaster;
                [self.messageManager changeUserRoleWithRole:role];
                [self.messageManager muteUserLocalAudioStream:user.isMuted];
                self.myselfModel.isMuted = user.isMuted;
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                    [self.delegate voiceChatRoomDidGetMyRole:role];
                }
                [self refreshAgoraTokenWithUserId:0];
            }
        }
        
        self.usersInApplyMicArray = [NSMutableArray new];
        for (SYVoiceRoomPlayerModel *player in list.waitList) {
            SYVoiceRoomUser *user = [self userWithUserAPIModel:player.userInfo];
            [self.usersInApplyMicArray addObject:user];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataPrepared)]) {
        [self.delegate voiceChatRoomDataPrepared];
    }
    
    if (self.messageManager.needSendToEM == NO) {
        if ([NSString sy_isBlankString:self.myselfModel.username] &&
            !self.myselfModel.uid && self.guestUserId.length >= 6) {
            self.myselfModel.username = [NSString stringWithFormat:@"Bee语音用户%@", [self.guestUserId substringFromIndex:(self.guestUserId.length - 6)]];
        }
        [self.messageManager sendEnterChannelMessageWithUser:self.myselfModel];
    }
    
    // 拿完麦位列表拿运营位信息
    [self.netManager requestVoiceRoomOperationWithSuccess:^(id  _Nullable response) {
        [self handleOperationData:response];
    } failure:^(NSError * _Nullable error) {
        if (self.networkErrorBlock) {
            self.networkErrorBlock(error);
        }
    }];
    
    [self.netManager requestPKInfoWithChannelId:self.channelID
                                        success:^(id  _Nullable response) {
                                            [self handlePKInfoData:response];
                                        } failure:^(NSError * _Nullable error) {
                                        }];
    
    // 获取老板麦信息
    [self.netManager requestRoomKingWithChannelId:self.channelID
                                          success:^(id  _Nullable response) {
                                              [self handleBossInfoData:response];
                                          } failure:^(NSError * _Nullable error) {
                                              
                                          }];
    
    // 获取房间列表群红包数据
    [self.saleManager requestRoomGroupRedPacketListWithRoomid:self.channelID success:^(id  _Nullable response) {
        [self handleRedpacketData:response];
    } failure:^(NSError * _Nullable error) {

    }];
    
    // 开始定时发心跳，获取麦位列表
    [self startTimer];
}

- (void)handleTimerRolesListData:(id)data {
    // 60秒定时获取rolelist
    if ([data isKindOfClass:[SYVoiceRoomPlayerListModel class]]) {
        
        BOOL originInMic = NO;
        if ([self isMyselfLogin] &&
            [self userMicPositionInMicListWithUid:self.myselfModel.uid] != NSNotFound) {
            originInMic = YES;
        }
        
        BOOL inMic = NO;
        NSMutableDictionary *dict = [NSMutableDictionary new];
        SYVoiceRoomPlayerListModel *list = (SYVoiceRoomPlayerListModel *)data;
        SYVoiceRoomPlayerModel *player0 = [list.jockeyList firstObject];
        if (player0) {
            SYVoiceRoomUser *user = [self userWithUserAPIModel:player0.userInfo];
            user.isMuted = (player0.status == 1);
            [dict setObject:user forKey:@(0)];
            
            if ([user.uid isEqualToString:self.myselfModel.uid]) {
                inMic = YES;
                SYChatRoomUserRole role = SYChatRoomUserRoleHost;
                [self.messageManager changeUserRoleWithRole:role];
                [self.messageManager muteUserLocalAudioStream:user.isMuted];
                self.myselfModel.isMuted = user.isMuted;
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                    [self.delegate voiceChatRoomDidGetMyRole:role];
                }
                
            }
        }
        
        for (SYVoiceRoomPlayerModel *player in list.playList) {
            SYVoiceRoomUser *user = [self userWithUserAPIModel:player.userInfo];
            user.isMuted = (player.status == 1);
            [dict setObject:user forKey:@(player.position+1)];
            
            if ([user.uid isEqualToString:self.myselfModel.uid]) {
                inMic = YES;
                SYChatRoomUserRole role = SYChatRoomUserRoleBroadcaster;
                [self.messageManager changeUserRoleWithRole:role];
                [self.messageManager muteUserLocalAudioStream:user.isMuted];
                self.myselfModel.isMuted = user.isMuted;
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                    [self.delegate voiceChatRoomDidGetMyRole:role];
                }
            }
        }
        self.usersInMicDict = dict;
        
        if (originInMic != inMic) {
            [self refreshAgoraTokenWithUserId:0];
            if (!inMic) {
                [self.messageManager changeUserRoleWithRole:self.initialRole];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
            [self.delegate voiceChatRoomUsersInMicDidChanged];
        }
        
        [self.usersInApplyMicArray removeAllObjects];
        for (SYVoiceRoomPlayerModel *player in list.waitList) {
            SYVoiceRoomUser *user = [self userWithUserAPIModel:player.userInfo];
            [self.usersInApplyMicArray addObject:user];
        }
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomUserInApplyMicListChanged)]) {
            [self.delegate voiceChatRoomUserInApplyMicListChanged];
        }
    }
}

- (void)handleApplyMicData:(id)data {
    [self.messageManager sendRequestMicMessage:self.myselfModel];
    
    NSString *role = (self.initialRole == SYChatRoomUserRoleAudience) ? @"听众": @"管理员";
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.myselfModel.uid?:@"",
                           @"role": role};
//    [MobClick event:@"roomReqMicClick" attributes:dict];
}

- (void)handleCancelApplyMicData:(id)data {
    [self.messageManager sendCancelRequestMicMessage:self.myselfModel];
}

- (void)handleConfirmMicData:(id)data
                        user:(SYVoiceRoomUser *)user
                    position:(NSInteger)position {
    if (user) {
        BOOL isMuted = NO;
        SYVoiceRoomUser *newUser = [self.usersInMicDict objectForKey:@(position)];
        if (newUser) {
            isMuted = newUser.isMuted;
        }
        [self.messageManager sendUpMicMessage:user position:position-1 isMute:isMuted];
        NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"opUserID": self.myselfModel.uid?:@"", @"userID": user.uid?:@""};
//        [MobClick event:@"roomUpMic" attributes:dict];
    }
}

- (void)handleKickMicData:(id)data
                     user:(SYVoiceRoomUser *)user
                 position:(NSInteger)position {
    SYVoiceRoomUser *_user = self.usersInMicDict[@(position)];
    if (_user && [_user.uid isEqualToString:user.uid]) {
        [self.messageManager sendDownMicMessage:user position:position-1];
        
        NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"opUserID": self.myselfModel.uid?:@"", @"userID": user.uid?:@""};
//        [MobClick event:@"roomDownMic" attributes:dict];
    }
}

- (void)handleConfirmHostMicData:(id)data
                            user:(SYVoiceRoomUser *)user
                        position:(NSInteger)position {
    if (user) {
        [self.messageManager sendHostUpMicMessage:user
                                         position:position];
        
        NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": user.uid?:@""};
//        [MobClick event:@"roomUpDirector" attributes:dict];
    }
}

- (void)handleKickHostMicData:(id)data
                         user:(SYVoiceRoomUser *)user
                     position:(NSInteger)position {
    SYVoiceRoomUser *_user = self.usersInMicDict[@(position)];
    if (_user && [_user.uid isEqualToString:user.uid]) {
        [self.messageManager sendHostDownMicMessage:user
                                           position:position];
        
        NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": user.uid?:@""};
//        [MobClick event:@"roomDownDirector" attributes:dict];
    }
}

- (void)handleMuteMicData:(id)data
                     user:(SYVoiceRoomUser *)user
                 position:(NSInteger)position {
    SYVoiceRoomUser *_user = self.usersInMicDict[@(position)];
    if (_user && ([_user.uid isEqualToString:user.uid] || (_user.uid == nil && user.uid == nil))) {
        [self.messageManager sendTurnOffMic:user position:position-1];
    }
}

- (void)handleCancelMuteMicData:(id)data
                           user:(SYVoiceRoomUser *)user
                       position:(NSInteger)position {
    SYVoiceRoomUser *_user = self.usersInMicDict[@(position)];
    if (_user && ([_user.uid isEqualToString:user.uid] || (_user.uid == nil && user.uid == nil))) {
        [self.messageManager sendTurnOnMicMessage:user position:position-1];
    }
}

- (void)handleMuteHostMicData:(id)data
                         user:(SYVoiceRoomUser *)user
                     position:(NSInteger)position {
    SYVoiceRoomUser *_user = self.usersInMicDict[@(position)];
    if (_user && ([_user.uid isEqualToString:user.uid] || (_user.uid == nil && user.uid == nil))) {
        [self.messageManager sendHostTurnOffMic:user position:position];
    }
}

- (void)handleCancelMuteHostMicData:(id)data
                               user:(SYVoiceRoomUser *)user
                           position:(NSInteger)position {
    SYVoiceRoomUser *_user = self.usersInMicDict[@(position)];
    if (_user && ([_user.uid isEqualToString:user.uid] || (_user.uid == nil && user.uid == nil))) {
        [self.messageManager sendHostTurnOnMicMessage:user position:position];
    }
}

- (void)handleForbidUserChatData:(id)data
                            user:(SYVoiceRoomUser *)user {
    [self.messageManager sendForbidUserChat:user];
}

- (void)handleCancelForbidUserChatData:(id)data
                                  user:(SYVoiceRoomUser *)user {
    [self.messageManager sendCancelForbidUserChat:user];
}

- (void)handleForbidUserEnterData:(id)data
                             user:(SYVoiceRoomUser *)user {
    [self.messageManager sendForbidUserEnter:user];
}

- (void)handleCancelForbidUserEnterData:(id)data
                                   user:(SYVoiceRoomUser *)user {
    [self.messageManager sendCancelForbidUserEnter:user];
}

- (void)handleCloseChannelData:(id)data {
    self.roomModel.status = 1;
    [self.messageManager sendCloseChannel];
}

- (void)handleOpenChannelData:(id)data {
    self.roomModel.status = 0;
    
}

- (void)handleStartPKData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomPKListModel class]]) {
        SYVoiceRoomPKListModel *pkListModel = (SYVoiceRoomPKListModel *)data;
        [self.messageManager sendStartPK:pkListModel];
        [SYToastView showToast:@"PK已开启"];
    }
}

- (void)handleStopPKData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomPKListModel class]]) {
        SYVoiceRoomPKListModel *pkListModel = (SYVoiceRoomPKListModel *)data;
        [self.messageManager sendStopPK:pkListModel];
        [SYToastView showToast:@"PK已关闭"];
    }
}

- (void)handlePKInfoData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomPKListModel class]]) {
        SYVoiceRoomPKListModel *pkListModel = (SYVoiceRoomPKListModel *)data;
        [self messageManagerDidReceiveSyncPKList:pkListModel];
    }
}

- (void)handleBossInfoData:(id)data {
    if ([data isKindOfClass:[SYVoiceRoomKingModel class]]) {
        self.bossModel = (SYVoiceRoomKingModel *)data;
        SYVoiceRoomBossViewModel *bossViewModel = [[SYVoiceRoomBossViewModel alloc] initWithBossModel:self.bossModel];
        self.isBossAvailable = bossViewModel.isValid;
        if (self.isBossAvailable) {
            [self startBossTimer];
        } else {
            [self stopBossTimer];
        }
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomBossStatusChanged)]) {
            [self.delegate voiceChatRoomBossStatusChanged];
        }
    }
}

#pragma mark - private method

- (void)startLiveInterruptedTimer {
    [self stopLiveInterruptedTimer];
    
    self.liveInterruptedTimer = [NSTimer scheduledTimerWithTimeInterval:300
                                                                 target:self
                                                               selector:@selector(interruptTimerAction:)
                                                               userInfo:nil
                                                                repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.liveInterruptedTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopLiveInterruptedTimer {
    if ([self.liveInterruptedTimer isKindOfClass:[NSTimer class]] &&
        [self.liveInterruptedTimer isValid]) {
        [self.liveInterruptedTimer invalidate];
    }
    self.liveInterruptedTimer = nil;
}

- (void)interruptTimerAction:(id)sender {
    [self stopLiveInterruptedTimer];
    [self messageManagerDidReceiveCloseChannel];
}

- (void)startBossTimer {
    [self stopBossTimer];
    self.bossTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(bossCountDown:)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.bossTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopBossTimer {
    if ([self.bossTimer isKindOfClass:[NSTimer class]] &&
        [self.bossTimer isValid]) {
        [self.bossTimer invalidate];
    }
    self.bossTimer = nil;
}

- (void)startTimer {
    [self stopTimer];
    self.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                           target:self
                                                         selector:@selector(requestHeartBeat:)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.heartBeatTimer
                                 forMode:NSRunLoopCommonModes];
    
    self.updateRoleListTimer = [NSTimer scheduledTimerWithTimeInterval:[SYSettingManager updatedRoleListInterval]
                                                                target:self
                                                              selector:@selector(updateRoleListTimerAction:)
                                                              userInfo:nil
                                                               repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.updateRoleListTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([self.heartBeatTimer isKindOfClass:[NSTimer class]] &&
        [self.heartBeatTimer isValid]) {
        [self.heartBeatTimer invalidate];
    }
    self.heartBeatTimer = nil;
    
    if ([self.updateRoleListTimer isKindOfClass:[NSTimer class]] &&
        [self.updateRoleListTimer isValid]) {
        [self.updateRoleListTimer invalidate];
    }
    self.updateRoleListTimer = nil;
}

- (void)requestHeartBeat:(id)sender {
    BOOL isGuest = [NSString sy_isBlankString:self.currentUser.userid];
    NSString *uid = isGuest ? self.guestUserId : self.currentUser.userid;
    [self.netManager requestHeartBeatWithChannelId:self.channelID
                                               uid:uid
                                           success:^(id  _Nullable response) {
                                               CFTimeInterval time =  CACurrentMediaTime();
                                               if ((time- self.joinRoomTime > 5*60) && !self.hasDailyTaskUpload) {
                                                   //直播时长5分钟上报
                                                   SYGiftNetManager *netManager = [SYGiftNetManager new];
                                                   [netManager dailyTaskLog:1];
                                                   self.hasDailyTaskUpload = YES;
                                               }
                                               
                                           } failure:^(NSError * _Nullable error) {
                                               
                                           }];
}

- (void)updateRoleListTimerAction:(id)sender {
    if (self.rolesListNeedUpdate) {
        [self requestUpdateRoleList:sender];
    }
    [self requestUpdateRoomHotScore];
}

- (void)requestUpdateRoleList:(id)sender {
    [self.netManager requestRolesListWithChannelID:self.channelID
                                           success:^(id  _Nullable response) {
                                               [self handleTimerRolesListData:response];
                                           } failure:^(NSError * _Nullable error) {
                                               
                                           }];
}

- (void)requestUpdateRoomHotScore {
    for (int i = 0; i < [self.usersInMicDict count]; i ++) {
        if ([self isMyselfAtMicPosition:i]) {
            [self.netManager requestChannelInfoWithChannelID:self.channelID
                                                     success:^(id  _Nullable response) {
                                                         if ([response isKindOfClass:[SYChatRoomModel class]]) {
                                                             SYChatRoomModel *roomModel = (SYChatRoomModel *)response;
                                                             [self.messageManager sendSyncRoomInfoMessage:roomModel];
                                                         }
                                                     } failure:^(NSError * _Nullable error) {
                                                         
                                                     }];
            break;
        }
    }
}

- (SYVoiceRoomUser *)userWithUserAPIModel:(SYVoiceRoomUserModel *)apiUser {
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = apiUser.id;
    user.bestid = apiUser.bestid;
    user.icon = apiUser.avatar;
    user.username = apiUser.name;
    user.gender = apiUser.gender;
    user.birthday = apiUser.birthday;
    user.age = [SYUtil ageWithBirthdayString:apiUser.birthday];
    user.avatarBox = apiUser.avatarbox;
    user.level = apiUser.level;
    user.streamer_level = apiUser.streamer_level;
    user.is_streamer = apiUser.is_streamer;
    user.is_super_admin = apiUser.is_super_admin;
    return user;
}

- (NSInteger)userMicPositionInMicListWithUid:(NSString *)uid {
    __block NSInteger ret = NSNotFound;
    [[self.usersInMicDict copy] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SYVoiceRoomUser class]]) {
            SYVoiceRoomUser *user = (SYVoiceRoomUser *)obj;
            if ([user.uid isEqualToString:uid]) {
                ret = [key integerValue];
                *stop = YES;
            }
        }
    }];
    return ret;
}

- (SYVoiceRoomUser *)userInApplyMicListWithUid:(NSString *)uid
                                isReverseCheck:(BOOL)isReverseCheck {
    SYVoiceRoomUser *ret = nil;
    NSArray *array = [self.usersInApplyMicArray copy];
    if (isReverseCheck) {
        array = [[array reverseObjectEnumerator] allObjects];
    }
    for (SYVoiceRoomUser *_user in array) {
        if ([_user.uid isEqualToString:uid]) {
            ret = _user;
            break;
        }
    }
    return ret;
}

- (void)addMessageToMessageArray:(SYVoiceRoomMessage *)message {
    if (!message) {
        return;
    }
    if ([self.textMessageArray count] > 200) {
        [self.textMessageArray removeObjectAtIndex:0];
    }
    [self.textMessageArray addObject:message];
}

- (void)reloadPublicScreenMessageWithMessage:(SYVoiceRoomMessage *)message {
    [self addMessageToMessageArray:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidReceivePublicScreenMessage)]) {
        [self.delegate voiceChatRoomDidReceivePublicScreenMessage];
    }
}


- (void)reloadLiveSteamUrl:(SYVoiceRoomMessage *)message {
    [self addMessageToMessageArray:message];
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomDidReceiveStartStreamingMessage)]) {
        [self.delegate liveRoomDidReceiveStartStreamingMessage];
    }
}

- (void)showUserProp:(nonnull SYVoiceRoomUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomShowUserProp:)]) {
        [self.delegate voiceChatRoomShowUserProp:user];
    }
}

- (void)requestMyselfInfo {
    [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
        if (success) {
            BOOL userUpgrade = (self.myselfModel && self.myselfModel.level < self.currentUser.level);
            [self getMyselfInfo];
            if (userUpgrade) {
                [self.messageManager sendUserUpgrade:self.myselfModel];
            }
        }
    }];
}

- (void)getMyselfInfo {
    SYVoiceRoomUser *user1 = [SYVoiceRoomUser new];
    user1.uid = self.currentUser.userid;
    user1.username = self.currentUser.username;
    user1.icon = self.currentUser.avatar_imgurl;
    user1.gender = self.currentUser.gender;
    user1.birthday = self.currentUser.birthday;
    user1.age = [SYUtil ageWithBirthdayString:self.currentUser.birthday];
    user1.level = self.currentUser.level;
    user1.avatarBox = self.currentUser.avatarbox;
    user1.vehicle = self.currentUser.vehicle;
    user1.streamer_level = self.currentUser.streamer_level;
    user1.is_streamer = self.currentUser.is_streamer;
    user1.is_super_admin = self.currentUser.is_super_admin;
    if (![NSString sy_isBlankString:user1.uid]) {
        self.guestUserId = nil;
        self.guestUserName = nil;
    }else {
        user1.username = self.guestUserName;
    }
    self.myselfModel = user1;
}

- (void)requestFollowStateWithBlock:(void(^)(BOOL isFollowed))block {
    SYVoiceChatUserViewModel *user = self.liveRoomHost;
    [self.netManager requestUserStatusWithChannelID:self.channelID
                                                uid:user.uid
                                            success:^(id  _Nullable response) {
                                                SYVoiceRoomUserStatusModel *status = (SYVoiceRoomUserStatusModel *)response;
                                                if (block) {
                                                    block(status.hasCare);
                                                }
                                            } failure:^(NSError * _Nullable error) {
                                                if (block) {
                                                    block(NO);
                                                }
                                            }];
}

- (void)updateOnlineNumber:(NSInteger)onlineNumber {
    self.roomModel.concurrentUser = onlineNumber;
}

- (void)refreshAgoraTokenWithUserId:(NSInteger)userId {
    __weak typeof(self) weakSelf = self;
    if (userId == 0) {
        userId = [self.messageManager.sdkUserId integerValue];
    }
    [self.netManager requestNewVoiceEngineTokenWithChannelId:self.channelID
                                                         uid:userId
                                                     success:^(id  _Nullable response) {
                                                         if ([response isKindOfClass:[NSString class]]) {
                                                             [weakSelf.messageManager renewVoiceEngineToken:response];
                                                         }
                                                     } failure:^(NSError * _Nullable error) {
                                                         if (self.networkErrorBlock) {
                                                             self.networkErrorBlock(error);
                                                         }
                                                     }];
}

- (void)gameFloatScreen:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    NSDictionary *dict = (NSDictionary *)noti.object;
    if (dict) {
        NSDictionary *msg = dict[@"msg"];
        if (msg) {
//            [MobClick event:@"breakEgg" attributes:@{@"roomID":self.channelID,@"userID":self.myselfModel.uid,@"hammer":[msg objectForKey:@"hammerName"],@"count":[msg objectForKey:@"hammerCount"],@"result":msg[@"price"]}];
            SYVoiceRoomGift *gift = [SYVoiceRoomGift new];
            gift.price = [msg[@"price"] integerValue];
            NSString *gameName = [msg objectForKey:@"gameName"];
            NSString *giftId = [msg objectForKey:@"giftId"];
            NSString *giftName = [msg objectForKey:@"giftName"];
            NSString *icon = [msg objectForKey:@"icon"];
            gift.giftid = [giftId integerValue];
            gift.name = giftName;
            gift.icon = icon;
            NSInteger trigger = [SYSettingManager gameInternalFloatScreenTrigger];
            if (trigger == 0) {
                trigger = 1000;
            }
            if (gift.price >= trigger) {
                [self.messageManager sendOverScreenGameMessage:gift
                                                        myself:self.myselfModel
                                                        roomId:self.channelID
                                                      gameName:gameName];
            }
            if ([self canBreakEggMessageBeSend]) {
                self.lastBreakEggTimeStamp = [[NSDate date] timeIntervalSince1970];
                SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
                message.msg = [SYVoiceRoomText new];
                message.msg.type = 10;
                message.gift = gift;
                message.user = self.myselfModel;
                message.gameName = gameName;
                [self reloadPublicScreenMessageWithMessage:message];
                [self.messageManager sendBreakEggWithGift:gift
                                                     user:self.myselfModel
                                                 gameName:gameName];
            }
        }
    }
    
}


/**
 自有通道消息处理

 @param sender noti
 */
- (void)webConnectionReceived:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    TokenCommand *command = (TokenCommand *)noti.object;
    if (command.type == TokenCommandTypeRoomBroadcast) {
        TokenRoomBroadcastCommand *roomBroadcast = (TokenRoomBroadcastCommand *)command;
        if ([self.channelID isEqualToString:roomBroadcast.roomId]) {
            NSDictionary *dic = [NSString sy_dictionaryWithJsonString:roomBroadcast.message];
            NSString *action = [dic objectForKey:@"action"];
            if (action && [action isEqualToString:@"stopStreaming"]) {
                [self messageManagerDidReceiveCloseChannel];
            }
        }
    }else if (command.type == TokenCommandTypeAllRoomBroadcast){

    }else if (command.type == TokenCommandTypeAllUserBroadcast){

    }else if (command.type == TokenCommandTypeLeaveRoom) {

    }else if (command.type == TokenCommandTypeJoinRoom) {

    }
}

- (NSInteger)beanValueWithUserId:(NSString *)userId {
    if ([userId integerValue] > 0) {
        for (SYVoiceRoomPKModel *pk in self.pkListModel.salesDetails) {
            if (pk.toUserId == [userId integerValue]) {
                return pk.giftPrice;
            }
        }
    }
    return 0;
}

- (NSString *)maxPKBeansUserId {
    if (!self.pkListModel) {
        return nil;
    }
    NSInteger maxBeans = 0;
    NSString *uid = nil;
    NSInteger count = [self.usersInMicDict.allKeys count];
  
    BOOL isFirstMicIndex = NO;

    for (int i = 0; i < count; i ++) {
        SYVoiceRoomUser *user = self.usersInMicDict[@(i)];
        if (user.uid) {
            if (!isFirstMicIndex) {
                isFirstMicIndex = YES;
                //初始默认最大值为首位有人的麦位的分值
                SYVoiceRoomUser *user = self.usersInMicDict[@(i)];
                maxBeans = [self beanValueWithUserId:user.uid];
                uid = user.uid;
            }
            NSInteger bean = [self beanValueWithUserId:user.uid];
            if (bean > maxBeans) {
                maxBeans = bean;
                uid = user.uid;
            }
        }
    }
    return uid;
}

- (NSString *)minPKBeansUserId {
    if (!self.pkListModel) {
        return nil;
    }

    NSInteger minBeans = 0;
    NSString *uid = nil;
    NSInteger count = [self.usersInMicDict.allKeys count];
 
    BOOL isFirstMicIndex = NO;
    for (int i = 0; i < count; i ++) {
        SYVoiceRoomUser *user = self.usersInMicDict[@(i)];
        if (user.uid) {
            if (!isFirstMicIndex) {
                isFirstMicIndex = YES;
                //初始默认最小值为首位有人的麦位的分值
                SYVoiceRoomUser *user = self.usersInMicDict[@(i)];
                minBeans = [self beanValueWithUserId:user.uid];
                uid = user.uid;
            }
            
            NSInteger bean = [self beanValueWithUserId:user.uid];
            if (bean < minBeans) {
                minBeans = bean;
                uid = user.uid;
            }
        }
    }
    return uid;
}


- (BOOL)canBreakEggMessageBeSend {
    return ([[NSDate date] timeIntervalSince1970] - self.lastBreakEggTimeStamp > [SYSettingManager gameMessageInterval]);
}

- (BOOL)canBeeHoneyMessageBeSend {
    return ([[NSDate date] timeIntervalSince1970] - self.lastBeeHoneyTimeStamp > [SYSettingManager beeHoneyMessageCD]);
}

- (void)bossCountDown:(id)sender {
    if (self.bossModel) {
        self.bossModel.current_timestamp += 1;
        SYVoiceRoomBossViewModel *bossViewModel = [[SYVoiceRoomBossViewModel alloc] initWithBossModel:self.bossModel];
        BOOL isBossAvailable = bossViewModel.isValid;
        if (isBossAvailable != self.isBossAvailable) {
            self.isBossAvailable = isBossAvailable;
            if (!self.isBossAvailable) {
                [self stopBossTimer];
            }
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomBossStatusChanged)]) {
                [self.delegate voiceChatRoomBossStatusChanged];
            }
        }
    }
}

#pragma mark - delegate method

- (void)messageManagerDidError {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDataError:)]) {
        [self.delegate voiceChatRoomDataError:SYVoiceChatRoomErrorSignaling];
    }
}

- (void)messageManagerDidJoinChannel {
    [self getMyselfInfo];
    // 获取房间麦位列表和排麦列表
    [self.netManager requestRolesListWithChannelID:self.channelID
                                           success:^(id  _Nullable response) {
                                               [self handleRolesListData:response];
                                           } failure:^(NSError * _Nullable error) {
                                               
                                           }];
}

- (void)messageManagerDidJoinEMChannel {
    if ([NSString sy_isBlankString:self.myselfModel.username] &&
        !self.myselfModel.uid && self.guestUserId.length >= 6) {
        self.myselfModel.username = [NSString stringWithFormat:@"Bee语音用户%@", [self.guestUserId substringFromIndex:(self.guestUserId.length - 6)]];
    }
    [self.messageManager sendEnterChannelMessageWithUser:self.myselfModel];
}

- (void)messageManagerVoiceEngineTokenWillExpireWithEngineUserId:(NSInteger)userId {
    [self refreshAgoraTokenWithUserId:userId];
}

- (void)messageManagerDidReceiveCancelMuteMicWithUser:(nonnull SYVoiceRoomUser *)user
                                           micPostion:(NSInteger)micPostion {
    micPostion += 1;
    NSLog(@"收到开麦消息，位置: %ld",(long)micPostion);
    SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
    if (savedUser) {
        savedUser.isMuted = NO;
        if (savedUser.uid && [savedUser.uid isEqualToString:user.uid]) {
            if ([savedUser.uid isEqualToString:self.myselfModel.uid]) {
                self.myselfModel.isMuted = NO;
                [self.messageManager muteUserLocalAudioStream:NO];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicMuteStateChangedWithState:position:)]) {
            [self.delegate voiceChatRoomUserInMicMuteStateChangedWithState:NO
                                                                  position:micPostion];
        }
    }
}

- (void)messageManagerDidReceiveMuteMicWithUser:(nonnull SYVoiceRoomUser *)user
                                     micPostion:(NSInteger)micPostion {
    micPostion += 1;
    NSLog(@"收到禁麦消息，位置: %ld",(long)micPostion);
    SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
    if (savedUser) {
        savedUser.isMuted = YES;
        if (savedUser.uid && [savedUser.uid isEqualToString:user.uid]) {
            if ([savedUser.uid isEqualToString:self.myselfModel.uid]) {
                self.myselfModel.isMuted = YES;
                [self.messageManager muteUserLocalAudioStream:YES];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicMuteStateChangedWithState:position:)]) {
            [self.delegate voiceChatRoomUserInMicMuteStateChangedWithState:YES
                                                                  position:micPostion];
        }
    }
}

- (void)messageManagerDidReceiveHostMuteMicWithUser:(SYVoiceRoomUser *)user
                                         micPostion:(NSInteger)micPostion {
    if (micPostion == 0) {
        SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
        if (savedUser) {
            savedUser.isMuted = YES;
            if (savedUser.uid && [savedUser.uid isEqualToString:user.uid]) {
                if ([savedUser.uid isEqualToString:self.myselfModel.uid]) {
                    self.myselfModel.isMuted = YES;
                    [self.messageManager muteUserLocalAudioStream:YES];
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicMuteStateChangedWithState:position:)]) {
                [self.delegate voiceChatRoomUserInMicMuteStateChangedWithState:YES
                                                                      position:micPostion];
            }
        }
    }
}

- (void)messageManagerDidReceiveHostCancelMuteMicWithUser:(SYVoiceRoomUser *)user
                                               micPostion:(NSInteger)micPostion {
    if (micPostion == 0) {
        SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
        if (savedUser) {
            savedUser.isMuted = NO;
            if (savedUser.uid && [savedUser.uid isEqualToString:user.uid]) {
                if ([savedUser.uid isEqualToString:self.myselfModel.uid]) {
                    self.myselfModel.isMuted = NO;
                    [self.messageManager muteUserLocalAudioStream:NO];
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicMuteStateChangedWithState:position:)]) {
                [self.delegate voiceChatRoomUserInMicMuteStateChangedWithState:NO
                                                                      position:micPostion];
            }
        }
    }
}

- (void)messageManagerDidReceiveConfirmMicWithUser:(nonnull SYVoiceRoomUser *)user
                                        micPostion:(NSInteger)micPostion {
    micPostion += 1; // 0-5 过度 1-6
    SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
    self.usersInMicDict[@(micPostion)] = user;
    if (savedUser) {
        user.isMuted = savedUser.isMuted;
    }
    SYVoiceRoomUser *_user = [self userInApplyMicListWithUid:user.uid
                                              isReverseCheck:NO];
    if (_user) {
        [self.usersInApplyMicArray removeObject:_user];
    }
    if ([user.uid isEqualToString:self.myselfModel.uid]) {
        SYChatRoomUserRole role = SYChatRoomUserRoleBroadcaster;
        [self.messageManager changeUserRoleWithRole:role];
        [self.messageManager muteUserLocalAudioStream:user.isMuted];
        self.myselfModel.isMuted = user.isMuted;
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
            [self.delegate voiceChatRoomDidGetMyRole:role];
        }
        [self refreshAgoraTokenWithUserId:0];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicChangedWithUser:position:isUpMic:)]) {
        NSInteger beans = [self beanValueWithUserId:user.uid];
        SYVoiceChatUserViewModel *userViewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:user
                                                                                         isMuted:user.isMuted
                                                   isPKing:self.isPKing beanValue:beans];
        [self.delegate voiceChatRoomUserInMicChangedWithUser:userViewModel
                                                    position:micPostion
                                                     isUpMic:YES];
        if (userViewModel.uid && ([[self maxPKBeansUserId] isEqualToString:userViewModel.uid]||[[self minPKBeansUserId] isEqualToString:userViewModel.uid])) {
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
                [self.delegate voiceChatRoomUsersInMicDidChanged];
            }
        }
    }
    
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 5;
    message.msg.msg = [NSString stringWithFormat:@"%@已上麦", [NSString sy_safeString:user.username]];
    message.user = user;
    [self reloadPublicScreenMessageWithMessage:message];
}

- (void)messageManagerDidReceiveKickMicWithUser:(nonnull SYVoiceRoomUser *)user
                                     micPostion:(NSInteger)micPostion {
    micPostion += 1;
    SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
    if ([user.uid isEqualToString:self.myselfModel.uid]) {
        [self.messageManager changeUserRoleWithRole:self.initialRole];
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
            [self.delegate voiceChatRoomDidGetMyRole:self.initialRole];
        }
        if (self.isChangingHostRole) {
            self.isChangingHostRole = NO;
            [self confirmMyselfHost];
        } else {
            [self refreshAgoraTokenWithUserId:0];
        }
    }
    if ([savedUser.uid isEqualToString:user.uid]) {
        BOOL removePKKing = NO;
        if (savedUser.uid && ([[self maxPKBeansUserId] isEqualToString:savedUser.uid]||[[self minPKBeansUserId] isEqualToString:savedUser.uid])) {
            removePKKing = YES;
        }
        [self.usersInMicDict removeObjectForKey:@(micPostion)];
        SYVoiceRoomUser *newUser = [SYVoiceRoomUser new];
        newUser.isMuted = savedUser.isMuted;
        [self.usersInMicDict setObject:newUser
                                forKey:@(micPostion)];
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicChangedWithUser:position:isUpMic:)]) {
            SYVoiceChatUserViewModel *userViewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:newUser
                                                                                             isMuted:user.isMuted];
            userViewModel.kickedUid = user.uid;
            [self.delegate voiceChatRoomUserInMicChangedWithUser:userViewModel
                                                        position:micPostion
                                                         isUpMic:NO];
            if (removePKKing) {
                if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
                    [self.delegate voiceChatRoomUsersInMicDidChanged];
                }
            }
        }
        SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
        message.msg = [SYVoiceRoomText new];
        message.msg.type = 5;
        message.msg.msg = [NSString stringWithFormat:@"%@已下麦", [NSString sy_safeString:user.username]];
        message.user = user;
        [self reloadPublicScreenMessageWithMessage:message];
    }
}

- (void)messageManagerDidReceiveConfirmHostMicWithUser:(SYVoiceRoomUser *)user
                                            micPostion:(NSInteger)micPostion {
    if (micPostion == 0) {
        SYVoiceRoomUser *_user = [self userInApplyMicListWithUid:user.uid
                                                  isReverseCheck:NO];
        if (_user) {
            [self.usersInApplyMicArray removeObject:_user];
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInApplyMicListChanged)]) {
                [self.delegate voiceChatRoomUserInApplyMicListChanged];
            }
        }
        
        NSInteger micPosition = [self userMicPositionInMicListWithUid:user.uid];
        if (micPosition != NSNotFound) {
            SYVoiceRoomUser *_user = self.usersInMicDict[@(micPosition)];
            if (_user) {
                [self.usersInMicDict removeObjectForKey:@(micPosition)];
                SYVoiceRoomUser *newUser = [SYVoiceRoomUser new];
                newUser.isMuted = _user.isMuted;
                [self.usersInMicDict setObject:newUser
                                        forKey:@(micPosition)];
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicChangedWithUser:position:isUpMic:)]) {
                    SYVoiceChatUserViewModel *userViewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:newUser
                                                                                                     isMuted:user.isMuted];
                    [self.delegate voiceChatRoomUserInMicChangedWithUser:userViewModel
                                                                position:micPosition
                                                                 isUpMic:NO];
                }
            }
        }
        
        // 现在主持人只有0
        SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
        self.usersInMicDict[@(micPostion)] = user;
        if (savedUser) {
            user.isMuted = savedUser.isMuted;
        }
        if ([user.uid isEqualToString:self.myselfModel.uid]) {
            SYChatRoomUserRole role = SYChatRoomUserRoleHost;
            [self.messageManager changeUserRoleWithRole:role];
            [self.messageManager muteUserLocalAudioStream:user.isMuted];
            self.myselfModel.isMuted = user.isMuted;
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                [self.delegate voiceChatRoomDidGetMyRole:role];
            }
            [self refreshAgoraTokenWithUserId:0];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicChangedWithUser:position:isUpMic:)]) {
            NSInteger beans = [self beanValueWithUserId:user.uid];
            SYVoiceChatUserViewModel *userViewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:user
                                                                                             isMuted:user.isMuted
                                                       isPKing:self.isPKing beanValue:beans];
            [self.delegate voiceChatRoomUserInMicChangedWithUser:userViewModel
                                                        position:micPostion
                                                         isUpMic:YES];
            if ( userViewModel.uid && ([[self maxPKBeansUserId] isEqualToString:userViewModel.uid]||[[self minPKBeansUserId] isEqualToString:userViewModel.uid])) {
                if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
                    [self.delegate voiceChatRoomUsersInMicDidChanged];
                }
            }
        }
        
        SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
        message.msg = [SYVoiceRoomText new];
        message.msg.type = 5;
        message.msg.msg = [NSString stringWithFormat:@"%@已上麦", [NSString sy_safeString:user.username]];
        message.user = user;
        [self reloadPublicScreenMessageWithMessage:message];
    }
}

- (void)messageManagerDidReceiveKickHostMicWithUser:(SYVoiceRoomUser *)user
                                         micPostion:(NSInteger)micPostion {
    if (micPostion == 0) {
        SYVoiceRoomUser *savedUser = self.usersInMicDict[@(micPostion)];
        if ([user.uid isEqualToString:self.myselfModel.uid]) {
            [self.messageManager changeUserRoleWithRole:self.initialRole];
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidGetMyRole:)]) {
                [self.delegate voiceChatRoomDidGetMyRole:self.initialRole];
            }
            [self refreshAgoraTokenWithUserId:0];
        }
        if ([savedUser.uid isEqualToString:user.uid]) {
            BOOL removePKKing = NO;
            if (savedUser.uid && ([[self maxPKBeansUserId] isEqualToString:savedUser.uid] || [[self minPKBeansUserId] isEqualToString:savedUser.uid])) {
                removePKKing = YES;
            }
            SYVoiceRoomUser *newUser = [SYVoiceRoomUser new];
            newUser.isMuted = savedUser.isMuted;
            [self.usersInMicDict removeObjectForKey:@(micPostion)];
            [self.usersInMicDict setObject:newUser
                                    forKey:@(micPostion)];
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicChangedWithUser:position:isUpMic:)]) {
                SYVoiceChatUserViewModel *userViewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:newUser
                                                                                                 isMuted:user.isMuted];
                userViewModel.kickedUid = user.uid;
                [self.delegate voiceChatRoomUserInMicChangedWithUser:userViewModel
                                                            position:micPostion
                                                             isUpMic:NO];
                if (removePKKing) {
                    if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
                        [self.delegate voiceChatRoomUsersInMicDidChanged];
                    }
                }
            }
            SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
            message.msg = [SYVoiceRoomText new];
            message.msg.type = 5;
            message.msg.msg = [NSString stringWithFormat:@"%@已下麦", [NSString sy_safeString:user.username]];
            message.user = user;
            [self reloadPublicScreenMessageWithMessage:message];
        }
    }
}

- (void)messageManagerDidReceiveGiftMessage:(nonnull SYVoiceRoomGift *)gift
                                     sender:(nonnull SYVoiceRoomUser *)sender
                                   receiver:(nonnull SYVoiceRoomUser *)receiver {
    NSLog(@"收到礼物消息，礼物: %@，sender: %@, receiver: %@", gift.name, sender.username, receiver.username);
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.gift = gift;
    message.user = sender;
    message.receiver = receiver;
    if ([gift.extraGifts count] == 0) {
        // 随机礼物本身不显示在公屏等地方
//        NSInteger internalTrigger = [SYSettingManager internalFloatScreenTrigger];
//        if (internalTrigger == 0) {
//            internalTrigger = 500;
//        }
//        NSInteger trigger = [SYSettingManager floatScreenTrigger];
//        if (trigger == 0) {
//            trigger = 1880;
//        }
//        if (gift.price >= internalTrigger && gift.price < trigger) {
//            message.from = @"OverScreenInternal";
//        }
        [self reloadPublicScreenMessageWithMessage:message];
        
        // 收到礼物，更新主播等级信息
        if ([self isMyselfLogin]) {
            if ([receiver.uid isEqualToString:self.myselfModel.uid]) {
                [self requestMyselfInfo];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidReceiveGiftWithGiftID:randomGiftIDs:withSender:withReciever:)]) {
        [self.delegate voiceChatRoomDidReceiveGiftWithGiftID:gift.giftid randomGiftIDs:gift.extraGifts withSender:sender withReciever:receiver];
    }
}

- (void)messageManagerDidReceiveTextMessage:(nonnull SYVoiceRoomText *)text
                                     sender:(nonnull SYVoiceRoomUser *)sender {
    NSLog(@"收到文字消息: %@", text.msg);
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = text;
    message.user = sender;
    [self reloadPublicScreenMessageWithMessage:message];
}

- (void)messageManagerDidReceiveUserApplyMicWithUser:(nonnull SYVoiceRoomUser *)user {
    NSLog(@"收到用户申请排麦消息");
    if (user) {
        SYVoiceRoomUser *_user = [self userInApplyMicListWithUid:user.uid
                                                  isReverseCheck:YES];
        if (_user) {
            return;
        }
        user.age = [SYUtil ageWithBirthdayString:user.birthday];
        [self.usersInApplyMicArray addObject:user];
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInApplyMicListChanged)]) {
            [self.delegate voiceChatRoomUserInApplyMicListChanged];
        }
    }
}

- (void)messageManagerDidReceiveUserCancelApplyMicWithUser:(nonnull SYVoiceRoomUser *)user {
    NSLog(@"收到用户取消申请排麦消息");
    if (user) {
        for (SYVoiceRoomUser *_user in [self.usersInApplyMicArray copy]) {
            if ([_user.uid isEqualToString:user.uid]) {
                [self.usersInApplyMicArray removeObject:_user];
                if ([user.uid isEqualToString:self.myselfModel.uid] &&
                    self.isChangingHostRole) {
                    self.isChangingHostRole = NO;
                    [self confirmMyselfHost];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInApplyMicListChanged)]) {
                    [self.delegate voiceChatRoomUserInApplyMicListChanged];
                }
                break;
            }
        }
    }
}

- (void)messageManagerDidReceiveUserJoinInChannelWithUser:(nonnull SYVoiceRoomUser *)user {
    NSLog(@"收到用户进入房间消息");
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 2;
    message.user = user;
    NSString *str = [NSString stringWithFormat:@"%@ 进入房间",user.username];
    message.msg.msg = str;
    [self reloadPublicScreenMessageWithMessage:message];
    //显示用户座驾
    [self showUserProp:user];
    
    if (self.roomModel) {
        self.roomModel.concurrentUser ++;
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomOnlineUserNumberDidChangedWithNumber:myself:)]) {
            [self.delegate voiceChatRoomOnlineUserNumberDidChangedWithNumber:self.roomModel.concurrentUser
                                                                      myself:[user.uid isEqualToString:self.myselfModel.uid]];
        }
    }
}

- (void)messageManagerDidReceiveUserLeaveChannelWithUser:(nonnull SYVoiceRoomUser *)user {
    SYVoiceRoomUser *_user = [self userInApplyMicListWithUid:user.uid
                                              isReverseCheck:NO];
    if (_user) {
        [self.usersInApplyMicArray removeObject:_user];
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInApplyMicListChanged)]) {
            [self.delegate voiceChatRoomUserInApplyMicListChanged];
        }
    }
    
    NSInteger micPosition = [self userMicPositionInMicListWithUid:user.uid];
    if (micPosition != NSNotFound) {
        SYVoiceRoomUser *_user = self.usersInMicDict[@(micPosition)];
        if (_user) {
            [self.usersInMicDict removeObjectForKey:@(micPosition)];
            SYVoiceRoomUser *newUser = [SYVoiceRoomUser new];
            newUser.isMuted = _user.isMuted;
            [self.usersInMicDict setObject:newUser
                                    forKey:@(micPosition)];
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserInMicChangedWithUser:position:isUpMic:)]) {
                SYVoiceChatUserViewModel *userViewModel = [[SYVoiceChatUserViewModel alloc] initWithUser:newUser
                                                                                                 isMuted:user.isMuted];
                [self.delegate voiceChatRoomUserInMicChangedWithUser:userViewModel
                                                            position:micPosition
                                                             isUpMic:NO];
            }
        }
    }
    
    if (self.roomModel) {
        if (self.roomModel.concurrentUser > 0) {
            self.roomModel.concurrentUser --;
        }
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomOnlineUserNumberDidChangedWithNumber:myself:)]) {
            [self.delegate voiceChatRoomOnlineUserNumberDidChangedWithNumber:self.roomModel.concurrentUser
                                                                      myself:[user.uid isEqualToString:self.myselfModel.uid]];
        }
    }
}

// 禁言
- (void)messageManagerDidReceiveForbidChatWithUser:(SYVoiceRoomUser *)user {
    if (user.uid && [self.myselfModel.uid isEqualToString:user.uid]) {
        self.isForbiddenChat = YES;
    }
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomUserIsForbiddenChatWithUid:)]) {
        [self.delegate voiceChatRoomUserIsForbiddenChatWithUid:user.uid];
    }
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 5;
    message.msg.msg = [NSString stringWithFormat:@"%@被禁言", [NSString sy_safeString:user.username]];
    message.user = user;
    [self reloadPublicScreenMessageWithMessage:message];
}

- (void)messageManagerDidReceiveCancelForbidChatWithUser:(SYVoiceRoomUser *)user {
    if (user.uid && [self.myselfModel.uid isEqualToString:user.uid]) {
        self.isForbiddenChat = NO;
    }
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomUserCancelForbiddenChatWithUid:)]) {
        [self.delegate voiceChatRoomUserCancelForbiddenChatWithUid:user.uid];
    }
//    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
//    message.msg = [SYVoiceRoomText new];
//    message.msg.type = 5;
//    message.msg.msg = [NSString stringWithFormat:@"%@被取消禁言", [NSString sy_safeString:user.username]];
//    [self reloadPublicScreenMessageWithMessage:message];
}

// 禁入
- (void)messageManagerDidReceiveForbidEnterWithUser:(SYVoiceRoomUser *)user {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserIsForbiddenEnterChannelWithUid:)]) {
        [self.delegate voiceChatRoomUserIsForbiddenEnterChannelWithUid:user.uid];
    }
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 5;
    message.msg.msg = [NSString stringWithFormat:@"%@被禁入", [NSString sy_safeString:user.username]];
    message.user = user;
    [self reloadPublicScreenMessageWithMessage:message];
    
    [self messageManagerDidReceiveUserLeaveChannelWithUser:user];
}

- (void)messageManagerDidReceiveCancelForbidEnterWithUser:(SYVoiceRoomUser *)user {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomUserCancelForbiddenEnterChannelWithUid:)]) {
        [self.delegate voiceChatRoomUserCancelForbiddenEnterChannelWithUid:user.uid];
    }
}

- (void)messageManagerDidReceiveFollowMessageWithFollower:(SYVoiceRoomUser *)follower
                                                 followee:(SYVoiceRoomUser *)followee {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 31;
    message.user = follower;
    message.receiver = followee;
    [self reloadPublicScreenMessageWithMessage:message];
}

- (void)messageManagerDidReceiveCloseChannel {
    self.roomModel.status = 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidCloseChannel)]) {
        [self.delegate voiceChatRoomDidCloseChannel];
    }
}

- (void)messageManagerDidReceiveOpenChannel {
    self.roomModel.status = 0;
}

- (void)messageManagerDidReceiveUpdateChannel {
    [self.netManager requestChannelInfoWithChannelID:self.channelID
                                             success:^(id  _Nullable response) {
                                                 if ([response isKindOfClass:[SYChatRoomModel class]]) {
                                                     SYChatRoomModel *roomModel = (SYChatRoomModel *)response;
                                                     self.roomModel = roomModel;
                                                     if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomInfoDataReady)]) {
                                                         [self.delegate voiceChatRoomInfoDataReady];
                                                     }
                                                 }
                                             } failure:^(NSError * _Nullable error) {
                                                 
                                             }];
}

- (void)messageManagerDidReceiveAdminStatusChangedWithUser:(SYVoiceRoomUser *)user {
    if (user.uid && [self.myselfModel.uid isEqualToString:user.uid]) {
        [self.netManager requestJoinChannelWithChannelID:self.channelID
                                                     uid:user.uid
                                                password:self.password
                                                 success:^(id  _Nullable response) {
                                                     [self handleReJoinChanelData:response];
                                                 } failure:^(NSError * _Nullable error) {
                                                     
                                                 }];
    }
}

- (void)messageManagerDidReceiveStartGame:(SYVoiceRoomGame *)game
                                     user:(nonnull SYVoiceRoomUser *)user {
    NSInteger micPosition = [self userMicPositionInMicListWithUid:user.uid];
    if (micPosition == NSNotFound) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomDidStartGameWithMicPosition:game:gameImageNames:resultImageName:)]) {
        if (!self.gameManager) {
            self.gameManager = [[SYVoiceRoomGameManager alloc] init];
        }
        [self.delegate voiceChatRoomDidStartGameWithMicPosition:micPosition
                                                           game:game.type
                                                      gameImageNames:[self.gameManager gameAnimateImageNamesWithGameType:game.type]
                                                    resultImageName:[SYVoiceRoomGameManager gameImageNameWithGameType:game.type value:game.value]];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
        message.game = game;
        message.user = user;
        [weakSelf reloadPublicScreenMessageWithMessage:message];
    });
}

- (void)messageManagerDidIndicateSpeakersWithUids:(NSArray <NSNumber *>*)uids {
    BOOL isMyself = NO;
    NSMutableArray *positions = [NSMutableArray new];
    for (NSNumber *uid in uids) {
        NSInteger intUid = [uid integerValue];
        if (intUid == 0) {
            isMyself = YES;
            intUid = [self.myselfModel.uid integerValue];
        }
        NSInteger position = [self userMicPositionInMicListWithUid:[NSString stringWithFormat:@"%ld",(long)intUid]];
        [positions addObject:@(position)];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomDidIndicateSpeakersInMicPositions:isMyself:)]) {
        [self.delegate voiceChatRoomDidIndicateSpeakersInMicPositions:positions isMyself:isMyself];
    }
}

- (void)messageManagerDidReceiveOverScreenMessage:(SYVoiceRoomMessage *)message {
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomDidReceiveOverScreenMessage:)]) {
        [self.delegate voiceChatRoomDidReceiveOverScreenMessage:[[SYVoiceTextMessageViewModel alloc] initWithMessage:message]];
    }
}

- (void)messageManagerDidReceiveStartPKWithPKList:(SYVoiceRoomPKListModel *)pkListModel {
    // pk清零，开始显示甜蜜值
    self.isPKing = YES;
    self.pkListModel = pkListModel;
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomPKStatusChanged)]) {
        [self.delegate voiceChatRoomPKStatusChanged];
    }
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
        [self.delegate voiceChatRoomUsersInMicDidChanged];
    }
}

- (void)messageManagerDidReceiveStopPKWithPKList:(SYVoiceRoomPKListModel *)pkListModel {
    // pk清零，不显示甜蜜值
    self.isPKing = NO;
    self.pkListModel = pkListModel;
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomPKStatusChanged)]) {
        [self.delegate voiceChatRoomPKStatusChanged];
    }
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
        [self.delegate voiceChatRoomUsersInMicDidChanged];
    }
}

- (void)messageManagerDidReceiveSyncPKList:(SYVoiceRoomPKListModel *)pkListModel {
    if (!pkListModel) {
        return;
    }
    if (self.pkListModel && self.pkListModel.unixMsno >= pkListModel.unixMsno) {
        // 同步老数据则不更新
        return;
    }
    self.pkListModel = pkListModel;
    self.isPKing = (pkListModel.status == 1);
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomUsersInMicDidChanged)]) {
        [self.delegate voiceChatRoomUsersInMicDidChanged];
    }
}

- (void)messageManagerDidCheckUnreadMessage:(BOOL)hasUnread {
    self.hasUnreadMessage = hasUnread;
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomDidCheckUnreadMessage:)]) {
        [self.delegate voiceChatRoomDidCheckUnreadMessage:hasUnread];
    }
}

- (void)messageManagerDidReceiveClearPublicScreen {
    if (self.textMessageArray) {
        __weak typeof(self) weakSelf = self;
        void (^block)(NSString *post) = ^(NSString *post) {
            [weakSelf.textMessageArray removeAllObjects];
            
            SYVoiceRoomMessage *clearMessage = [SYVoiceRoomMessage new];
            SYVoiceRoomText *clearText = [SYVoiceRoomText new];
            clearText.msg = @"公屏消息已清除";
            clearText.type = 6;
            clearMessage.msg = clearText;
            [weakSelf reloadPublicScreenMessageWithMessage:clearMessage];
            
            SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
            SYVoiceRoomText *text = [SYVoiceRoomText new];
            text.msg = post;
            text.type = 6;
            message.msg = text;
            [weakSelf reloadPublicScreenMessageWithMessage:message];
            
            message = [SYVoiceRoomMessage new];
            message.msg = [SYVoiceRoomText new];
            message.msg.type = 3;
            message.msg.msg = [NSString stringWithFormat:@"欢迎语：%@", weakSelf.roomModel.greeting];
            [weakSelf reloadPublicScreenMessageWithMessage:message];
        };
        
        // 取完运营位信息取聊天室公告
        [self.netManager requestVoiceRoomPostWithSuccess:^(id  _Nullable response) {
            if ([response isKindOfClass:[NSString class]]) {
                block(response);
            }
        } failure:^(NSError * _Nullable error) {
            block(@"欢迎来到聊天室，Bee语音努力营造绿色健康的直播环境，对直播内容进行24小时巡查，任何传播违法、违规、低俗、暴力等不良信息的行为，一经发现，均会被封停账号。");
        }];
    }
}

- (void)messageManagerDidReceiveUserUpgradeMessageWithUser:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 9;
    message.user = user;
    [self reloadPublicScreenMessageWithMessage:message];
}

- (void)messageManagerDidReceiveBreakEggMessage:(SYVoiceRoomGift *)gift
                                         sender:(SYVoiceRoomUser *)sender
                                       gameName:(nonnull NSString *)gameName {
    if ([self canBreakEggMessageBeSend]) {
        self.lastBreakEggTimeStamp = [[NSDate date] timeIntervalSince1970];
        SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
        message.msg = [SYVoiceRoomText new];
        message.msg.type = 10;
        message.gift = gift;
        message.user = sender;
        message.gameName = gameName;
        [self reloadPublicScreenMessageWithMessage:message];
    }
}

- (void)messageManagerDidReceiveBeeHoneyMessage:(SYVoiceRoomGift *)gift
                                         sender:(SYVoiceRoomUser *)sender
                                       gameName:(NSString *)gameName {
    if ([self canBeeHoneyMessageBeSend]) {
        self.lastBeeHoneyTimeStamp = [[NSDate date] timeIntervalSince1970];
        SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
        message.msg = [SYVoiceRoomText new];
        message.msg.type = 30;
        message.gift = gift;
        message.user = sender;
        message.gameName = gameName;
        [self reloadPublicScreenMessageWithMessage:message];
    }
}

- (void)messageManagerDidReceiveExpression:(SYVoiceRoomExpression *)expression
                                      user:(SYVoiceRoomUser *)user
                               micPosition:(NSInteger)micPosition {
    micPosition += 1;
    if (micPosition >= 1) {
        // 在麦位，需要在麦位显示表情
        SYVoiceRoomUser *_user = self.usersInMicDict[@(micPosition)];
        if ([_user.uid isEqualToString:user.uid]) {
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomDidReceiveExpressionWithPosition:expressionImages:)]) {
                NSArray *images = [[SYGiftInfoManager sharedManager] expressionAnimationImagesWithExpressionID:expression.id];
                [self.delegate voiceChatRoomDidReceiveExpressionWithPosition:micPosition
                                                            expressionImages:images];
            }
        }
    }
    
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.emoji = expression;
    message.user = user;
    [self reloadPublicScreenMessageWithMessage:message];
}

- (void)messageManagerDidReceiveHostExpression:(SYVoiceRoomExpression *)expression
                                          user:(SYVoiceRoomUser *)user {
    if (user) {
        SYVoiceRoomUser *_user = self.usersInMicDict[@(0)];
        if ([_user.uid isEqualToString:user.uid]) {
            // 展示表情，并且在主持人位置显示表情
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomDidReceiveExpressionWithPosition:expressionImages:)]) {
                NSArray *images = [[SYGiftInfoManager sharedManager] expressionAnimationImagesWithExpressionID:expression.id];
                [self.delegate voiceChatRoomDidReceiveExpressionWithPosition:0
                                                            expressionImages:images];
            }
            
            SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
            message.emoji = expression;
            message.user = user;
            [self reloadPublicScreenMessageWithMessage:message];
        }
    }
}

- (void)messageManagerDidReceiveBossInfo:(SYVoiceRoomKingModel *)bossInfo {
    [self handleBossInfoData:bossInfo];
}

// 发送群红包
- (void)messageManagerDidReceiveSendGroupRedPacketMessage:(SYVoiceRoomUser *)sender {
    // 收到发送群红包信令，刷新群红包列表
    [self refreshRoomGroupRedpacketList];
    // 发送一条公屏消息 - @"*** 发了个红包哦~ 3分钟后领取"
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = SYVoiceTextMessageTypeSendRedpacket;
    message.user = sender;
    NSString *str = [NSString stringWithFormat:@"%@ 发了个红包哦~ 3分钟后领取",sender.username];
    message.msg.msg = str;
    [self reloadPublicScreenMessageWithMessage:message];
}

// 领取群红包
- (void)messageManagerDidReceiveGetGroupRedPacketMessage:(SYVoiceRoomUser *)sender fromUserModel:(SYVoiceRoomBoonModel *)fromUserModel {
    NSLog(@"*** 在 ***的红包中领取了***蜜豆，感谢老板~");
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.user = sender;
    message.receiver = fromUserModel.user;
    message.msg = [SYVoiceRoomText new];
    message.msg.type = SYVoiceTextMessageTypeGetRedpacket;
    NSString *str = [NSString stringWithFormat:@"%@在%@的红包领取了%ld蜜豆，感谢老板~",sender.username,fromUserModel.user.username,fromUserModel.count];
    message.msg.msg = str;
    message.extra = [SYVoiceRoomExtra new];
    message.extra.data = [NSString stringWithFormat:@"%ld",fromUserModel.count];    // 传入蜜豆数
    [self reloadPublicScreenMessageWithMessage:message];
}

- (void)messageManagerDidReceiveGetGroupRedPacketEmptyMessage:(SYVoiceRoomBoomEmptyModel *)emptyModel {
    if (emptyModel && self.redPacketList && self.redPacketList.count > 0) {
        NSString *redPacketId = emptyModel.redbag_id;
        NSString *roomId = emptyModel.room_id;
        NSString *ownerId = emptyModel.owner_id;
        SYRoomGroupRedpacketModel *tempModel;
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.redPacketList];
        for (int i = 0; i < tempArr.count; i++) {
            tempModel = [tempArr objectAtIndex:i];
            if ([tempModel.redbag_id isEqualToString:redPacketId] &&
                [tempModel.room_id isEqualToString:roomId] &&
                [tempModel.owner_id isEqualToString:ownerId]) {
                break;
            } else {
                tempModel = nil;
            }
        }
        if (tempModel) {
            [tempArr removeObject:tempModel];
            self.redPacketList = [NSArray arrayWithArray:tempArr];
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomRefreshGroupRedPacketData)]) {
                [self.delegate voiceChatRoomRefreshGroupRedPacketData];
            }
        }
    }
}

//直播推直播流
- (void)messageManagerDidReceiveStartStreamingWithUser:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 122;
    message.user = user;
    [self reloadLiveSteamUrl:message];
}

- (void)messageManagerDidReceiveRoomInfoSyncWithRoomInfo:(SYChatRoomModel *)roomInfo {
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomDidFetchRoomHotScore:)]) {
        [self.delegate voiceChatRoomDidFetchRoomHotScore:roomInfo.score];
    }
}

#pragma mark - room info change protocol

- (void)voiceRoomInfoDidChange {
    [self updateRoomInfo];
}

- (void)voiceRoomInfoDidAddAdminister:(NSString *)uid {
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = uid;
    [self.messageManager sendAddAdminister:user];
}

- (void)voiceRoomInfoDidDeleteAdminister:(NSString *)uid {
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = uid;
    [self.messageManager sendDeleteAdminister:user];
}

- (void)voiceRoomInfoDidRemoveForbiddenChatUser:(NSString *)uid {
    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    user.uid = uid;
    [self.messageManager sendCancelForbidUserChat:user];
}

- (void)voiceRoomInfoDidRemoveForbiddenEnterUser:(NSString *)uid {
    
}

- (void)voiceRoomInfoDidChangeRoomBackgroundImage:(NSInteger)imageNum {
    //
    
}

#pragma mark -

- (void)managerDidRecvSendMessageToWXResponse:(SendMessageToWXResp *)response {
    //sso 授权完成
    if ([response isKindOfClass:[SendAuthResp class]]) {

    }else if ([response isKindOfClass:[WXLaunchMiniProgramResp class]]){
        if (response.errCode == WXSuccess) {//微信小程序  拉起成功
            NSString *uid = self.myselfModel.uid ?: self.guestUserId;
            NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": uid?:@""};
//            [MobClick event:@"roomShareSuccess" attributes:dict];
        }else{ //微信小程序   拉起失败

        }
    } else{
        if (response.errCode == WXSuccess) {
            NSString *uid = self.myselfModel.uid ?: self.guestUserId;
            NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": uid?:@"",@"url":[NSString stringWithFormat:SYRoomShareUrl,self.roomModel.id,SHANYIN_PCODE]};
//            [MobClick event:@"roomShareSuccess" attributes:dict];
            [SYToastView showToast:@"分享成功"];
        }else{
            [SYToastView showToast:response.errCode == WXErrCodeUserCancel ? @"用户取消" : @"分享失败"];
        }
    }
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response  {

}



@end
