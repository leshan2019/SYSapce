//
//  SYTransferPaymentVC.m
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/7/11.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import "SYTransferPaymentVC.h"
#import "SYWalletNetWorkManager.h"
#import "SYTransferPopView.h"

@interface SYTransferPaymentVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UIView *topNavBar;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UIImageView *userPhoto;
@property (nonatomic, strong)UILabel *userName;
@property (nonatomic, strong)UILabel *beeCoinLbl;
@property (nonatomic, strong)UITextField *beeCoinCountText;
@property (nonatomic, strong)UILabel *chargeLbl;//手续费
@property (nonatomic, strong)UILabel *beeCoinDes;
@property (nonatomic, strong)UIImageView *beeCoinIcon;
@property (nonatomic, strong)UILabel *beeCoinCountLbl;
@property (nonatomic, strong)UIButton *sendBtn;

@property (nonatomic, strong)MBProgressHUD *hubView;

@property (nonatomic, strong)SYTransferPopView *popUpView;  // 确认转账弹窗

@property (nonatomic, strong)UserProfileEntity *userInfo;

@property (nonatomic, assign)BOOL isOutMax;
@property (nonatomic, weak)id delegate;

@end

@implementation SYTransferPaymentVC


- (instancetype)initWithUserInfo:(UserProfileEntity *)recervedInfo delegate:(id<SYTransferPaymentVCProtocol>)delegate{
    self = [self init];
    if (self) {
        self.userInfo = recervedInfo;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F6F7"];
    [self.view addSubview:self.topNavBar];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset((iPhoneX ? 44 : 20));
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self.topNavBar addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topNavBar).with.offset(20);
        make.centerY.equalTo(self.topNavBar);
        make.size.mas_equalTo(CGSizeMake(32, 22));
    }];
    [self.topNavBar addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topNavBar);
        make.size.mas_equalTo(CGSizeMake(200, 22));
    }];

    [self.view addSubview:self.userPhoto];
    [self.userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topNavBar.mas_bottom).with.offset(6);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];

    [self.view addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userPhoto.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 22));
    }];

    [self.view addSubview:self.beeCoinCountText];
    [self.beeCoinCountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom).with.offset(16);
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.height.mas_equalTo(58);
    }];

    [self.beeCoinCountText addSubview:self.beeCoinLbl];
    [self.beeCoinLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beeCoinCountText).with.offset(10);
        make.centerY.equalTo(self.beeCoinCountText);
        make.size.mas_equalTo(CGSizeMake(51, 22));
    }];

    __block CGFloat ratio = [SYSettingManager getRedpacketRatio];
    [self.view addSubview:self.chargeLbl];
    [self.chargeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.beeCoinCountText);
        make.top.mas_equalTo(self.beeCoinCountText.mas_bottom).with.offset(10);
        make.width.equalTo(self.beeCoinCountText);
        if (ratio > 0) {
             make.height.mas_equalTo(15);
        } else {
            make.size.mas_equalTo(CGSizeZero);
        }
    }];

    [self.view addSubview:self.beeCoinDes];
    [self.beeCoinDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.top.mas_equalTo(self.chargeLbl.mas_bottom).with.offset(15);
        make.height.mas_equalTo(ratio > 0 ? 110 : 70);
    }];

    [self.view addSubview:self.beeCoinCountLbl];
    [self.beeCoinCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.top.mas_equalTo(self.beeCoinDes.mas_bottom).with.offset(40);
        make.height.mas_equalTo(44);
    }];

    [self.view addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.beeCoinCountLbl.mas_bottom).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(184, 42));
    }];
    [self configData:self.userInfo];
    [self setCountLalText:@"0"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self sy_setStatusBarDard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)configData:(UserProfileEntity *)user {
    if (nil == user) {
        return;
    }
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:user.avatar_imgurl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    self.userName.text = user.username;
}

- (void)setCountLalText:(NSString *)count {

    NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];

    NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",count]];
    NSRange idRange = NSMakeRange(0, attrIdStr.length);
    // 设置字体大小
    [attrIdStr addAttribute:NSFontAttributeName value:self.beeCoinCountLbl.font range:idRange];
    // 设置颜色
    [attrIdStr addAttribute:NSForegroundColorAttributeName value:self.beeCoinCountLbl.textColor range:idRange];
    // 文字中加图片
    NSTextAttachment *attachmentID=[[NSTextAttachment alloc] init];
    UIImage *idImg=[UIImage imageNamed_sy:@"transgerBeeCoin"];
    attachmentID.image = idImg;
    attachmentID.bounds=CGRectMake(-4, 2, idImg.size.width, idImg.size.height);
    NSAttributedString *idImgStr = [NSAttributedString attributedStringWithAttachment:attachmentID];
    [idTextAttrStr appendAttributedString:idImgStr];
    [idTextAttrStr appendAttributedString:attrIdStr];

    self.beeCoinCountLbl.attributedText = idTextAttrStr;

    CGFloat ratio = [SYSettingManager getRedpacketRatio];
    if (ratio > 0) {
        NSInteger countNum = [count integerValue];
        if (countNum < /* DISABLES CODE */ (1) && countNum > 0) {
            countNum = 1;
        }
        CGFloat charge = countNum * ratio;
        int chargeInt = ceilf(charge);
        self.chargeLbl.text = [NSString stringWithFormat:@"本次手续费：%d蜜豆，共消耗%ld蜜豆",chargeInt,chargeInt + countNum];
    }else {
        self.chargeLbl.text = @"";
    }
}


- (void)backAction
{
    [self.beeCoinCountText resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[UIView alloc] initWithFrame:CGRectZero];
        _topNavBar.backgroundColor = [UIColor clearColor];
    }
    return _topNavBar;
}

- (UIButton *)cancelBtn {

    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor sy_colorWithHexString:@"#0B0B0B"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        [_cancelBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        if (nil == font) {
            font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        }
        _titleLbl.font = font;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.text = @"发红包";
    }
    return _titleLbl;
}

- (UIImageView *)userPhoto {
    if (!_userPhoto) {
        _userPhoto = [UIImageView new];
        _userPhoto.layer.cornerRadius = 6;
        _userPhoto.layer.masksToBounds = YES;
    }
    return _userPhoto;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [UILabel new];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        if (nil == font) {
            font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        }
        _userName.font = font;
        _userName.textAlignment = NSTextAlignmentCenter;
    }
    return _userName;
}


- (UILabel *)beeCoinLbl {
    if (!_beeCoinLbl) {
        _beeCoinLbl = [UILabel new];
        _beeCoinLbl.backgroundColor = [UIColor clearColor];
        _beeCoinLbl.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
        UIFont *font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _beeCoinLbl.font = font;
        _beeCoinLbl.textAlignment = NSTextAlignmentLeft;
        _beeCoinLbl.text = @"蜜豆数";
    }
    return _beeCoinLbl;
}


- (UILabel *)chargeLbl {
    if (!_chargeLbl) {
        _chargeLbl = [UILabel new];
        _chargeLbl.backgroundColor = [UIColor clearColor];
        _chargeLbl.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        UIFont *font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _chargeLbl.font = font;
        _chargeLbl.textAlignment = NSTextAlignmentRight;
    }
    return _chargeLbl;
}


- (UITextField *)beeCoinCountText {
    if (!_beeCoinCountText) {
        _beeCoinCountText = [[UITextField alloc] initWithFrame:CGRectZero];
        _beeCoinCountText.clipsToBounds = YES;
        _beeCoinCountText.layer.cornerRadius = 4;
        _beeCoinCountText.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _beeCoinCountText.textColor = RGBACOLOR(11,11,11,1);
        _beeCoinCountText.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _beeCoinCountText.clearButtonMode = UITextFieldViewModeNever;
        _beeCoinCountText.placeholder = @"0";
        _beeCoinCountText.delegate = self;
        _beeCoinCountText.textAlignment = NSTextAlignmentRight;
        _beeCoinCountText.keyboardType = UIKeyboardTypeNumberPad;
        _beeCoinCountText.returnKeyType = UIReturnKeySend;
        [_beeCoinCountText addTarget:self action:@selector(textContentChanged:) forControlEvents:UIControlEventEditingChanged];
        _beeCoinCountText.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 0)];
        _beeCoinCountText.rightViewMode = UITextFieldViewModeAlways;
    }
    return _beeCoinCountText;
}

- (UILabel *)beeCoinDes {
    if (!_beeCoinDes) {
        _beeCoinDes = [UILabel new];
        _beeCoinDes.backgroundColor = [UIColor clearColor];
        _beeCoinDes.textColor = [UIColor sy_colorWithHexString:@"#999999"];
        UIFont *font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _beeCoinDes.font = font;
        _beeCoinDes.textAlignment = NSTextAlignmentLeft;
        _beeCoinDes.numberOfLines = 0;
        _beeCoinDes.lineBreakMode = NSLineBreakByWordWrapping;

        NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:@"红包说明："];
        NSRange idRange = NSMakeRange(0, attrIdStr.length);
        // 设置字体大小
        [attrIdStr addAttribute:NSFontAttributeName value:font range:idRange];
        // 设置颜色
        [attrIdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#999999"] range:idRange];
        [idTextAttrStr appendAttributedString:attrIdStr];

        NSMutableAttributedString *secondStr = [[NSMutableAttributedString alloc] initWithString:@"\n\n1.一经确认，不可撤回\n2.单个红包不能超过"];
        NSRange secondRange = NSMakeRange(0, secondStr.length);
        // 设置字体大小
        [secondStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:12] range:secondRange];
        // 设置颜色
        [secondStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#999999"] range:secondRange];
        [idTextAttrStr appendAttributedString:secondStr];

        NSString *countStr = [NSString stringWithFormat:@" %ld ",(long)[SYSettingManager redpacketMaxCount]];
        NSMutableAttributedString *thirdStr = [[NSMutableAttributedString alloc] initWithString:countStr];

        NSRange thirdRange = NSMakeRange(0, thirdStr.length);
        // 设置字体大小
        [thirdStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:12] range:thirdRange];
        // 设置颜色
        [thirdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#73a8e4"] range:thirdRange];
        [idTextAttrStr appendAttributedString:thirdStr];

        CGFloat ratio = [SYSettingManager getRedpacketRatio];
        if (ratio > 0) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterPercentStyle];
            NSString *convertNumber = [formatter stringFromNumber:[NSNumber numberWithFloat:ratio]];
            NSMutableAttributedString *fourthStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"蜜豆\n3.本次转账手续费为实际转账金额的%@，手续费出现小数，会向上取整",convertNumber]];
            NSRange fourthRange = NSMakeRange(0, fourthStr.length);
            // 设置字体大小
            [fourthStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:12] range:fourthRange];
            // 设置颜色
            [fourthStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#999999"] range:fourthRange];
            [idTextAttrStr appendAttributedString:fourthStr];
        }else {
            NSMutableAttributedString *fourthStr = [[NSMutableAttributedString alloc] initWithString:@"蜜豆"];
            NSRange fourthRange = NSMakeRange(0, fourthStr.length);
            // 设置字体大小
            [fourthStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:12] range:fourthRange];
            // 设置颜色
            [fourthStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#999999"] range:fourthRange];
            [idTextAttrStr appendAttributedString:fourthStr];
        }
        _beeCoinDes.attributedText = idTextAttrStr;
    }
    return _beeCoinDes;
}

- (UIImageView *)beeCoinIcon {
    if (!_beeCoinIcon) {
        _beeCoinIcon = [UIImageView new];
        _beeCoinIcon.image = [UIImage imageNamed_sy:@"transgerBeeCoin"];
    }
    return _beeCoinIcon;
}

- (UILabel *)beeCoinCountLbl {
    if (!_beeCoinCountLbl) {
        _beeCoinCountLbl = [UILabel new];
        _beeCoinCountLbl.backgroundColor = [UIColor clearColor];
        _beeCoinCountLbl.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:50];
        if (nil == font) {
            font = [UIFont fontWithName:@"PingFang-SC-Medium" size:50];
        }
        _beeCoinCountLbl.font = font;
        _beeCoinCountLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _beeCoinCountLbl;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setBackgroundImage:[SYUtil imageFromColor:[UIColor sy_colorWithHexString:@"#A98AEE"]] forState:UIControlStateDisabled];
        [_sendBtn setTitleColor:[UIColor sy_colorWithHexString:@"#FFFFFF"] forState:UIControlStateDisabled];
        [_sendBtn setBackgroundImage:[SYUtil imageFromColor:[UIColor sy_colorWithHexString:@"#7138EF"]] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor sy_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _sendBtn.clipsToBounds = YES;
        _sendBtn.layer.cornerRadius = 6;
        _sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:18];
        [_sendBtn setTitle:@"塞进红包" forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.enabled = NO;
    }
    return _sendBtn;
}

- (void)sendAction {
    [UIView setAnimationsEnabled:NO];
    [self.beeCoinCountText resignFirstResponder];
    [UIView setAnimationsEnabled:YES];
    // 确认转账弹窗
    if (self.popUpView) {
        [self.popUpView removeFromSuperview];
        self.popUpView = nil;
    }
    __weak typeof(self) weakSelf = self;
    self.popUpView = [[SYTransferPopView alloc] initSYTransferPopViewWithHoneyCount:[self.beeCoinCountText.text integerValue] ensureBlock:^{
        [weakSelf doSendTransferRequest];
    }];
    [self.view addSubview:self.popUpView];
    [self.popUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)doSendTransferRequest {
    NSInteger count = [self.beeCoinCountText.text integerValue];
    if (count <= 0) {
        [SYToastView showToast:@"蜜豆数不能为零"];
        return;
    }
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"您的网络似乎有问题，请检查网络设置。"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self showHudInView:self.view hint:@"支付中..."];
    SYWalletNetWorkManager *netWork = [[SYWalletNetWorkManager alloc] init];
    [netWork requestRedPackageTransferToUser:self.userInfo.userid amount:self.beeCoinCountText.text success:^(id  _Nullable response) {
        [weakSelf hideHud];
        NSDictionary *data = response;
        NSNumber *code = [data objectForKey:@"code"];
        NSString *message = [data objectForKey:@"message"];
        if([code integerValue] == 0) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSendRedpackage:beeCount:)]) {
                [weakSelf.delegate didSendRedpackage:weakSelf.userInfo beeCount:weakSelf.beeCoinCountText.text];
            }
            [weakSelf backAction];
            UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
//            [MobClick event:@"red_package;" attributes:@{@"sender":[NSString sy_safeString:user.userid],@"receiver":[NSString sy_safeString:weakSelf.userInfo.userid],@"count":weakSelf.beeCoinCountText.text}];
        }else {
            [SYToastView showToast:message];
        }
    } failure:^(NSError * _Nullable error) {
        [weakSelf hideHud];
        [SYToastView showToast:@"发送红包失败"];
    }];
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendAction];
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *text = [[NSMutableString alloc] initWithString:textField.text];
    if ([text isEqualToString:@""] && [string isEqualToString:@"0"]) {
        return NO;
    }
    [text replaceCharactersInRange:range withString:string];
    NSLog(@"replacementString  is %@",string);
    NSLog(@"text is %@",text);
    NSLog(@"rang is %@",NSStringFromRange(range));
    NSInteger count = [text integerValue];
    self.sendBtn.enabled = count > 0;
    if (count > [SYSettingManager redpacketMaxCount]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)textContentChanged:(UITextField*)textFiled {
    NSLog( @"text changed11: %@", textFiled.text);
    UITextRange * selectedRange = [textFiled markedTextRange];
    if(selectedRange == nil || selectedRange.empty){
        if ([NSString sy_isBlankString:textFiled.text]) {
            [self setCountLalText:textFiled.placeholder];
        }else {
            [self setCountLalText:textFiled.text];
        }
    }
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.beeCoinCountText resignFirstResponder];
}

#pragma mark - Rotate

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
