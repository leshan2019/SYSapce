//
//  SYMineModifyPersonInfoVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/27.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineModifyPersonInfoVC.h"
#import "SYSystemPhotoManager.h"
#import "SYDatePickerView.h"
#import "SYDistrictPickerView.h"
#import "SYUserServiceAPI.h"
#import "SYSignProvider.h"
#import "SYDistrictProvider.h"

@interface SYMineModifyPersonInfoVC ()<UITextFieldDelegate, SYDatePickerViewDelegate, SYDistrictPickerViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImage; // 背景图
@property (nonatomic, strong) UIButton *backBtn;        // 返回上一层
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
@property (nonatomic, strong) UIButton *ensureBtn;      // 确定修改

@property (nonatomic, strong) UITextField *changeName;   // 更改名字
@property (nonatomic, strong) UIButton *changeBirthday;  // 更改生日
@property (nonatomic, strong) UIButton *changeLocation;  // 更改所在地

@property (nonatomic, strong) UIImageView *boyCircle;    // 男生圆圈
@property (nonatomic, strong) UIImageView *girlCircle;   // 女生圆圈
@property (nonatomic, strong) UILabel *boyLabel;         // 男生
@property (nonatomic, strong) UILabel *girlLabel;        // 女生
@property (nonatomic, strong) UILabel *noModifyLabel;    // 不可更改

@property (nonatomic, strong) SYSystemPhotoManager *photoManager;

@property (nonatomic, strong) SYDatePickerView *datePicker;
@property (nonatomic, copy) NSString *datePickerSelectDate; //保存datePicker返回的date

@property (nonatomic, strong) SYDistrictPickerView *districtPicker;
@property (nonatomic, assign) NSInteger selectedDistrictId;

@property (nonatomic, strong) UIImage *selectedAvatarImage; // 改动的头像

@end

@implementation SYMineModifyPersonInfoVC

- (void)dealloc {
    NSLog(@"SYMineModifyPersonInfoVC-dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(117, 63, 251, 1);

    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.backBtn];
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
    [self.view addSubview:self.boyCircle];
    [self.view addSubview:self.boyLabel];
    [self.view addSubview:self.girlCircle];
    [self.view addSubview:self.girlLabel];
    [self.view addSubview:self.noModifyLabel];
    [self.view addSubview:self.ensureBtn];

    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 44));
        make.left.equalTo(self.view).with.offset(10);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 44 : 20);
    }];

    [self.mineInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(96, 32));
        make.left.equalTo(self.view).with.offset(22);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 98 : 74);
    }];

    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 160));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mineInfo.mas_bottom).with.offset(23);
    }];

    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
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
        make.top.equalTo(self.idLabel.mas_bottom).with.offset(37);
    }];

    [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(42);
        make.right.equalTo(self.view).with.offset(-42);
        make.top.equalTo(self.nickname.mas_bottom).with.offset(7.8);
        make.height.mas_equalTo(1);
    }];

    [self.changeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickname);
        make.left.equalTo(self.nickname.mas_right).with.offset(30);
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
        make.left.equalTo(self.birthday.mas_right).with.offset(30);
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
        make.left.equalTo(self.location.mas_right).with.offset(16);
        make.right.equalTo(self.thirdLine.mas_right);
        make.height.mas_equalTo(30);
    }];

    [self.gender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 16));
        make.left.equalTo(self.view).with.offset(42);
        make.top.equalTo(self.location.mas_bottom).with.offset(23);
    }];

    [self.boyCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.gender.mas_right).with.offset(30);
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

    [self.noModifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(84, 16));
        make.left.equalTo(self.girlLabel.mas_right);
        make.centerY.equalTo(self.gender);
    }];

    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(iPhone5 ? -20 : -77);
        make.size.mas_equalTo(CGSizeMake(263, 44));
    }];

    [self configueInitValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self addKeyboardNotifcations];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeKeyboardNotifications];
}

#pragma mark - iphone5机型适配

- (void)addKeyboardNotifcations {
    if (iPhone5) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)removeKeyboardNotifications {
    if (iPhone5) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    CGFloat keyboardHeight = keyboardRect.size.height;

    CGRect frame = self.view.frame;
    frame.origin.y = -keyboardHeight/4;
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
}

#pragma mark - Private

- (void)configueInitValue {
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    if (userInfo && userInfo.userid) {
        // avatar
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_imgurl]placeholderImage:[UIImage imageNamed_sy:@"mine_edit_head_default"]];
        // id
        NSString *idText = [NSString stringWithFormat:@"Bee语音ID：%@",userInfo.userid];
        self.idLabel.text = idText;
        // name
        NSString *name = [NSString sy_safeString:userInfo.username];;
        self.changeName.text = name;
        // birthday
        NSString *birthday = [NSString sy_safeString:userInfo.birthday];
        self.datePickerSelectDate = userInfo.birthday;
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
        if ([gender isEqualToString:@"male"]) {
            self.boyCircle.image = [UIImage imageNamed_sy:@"mine_gender_circle_select"];
            self.boyLabel.textColor = [UIColor whiteColor];
            self.girlCircle.image = [UIImage imageNamed_sy:@"mine_gender_circle_normal"];
            self.girlLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
        } else if ([gender isEqualToString:@"female"]) {
            self.girlCircle.image = [UIImage imageNamed_sy:@"mine_gender_circle_select"];
            self.girlLabel.textColor = [UIColor whiteColor];
            self.boyCircle.image = [UIImage imageNamed_sy:@"mine_gender_circle_normal"];
            self.boyLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([NSString sy_isBlankString:textField.text]) {
        [SYToastView showToast:@"昵称不能为空"];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {  // 删除
        return YES;
    } else if (textField.text.length >= 12) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_changeName resignFirstResponder];
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

// 返回
- (void)handleBackBtn {
    [self packUpKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
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

// 确定修改
- (void)handleEnsureBtnClick {
    [self packUpKeyboard];
    NSString *name = self.changeName.text;
    if ([NSString sy_isBlankString:name]) {
        [SYToastView showToast:@"昵称不能为空"];
        return;
    }
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
    NSString *gender = userInfo.gender;
    NSString *signature = @"";
    NSString *birthday = self.datePickerSelectDate;
    NSString *districtId = [NSString stringWithFormat:@"%ld",self.selectedDistrictId];
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
                                                                  [SYToastView showToast:@"修改信息成功"];
                                                                  weakSelf.selectedAvatarImage = nil;
                                                              } else if (code == 2008) {
                                                                  [SYToastView showToast:@"accesstoken无效"];
                                                              } else if (code == 2009) {
                                                                  [SYToastView showToast:@"accesstoken失效"];
                                                              } else if (code == 2022) {
                                                                  [SYToastView showToast:@"不能包含敏感词汇，请修改"];
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

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"voiceroom_back"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(handleBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
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
        _avatarImage.layer.cornerRadius = 80;
        _avatarImage.image = [UIImage imageNamed_sy:@"mine_edit_head_default"];
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
        _idLabel.text = @"Bee语音ID:2345623";
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

- (UIImageView *)boyCircle {
    if (!_boyCircle) {
        _boyCircle = [UIImageView new];
    }
    return _boyCircle;
}

- (UILabel *)boyLabel {
    if (!_boyLabel) {
        _boyLabel = [UILabel new];
        _boyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _boyLabel.textAlignment = NSTextAlignmentCenter;
        _boyLabel.text = @"男生";
    }
    return _boyLabel;
}

- (UIImageView *)girlCircle {
    if (!_girlCircle) {
        _girlCircle = [UIImageView new];
    }
    return _girlCircle;
}

- (UILabel *)girlLabel {
    if (!_girlLabel) {
        _girlLabel = [UILabel new];
        _girlLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _girlLabel.textAlignment = NSTextAlignmentCenter;
        _girlLabel.text = @"女生";
    }
    return _girlLabel;
}

- (UILabel *)noModifyLabel {
    if (!_noModifyLabel) {
        _noModifyLabel = [UILabel new];
        _noModifyLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _noModifyLabel.textColor = RGBACOLOR(255, 255, 255, 0.8);
        _noModifyLabel.textAlignment = NSTextAlignmentCenter;
        _noModifyLabel.text = @"(不可更改)";
    }
    return _noModifyLabel;
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

@end
