//
//  SYPerfectUserInfoVC.m
//  Shining
//
//  Created by 杨玄 on 2019/6/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPerfectUserInfoVC.h"
#import "SYSystemPhotoManager.h"
#import "SYDatePickerView.h"
#import "SYDistrictPickerView.h"
#import "SYUserServiceAPI.h"
#import "SYSignProvider.h"
#import "SYDistrictProvider.h"
#import "SYAPPServiceAPI.h"

// 性别tag
#define SYGenderMale 10000
#define SYGenderFemale 20000

// 最大个性签名数
#define SYMaxSignNumber 20

@interface SYPerfectUserInfoVC ()<UITextFieldDelegate, SYDatePickerViewDelegate, SYDistrictPickerViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIImageView *backgroundImage; // 背景图
@property (nonatomic, strong) UIButton *jumpMoreBtn;        // 跳过按钮
@property (nonatomic, strong) UILabel *mineInfo;        // 我的信息
@property (nonatomic, strong) UIImageView *avatarImage; // 头像
@property (nonatomic, strong) UIButton *cameraBtn;      // 修改头像
@property (nonatomic, strong) UILabel *idLabel;         // ID

@property (nonatomic, strong) UILabel *nickname;        // 昵称
@property (nonatomic, strong) UIView *firstLine;        // 分割线1
@property (nonatomic, strong) UILabel *birthday;        // 生日
@property (nonatomic, strong) UIView *secondLine;       // 分割线2
@property (nonatomic, strong) UILabel *location;        // 所在地
@property (nonatomic, strong) UIView *thirdLine;        // 分割线3
@property (nonatomic, strong) UILabel *gender;          // 性别
@property (nonatomic, strong) UIView *fourLine;         // 分割线4
@property (nonatomic, strong) UILabel *signature;       // 签名
@property (nonatomic, strong) UITextView *textView;     // 个人签名输入框
@property (nonatomic, strong) UILabel *signatureDefaultLabel;  // 个人签名默认label
@property (nonatomic, strong) UILabel *maxSignatureLabel;  // 个人签名最多输入个数
@property (nonatomic, strong) UIView *fiveLine;         // 分割线5
@property (nonatomic, strong) UIButton *ensureBtn;      // 确定修改

@property (nonatomic, strong) UITextField *changeName;   // 更改名字
@property (nonatomic, strong) UIButton *changeBirthday;  // 更改生日
@property (nonatomic, strong) UIButton *changeLocation;  // 更改所在地

@property (nonatomic, strong) UIButton *boyCircle;       // 男生圆圈
@property (nonatomic, strong) UIButton *girlCircle;      // 女生圆圈
@property (nonatomic, strong) UIButton *boyLabel;        // 男生
@property (nonatomic, strong) UIButton *girlLabel;       // 女生
@property (nonatomic, strong) UILabel *userGender;       // @"男生" | @"女生"
@property (nonatomic, strong) UILabel *sexNoChangeLabel; // @"性别设置后不可更改哦"

@property (nonatomic, strong) SYSystemPhotoManager *photoManager;

@property (nonatomic, strong) SYDatePickerView *datePicker;
@property (nonatomic, copy) NSString *datePickerSelectDate; //保存datePicker返回的date

@property (nonatomic, strong) SYDistrictPickerView *districtPicker;
@property (nonatomic, assign) NSInteger selectedDistrictId;

@property (nonatomic, strong) UIImage *selectedAvatarImage; // 改动的头像
@property (nonatomic, copy) NSString *selectedGender;       // 改动的性别

@end

@implementation SYPerfectUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = RGBACOLOR(117, 63, 251, 1);

    [self.view addSubview:self.backgroundImage];
#ifdef ShiningSdk
    [self.view addSubview:self.jumpMoreBtn];
#endif
    [self.view addSubview:self.mineInfo];
    [self.view addSubview:self.avatarImage];
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.idLabel];
    [self.view addSubview:self.nickname];
    [self.view addSubview:self.changeName];
    [self.view addSubview:self.firstLine];
    [self.view addSubview:self.birthday];
    [self.view addSubview:self.changeBirthday];
    [self.view addSubview:self.secondLine];
    [self.view addSubview:self.location];
    [self.view addSubview:self.changeLocation];
    [self.view addSubview:self.thirdLine];
    [self.view addSubview:self.gender];
    [self.view addSubview:self.fourLine];
    [self.view addSubview:self.signature];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.signatureDefaultLabel];
    [self.view addSubview:self.maxSignatureLabel];
    [self.view addSubview:self.fiveLine];
    [self.view addSubview:self.boyCircle];
    [self.view addSubview:self.boyLabel];
    [self.view addSubview:self.girlCircle];
    [self.view addSubview:self.girlLabel];
    [self.view addSubview:self.userGender];
    [self.view addSubview:self.sexNoChangeLabel];
    [self.view addSubview:self.ensureBtn];

    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

#ifdef ShiningSdk
    [self.jumpMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 44));
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 44 : 20);
    }];
#endif

    [self.mineInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(96, 32));
        make.left.equalTo(self.view).with.offset(22);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 98 : 74);
    }];

    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mineInfo.mas_bottom).with.offset(iPhone5 ? 20 : 42);
    }];

    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.bottom.equalTo(self.avatarImage.mas_bottom);
        make.right.equalTo(self.avatarImage.mas_right);
    }];

    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.mas_bottom).with.offset(6);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(16);
    }];

    [self.nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 16));
        make.left.equalTo(self.view).with.offset(42);
        make.top.equalTo(self.idLabel.mas_bottom).with.offset(iPhone5 ? 24 : 46);
    }];

    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(42);
        make.right.equalTo(self.view).with.offset(-42);
        make.top.equalTo(self.nickname.mas_bottom).with.offset(7.8);
        make.height.mas_equalTo(1);
    }];

    [self.changeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickname);
        make.left.equalTo(self.nickname.mas_right).with.offset(42);
        make.right.equalTo(self.firstLine.mas_right);
        make.height.mas_equalTo(30);
    }];

    [self.birthday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 16));
        make.left.equalTo(self.view).with.offset(42);
        make.top.equalTo(self.nickname.mas_bottom).with.offset(20);
    }];

    [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(42);
        make.right.equalTo(self.view).with.offset(-42);
        make.top.equalTo(self.birthday.mas_bottom).with.offset(11);
        make.height.mas_equalTo(1);
    }];

    [self.changeBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.birthday);
        make.left.equalTo(self.changeName.mas_left);
        make.right.equalTo(self.secondLine.mas_right);
        make.height.mas_equalTo(30);
    }];

    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 16));
        make.left.equalTo(self.view).with.offset(42);
        make.top.equalTo(self.birthday.mas_bottom).with.offset(23);
    }];

    [self.thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(42);
        make.right.equalTo(self.view).with.offset(-42);
        make.top.equalTo(self.location.mas_bottom).with.offset(10);
        make.height.mas_equalTo(1);
    }];

    [self.changeLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.location);
        make.left.equalTo(self.changeName.mas_left);
        make.right.equalTo(self.thirdLine.mas_right);
        make.height.mas_equalTo(30);
    }];

    [self.gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 16));
        make.left.equalTo(self.view).with.offset(42);
        make.top.equalTo(self.location.mas_bottom).with.offset(24);
    }];

    [self.fourLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(42);
        make.right.equalTo(self.view).with.offset(-42);
        make.top.equalTo(self.gender.mas_bottom).with.offset(11);
        make.height.mas_equalTo(1);
    }];

    [self.signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 16));
        make.left.equalTo(self.view).with.offset(42);
        make.top.equalTo(self.gender.mas_bottom).with.offset(23);
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gender.mas_bottom).with.offset(13);
        make.left.equalTo(self.signature.mas_right).with.offset(10);
        make.right.equalTo(self.fourLine.mas_right);
        make.height.mas_equalTo(50);
    }];

    [self.signatureDefaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.changeName.mas_left);
        make.right.equalTo(self.changeName.mas_right);
        make.top.equalTo(self.signature.mas_top);
        make.height.mas_equalTo(16);
    }];

    [self.fiveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(42);
        make.right.equalTo(self.view).with.offset(-42);
        make.top.equalTo(self.signature.mas_bottom).with.offset(27);
        make.height.mas_equalTo(1);
    }];

    [self.maxSignatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textView.mas_right).with.offset(-8);
        make.bottom.equalTo(self.fiveLine.mas_top).with.offset(-6);
        make.size.mas_equalTo(CGSizeMake(30, 10));
    }];

    [self.boyCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.changeName.mas_left);
        make.centerY.equalTo(self.gender);
    }];

    [self.boyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 16));
        make.left.equalTo(self.boyCircle.mas_right).with.offset(4);
        make.centerY.equalTo(self.gender);
    }];

    [self.girlCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.boyLabel.mas_right).with.offset(18);
        make.centerY.equalTo(self.gender);
    }];

    [self.girlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 16));
        make.left.equalTo(self.girlCircle.mas_right).with.offset(4);
        make.centerY.equalTo(self.gender);
    }];

    [self.userGender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(84, 16));
        make.left.equalTo(self.changeName.mas_left);
        make.centerY.equalTo(self.gender);
    }];

    [self.sexNoChangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(132, 28));
        make.top.equalTo(self.boyLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.boyCircle.mas_left);
    }];

    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.fiveLine.mas_bottom).with.offset(iPhone5 ? 22 : 33);
        make.size.mas_equalTo(CGSizeMake(263, 44));
    }];

    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    if (userInfo && userInfo.userid) {
        [self configueData];
    } else {
        __weak typeof(self) weakSelf = self;
        [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
            if (success) {
                [weakSelf configueData];
            } else {
                [SYToastView showToast:@"信息获取异常，请重试!"];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self addKeyboardNotifcations];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSignatureDefaultLabelState) name:UITextViewTextDidChangeNotification object:nil];
#ifdef ShiningSdk
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    [SYSettingManager setShowNeedInfo:YES withUid:user.userid];
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - 个性签名

- (void)updateSignatureDefaultLabelState {
    if (self.textView.text.length == 0) {
        self.signatureDefaultLabel.hidden = NO;
    } else {
        self.signatureDefaultLabel.hidden = YES;
    }
}

#pragma mark - PrivateMethod

- (void)updateUserDataAfterModifySuccess {
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
        [SYToastView showToast:@"修改信息成功"];
        [weakSelf configueData];
        [weakSelf handleJumpBtnClickEvent];
    }];
}

- (void)configueData {
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    if (userInfo && userInfo.userid) {

        // 头像
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_imgurl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];

        // id
        NSString *showId = [userInfo.bestid integerValue] > 0 ? userInfo.bestid : userInfo.userid;
        NSString *idText = [NSString stringWithFormat:@"Bee语音ID：%@",showId];
        self.idLabel.text = idText;

        // name
        NSString *name = [NSString sy_safeString:userInfo.username];
        self.changeName.text = name;

        // birthday
        NSString *birthday = [NSString sy_safeString:userInfo.birthday];
        self.datePickerSelectDate = birthday;
        NSString *formatBirth = [SYUtil formatBirthdayWithStr:birthday];
        [self.changeBirthday setTitle:formatBirth forState:UIControlStateNormal];

        // location
        self.selectedDistrictId = [userInfo.residence_place integerValue];
        SYDistrict *district = [[SYDistrictProvider shared] districtOfId:[userInfo.residence_place integerValue]];
        NSString *location = [NSString stringWithFormat:@"%@%@",district.provinceName,district.districtName];
        if ([NSObject sy_empty:district]) {
            location = @"保密";
        }
        [self.changeLocation setTitle:location forState:UIControlStateNormal];

        // gender
        NSString *gender = [NSString sy_safeString:userInfo.gender];
        self.selectedGender = gender;
        if ([gender isEqualToString:@"male"] || [gender isEqualToString:@"female"]) {
            self.userGender.hidden = NO;
            self.boyCircle.hidden = YES;
            self.boyLabel.hidden = YES;
            self.girlCircle.hidden = YES;
            self.girlLabel.hidden = YES;
            self.sexNoChangeLabel.hidden = YES;
            self.userGender.text = [gender isEqualToString:@"male"] ? @"男生" : @"女生";
        } else {
            self.userGender.hidden = YES;
            self.sexNoChangeLabel.hidden = YES;
        }

        // 个性签名
        NSString *signature = [NSString sy_safeString:userInfo.signature];
        self.textView.text = signature;
        NSInteger currentCount = signature.length >= 20 ? 20 :signature.length;
        self.maxSignatureLabel.text = [NSString stringWithFormat:@"%ld/20",currentCount];
        [self updateSignatureDefaultLabelState];
    }
}

#pragma mark - iphone5机型适配

- (void)addKeyboardNotifcations {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    CGFloat keyboardHeight = keyboardRect.size.height;

    CGRect frame = self.view.frame;
    if (iPhone5) {
        frame.origin.y = -(keyboardHeight - 59);
    } else {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        CGFloat bottomSpace = screenFrame.size.height - (iPhoneX ? 531 + 24 : 531);
        frame.origin.y = - (keyboardHeight + 27 - bottomSpace);
    }
    self.view.frame = frame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
}

// 收起键盘
- (void)packUpKeyboard {
    [self.changeName resignFirstResponder];
    [self.textView resignFirstResponder];
}

//#pragma mark - UITextFieldTextDidChangeNotification
//
//- (void)addTextFieldTextChangeNotification {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.changeName];
//}
//
//- (void)removeTextFieldTextChangeNotification {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.changeName];
//}
//
//- (void)textFiledEditChanged:(NSNotification *)noti
//{
//    UITextField *infoText = noti.object;
//    int kMaxLength = 12;
//    NSString *toBeString = infoText.text;
//    NSString *lang = [UIApplication sharedApplication].textInputMode.primaryLanguage; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
//        UITextRange *selectedRange = [infoText markedTextRange];
//        //获取高亮部分
//        // 系统的UITextRange，有两个变量，一个是start，一个是end，这是对于的高亮区域
//        UITextPosition *position = [infoText positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > kMaxLength) {
//                infoText.text = [toBeString substringToIndex:kMaxLength];
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//        }
//    }
//    else{
//        if (toBeString.length > kMaxLength) {// 表情之类的，中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//            infoText.text = [toBeString substringToIndex:kMaxLength];
//        }
//    }
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([NSString sy_isBlankString:textField.text]) {
        [SYToastView showToast:@"昵称不能为空"];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length > 0 && [string isEqualToString:@""]) {     // 点击键盘中删除按钮操作
        return YES;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 12;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.changeName resignFirstResponder];
    [self.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSString *textStr = textView.text;
    if (textStr.length > SYMaxSignNumber) {
        textView.text = [textStr substringToIndex:SYMaxSignNumber];
    }
    textStr = textView.text;
    NSInteger currentCount = textStr.length >= 20 ? 20 :textStr.length;
    self.maxSignatureLabel.text = [NSString stringWithFormat:@"%ld/20",currentCount];
}

#pragma mark - SYDatePickerViewDelegate

- (void)handleSYDatePickerViewCancelBtn {
    self.datePicker = nil;
}

- (void)handleSYDatePickerViewEnsureBtnWithDateStr:(NSString *)date {
    self.datePicker = nil;
    self.datePickerSelectDate = date;
    NSString *formatDate = [SYUtil formatBirthdayWithStr:date];
    [self.changeBirthday setTitle:formatDate forState:UIControlStateNormal];
}

#pragma mark - SYDistrictPickerViewDelegate

- (void)handleSYDistrictPicerViewCancelBtn {
    self.districtPicker = nil;
}

- (void)handleSYDistrictPickerViewEnsureBtnwithDistrictId:(NSInteger)districtId {
    self.districtPicker = nil;
    self.selectedDistrictId = districtId;
    SYDistrict *district = [[SYDistrictProvider shared] districtOfId: districtId];
    NSString *location = [NSString stringWithFormat:@"%@%@",district.provinceName,district.districtName];
    if ([NSObject sy_empty:district]) {
        location = @"保密";
    }
    [self.changeLocation setTitle:location forState:UIControlStateNormal];
}

#pragma mark - BtnClick

// 跳过
- (void)handleJumpBtnClickEvent {
    [self packUpKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 修改头像
- (void)handleCameraBtnClick {
    [self packUpKeyboard];
    NSArray *actions = @[@"拍照", @"从手机相册选择"];
    __weak typeof(self) weakSelf = self;
    SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
                                                                  cancelTitle:@"取消"
                                                                  selectBlock:^(NSInteger index) {
                                                                      switch (index) {
                                                                          case 0:
                                                                          {
                                                                              [weakSelf.photoManager openPhotoGraph];
                                                                          }
                                                                              break;
                                                                          case 1:
                                                                          {
                                                                              [weakSelf.photoManager openPhotoAlbum];
                                                                          }
                                                                              break;
                                                                          default:
                                                                              break;
                                                                      }
                                                                  } cancelBlock:^{

                                                                  }];
    [sheet show];
}

// 选择生日
- (void)handleChangeBirthdayBtnClick {
    [self packUpKeyboard];
    if (self.datePicker) {
        [self.datePicker removeFromSuperview];
        self.datePicker  = nil;
    }
    self.datePicker = [[SYDatePickerView alloc] initWithFrame:CGRectZero];
    self.datePicker.delegate = self;
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    NSString *defaultDate;
    if ([NSString sy_isBlankString:self.datePickerSelectDate]) {
        defaultDate = [NSString sy_safeString:userInfo.birthday];
    } else {
        defaultDate = self.datePickerSelectDate;
    }
    self.datePicker.defaultDate = defaultDate;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

// 选择地区
- (void)handleChangeLocationBtnClick {
    [self packUpKeyboard];
    if (self.districtPicker) {
        [self.districtPicker removeFromSuperview];
        self.districtPicker  = nil;
    }
    self.districtPicker = [[SYDistrictPickerView alloc] initWithFrame:CGRectZero];
    self.districtPicker.delegate = self;
    self.districtPicker.district_id = self.selectedDistrictId;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.districtPicker];
    [self.districtPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

// 选择性别
- (void)handleGenderBtnClickEvent:(UIButton *)btn {
    NSInteger genderTag = btn.tag;
    switch (genderTag) {
        case SYGenderMale:
        {
            self.selectedGender = @"male";
            [self.boyCircle setImage:[UIImage imageNamed_sy:@"mine_gender_circle_select"] forState:UIControlStateNormal];
            [self.boyLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.girlCircle setImage:[UIImage imageNamed_sy:@"mine_gender_circle_normal"] forState:UIControlStateNormal];
            [self.girlLabel setTitleColor:RGBACOLOR(255, 255, 255, 0.8) forState:UIControlStateNormal];
            self.sexNoChangeLabel.hidden = NO;
            [self.sexNoChangeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.boyCircle.mas_left);
            }];
        }
            break;
        case SYGenderFemale:
        {
            self.selectedGender = @"female";
            [self.girlCircle setImage:[UIImage imageNamed_sy:@"mine_gender_circle_select"] forState:UIControlStateNormal];
            [self.girlLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.boyCircle setImage:[UIImage imageNamed_sy:@"mine_gender_circle_normal"] forState:UIControlStateNormal];
            [self.boyLabel setTitleColor:RGBACOLOR(255, 255, 255, 0.8) forState:UIControlStateNormal];
            self.sexNoChangeLabel.hidden = NO;
            [self.sexNoChangeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.boyCircle.mas_left).with.offset(20+50);
            }];
        }
            break;
        default:
            break;
    }
}

// 确定修改
- (void)handleEnsureBtnClick {
    [self packUpKeyboard];
    NSString *name = self.changeName.text;
    if ([NSString sy_isBlankString:name]) {
        [SYToastView showToast:@"昵称不能为空~"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self requestValidContent:self.textView.text block:^(BOOL success) {
        if (success) {
            [weakSelf updateInfos];
        } else {
            [SYToastView showToast:@"个性签名含有敏感信息~"];
        }
    }];
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

- (void)updateInfos {
    NSString *name = self.changeName.text;
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    NSString *avatarUrl = @"";
    UIImage *avatarImage = nil;
    NSData *avatarData = [NSData data];
    if (self.selectedAvatarImage) {
        avatarUrl = @"";
        avatarImage = [SYUtil compressImage:self.selectedAvatarImage withTargetSize:CGSizeMake(500, 500)];
        avatarData = UIImageJPEGRepresentation(avatarImage, 0.5);
    } else {
        avatarUrl = userInfo.avatar_imgurl;
    }

    NSString *gender = self.selectedGender;
    NSString *signature = self.textView.text;
    NSString *birthday = self.datePickerSelectDate;
    NSString *districtId = [NSString stringWithFormat:@"%ld",self.selectedDistrictId];

    if (avatarData.length > 0) {
        __weak typeof(self) weakSelf = self;
        [[SYAPPServiceAPI sharedInstance] requestValidateImage:avatarData success:^(id  _Nullable response) {
            [weakSelf uploadUserInfoWithHeadAvatarUrl:avatarUrl avatarData:avatarData name:name gender:gender signature:signature birthday:birthday districtId:districtId];
        } failure:^(NSError * _Nullable error) {
            NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"person"};
//            [MobClick event:@"imagePorn" attributes:pubParam];
            [SYToastView showToast:@"头像包含敏感信息，请重新上传~"];
        }];
        return;
    }
    [self uploadUserInfoWithHeadAvatarUrl:avatarUrl avatarData:avatarData name:name gender:gender signature:signature birthday:birthday districtId:districtId];
}

- (void)uploadUserInfoWithHeadAvatarUrl:(NSString *)avatarUrl avatarData:(NSData *)avatarData name:(NSString *)name gender:(NSString *)gender signature:(NSString *)signature birthday:(NSString *)birthday districtId:(NSString *)districtId {
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] updateUserInfoWithOriginAvatarUrl:avatarUrl
                                              withChangedAvatarImageFile:avatarData
                                                            withUserName:name
                                                              withGender:gender
                                                           withSignature:signature
                                                            withBirthday:birthday
                                                          withDistrictiD:districtId
                                                                 success:^(NSInteger code) {
                                                              if (code == 0) {
                                                                  [weakSelf updateUserDataAfterModifySuccess];
                                                              } else if (code == 2008) {
                                                                  [SYToastView showToast:@"accesstoken无效"];
                                                              } else if (code == 2009) {
                                                                  [SYToastView showToast:@"accesstoken失效"];
                                                              } else if (code == 2022) {
                                                                  NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:name],
                                                                                             @"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],
                                                                                             @"from":@"person"};
//                                                                  [MobClick event:@"textPorn" attributes:pubParam];
                                                                  [SYToastView showToast:@"昵称包含敏感信息，请重新输入~"];
                                                              } else {
                                                                  [SYToastView showToast:@"修改信息失败,稍后重试"];
                                                              }
                                                          }];
}

#pragma mark - LazyLoad

- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        _backgroundImage = [UIImageView new];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = [UIImage imageNamed_sy:@"mine_background"];
    }
    return _backgroundImage;
}

- (UIButton *)jumpMoreBtn {
    if (!_jumpMoreBtn) {
        _jumpMoreBtn = [UIButton new];
        [_jumpMoreBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_jumpMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _jumpMoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_jumpMoreBtn addTarget:self action:@selector(handleJumpBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpMoreBtn;
}

- (UILabel *)mineInfo {
    if (!_mineInfo) {
        _mineInfo = [UILabel new];
        _mineInfo.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
        _mineInfo.textColor = [UIColor whiteColor];
        _mineInfo.textAlignment = NSTextAlignmentCenter;
        _mineInfo.text = @"我的信息";
    }
    return _mineInfo;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIImageView new];
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImage.clipsToBounds = YES;
        _avatarImage.layer.cornerRadius = 60;
        _avatarImage.image = [UIImage imageNamed_sy:@"mine_head_default"];
    }
    return _avatarImage;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [UIButton new];
        [_cameraBtn setImage:[UIImage imageNamed_sy:@"mine_camera"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(handleCameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [UILabel new];
        _idLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _idLabel.textColor = [UIColor whiteColor];
        _idLabel.textAlignment = NSTextAlignmentCenter;
        _idLabel.text = @"Bee语音ID:-";
    }
    return _idLabel;
}

- (UILabel *)nickname {
    if (!_nickname) {
        _nickname = [UILabel new];
        _nickname.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _nickname.textColor = [UIColor whiteColor];
        _nickname.textAlignment = NSTextAlignmentCenter;
        _nickname.text = @"昵称";
    }
    return _nickname;
}

- (UITextField *)changeName {
    if (!_changeName) {
        _changeName = [[UITextField alloc]init];
        _changeName.backgroundColor = [UIColor clearColor];
        _changeName.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _changeName.textColor = [UIColor whiteColor];
        _changeName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _changeName.textAlignment = NSTextAlignmentLeft;
        _changeName.delegate = self;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"取一个好听的名字呗" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(255,255,255,0.8),NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:14]}];
        _changeName.attributedPlaceholder = attrString;
    }
    return _changeName;
}

- (UIView *)firstLine {
    if (!_firstLine) {
        _firstLine = [UIView new];
        _firstLine.backgroundColor = RGBACOLOR(255, 255, 255, 0.2);
    }
    return _firstLine;
}

- (UILabel *)birthday {
    if (!_birthday) {
        _birthday = [UILabel new];
        _birthday.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _birthday.textColor = [UIColor whiteColor];
        _birthday.textAlignment = NSTextAlignmentCenter;
        _birthday.text = @"生日";
    }
    return _birthday;
}

- (UIButton *)changeBirthday {
    if (!_changeBirthday) {
        _changeBirthday = [UIButton new];
        _changeBirthday.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _changeBirthday.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_changeBirthday setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeBirthday addTarget:self action:@selector(handleChangeBirthdayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBirthday;
}

- (UIView *)secondLine {
    if (!_secondLine) {
        _secondLine = [UIView new];
        _secondLine.backgroundColor = RGBACOLOR(255, 255, 255, 0.2);
    }
    return _secondLine;
}

- (UILabel *)location {
    if (!_location) {
        _location = [UILabel new];
        _location.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _location.textColor = [UIColor whiteColor];
        _location.textAlignment = NSTextAlignmentCenter;
        _location.text = @"所在地";
    }
    return _location;
}

- (UIButton *)changeLocation {
    if (!_changeLocation) {
        _changeLocation = [UIButton new];
        _changeLocation.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _changeLocation.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_changeLocation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeLocation addTarget:self action:@selector(handleChangeLocationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeLocation;
}

- (UIView *)thirdLine {
    if (!_thirdLine) {
        _thirdLine = [UIView new];
        _thirdLine.backgroundColor = RGBACOLOR(255, 255, 255, 0.2);
    }
    return _thirdLine;
}

- (UILabel *)gender {
    if (!_gender) {
        _gender = [UILabel new];
        _gender.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _gender.textColor = [UIColor whiteColor];
        _gender.textAlignment = NSTextAlignmentCenter;
        _gender.text = @"性别";
    }
    return _gender;
}

- (UIView *)fourLine {
    if (!_fourLine) {
        _fourLine = [UIView new];
        _fourLine.backgroundColor = RGBACOLOR(255, 255, 255, 0.2);
    }
    return _fourLine;
}

- (UILabel *)signature {
    if (!_signature) {
        _signature = [UILabel new];
        _signature.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _signature.textColor = [UIColor whiteColor];
        _signature.textAlignment = NSTextAlignmentCenter;
        _signature.text = @"个性签名";
    }
    return _signature;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textView.textColor = RGBACOLOR(255,255,255,1);
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

- (UILabel *)signatureDefaultLabel {
    if (!_signatureDefaultLabel) {
        _signatureDefaultLabel = [UILabel new];
        _signatureDefaultLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _signatureDefaultLabel.textColor = RGBACOLOR(255,255,255,0.8);
        _signatureDefaultLabel.textAlignment = NSTextAlignmentLeft;
        _signatureDefaultLabel.text = @"记录自己的个性宣言~";
    }
    return _signatureDefaultLabel;
}

- (UILabel *)maxSignatureLabel {
    if (!_maxSignatureLabel) {
        _maxSignatureLabel = [UILabel new];
        _maxSignatureLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _maxSignatureLabel.textColor = RGBACOLOR(255,255,255,0.5);
        _maxSignatureLabel.textAlignment = NSTextAlignmentRight;
        _maxSignatureLabel.text = @"0/20";
    }
    return _maxSignatureLabel;
}

- (UIView *)fiveLine {
    if (!_fiveLine) {
        _fiveLine = [UIView new];
        _fiveLine.backgroundColor = RGBACOLOR(255, 255, 255, 0.2);
    }
    return _fiveLine;
}

- (UIButton *)boyCircle {
    if (!_boyCircle) {
        _boyCircle = [UIButton new];
        _boyCircle.tag = SYGenderMale;
        [_boyCircle setImage:[UIImage imageNamed_sy:@"mine_gender_circle_normal"] forState:UIControlStateNormal];
        [_boyCircle addTarget:self action:@selector(handleGenderBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _boyCircle;
}

- (UIButton *)boyLabel {
    if (!_boyLabel) {
        _boyLabel = [UIButton new];
        _boyLabel.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        [_boyLabel setTitle:@"男生" forState:UIControlStateNormal];
        [_boyLabel setTitleColor:RGBACOLOR(255, 255, 255, 0.8) forState:UIControlStateNormal];
        _boyLabel.tag = SYGenderMale;
        [_boyLabel addTarget:self action:@selector(handleGenderBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _boyLabel;
}

- (UIButton *)girlCircle {
    if (!_girlCircle) {
        _girlCircle = [UIButton new];
        _girlCircle.tag = SYGenderFemale;
        [_girlCircle setImage:[UIImage imageNamed_sy:@"mine_gender_circle_normal"] forState:UIControlStateNormal];
        [_girlCircle addTarget:self action:@selector(handleGenderBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _girlCircle;
}

- (UIButton *)girlLabel {
    if (!_girlLabel) {
        _girlLabel = [UIButton new];
        _girlLabel.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        [_girlLabel setTitle:@"女生" forState:UIControlStateNormal];
        [_girlLabel setTitleColor:RGBACOLOR(255, 255, 255, 0.8) forState:UIControlStateNormal];
        _girlLabel.tag = SYGenderFemale;
        [_girlLabel addTarget:self action:@selector(handleGenderBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _girlLabel;
}

- (UILabel *)userGender {
    if (!_userGender) {
        _userGender = [UILabel new];
        _userGender.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _userGender.textColor = [UIColor whiteColor];
        _userGender.textAlignment = NSTextAlignmentLeft;
        _userGender.hidden = YES;
    }
    return _userGender;
}

- (UILabel *)sexNoChangeLabel {
    if (!_sexNoChangeLabel) {
        _sexNoChangeLabel = [UILabel new];
        _sexNoChangeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
        _sexNoChangeLabel.textColor = RGBACOLOR(255, 255, 255, 0.6);
        _sexNoChangeLabel.backgroundColor = RGBACOLOR(162,127,255,1);
        _sexNoChangeLabel.textAlignment = NSTextAlignmentCenter;
        _sexNoChangeLabel.text = @"性别设置后不可更改哦";
        CGRect bounds = CGRectMake(0, 0, 132, 28);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(14, 14)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.CGPath;
        _sexNoChangeLabel.layer.mask = maskLayer;
    }
    return _sexNoChangeLabel;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton new];
        [_ensureBtn setTitle:@"确定修改" forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:RGBACOLOR(126,69,253,1) forState:UIControlStateNormal];
        [_ensureBtn setBackgroundImage:[SYUtil imageFromColor:RGBACOLOR(255, 255, 255, 1)] forState:UIControlStateNormal];
        [_ensureBtn setBackgroundImage:[SYUtil imageFromColor:RGBACOLOR(193, 193, 193, 1)] forState:UIControlStateHighlighted];
        _ensureBtn.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _ensureBtn.clipsToBounds = YES;
        _ensureBtn.layer.cornerRadius = 22;
        [_ensureBtn addTarget:self action:@selector(handleEnsureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

- (SYSystemPhotoManager *)photoManager {
    if (!_photoManager) {
        __weak typeof(self)weakSelf = self;
        _photoManager = [[SYSystemPhotoManager alloc] initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image) {
            weakSelf.selectedAvatarImage = image;
            weakSelf.avatarImage.image = image;
        }];
    }
    return _photoManager;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
