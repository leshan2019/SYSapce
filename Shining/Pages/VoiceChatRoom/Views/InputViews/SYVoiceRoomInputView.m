//
//  SYVoiceRoomInputView.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomInputView.h"
#import "SYVoiceRoomEmojPanView.h"
#import "SYGiftNetManager.h"
#import "SYDanmuListModel.h"
#import "SYDanmuModel.h"
#import "SYVoiceRoomDanmuTypeCell.h"
//#import <Masonry.h>

#define SYVoiceRoomDanmuTypeCellID @"SYVoiceRoomDanmuTypeCellID"

@interface SYVoiceRoomInputView () <UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *backMask;                     // 透明度背景
@property (nonatomic, strong) UIView *textBackView;                 // 输入框SuperView
@property (nonatomic, strong) UIButton *danmuBtn;                   // 弹幕Btn
@property (nonatomic, strong) UITextField *textField;               // 输入框
@property (nonatomic, strong) UIView *horizonLine;                  // 输入框和弹幕类型分割线
@property (nonatomic, strong) UICollectionView *danmuTypeView;      // 弹幕类型选择view
@property (nonatomic, assign) NSInteger selectDanmuTypeIndex;       // 选中的弹幕类型索引
@property (nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) SYVoiceRoomEmojPanView *emojView;

@property (nonatomic, strong) SYGiftNetManager *netManager;
@property (nonatomic, strong) SYDanmuListModel *danmuList;

// info
@property (nonatomic, strong) NSString *roomID;
@property (nonatomic, strong) NSString *userID;

@end

@implementation SYVoiceRoomInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectDanmuTypeIndex = 0;
        [self addSubview:self.backMask];
        [self addSubview:self.textBackView];
        [self.textBackView addSubview:self.danmuBtn];
        [self.textBackView addSubview:self.textField];
        [self addSubview:self.horizonLine];
        [self addSubview:self.danmuTypeView];
        self.danmuTypeView.hidden = ![SYSettingManager openDanmu];
        if (![SYSettingManager voiceRoomDanmuEnable]) {
            self.danmuTypeView.hidden = YES;
            self.danmuBtn.hidden = YES;
            self.textField.sy_left = 20.f;
            self.textField.sy_width = self.textBackView.sy_width - 40.f;
        }
        [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(48);
        }];
        [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self.textBackView.mas_top);
            make.height.mas_equalTo(0.5);
        }];
        [self.danmuTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self.horizonLine.mas_top);
            make.height.mas_equalTo(44);
        }];
//        [self.textBackView addSubview:self.iconButton];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        __weak typeof(self) weakSelf = self;
        [self.netManager requestDanmuListWithSuccess:^(id  _Nullable response) {
            SYDanmuListModel *model = (SYDanmuListModel *)response;
            if (model && model.list && model.list.count > 0) {
                weakSelf.danmuList = model;
            }
        } failure:^(NSError * _Nullable error) {
            weakSelf.danmuList = nil;
        }];

    }
    return self;
}

#pragma mark - Setter

- (void)setDanmuList:(SYDanmuListModel *)danmuList {
    _danmuList = danmuList;
    if (danmuList) {
        [self.danmuTypeView reloadData];
    }
}
#pragma mark -

- (void)becomeFirstResponder {
    [self.textField becomeFirstResponder];
    [self.danmuTypeView reloadData];
}

- (void)tap:(id)sender {
    [self removeFromSuperview];
}

- (void)tapExpression:(id)sender {
    [self.textField resignFirstResponder];
    [self.emojView removeFromSuperview];
    CGFloat height = 200;
    if (iPhoneX) {
        height += 34;
    }
    SYVoiceRoomEmojPanView *emojView = [[SYVoiceRoomEmojPanView alloc] initWithFrame:CGRectMake(0, self.sy_height - height, self.sy_width, height)];
    [self addSubview:emojView];
    __weak typeof(self) weakSelf = self;
    emojView.emojBlock = ^(NSString * _Nonnull emoj) {
        NSString *text = weakSelf.textField.text;
        text = [text stringByAppendingString:emoj];
        weakSelf.textField.text = text;
    };
    self.emojView = emojView;
    self.textBackView.sy_bottom = self.emojView.sy_top;
}

#pragma mark - purchase danmaku

- (void)setRoomID:(NSString *)roomID
           userID:(NSString *)userID {
    self.roomID = roomID;
    self.userID = userID;
}

- (void)purchaseDanmaku {
    if ([self.delegate respondsToSelector:@selector(voiceRoomInputViewCanSendDanmaku)]) {
        if (![self.delegate voiceRoomInputViewCanSendDanmaku]) {
            [SYToastView showToast:@"您已被管理员禁言"];
            return;
        }
    }
    SYDanmuModel *model = [self.danmuList.list objectAtIndex:self.selectDanmuTypeIndex];
    NSString *danmaku = self.textField.text;
    [self.netManager requestDanmuSendWithUserId:self.userID
                                        danmuId:model.danmu_id
                                         roomId:self.roomID
                                           word:danmaku
                                        success:^(id  _Nullable response) {
                                            [self sendDanmakuWithDanmaku:danmaku
                                                                 danmuId:model.danmu_id];
                                        }
                                        failure:^(NSError * _Nullable error) {
                                            if (error.code == 4003) {
                                                // 余额不足
                                                if ([self.delegate respondsToSelector:@selector(voiceRoomInputViewLackOfBalance)]) {
                                                    [self.delegate voiceRoomInputViewLackOfBalance];
                                                }
                                            } else {
                                                [SYToastView showToast:@"发送弹幕失败"];
                                            }
                                        }];
}

#pragma mark - send message

- (void)sendMessage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomInputViewDidSendText:)]) {
        [self.delegate voiceRoomInputViewDidSendText:self.textField.text];
    }
    self.textField.text = @"";
    
    [self.netManager dailyTaskLog:2];
}

- (void)sendDanmakuWithDanmaku:(NSString *)danmaku
                       danmuId:(NSInteger)danmuId {
    if ([self.delegate respondsToSelector:@selector(voiceRoomInputViewDidSendDanmaku:danmuId:)]) {
        [self.delegate voiceRoomInputViewDidSendDanmaku:danmaku
                                                danmuId:danmuId];
    }
    self.textField.text = @"";
}

#pragma mark - UITextFieldDelate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.emojView removeFromSuperview];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((range.location + string.length) > 100) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(voiceRoomInputViewShouldSend)]) {
            if (![self.delegate voiceRoomInputViewShouldSend]) {
                [textField resignFirstResponder];
                [self tap:nil];
                return NO;
            }
        }
        if (self.danmuBtn.selected && [SYSettingManager voiceRoomDanmuEnable]) {
            if ([self.delegate respondsToSelector:@selector(voiceRoomInputViewNeedChildProtect)]) {
                if ([self.delegate voiceRoomInputViewNeedChildProtect]) {
                    [self tap:nil];
                    return NO;
                }
            }
            [self purchaseDanmaku];
        } else {
            [self sendMessage];
        }
        [self tap:nil];
        return YES;
    }
    return NO;
}

#pragma mark - KeyboardNotification

- (void)keyboardWillShow:(NSNotification *)noti {
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = value.CGRectValue;
    CGFloat offY = keyboardFrame.size.height;
    [self.textBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-offY);
    }];
}

#pragma mark - parivate method

- (BOOL)canSendVipDanmakuWithDanmakuLevel:(NSInteger)level {
    if ([self.delegate respondsToSelector:@selector(voiceRoomInputViewCanVipDanmakuBeSendWithDanmakuLevel:)]) {
        return [self.delegate voiceRoomInputViewCanVipDanmakuBeSendWithDanmakuLevel:level];
    }
    return NO;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.danmuList) {
        return self.danmuList.list.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomDanmuTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYVoiceRoomDanmuTypeCellID forIndexPath:indexPath];
    NSInteger item = indexPath.item;
    SYDanmuModel *model = [self.danmuList.list objectAtIndex:item];
    SYVoiceRoomDanmuType type = model.danmu_style;
    [cell updateDanmuTypeCellWithName:model.name
                            withPrice:model.price];
    [cell updateDanmuTypeCellSelectState:item == self.selectDanmuTypeIndex
                            withVipDanmu:type == SYVoiceRoomDanmuType_Vip
                               canBeSend:[self canSendVipDanmakuWithDanmakuLevel:model.vip_level]
                                vipLevel:model.vip_level];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = indexPath.item;
    SYDanmuModel *model = [self.danmuList.list objectAtIndex:item];
    SYVoiceRoomDanmuType type = model.danmu_style;
    BOOL canBeSend = YES;
    if (type == SYVoiceRoomDanmuType_Vip) {
        canBeSend = [self canSendVipDanmakuWithDanmakuLevel:model.vip_level];
        if (!canBeSend) {
            [SYToastView showToast:@"vip等级不够,请充值后使用~"];
            return;
        }
    }
    if (item == self.selectDanmuTypeIndex) {
        return;
    }

    SYDanmuModel *oldModel = [self.danmuList.list objectAtIndex:self.selectDanmuTypeIndex];
    SYVoiceRoomDanmuType oldType = oldModel.danmu_style;
    BOOL oldCanBeSend = YES;
    if (oldType == SYVoiceRoomDanmuType_Vip) {
        oldCanBeSend = [self canSendVipDanmakuWithDanmakuLevel:oldModel.vip_level];
    }
    SYVoiceRoomDanmuTypeCell *cell = (SYVoiceRoomDanmuTypeCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectDanmuTypeIndex inSection:0]];
    [cell updateDanmuTypeCellSelectState:NO withVipDanmu:oldType == SYVoiceRoomDanmuType_Vip canBeSend:oldCanBeSend vipLevel:oldModel.vip_level];
    self.selectDanmuTypeIndex = item;
    cell = (SYVoiceRoomDanmuTypeCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectDanmuTypeIndex inSection:0]];
    [cell updateDanmuTypeCellSelectState:YES withVipDanmu:type == SYVoiceRoomDanmuType_Vip canBeSend:canBeSend vipLevel:model.vip_level];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat count = (self.danmuList.list.count == 0) ? 3 : (CGFloat)self.danmuList.list.count;
    CGFloat width = __MainScreen_Width / count;
    CGFloat height = 44;
    return CGSizeMake(width, height);
}

#pragma mark - HandleBtnClickEvent

- (void)handleDanmuBtnClickEvent:(UIButton *)btn {
    btn.selected = !btn.selected;
    [SYSettingManager setDanmuOpen:btn.selected];
    if (btn.selected) {
        self.danmuTypeView.hidden = NO;
    } else {
        self.danmuTypeView.hidden = YES;
    }
}

#pragma mark - LazyLoad

- (UIView *)backMask {
    if (!_backMask) {
        _backMask = [[UIView alloc] initWithFrame:self.bounds];
        _backMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backMask addGestureRecognizer:tap];
    }
    return _backMask;
}

- (UIView *)textBackView {
    if (!_textBackView) {
        _textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 48.f, self.bounds.size.width, 48.f)];
        _textBackView.backgroundColor = [UIColor whiteColor];
    }
    return _textBackView;
}

- (UIButton *)danmuBtn {
    if (!_danmuBtn) {
        _danmuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _danmuBtn.frame = CGRectMake(16, 12, 52, 24);
        [_danmuBtn setImage:[UIImage imageNamed_sy:@"voiceroom_danmu_off"] forState:UIControlStateNormal|UIControlStateHighlighted];
        [_danmuBtn setImage:[UIImage imageNamed_sy:@"voiceroom_danmu_on"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [_danmuBtn setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_danmu_off"] forState:UIControlStateNormal];
        [_danmuBtn setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_danmu_on"] forState:UIControlStateSelected];
        [_danmuBtn addTarget:self
                        action:@selector(handleDanmuBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        _danmuBtn.selected = [SYSettingManager openDanmu];
    }
    return _danmuBtn;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(78, 9.f, self.bounds.size.width - 78 - 20, 30.f)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"主播很期待你的评论哦~";
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.textColor = RGBACOLOR(11, 11, 11, 1);
    }
    return _textField;
}

- (UIView *)horizonLine {
    if (!_horizonLine) {
        _horizonLine = [UIView new];
        _horizonLine.backgroundColor = RGBACOLOR(238, 238, 238, 1);
    }
    return _horizonLine;
}

- (UICollectionView *)danmuTypeView {
    if (!_danmuTypeView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _danmuTypeView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 44) collectionViewLayout:layout];
        [_danmuTypeView registerClass:[SYVoiceRoomDanmuTypeCell class] forCellWithReuseIdentifier:SYVoiceRoomDanmuTypeCellID];
        _danmuTypeView.backgroundColor = [UIColor whiteColor];
        _danmuTypeView.delegate = self;
        _danmuTypeView.dataSource = self;
    }
    return _danmuTypeView;
}

- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.frame = CGRectMake(self.bounds.size.width - 47.f, 6.f, 36, 36);
        [_iconButton setImage:[UIImage imageNamed_sy:@"voiceroom_expression"] forState:UIControlStateNormal];
        [_iconButton addTarget:self
                        action:@selector(tapExpression:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconButton;
}

- (SYGiftNetManager *)netManager {
    if (!_netManager) {
        _netManager = [[SYGiftNetManager alloc] init];
    }
    return _netManager;
}

@end
