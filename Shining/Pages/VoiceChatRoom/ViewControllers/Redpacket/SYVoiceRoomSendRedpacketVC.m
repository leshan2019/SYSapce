//
//  SYVoiceRoomSendRedpacketVC.m
//  Shining
//
//  Created by yangxuan on 2019/9/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomSendRedpacketVC.h"
#import "SYTransferPopView.h"
#import "SYWalletNetWorkManager.h"

@interface SYVoiceRoomSendRedpacketVC ()<UITextFieldDelegate>

// 返回按钮 + title
@property (nonatomic, strong) UIButton *goBackBtn;
@property (nonatomic, strong) UILabel *titleLabel;      //@"倒计时红包"

// 蜜豆数量
@property (nonatomic, strong) UIView *coinBg;
@property (nonatomic, strong) UILabel *coinTitle;
@property (nonatomic, strong) UITextField *coinInputView;
@property (nonatomic, strong) UILabel *coinTip;          // @"个"

// 红包个数
@property (nonatomic, strong) UIView *countBg;
@property (nonatomic, strong) UILabel *countTitle;
@property (nonatomic, strong) UITextField *countInputView;
@property (nonatomic, strong) UILabel *countTip;         // @"个"

// 手续费
@property (nonatomic, strong) UILabel *chargeLabel;

// 金币icon
@property (nonatomic, strong) UIImageView *coinIconView;
@property (nonatomic, strong) UILabel *coinCountLabel;

// 发送红包
@property (nonatomic, strong) UIButton *sendRedpacketBtn;
@property (nonatomic, strong) UILabel *sendTipLabel;

// 红包说明
@property (nonatomic, strong) UILabel *redPacketDes;

@property (nonatomic, assign) NSInteger coinNum;        // 蜜豆数量
@property (nonatomic, assign) NSInteger redPtCount;     // 红包个数
@property (nonatomic, strong) SYTransferPopView *popUpView;  // 确认转账弹窗

@end

@implementation SYVoiceRoomSendRedpacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245,246,247,1);
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self sy_setStatusBarDard];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.coinInputView resignFirstResponder];
    [self.countInputView resignFirstResponder];
}

#pragma mark - Private

- (void)updateSendRedptBtnState {
    self.sendRedpacketBtn.enabled = self.coinNum > 0 && self.redPtCount > 0;
}

// 刷新手续费label
- (void)updateChargeLabelText:(NSString *)count {
    CGFloat ratio = [SYSettingManager getGroupRedpacketRatio];
    if (ratio > 0) {
        self.chargeLabel.hidden = NO;
        NSInteger countNum = [count integerValue];
        if (countNum < 1 && countNum > 0) {
            countNum = 1;
        }
        CGFloat charge = countNum * ratio;
        int chargeInt = ceilf(charge);
        self.chargeLabel.text = [NSString stringWithFormat:@"本次手续费：%d蜜豆，共消耗%ld蜜豆",chargeInt,chargeInt + countNum];
    } else {
        self.chargeLabel.text = @"";
        self.chargeLabel.hidden = YES;
    }
}

- (void)updateCoinCountLabel:(NSString *)count {
    if (count.length == 0) {
        count = @"0";
    }
    NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",count]];
    NSRange idRange = NSMakeRange(0, attrIdStr.length);
    // 设置字体大小
    [attrIdStr addAttribute:NSFontAttributeName value:self.coinCountLabel.font range:idRange];
    // 设置颜色
    [attrIdStr addAttribute:NSForegroundColorAttributeName value:self.coinCountLabel.textColor range:idRange];
    // 文字中加图片
    NSTextAttachment *attachmentID=[[NSTextAttachment alloc] init];
    UIImage *idImg=[UIImage imageNamed_sy:@"transgerBeeCoin"];
    attachmentID.image = idImg;
    attachmentID.bounds=CGRectMake(-4, 2, idImg.size.width, idImg.size.height);
    NSAttributedString *idImgStr = [NSAttributedString attributedStringWithAttachment:attachmentID];
    [idTextAttrStr appendAttributedString:idImgStr];
    [idTextAttrStr appendAttributedString:attrIdStr];
    
    self.coinCountLabel.attributedText = idTextAttrStr;
}

//  点击发送红包按钮
- (void)clickSendRedpackeBtn {
    if (self.coinNum < self.redPtCount) {
        [SYToastView showToast:@"每个红包至少1蜜豆"];
        return;
    }
    [UIView setAnimationsEnabled:NO];
    [self.coinInputView resignFirstResponder];
    [self.countInputView resignFirstResponder];
    [UIView setAnimationsEnabled:YES];
    // 确认转账弹窗
    if (self.popUpView) {
        [self.popUpView removeFromSuperview];
        self.popUpView = nil;
    }
    __weak typeof(self) weakSelf = self;
    self.popUpView = [[SYTransferPopView alloc] initSYTransferPopViewWithHoneyCount:self.coinNum ensureBlock:^{
        [weakSelf doSendTransferRequest];
    }];
    [self.view addSubview:self.popUpView];
    [self.popUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)doSendTransferRequest {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"您的网络似乎有问题，请检查网络设置。"];
        return;
    }
    [self showHudInView:self.view hint:@"支付中..."];
    SYWalletNetWorkManager *netWork = [[SYWalletNetWorkManager alloc] init];
    [netWork requestSendGroupRedPacketWithRoomid:self.roomId amount:self.coinInputView.text nums:self.countInputView.text success:^(id  _Nullable response) {
        [self hideHud];
        NSNumber *code = [response objectForKey:@"code"];
        if([code integerValue] == 0) {
            if (self.sendSuccess) {
                NSInteger sendCount = [self.coinInputView.text integerValue];
                NSInteger overScreenMax = [SYSettingManager getGroupRedPacketOverScreenCount];
                self.sendSuccess(sendCount >= overScreenMax);
            }
            [SYToastView showToast:@"发送成功"];
            [self handleGoBackBtnClick:self.goBackBtn];
        } else if ([code integerValue] == 4004) {
            [SYToastView showToast:@"扣除失败，请重试"];
        } else if ([code integerValue] == 4003) {
            [SYToastView showToast:@"余额不足，请充值"];
        } else {
            [SYToastView showToast:@"发送失败，请重试"];
        }
    } failure:^(NSError * _Nullable error) {
        [self hideHud];
        [SYToastView showToast:@"发送失败，请重试"];
    }];
}

// 返回
- (void)handleGoBackBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Init

- (void)initSubViews {
    [self.view addSubview:self.goBackBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.coinBg];
    [self.coinBg addSubview:self.coinTitle];
    [self.coinBg addSubview:self.coinInputView];
    [self.coinBg addSubview:self.coinTip];
    [self.view addSubview:self.countBg];
    [self.countBg addSubview:self.countTitle];
    [self.countBg addSubview:self.countInputView];
    [self.countBg addSubview:self.countTip];
    [self.view addSubview:self.chargeLabel];
    [self.view addSubview:self.coinCountLabel];
    [self.view addSubview:self.sendRedpacketBtn];
    [self.view addSubview:self.sendTipLabel];
    [self.view addSubview:self.redPacketDes];
    [self mas_makeConstraintsWithSubViews];
    [self updateChargeLabelText:@"0"];
    [self updateCoinCountLabel:@"0"];
    [self updateSendRedptBtnState];
}

- (void)mas_makeConstraintsWithSubViews {
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(4);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 24 + 20 : 20);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.goBackBtn);
        make.size.mas_equalTo(CGSizeMake(88, 22));
    }];
    CGFloat bgHeight = 58;
    [self.coinBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 24 + 84 : 84);
        make.height.mas_equalTo(bgHeight);
    }];
    [self.coinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coinBg).with.offset(10);
        make.centerY.equalTo(self.coinBg);
        make.size.mas_equalTo(CGSizeMake(68, 22));
    }];
    [self.coinTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coinBg).with.offset(-11);
        make.centerY.equalTo(self.coinBg);
        make.size.mas_equalTo(CGSizeMake(17, 22));
    }];
    [self.coinInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coinTip.mas_left).with.offset(-5);
        make.left.equalTo(self.coinTitle.mas_right).with.offset(16);
        make.centerY.equalTo(self.coinBg);
        make.height.mas_equalTo(bgHeight);
    }];
    [self.countBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);;
        make.right.equalTo(self.view).with.offset(-24);;
        make.top.equalTo(self.coinBg.mas_bottom).with.offset(18);
        make.height.mas_equalTo(bgHeight);
    }];
    [self.countTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countBg).with.offset(10);
        make.centerY.equalTo(self.countBg);
        make.size.mas_equalTo(CGSizeMake(68, 22));
    }];
    [self.countTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countBg).with.offset(-11);
        make.centerY.equalTo(self.countBg);
        make.size.mas_equalTo(CGSizeMake(17, 22));
    }];
    [self.countInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countTip.mas_left).with.offset(-5);
        make.left.equalTo(self.countTitle.mas_right).with.offset(16);
        make.centerY.equalTo(self.countBg);
        make.height.mas_equalTo(bgHeight);
    }];
    [self.chargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.top.equalTo(self.countBg.mas_bottom).with.offset(10);
        make.height.mas_equalTo(15);
    }];
    [self.coinCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.top.mas_equalTo(self.chargeLabel.mas_bottom).with.offset(40);
        make.height.mas_equalTo(44);
    }];
    [self.sendRedpacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chargeLabel.mas_bottom).with.offset(94);
        make.size.mas_equalTo(CGSizeMake(184, 42));
        make.centerX.equalTo(self.view);
    }];
    [self.sendTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendRedpacketBtn.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(116, 15));
        make.centerX.equalTo(self.view);
    }];
    [self.redPacketDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.top.equalTo(self.sendTipLabel.mas_bottom).with.offset(30);
        make.height.mas_equalTo(140);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *text = [[NSMutableString alloc] initWithString:textField.text];
    if ([text isEqualToString:@""] && [string isEqualToString:@"0"]) {
        return NO;
    }
    [text replaceCharactersInRange:range withString:string];
    NSInteger inputCount = [text integerValue];
    if (textField == self.coinInputView) {
        if (inputCount > 9999) {
            [SYToastView showToast:@"蜜豆数量最多9999个"];
            return NO;
        }
        self.coinNum = inputCount;
        [self updateSendRedptBtnState];
        return YES;
    } else if (textField == self.countInputView) {
        if (inputCount > 50) {
            [SYToastView showToast:@"红包个数最多50个"];
            return NO;
        }
        self.redPtCount = inputCount;
        [self updateSendRedptBtnState];
        return YES;
    }
    return NO;
}

- (void)textContentChanged:(UITextField*)textFiled {
    if (textFiled == self.coinInputView) {
        [self updateChargeLabelText:textFiled.text];
        [self updateCoinCountLabel:textFiled.text];
    }
}

#pragma mark - Lazyload

- (UIButton *)goBackBtn {
    if (!_goBackBtn) {
        _goBackBtn = [UIButton new];
        [_goBackBtn addTarget:self action:@selector(handleGoBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_goBackBtn setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_back_normale"] forState:UIControlStateNormal];
        [_goBackBtn setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_back_selected"] forState:UIControlStateHighlighted];
    }
    return _goBackBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(11,11,11,1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"倒计时红包";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _titleLabel;
}

- (UIView *)coinBg {
    if (!_coinBg) {
        _coinBg = [UIView new];
        _coinBg.backgroundColor = [UIColor whiteColor];
        _coinBg.layer.cornerRadius = 4;
    }
    return _coinBg;
}

- (UILabel *)coinTitle {
    if (!_coinTitle) {
        _coinTitle = [UILabel new];
        _coinTitle.text = @"蜜豆数量";
        _coinTitle.textColor = RGBACOLOR(11,11,11,1);
        _coinTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _coinTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _coinTitle;
}

- (UITextField *)coinInputView {
    if (!_coinInputView) {
        _coinInputView = [[UITextField alloc] initWithFrame:CGRectZero];
        _coinInputView.textColor = RGBACOLOR(11,11,11,1);
        _coinInputView.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _coinInputView.clearButtonMode = UITextFieldViewModeNever;
        _coinInputView.placeholder = @"最多9999";
        _coinInputView.delegate = self;
        _coinInputView.textAlignment = NSTextAlignmentRight;
        _coinInputView.keyboardType = UIKeyboardTypeNumberPad;
        [_coinInputView addTarget:self action:@selector(textContentChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _coinInputView;
}

- (UILabel *)coinTip {
    if (!_coinTip) {
        _coinTip = [UILabel new];
        _coinTip.text = @"个";
        _coinTip.textColor = RGBACOLOR(11,11,11,1);
        _coinTip.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _coinTip.textAlignment = NSTextAlignmentLeft;
    }
    return _coinTip;
}

- (UIView *)countBg {
    if (!_countBg) {
        _countBg = [UIView new];
        _countBg.backgroundColor = [UIColor whiteColor];
        _coinBg.layer.cornerRadius = 4;
    }
    return _countBg;
}

- (UILabel *)countTitle {
    if (!_countTitle) {
        _countTitle = [UILabel new];
        _countTitle.text = @"红包个数";
        _countTitle.textColor = RGBACOLOR(11,11,11,1);
        _countTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _countTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _countTitle;
}

- (UITextField *)countInputView {
    if (!_countInputView) {
        _countInputView = [[UITextField alloc] initWithFrame:CGRectZero];
        _countInputView.textColor = RGBACOLOR(11,11,11,1);
        _countInputView.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _countInputView.clearButtonMode = UITextFieldViewModeNever;
        _countInputView.placeholder = @"最多50";
        _countInputView.delegate = self;
        _countInputView.textAlignment = NSTextAlignmentRight;
        _countInputView.keyboardType = UIKeyboardTypeNumberPad;
        [_countInputView addTarget:self action:@selector(textContentChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _countInputView;
}

- (UILabel *)countTip {
    if (!_countTip) {
        _countTip = [UILabel new];
        _countTip.text = @"个";
        _countTip.textColor = RGBACOLOR(11,11,11,1);
        _countTip.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _countTip.textAlignment = NSTextAlignmentLeft;
    }
    return _countTip;
}

- (UILabel *)chargeLabel {
    if (!_chargeLabel) {
        _chargeLabel = [UILabel new];
        _chargeLabel.text = @"本次手续费0，共消耗0蜜豆";
        _chargeLabel.textColor = RGBACOLOR(68,68,68,1);
        _chargeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _chargeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _chargeLabel;
}

- (UIImageView *)coinIconView {
    if (!_coinIconView) {
        _coinIconView = [UIImageView new];
        _coinIconView.image = [UIImage imageNamed_sy:@"transgerBeeCoin"];
    }
    return _coinIconView;
}

- (UILabel *)coinCountLabel {
    if (!_coinCountLabel) {
        _coinCountLabel = [UILabel new];
        _coinCountLabel.textColor = RGBACOLOR(11,11,11,1);
        _coinCountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:50];
        _coinCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coinCountLabel;
}

- (UIButton *)sendRedpacketBtn {
    if (!_sendRedpacketBtn) {
        _sendRedpacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendRedpacketBtn setBackgroundImage:[SYUtil imageFromColor:[UIColor sy_colorWithHexString:@"#A98AEE"]] forState:UIControlStateDisabled];
        [_sendRedpacketBtn setTitleColor:[UIColor sy_colorWithHexString:@"#FFFFFF"] forState:UIControlStateDisabled];
        [_sendRedpacketBtn setBackgroundImage:[SYUtil imageFromColor:[UIColor sy_colorWithHexString:@"#7138EF"]] forState:UIControlStateNormal];
        [_sendRedpacketBtn setTitleColor:[UIColor sy_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _sendRedpacketBtn.clipsToBounds = YES;
        _sendRedpacketBtn.layer.cornerRadius = 6;
        _sendRedpacketBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:18];
        [_sendRedpacketBtn setTitle:@"塞进红包" forState:UIControlStateNormal];
        [_sendRedpacketBtn addTarget:self action:@selector(clickSendRedpackeBtn) forControlEvents:UIControlEventTouchUpInside];
        _sendRedpacketBtn.enabled = NO;
    }
    return _sendRedpacketBtn;
}

- (UILabel *)sendTipLabel {
    if (!_sendTipLabel) {
        _sendTipLabel = [UILabel new];
        _sendTipLabel.text = @"发送红包3分钟后可抢";
        _sendTipLabel.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        UIFont *font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _sendTipLabel.font = font;
        _sendTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sendTipLabel;
}

- (UILabel *)redPacketDes {
    if (!_redPacketDes) {
        _redPacketDes = [UILabel new];
        _redPacketDes.textColor = [UIColor sy_colorWithHexString:@"#999999"];
        UIFont *font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _redPacketDes.font = font;
        _redPacketDes.textAlignment = NSTextAlignmentLeft;
        _redPacketDes.numberOfLines = 0;
        _redPacketDes.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableString *redDesStr = [NSMutableString stringWithFormat:@"%@",@"红包说明：\n\n1.每个人领到的蜜豆随机\n2.没领完的红包在一小时后会返还到您的账户\n3.发红包不会提升等级\n4.红包仅供娱乐"];
        CGFloat ratio = [SYSettingManager getGroupRedpacketRatio];
        if (ratio > 0) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterPercentStyle];
            NSString *convertNumber = [formatter stringFromNumber:[NSNumber numberWithFloat:ratio]];
            NSString *appendStr = [NSString stringWithFormat:@"\n5.本次转账手续费为实际转账金额的%@，手续费出现小数，会向上取整",convertNumber];
            [redDesStr appendString:appendStr];
        }
        _redPacketDes.text = redDesStr;
    }
    return _redPacketDes;
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

@end
