//
//  SYVoiceChatRoomDetailInfoViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomDetailInfoViewModel.h"
#import "SYVoiceChatNetManager.h"
#import "SYVoiceChatRoomDetailInfoVC.h"

@interface SYVoiceChatRoomDetailInfoViewModel ()

@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, strong) NSMutableArray *dataSources;         // 分组数据源
@property (nonatomic, strong) SYChatRoomModel *roomModel;         // 房间信息

@property (nonatomic, assign) BOOL openPassword;    // 开关
@property (nonatomic, copy) NSString *passWord;     // 房间密码

@end

@implementation SYVoiceChatRoomDetailInfoViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *tempArr = @[@[@"房间名称",@"玩法公告",@"欢迎语",@"房间封面",@"房间背景"],
                             @[@"管理员列表"],
                             @[@"禁言名单",@"禁入名单"],
                             @[@"房间加密"]
                             ];
        self.dataSources = [NSMutableArray arrayWithArray:tempArr];
        self.openPassword = NO;
        self.passWord = @"";
    }
    return self;
}

- (void)setIsLiving:(BOOL)isLiving {
    _isLiving = isLiving;
    if (isLiving) {
        NSArray *tempArr = @[@[@"房间名称",@"欢迎语",@"房间封面"],
                             @[@"管理员列表"],
                             @[@"禁言名单",@"禁入名单"]
                             ];
        self.dataSources = [NSMutableArray arrayWithArray:tempArr];
    }
}

#pragma mark - 房间信息

- (void)requestChannelInfoWithChannelID:(NSString *)channelID {
    __weak typeof(self)weakSelf = self;
    if (!self.isLiving) {
        // 请求房间密码
        [self.netManager requestRoomPasswordWithChannelId:channelID success:^(id  _Nullable response) {
            if ([response isKindOfClass:[NSString class]]) {
                weakSelf.passWord = (NSString *)response;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getChannelInfoSuccess)]) {
                    [weakSelf.delegate getChannelInfoSuccess];
                }
            }
        } failure:^(NSError * _Nullable error) {
            weakSelf.passWord = @"";
        }];
    }
    // 请求房间信息
    [self.netManager requestChannelInfoWithChannelID:channelID success:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYChatRoomModel class]]) {
            SYChatRoomModel *model = (SYChatRoomModel *)response;
            weakSelf.roomModel = model;
            if (model) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getChannelInfoSuccess)]) {
                    [weakSelf.delegate getChannelInfoSuccess];
                }
            } else {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getChannelInfoFailed)]) {
                    [weakSelf.delegate getChannelInfoFailed];
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getChannelInfoFailed)]) {
            [weakSelf.delegate getChannelInfoFailed];
        }
    }];
}

- (void)openRoomEncryptionWithChannelId:(NSString *)channelId password:(NSString *)password success:(openEncryptionBlock)success {
    __weak typeof(self) weakSelf = self;
    [self.netManager requestUpdateRoomPasswordWithChannelId:channelId lock:1 password:password success:^(id  _Nullable response) {
        weakSelf.passWord = password;
        [weakSelf openRoomEncryption:YES];
        success(YES);
    } failure:^(NSError * _Nullable error) {
        weakSelf.passWord = @"";
        [weakSelf openRoomEncryption:NO];
        success(NO);
    }];
}

- (void)closeRoomEncryptionWithChannelId:(NSString *)channelId success:(openEncryptionBlock)success {
    __weak typeof(self) weakSelf = self;
    [self.netManager requestUpdateRoomPasswordWithChannelId:channelId lock:0 password:@"" success:^(id  _Nullable response) {
        [weakSelf openRoomEncryption:NO];
        success(YES);
    } failure:^(NSError * _Nullable error) {
        [weakSelf openRoomEncryption:YES];
        success(NO);
    }];
}

#pragma mark - Setter

- (void)setIsRoomOwner:(BOOL)isRoomOwner {
    _isRoomOwner = isRoomOwner;
    // 不是房主，没有管理员列表
    if (!isRoomOwner) {
        [self.dataSources removeObjectAtIndex:1];
    }
}

- (void)setRoomModel:(SYChatRoomModel *)roomModel {
    _roomModel = roomModel;
    if (!self.isLiving) {
        NSInteger lock = roomModel.lock;
        [self openRoomEncryption: lock == 1];
    }
}

#pragma mark - Private

- (void)openRoomEncryption:(BOOL)open {
    if (open) {
        self.openPassword = YES;
        [self.dataSources removeLastObject];
        [self.dataSources addObject:@[@"房间加密",@"房间密码"]];
    } else {
        self.openPassword = NO;
        self.passWord = @"";
        [self.dataSources removeLastObject];
        [self.dataSources addObject:@[@"房间加密"]];
    }
}

#pragma mark - CellData

- (NSInteger)numberOfSections {
    return self.dataSources.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    NSArray *subArr = [self.dataSources objectAtIndex:section];
    return subArr.count;
}

- (NSString *)mainTitleWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *subArr = [self.dataSources objectAtIndex:indexPath.section];
    return [NSString sy_safeString:[subArr objectAtIndex:indexPath.item]];
}

- (NSString *)subTitleWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceChatRoomDetailInfoType cellType = [self cellTypeWithIndexPath:indexPath];
    switch (cellType) {
        case SYVoiceChatRoomName:
            return [NSString sy_safeString:self.roomModel.name];
            break;
        case SYVoiceChatRoomPlay:
            return [NSString sy_safeString:self.roomModel.desc];
            break;
        case SYVoiceChatRoomWelcome:
            return [NSString sy_safeString:self.roomModel.greeting];
            break;
        case SYVoiceChatRoomPassword:
            return [NSString sy_safeString:self.passWord];
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)subImageUrlStrWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceChatRoomDetailInfoType cellType = [self cellTypeWithIndexPath:indexPath];
    if (cellType == SYVoiceChatRoomCover_1_1) {
        return [NSString sy_safeString:self.roomModel.icon];
    } else if (cellType == SYVoiceChatRoomBackdrop) {
        NSString *backDropFile = [NSString stringWithFormat:@"voiceroom_bg_%ld",[self roomBackDropNum]];
        return backDropFile;
    }
    return @"";
}

- (BOOL)showBottomLine:(NSIndexPath *)indexPath {
    NSArray *subArr = [self.dataSources objectAtIndex:indexPath.section];
    return indexPath.item < subArr.count - 1;
}

- (BOOL)showUISwitchBtn:(NSIndexPath *)indexPath {
    SYVoiceChatRoomDetailInfoType cellType = [self cellTypeWithIndexPath:indexPath];
    if (cellType == SYVoiceChatRoomEncryption) {
        return YES;
    }
    return NO;
}

- (BOOL)judgeUISwitchBtnOpenState:(NSIndexPath *)indexPath {
    SYVoiceChatRoomDetailInfoType cellType = [self cellTypeWithIndexPath:indexPath];
    if (cellType == SYVoiceChatRoomEncryption) {
        return self.openPassword;
    }
    return NO;
}

- (SYVoiceChatRoomDetailInfoType)cellTypeWithIndexPath:(NSIndexPath *)indexPath {
    if (self.isLiving) {
        SYVoiceChatRoomDetailInfoType type = SYVoiceChatRoomUnknow;
        NSInteger section = indexPath.section;
        NSInteger item = indexPath.item;
        if (section == 0) {
            switch (item) {
                case 0:
                {
                    type = SYVoiceChatRoomName;
                }
                    break;
                case 1:
                {
                    type = SYVoiceChatRoomWelcome;
                }
                    break;
                case 2:
                {
                    type = SYVoiceChatRoomCover_1_1;
                }
                    break;
                default:
                    break;
            }
        }
        if (self.isRoomOwner) {
            if (section == 1) {
                type = SYVoiceChatRoomManagerList;
            } else if (section == 2) {
                if (item == 0) {
                    type = SYVoiceChatRoomForbideChat;
                } else if (item == 1) {
                    type = SYVoiceChatRoomForbideEnter;
                }
            }
        } else {
            if (section == 1) {
                if (item == 0) {
                    type = SYVoiceChatRoomForbideChat;
                } else if (item == 1) {
                    type = SYVoiceChatRoomForbideEnter;
                }
            }
        }
        return type;
    }
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0) {
        return (SYVoiceChatRoomDetailInfoType)item;
    }
    if (self.isRoomOwner) {
        switch (section) {
            case 1:
            {
                if (item == 0) {
                    return SYVoiceChatRoomManagerList;
                }
            }
                break;
            case 2:
            {
                if (item == 0) {
                    return SYVoiceChatRoomForbideChat;
                } else if (item == 1) {
                    return SYVoiceChatRoomForbideEnter;
                }
            }
                break;
            case 3:
            {
                if (item == 0) {
                    return SYVoiceChatRoomEncryption;
                } else if (item == 1) {
                    return SYVoiceChatRoomPassword;
                }
            }
                break;
            default:
                break;
        }
    } else {
        switch (section) {
            case 1:
            {
                if (item == 0) {
                    return SYVoiceChatRoomForbideChat;
                } else if (item == 1) {
                    return SYVoiceChatRoomForbideEnter;
                }
            }
                break;
            case 2:
            {
                if (item == 0) {
                    return SYVoiceChatRoomEncryption;
                } else if (item == 1) {
                    return SYVoiceChatRoomPassword;
                }
            }
                break;
            default:
                break;
        }
    }
    return SYVoiceChatRoomUnknow;
}

- (NSInteger)roomBackDropNum {
    if (self.roomModel) {
        // 最多4张背景图，取值分别对应：0，1，2，3。
        NSInteger bgNum = self.roomModel.background;
        if (bgNum < 0 || bgNum > 3) {
            return 0;
        }
        return bgNum;
    }
    return 0;
}

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
