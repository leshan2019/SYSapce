//
//  SYVoiceRoomGiftView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiftView.h"
#import "SYVoiceChatRoomGiftViewModel.h"
#import "SYGiftReceiverListView.h"
#import "SYVoiceRoomGiftGroupView.h"
#import "SYVoiceRoomGiftNumSendView.h"
#import "SYGiftNetManager.h"

#define GiftReceiverListHeight 44
#define GiftToolbarHeight 49
#define GiftGroupButtonHeight 43.f
#define GiftGroupButtonStartTag 30430

@interface SYVoiceRoomGiftView () <SYGiftReceiverListViewDelegate, SYVoiceRoomGiftGroupViewDelegate, SYVoiceRoomGiftNumSendViewDelegate>

@property (nonatomic, assign) BOOL isAllMic; // 是否打赏全麦
@property (nonatomic, strong) NSString *channelID;

@property (nonatomic, strong) UIView *backMask;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SYGiftReceiverListView *receiverListView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UIButton *cashierButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) SYVoiceRoomGiftNumSendView *numSendView;

@property (nonatomic, strong) SYVoiceChatRoomGiftViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *groupGiftViewArray;

@property (nonatomic, assign) NSInteger selectedGiftGroup;
@property (nonatomic, assign) NSInteger highlightedIndex;

@property (nonatomic, strong) NSArray <SYVoiceChatUserViewModel *>*receiverArray;

@end

@implementation SYVoiceRoomGiftView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame isAllMic:NO channelID:@""];
}

- (instancetype)initWithFrame:(CGRect)frame
                     isAllMic:(BOOL)isAllMic
                    channelID:(nonnull NSString *)channelID {
    self = [super initWithFrame:frame];
    if (self) {
        _channelID = channelID;
        _selectedGiftGroup = 0;
        if (kShiningGiftBagSupported) {
            _selectedGiftGroup = 1;
        }
        _highlightedIndex = -1;
        _isAllMic = isAllMic;
        [self addSubview:self.backMask];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.receiverListView];
        [self.containerView addSubview:[self lineWithY:GiftReceiverListHeight+GiftGroupButtonHeight]];
        CGFloat groupViewHeight = [self groupViewHeight];
        groupViewHeight += GiftPageControlHeight;
        self.bottomLine = [self lineWithY:(self.receiverListView.sy_bottom + GiftGroupButtonHeight + groupViewHeight)];
        [self.containerView addSubview:self.bottomLine];
        [self.containerView addSubview:self.icon];
        [self.containerView addSubview:self.balanceLabel];
        [self.containerView addSubview:self.cashierButton];
        [self.containerView addSubview:self.sendButton];
        [self.containerView addSubview:self.numSendView];
        
        _viewModel = [[SYVoiceChatRoomGiftViewModel alloc] init];
        _groupGiftViewArray = [NSMutableArray new];
    }
    return self;
}

- (void)destroy {
    [self.numSendView destroy];
}

- (void)loadGifts {
    [self.viewModel requestGiftListWithBlock:^(BOOL success) {
        if (success) {
            [self reloadData];
        }
    }];
    [self loadBalance];
}

- (void)loadBalance {
    [self.viewModel requestWalletWithBlock:^(BOOL success) {
        if (success) {
            self.balanceLabel.text = [NSString stringWithFormat:@"%@", @(self.viewModel.walletCoinAmount)];
            CGRect rect = [self.balanceLabel.text boundingRectWithSize:CGSizeMake(999, self.balanceLabel.sy_height)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName: self.balanceLabel.font}
                                                               context:nil];
            self.balanceLabel.sy_width = rect.size.width;
            self.cashierButton.sy_left = self.balanceLabel.sy_right + 20.f;
        } else {
            [SYToastView showToast:@"金币余额获取失败"];
        }
    }];
}

- (void)reloadData {
    NSInteger groupCount = [self.viewModel giftGroupCount];
    
    CGFloat x = 20.f;
    CGFloat padding = 25.f;
    CGFloat width = 50.f;
    for (int i = 0; i < groupCount; i ++) {
        NSString *title = [self.viewModel giftGroupNameWithGroupIndex:i];
        if (kShiningGiftBagSupported && i == 0) {
            width = 30.f;
        } else {
            if (title.length == 2) {
                width = 30.f;
            } else if (title.length > 3) {
                width = 58.f;
            } else if (title.length > 2) {
                width = 44.f;
            }
        }
        UIButton *groupButton = [self groupButtonWithGroupIndex:i
                                                          frame:CGRectMake(x, self.receiverListView.sy_bottom, width, GiftGroupButtonHeight)
                                                          title:title];
        groupButton.selected = (i == self.selectedGiftGroup);
        [self.containerView addSubview:groupButton];
        x += (width + padding);
        
        if (i < (groupCount - 1)) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x - padding / 2.f, groupButton.sy_top + (groupButton.sy_height - 12.f) / 2.f, 0.5f, 12.f)];
            line.backgroundColor = [UIColor sam_colorWithHex:@"#575757"];
            [self.containerView addSubview:line];
        }
        
        CGFloat groupViewHeight = [self groupViewHeight];
        SYVoiceRoomGiftGroupView *groupView = [[SYVoiceRoomGiftGroupView alloc] initWithFrame:CGRectMake(0, self.receiverListView.sy_bottom + GiftGroupButtonHeight, self.containerView.sy_width, groupViewHeight + GiftPageControlHeight)];
        if (kShiningGiftBagSupported) {
            groupView.isGiftBag = (i == 0);
        } else {
            groupView.isGiftBag = NO;
        }
        groupView.delegate = self;
        [self.containerView addSubview:groupView];
        [self.groupGiftViewArray addObject:groupView];
        groupView.hidden = (i != self.selectedGiftGroup);
        [groupView showGiftListWithGroup:i
                               viewModel:self.viewModel];
    }
    
    if ([self.dataSource respondsToSelector:@selector(giftViewReceiversWithGiftView:)]) {
        self.receiverArray = [self.dataSource giftViewReceiversWithGiftView:self];
    }
    
    NSInteger count = [self.receiverArray count];
    NSMutableArray *avatarArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        SYVoiceChatUserViewModel *user = [self.receiverArray objectAtIndex:i];
        NSString *avatar = user.avatarURL;
        if (avatar) {
            [avatarArray addObject:avatar];
        }
    }
    [self.receiverListView setUserAvatarURLArray:avatarArray highlightedIndex:self.highlightedIndex];
    [self reloadSendButtonState];
}

- (UIView *)backMask {
    if (!_backMask) {
        _backMask = [[UIView alloc] initWithFrame:self.bounds];
        _backMask.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backMask addGestureRecognizer:tap];
    }
    return _backMask;
}

- (SYGiftReceiverListView *)receiverListView {
    if (!_receiverListView) {
        _receiverListView = [[SYGiftReceiverListView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.sy_width, GiftReceiverListHeight)];
        _receiverListView.delegate = self;
    }
    return _receiverListView;
}

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat height = [self groupViewHeight] + GiftReceiverListHeight + GiftToolbarHeight + GiftPageControlHeight + GiftGroupButtonHeight;
        if (iPhoneX) {
            height += 34.f;
        }
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height)];
        _containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *_effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = _containerView.bounds;
        [_containerView addSubview:_effectView];
    }
    return _containerView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, CGRectGetMaxY(self.bottomLine.frame) + 15.f, 20.f, 20.f)];
        _icon.image = [UIImage imageNamed_sy:@"voiceroom_note"];
    }
    return _icon;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame) + 2.f, CGRectGetMinY(self.icon.frame), 70.f, 20.f)];
        _balanceLabel.font = [UIFont systemFontOfSize:14.f];
        _balanceLabel.textColor = [UIColor whiteColor];
    }
    return _balanceLabel;
}

- (UIButton *)cashierButton {
    if (!_cashierButton) {
        _cashierButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cashierButton.frame = CGRectMake(CGRectGetMaxX(self.balanceLabel.frame) + 24.f, CGRectGetMinY(self.icon.frame), 30.f, 20.f);
        _cashierButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_cashierButton setTitle:@"充值" forState:UIControlStateNormal];
        [_cashierButton setTitleColor:[UIColor sam_colorWithHex:@"#FFFE54"]
                             forState:UIControlStateNormal];
        [_cashierButton addTarget:self
                           action:@selector(goToCashier:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _cashierButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 68.f;
        _sendButton.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - width - 20.f, CGRectGetMaxY(self.bottomLine.frame) + 11.f, width, 28.f);
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _sendButton.layer.cornerRadius = 14.f;
        _sendButton.clipsToBounds = YES;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_send_bg"]
                               forState:UIControlStateNormal];
        [_sendButton addTarget:self
                        action:@selector(send:)
              forControlEvents:UIControlEventTouchUpInside];
        _sendButton.hidden = YES;
    }
    return _sendButton;
}

- (SYVoiceRoomGiftNumSendView *)numSendView {
    if (!_numSendView) {
        CGFloat width = 110;
        _numSendView = [[SYVoiceRoomGiftNumSendView alloc] initWithFrame:CGRectMake(self.containerView.sy_width - 16.f - width, self.bottomLine.sy_bottom + 11, width, 32)];
        [_numSendView setEnabled:NO];
        [_numSendView resetGiftNum];
        _numSendView.delegate = self;
    }
    return _numSendView;
}

- (void)reloadSendButtonState {
    SYVoiceRoomGiftGroupView *groupView = [self groupViewAtGroupIndex:self.selectedGiftGroup];
    BOOL isEnable = (groupView.selectedGiftIndex >= 0 && [self.receiverListView.selectIndexArray count] > 0);
    self.sendButton.enabled = isEnable;
    UIColor *color = isEnable ? [UIColor whiteColor] : [UIColor sam_colorWithHex:@"#BAC0C5"];
    [self.sendButton setTitleColor:color forState:UIControlStateNormal];
    [self.numSendView setEnabled:isEnable];
    
    BOOL canMutiSend = [self.viewModel giftIsMutiSendAtIndexPath:[NSIndexPath indexPathForItem:groupView.selectedGiftIndex inSection:self.selectedGiftGroup]];
    BOOL showNumSend = !groupView.isGiftBag && canMutiSend;
    self.sendButton.hidden = showNumSend;
    self.numSendView.hidden = !showNumSend;
    [self.numSendView resetGiftNum];
}

- (UIView *)lineWithY:(CGFloat)y {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.sy_width, 0.5)];
    line.backgroundColor = [UIColor sam_colorWithHex:@"#575757"];
    return line;
}

- (UIButton *)groupButtonWithGroupIndex:(NSInteger)groupIndex
                                  frame:(CGRect)frame
                                  title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor sam_colorWithHex:@"#999999"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor sam_colorWithHex:@"#FFFE54"]
                 forState:UIControlStateSelected];
    button.tag = groupIndex + GiftGroupButtonStartTag;
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(groupButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - action

- (void)tap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(giftViewDidCloseWithGiftView:)]) {
        [self.delegate giftViewDidCloseWithGiftView:self];
    }
    [self removeFromSuperview];
}

- (void)goToCashier:(id)sender {
    if ([self.delegate respondsToSelector:@selector(giftViewShouldOperateUserRelatives)]) {
        if (![self.delegate giftViewShouldOperateUserRelatives]) {
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(giftViewShouldOperateTeenager)]) {
        if (![self.delegate giftViewShouldOperateTeenager]) {
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(giftView:didGoToCachierWithGiftViewWithCoin:)]) {
        [self.delegate giftView:self didGoToCachierWithGiftViewWithCoin:self.viewModel.walletCoinAmount];
    }
}

- (void)send:(id)sender {
    if ([self.delegate respondsToSelector:@selector(giftViewShouldOperateUserRelatives)]) {
        if (![self.delegate giftViewShouldOperateUserRelatives]) {
            return;
        }
    }
    if ([self.delegate respondsToSelector:@selector(giftViewShouldOperateTeenager)]) {
        if (![self.delegate giftViewShouldOperateTeenager]) {
            return;
        }
    }
    SYVoiceRoomGiftGroupView *groupView = [self groupViewAtGroupIndex:self.selectedGiftGroup];
    if (groupView.selectedGiftIndex >= 0 && [self.receiverListView.selectIndexArray count] > 0) {
        NSArray *selectIndexArray = [self.receiverListView.selectIndexArray copy];
        
        if (groupView.isGiftBag) {
            NSInteger count = [selectIndexArray count];
            NSInteger ownCount = [self.viewModel giftBagGiftNumAtIndexPath:[NSIndexPath indexPathForItem:groupView.selectedGiftIndex inSection:self.selectedGiftGroup]];
            if (ownCount < count) {
                [SYToastView showToast:@"礼物数量不足，请重新选择"];
                return;
            }
        } else {
            NSInteger price = [self.viewModel giftPriceAtIndexPath:[NSIndexPath indexPathForItem:groupView.selectedGiftIndex inSection:self.selectedGiftGroup]];
            if (self.viewModel.walletCoinAmount < price * [selectIndexArray count] * self.numSendView.giftNum) {
                //            [SYToastView showToast:@"余额不足，请充值"];
                if ([self.delegate respondsToSelector:@selector(giftViewLackOfBalance)]) {
                    [self.delegate giftViewLackOfBalance];
                }
                return;
            }
            NSInteger level = [self.viewModel giftLevelAtIndexPath:[NSIndexPath indexPathForItem:groupView.selectedGiftIndex inSection:self.selectedGiftGroup]];
            if ([self.delegate respondsToSelector:@selector(giftViewCanSendGiftWithGiftLevel:)]) {
                if (![self.delegate giftViewCanSendGiftWithGiftLevel:level]) {
                    [SYToastView showToast:@"用户等级尚不够发送此礼物"];
                    return;
                }
            }
        }
        
        NSInteger count = [selectIndexArray count];
        NSString *uids = @"";
        for (int i = 0; i < count; i ++) {
            NSInteger index = [selectIndexArray[i] integerValue];
            if (index >= 0 && index < [self.receiverArray count]) {
                SYVoiceChatUserViewModel *user = [self.receiverArray objectAtIndex:index];
                NSString *uid = user.uid;
                if (uid) {
                    uids = [uids stringByAppendingString:uid];
                    if (i != count - 1) {
                        uids = [uids stringByAppendingString:@","];
                    }
                }
            }
        }
        
        NSInteger giftID = [self.viewModel giftIDAtIndexPath:[NSIndexPath indexPathForItem:groupView.selectedGiftIndex inSection:self.selectedGiftGroup]];
        NSInteger giftCategoryId = [self.viewModel giftCategoryIdAtIndexPath:[NSIndexPath indexPathForItem:groupView.selectedGiftIndex inSection:self.selectedGiftGroup]];
        
        BOOL isRandomGift = (giftCategoryId == 3);
        if (groupView.isGiftBag) {
            [self.viewModel requestSendBagGiftToUser:uids
                                              giftID:giftID
                                           channelID:self.channelID
                                               block:^(BOOL success, NSArray<NSDictionary *> * _Nonnull giftArray, NSInteger errorCode) {
                                                   if (success) {
                                                       if (isRandomGift) {
                                                           // 随机礼物
                                                           if ([self.delegate respondsToSelector:@selector(giftView:didSendRandomGiftWithGiftIDs:giftID:)]) {
                                                               NSMutableArray *giftIDs = [NSMutableArray new];
                                                               for (NSDictionary *dict in giftArray) {
                                                                   SYVoiceChatUserViewModel *user = [self userViewModelWithUid:dict[@"userId"]];
                                                                   if (user) {
                                                                       if (dict[@"giftId"]) {
                                                                           [giftIDs addObject:dict[@"giftId"]];
                                                                       }
                                                                   }
                                                               }
                                                               [self.delegate giftView:self didSendRandomGiftWithGiftIDs:giftIDs giftID:giftID];
                                                           }
                                                       }
                                                       if ([self.delegate respondsToSelector:@selector(giftView:didSendGiftToUser:giftID:randomGiftId:nums:)]) {
                                                           for (NSDictionary *dict in giftArray) {
                                                               SYVoiceChatUserViewModel *user = [self userViewModelWithUid:dict[@"userId"]];
                                                               if (user) {
                                                                   [self.delegate giftView:self didSendGiftToUser:user giftID:[dict[@"giftId"] integerValue] randomGiftId:(isRandomGift ? giftID : 0) nums:1];
                                                               }
                                                           }
                                                       }
                                                       [self.viewModel requestGiftBagListWithBlock:^(BOOL success) {
                                                           if (success) {
                                                               SYVoiceRoomGiftGroupView *groupView = [self groupViewAtGroupIndex:0];
                                                               if (groupView) {
                                                                   [groupView reloadData];
                                                                   [self reloadSendButtonState];
                                                               }
                                                           }
                                                       }];
                                                       if ([self.delegate respondsToSelector:@selector(giftViewDidSendGiftToUpdateVIPLevel)]) {
                                                           [self.delegate giftViewDidSendGiftToUpdateVIPLevel];
                                                       }
                                                       if ([self.delegate respondsToSelector:@selector(giftViewDidFinishSendGift)]) {
                                                           [self.delegate giftViewDidFinishSendGift];
                                                       }
                                                       SYGiftNetManager *netManager = [SYGiftNetManager new];
                                                       [netManager dailyTaskLog:5 withGiftId:giftID withGiftNum:self.numSendView.giftNum];
                                                   } else {
                                                       if (errorCode == 4015) {
                                                           // 礼物数量不足
                                                           [SYToastView showToast:@"礼物数量不足，请重新选择"];
                                                       }
                                                   }
                                               }];
        } else {
            [self.viewModel requestSendGiftToUser:uids
                                           giftID:giftID
                                        channelID:self.channelID
                                           number:self.numSendView.giftNum
                                            block:^(BOOL success, NSArray<NSDictionary *>* giftArray, NSInteger errorCode) {
                                                if (success) {
                                                    if (isRandomGift) {
                                                        // 随机礼物
                                                        if ([self.delegate respondsToSelector:@selector(giftView:didSendRandomGiftWithGiftIDs:giftID:)]) {
                                                            NSMutableArray *giftIDs = [NSMutableArray new];
                                                            for (NSDictionary *dict in giftArray) {
                                                                SYVoiceChatUserViewModel *user = [self userViewModelWithUid:dict[@"userId"]];
                                                                if (user) {
                                                                    if (dict[@"giftId"]) {
                                                                        [giftIDs addObject:dict[@"giftId"]];
                                                                    }
                                                                }
                                                            }
                                                            [self.delegate giftView:self didSendRandomGiftWithGiftIDs:giftIDs giftID:giftID];
                                                        }
                                                    }
                                                    if ([self.delegate respondsToSelector:@selector(giftView:didSendGiftToUser:giftID:randomGiftId:nums:)]) {
                                                        for (NSDictionary *dict in giftArray) {
                                                            SYVoiceChatUserViewModel *user = [self userViewModelWithUid:dict[@"userId"]];
                                                            if (user) {
                                                                [self.delegate giftView:self didSendGiftToUser:user giftID:[dict[@"giftId"] integerValue]
                                                                           randomGiftId:(isRandomGift ? giftID : 0) nums:[dict[@"nums"] integerValue]];
                                                            }
                                                        }
                                                    }
                                                    [self loadBalance];
                                                    if ([self.delegate respondsToSelector:@selector(giftViewDidSendGiftToUpdateVIPLevel)]) {
                                                        [self.delegate giftViewDidSendGiftToUpdateVIPLevel];
                                                    }
                                                    if ([self.delegate respondsToSelector:@selector(giftViewDidFinishSendGift)]) {
                                                        [self.delegate giftViewDidFinishSendGift];
                                                    }
                                                    SYGiftNetManager *netManager = [SYGiftNetManager new];
                                                    [netManager dailyTaskLog:5 withGiftId:giftID withGiftNum:self.numSendView.giftNum];
                                                } else {
                                                    if (errorCode == 4003) {
                                                        // 余额不足
                                                        [self showLackOfBalanceAlert];
                                                    }
                                                }
                                            }];
        }
    }
}

- (void)showLackOfBalanceAlert {
    if ([self.delegate respondsToSelector:@selector(giftViewLackOfBalance)]) {
        [self.delegate giftViewLackOfBalance];
    }
}

#pragma mark - private

- (CGFloat)groupViewHeight {
    return (self.sy_width / 375.f * 72.f + 6.f) * 2.f;
}

- (SYVoiceChatUserViewModel *)userViewModelWithUid:(NSString *)uid {
    for (SYVoiceChatUserViewModel *user in self.receiverArray) {
        if ([user.uid isEqualToString:uid]) {
            return user;
            break;
        }
    }
    return nil;
}

- (SYVoiceRoomGiftGroupView *)groupViewAtGroupIndex:(NSInteger)groupIndex {
    if (groupIndex >= 0 && groupIndex < [self.groupGiftViewArray count]) {
        return [self.groupGiftViewArray objectAtIndex:groupIndex];
    }
    return nil;
}

- (void)groupButtonAction:(id)sender {
    NSInteger oldGroupIndex = self.selectedGiftGroup;
    NSInteger oldTag = oldGroupIndex + GiftGroupButtonStartTag;
    UIButton *oldButton = [self.containerView viewWithTag:oldTag];
    oldButton.selected = NO;
    SYVoiceRoomGiftGroupView *groupView = [self groupViewAtGroupIndex:oldGroupIndex];
    if (groupView) {
        groupView.hidden = YES;
    }
    
    UIButton *button = (UIButton *)sender;
    button.selected = YES;
    NSInteger groupIndex = button.tag - GiftGroupButtonStartTag;
    self.selectedGiftGroup = groupIndex;
    groupView = [self groupViewAtGroupIndex:groupIndex];
    if (groupView) {
        groupView.hidden = NO;
    }
    [self reloadSendButtonState];
}

#pragma mark -

- (void)giftReceiverListViewSelectIndexesChanged {
    [self reloadSendButtonState];
}

#pragma mark -

- (void)voiceRoomGiftGroupViewDidChangeGiftSelectIndexWithGroupView:(SYVoiceRoomGiftGroupView *)groupView {
    NSInteger index = [self.groupGiftViewArray indexOfObject:groupView];
    if (index != NSNotFound && self.selectedGiftGroup != index) {
        self.selectedGiftGroup = index;
    }
    [self reloadSendButtonState];
}

#pragma mark -

- (void)voiceRoomGiftNumSendViewDidSendGiftWithNum:(NSInteger)num {
    [self send:nil];
}

- (void)voiceRoomGiftNumSendViewTouchWhenDisable {
    if ([self.receiverListView.selectIndexArray count] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView
                                                  animated:YES];
        hud.labelText = @"请选择主播";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.f];
        return;
    }
    
    SYVoiceRoomGiftGroupView *groupView = [self groupViewAtGroupIndex:self.selectedGiftGroup];
    if (groupView.selectedGiftIndex <= 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView
                                                  animated:YES];
        hud.labelText = @"请选择礼物";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.f];
        return;
    }
}

@end
