//
//  SYCreateVoiceRoomVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateVoiceRoomVC.h"
#import "SYPlaceholderTextView.h"
#import "SYVoiceChatNetManager.h"
#import "SYSystemPhotoManager.h"
#import "SYCreateVoiceRoomTypeView.h"
#import "SYCreateVoiceRoomNumView.h"
#import "SYPickerView.h"
#import "SYCreateVoiceRoomViewModel.h"
#import "SYVoiceChatRoomBackdropVC.h"

#define ScrollTitleHeight 15.f
#define ScrollTitleWidth 70.f

@interface SYCreateVoiceRoomVC () <UITextFieldDelegate, SYPlaceholderTextViewDelegate, SYCreateVoiceRoomNumViewDelegate, SYPickerViewDelegate, UIScrollViewDelegate, SYVoiceChatRoomBackdropVCDelegate>

@property (nonatomic, strong) SYCreateVoiceRoomViewModel *viewModel;

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *passwordField;
//@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) SYPlaceholderTextView *playRuleTextView;
@property (nonatomic, strong) SYPlaceholderTextView *greetTextView;
@property (nonatomic, strong) UIImageView *avatarView;
//@property (nonatomic, strong) UIImageView *avatarView169;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, assign) NSInteger selectedBackImage;  // 选中的第几张房间背景
@property (nonatomic, strong) SYCreateVoiceRoomTypeView *typeChooseView;
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) SYCreateVoiceRoomNumView *numView;

@property (nonatomic, strong) SYSystemPhotoManager *photoManager;
//@property (nonatomic, strong) SYSystemPhotoManager *photoManager169;
@property (nonatomic, strong) UIImage *avatarImage;
//@property (nonatomic, strong) UIImage *avatarImage169;
@property (nonatomic, strong) NSMutableArray *mutableSubviewArray;



@end

@implementation SYCreateVoiceRoomVC

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewModel = [[SYCreateVoiceRoomViewModel alloc] init];
        _mutableSubviewArray = [NSMutableArray new];
        self.selectedBackImage = 0; // 默认是第一张
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.typeChooseView removeObserver:self forKeyPath:@"selectedIndex"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sy_configDataInfoPageName:SYPageNameType_CreateRoom];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.viewModel requestCategoryListWithBlock:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self drawView];
    }];
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.containerView];
    
    [self.containerView addSubview:self.scrollView];
}

- (void)drawView {
    CGFloat top = 39.f;
    [self.scrollView addSubview:[self labelWithText:@"房间名称" top:top]];
    top += (36 + ScrollTitleHeight);
    [self.scrollView addSubview:[self labelWithText:@"房间封面" top:top]];
    top += (37 + ScrollTitleHeight);
//    [self.scrollView addSubview:[self labelWithText:@"房间封面" top:top]];
    top += (37 + ScrollTitleHeight);
    [self.scrollView addSubview:[self labelWithText:@"房间背景" top:(top - 52.f)]];
    top += (40 + ScrollTitleHeight);
    [self.scrollView addSubview:[self labelWithText:@"房间类型" top:(top - 52.f)]];
    top += (100 + ScrollTitleHeight);
    UILabel *micLabel = [self labelWithText:@"麦位数量" top:top];
    [self.scrollView addSubview:micLabel];
    top += (25 + ScrollTitleHeight);
    UILabel *playRuleLabel = [self labelWithText:@"玩法公告" top:top];
    [self.scrollView addSubview:playRuleLabel];
    top += (85 + ScrollTitleHeight);
    UILabel *welcomeLabel = [self labelWithText:@"欢迎语" top:top];
    [self.scrollView addSubview:welcomeLabel];
    top += (73 + ScrollTitleHeight);
    UILabel *privateLabel = [self longLabelWithText:@"是否为私密房间" top:top
                                              width:108.f];
    [self.scrollView addSubview:privateLabel];
    top += (35 + ScrollTitleHeight);
    UILabel *passwordLabel = [self labelWithText:@"数字密码" top:top];
    [self.scrollView addSubview:passwordLabel];
    passwordLabel.hidden = YES;
    self.passwordLabel = passwordLabel;
    [self.scrollView addSubview:passwordLabel];
    
    [self.mutableSubviewArray addObject:micLabel];
    [self.mutableSubviewArray addObject:playRuleLabel];
    [self.mutableSubviewArray addObject:welcomeLabel];
    [self.mutableSubviewArray addObject:privateLabel];
    [self.mutableSubviewArray addObject:passwordLabel];
    
    [self.scrollView addSubview:self.nameField];
    [self.scrollView addSubview:[self imageViewWithFrame:CGRectMake(self.scrollView.sy_width - 36.f, 90.f, 16.f, 16.f)
                                               imageName:@"voiceroom_right_icon"]];
    [self.scrollView addSubview:[self hintLabelWithText:@"1:1" top:92]];
    [self.scrollView addSubview:self.avatarView];
    [self.scrollView addSubview:[self buttonWithFrame:CGRectMake(0, 72.f, self.scrollView.sy_width, 52.f)
                                               action:@selector(addAvatar:)]];
//    [self.scrollView addSubview:[self imageViewWithFrame:CGRectMake(self.scrollView.sy_width - 36.f, 142.f, 16.f, 16.f)
//                                               imageName:@"voiceroom_right_icon"]];
//    [self.scrollView addSubview:[self buttonWithFrame:CGRectMake(0, 124.f, self.scrollView.sy_width, 52.f)
//                                               action:@selector(addAvatar169:)]];
//    [self.scrollView addSubview:[self hintLabelWithText:@"16:9" top:144]];
//    [self.scrollView addSubview:self.avatarView169];

    [self.scrollView addSubview:[self imageViewWithFrame:CGRectMake(self.scrollView.sy_width - 36.f, 142.f, 16.f, 16.f)
                                               imageName:@"voiceroom_right_icon"]];
//    [self.scrollView addSubview:[self hintLabelWithText:@"1:1" top:144]];
    [self.scrollView addSubview:self.backgroundImage];
    [self.scrollView addSubview:[self buttonWithFrame:CGRectMake(0, 124.f, self.scrollView.sy_width, 52.f)
                                               action:@selector(addRoomBackgroundImage)]];

    [self.scrollView addSubview:self.typeChooseView];
    NSInteger count = [self.viewModel categoryCount];
    NSMutableArray *names = [NSMutableArray new];
    for (int i = 0; i < count; i ++) {
        [names addObject:[self.viewModel categoryStringAtIndex:i]];
    }
    [self.typeChooseView showWithCategoryNames:names];
    [self.scrollView addSubview:self.playRuleTextView];
    [self.scrollView addSubview:self.greetTextView];
    [self.scrollView addSubview:self.passwordField];
    [self.scrollView addSubview:self.switchControl];
    [self.scrollView addSubview:self.numView];
    
    [self.mutableSubviewArray addObject:self.playRuleTextView];
    [self.mutableSubviewArray addObject:self.greetTextView];
    [self.mutableSubviewArray addObject:self.passwordField];
    [self.mutableSubviewArray addObject:self.switchControl];
    [self.mutableSubviewArray addObject:self.numView];
    
    CGFloat changedHeight = self.typeChooseView.sy_height - 64.f - 52.f;
    for (UIView *view in self.mutableSubviewArray) {
        view.sy_top += changedHeight;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.sy_width, self.scrollView.contentSize.height + changedHeight + 52.f);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarLight];
    [self.navigationController setNavigationBarHidden:YES];
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat top = 22.f;
        if (iPhoneX) {
            top += 24;
        }
        _backButton.frame = CGRectMake(14.f, top, 36, 44);
        [_backButton setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"]
                     forState:UIControlStateNormal];
        [_backButton addTarget:self
                        action:@selector(back:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIImageView *)headView {
    if (!_headView) {
        CGFloat ratio = 750.f/564.f;
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat height = width / ratio;
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _headView.image = [UIImage imageNamed_sy:@"voiceroom_create_head"];
    }
    return _headView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat top = 62.f;
        if (iPhoneX) {
            top += 24.f;
        }
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.f, top, 150, 32)];
        _titleLabel.font = [UIFont systemFontOfSize:24.f weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"创建聊天室";
    }
    return _titleLabel;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        CGFloat top = CGRectGetHeight(self.view.bounds) - 64.f;
        if (iPhoneX) {
            top -= 34.f;
        }
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(40.f, top, CGRectGetWidth(self.view.bounds) - 80.f, 44);
        [_submitButton setTitle:@"创建" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_submitButton setBackgroundImage:[SYUtil imageFromColor:[UIColor sam_colorWithHex:@"#7B40FF"]]
                                 forState:UIControlStateNormal];
        [_submitButton addTarget:self
                          action:@selector(submit:)
                forControlEvents:UIControlEventTouchUpInside];
        _submitButton.layer.cornerRadius = 22.f;
        _submitButton.clipsToBounds = YES;
    }
    return _submitButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat top = CGRectGetMaxY(self.titleLabel.frame) + 26.f;
        CGFloat height = CGRectGetMinY(self.submitButton.frame) - 43.f - top;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(40.f, top, CGRectGetWidth(self.view.bounds) - 80.f, height)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
        _containerView.layer.shadowOffset = CGSizeMake(0, 10);
        _containerView.layer.shadowRadius = 24.f;
        _containerView.layer.shadowOpacity = 0.1;
        _containerView.layer.cornerRadius = 10.f;
    }
    return _containerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.containerView.bounds];
        _scrollView.delegate = self;
        _scrollView.layer.cornerRadius = 10.f;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), 647.f);
        _scrollView.showsVerticalScrollIndicator = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(88.f, 26.f, CGRectGetWidth(self.scrollView.bounds) - 108.f, 40)];
        _nameField.borderStyle = UITextBorderStyleNone;
        _nameField.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
        _nameField.placeholder = @"20字以内";
        _nameField.clipsToBounds = YES;
        _nameField.layer.cornerRadius = 4.f;
        _nameField.font = [UIFont systemFontOfSize:12];
        _nameField.textColor = [UIColor sam_colorWithHex:@"#999999"];
        UIView *leftblankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        UIView *rightblankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _nameField.leftView = leftblankView;
        _nameField.rightView = rightblankView;
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        _nameField.rightViewMode = UITextFieldViewModeAlways;
        _nameField.returnKeyType = UIReturnKeyDone;
        _nameField.delegate = self;
    }
    return _nameField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(88.f, 583 + 52.f, CGRectGetWidth(self.scrollView.bounds) - 108.f, 30)];
        _passwordField.borderStyle = UITextBorderStyleNone;
        _passwordField.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
        _passwordField.placeholder = @"4位密码";
        _passwordField.clipsToBounds = YES;
        _passwordField.layer.cornerRadius = 4.f;
        _passwordField.font = [UIFont systemFontOfSize:12];
        _passwordField.textColor = [UIColor sam_colorWithHex:@"#999999"];
        UIView *leftblankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        UIView *rightblankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _passwordField.leftView = leftblankView;
        _passwordField.rightView = rightblankView;
        _passwordField.leftViewMode = UITextFieldViewModeAlways;
        _passwordField.rightViewMode = UITextFieldViewModeAlways;
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.delegate = self;
        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordField.hidden = YES;
    }
    return _passwordField;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [self imageViewWithFrame:CGRectMake(self.scrollView.sy_width - 70.f, 82.f, 32.f, 32.f)
                                     imageName:@""];
    }
    return _avatarView;
}

//- (UIImageView *)avatarView169 {
//    if (!_avatarView169) {
//        _avatarView169 = [self imageViewWithFrame:CGRectMake(self.scrollView.sy_width - 70.f - 25, 82.f + 52.f, 57.f, 32.f)
//                                     imageName:@""];
//    }
//    return _avatarView169;
//}

- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        _backgroundImage = [self imageViewWithFrame:CGRectMake(self.scrollView.sy_width - 70.f, 82.f + 52.f, 32.f, 32.f)
                                        imageName:@""];
        _backgroundImage.image = [UIImage imageNamed_sy:[NSString stringWithFormat:@"voiceroom_bg_%ld",self.selectedBackImage]];
    }
    return _backgroundImage;
}

//- (UIButton *)avatarButton {
//    if (!_avatarButton) {
//        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _avatarButton.frame = CGRectMake(18.f, 130.f, 60.f, 60.f);
//        [_avatarButton setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_add"]
//                       forState:UIControlStateNormal];
//        _avatarButton.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
//        [_avatarButton addTarget:self
//                          action:@selector(addAvatar:)
//                forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _avatarButton;
//}

- (SYPlaceholderTextView *)playRuleTextView {
    if (!_playRuleTextView) {
        _playRuleTextView = [[SYPlaceholderTextView alloc] initWithFrame:CGRectMake(88.f, 352.f + 52.f, CGRectGetWidth(self.scrollView.bounds) - 108.f, 80) limitedTextLength:200];
        _playRuleTextView.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
        _playRuleTextView.layer.cornerRadius = 4.f;
        _playRuleTextView.textDelegate = self;
    }
    return _playRuleTextView;
}

- (SYPlaceholderTextView *)greetTextView {
    if (!_greetTextView) {
        _greetTextView = [[SYPlaceholderTextView alloc] initWithFrame:CGRectMake(88.f, self.playRuleTextView.sy_bottom + 20.f, CGRectGetWidth(self.scrollView.bounds) - 108.f, 60) limitedTextLength:80];
        _greetTextView.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
        _greetTextView.layer.cornerRadius = 4.f;
        _greetTextView.textDelegate = self;
    }
    return _greetTextView;
}

- (SYCreateVoiceRoomTypeView *)typeChooseView {
    if (!_typeChooseView) {
        _typeChooseView = [[SYCreateVoiceRoomTypeView alloc] initWithFrame:CGRectMake(0.f, 224.f, self.scrollView.sy_width, 64.f)];
        [_typeChooseView addObserver:self
                          forKeyPath:@"selectedIndex"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
    }
    return _typeChooseView;
}

- (UISwitch *)switchControl {
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(140.f, 480.f + 52.f + 52.f, 51, 31)];
        _switchControl.onTintColor = [UIColor sam_colorWithHex:@"#7138EF"];
        _switchControl.on = NO;
        [_switchControl addTarget:self
                           action:@selector(switchAction:)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

- (SYCreateVoiceRoomNumView *)numView {
    if (!_numView) {
        _numView = [[SYCreateVoiceRoomNumView alloc] initWithFrame:CGRectMake(88.f, 254.f + 52 + 52.f, 85, 28)];
        _numView.delegate = self;
    }
    return _numView;
}

#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat y = 0;
    if (self.nameField.isFirstResponder) {
        y = self.nameField.sy_top - ScrollTitleHeight;
    } else if (self.passwordField.isFirstResponder) {
        y = self.passwordField.sy_top - ScrollTitleHeight;
    }
    CGFloat padding = CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentSize.height;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, y + padding, 0);
    [self.scrollView setContentOffset:CGPointMake(0, y)
                             animated:YES];
    
    textField.layer.borderColor = [UIColor sam_colorWithHex:@"#7138EF"].CGColor;
    textField.layer.borderWidth = 0.5;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    textField.layer.borderWidth = 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.nameField) {
        if ((range.location + string.length) > 20) {
            return NO;
        }
    } else if (textField == self.passwordField) {
        if ((range.location + string.length) > 4) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UI constructor

- (UILabel *)labelWithText:(NSString *)text
                       top:(CGFloat)top {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18.f, top, ScrollTitleWidth, 16.f)];
    label.text = text;
    label.textColor = [UIColor sam_colorWithHex:@"#0B0B0B"];
    label.font = [UIFont systemFontOfSize:15.f];
    return label;
}

- (UILabel *)hintLabelWithText:(NSString *)text
                           top:(CGFloat)top {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.scrollView.sy_width - 38.f - ScrollTitleWidth, top, ScrollTitleWidth, 11.f)];
    label.text = text;
    label.textColor = [UIColor sam_colorWithHex:@"#999999"];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:11.f];
    return label;
}

- (UILabel *)longLabelWithText:(NSString *)text
                           top:(CGFloat)top
                         width:(CGFloat)width {
    UILabel *label = [self labelWithText:text top:top];
    label.sy_width = width;
    return label;
}

- (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed_sy:imageName];
    return imageView;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark -

- (void)placeholderTextViewDidBeginEditingWithTextView:(SYPlaceholderTextView *)textView {
    CGFloat y = 0;
    if (self.playRuleTextView.isFirstResponder) {
        y = self.playRuleTextView.sy_top - ScrollTitleHeight;
        [self.scrollView setContentOffset:CGPointMake(0, y)
                                 animated:YES];
    } else if (self.greetTextView.isFirstResponder) {
        y = self.greetTextView.sy_top - ScrollTitleHeight;
        [self.scrollView setContentOffset:CGPointMake(0, y)
                                 animated:YES];
    }
    CGFloat padding = CGRectGetHeight(self.scrollView.bounds) - self.scrollView.contentSize.height;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, y + padding, 0);
    
    textView.layer.borderColor = [UIColor sam_colorWithHex:@"#7138EF"].CGColor;
    textView.layer.borderWidth = 0.5;
    
}
- (void)placeholderTextView:(SYPlaceholderTextView *)textView
          didFinishWithText:(NSString *)text {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    textView.layer.borderWidth = 0.f;
}

#pragma mark - action

- (void)submit:(id)sender {
    if ([NSString sy_isBlankString:self.nameField.text] ||
        self.greetTextView.hasContent == NO ||
        self.playRuleTextView.hasContent == NO ||
        self.avatarImage == nil ||
//        self.avatarImage169 == nil ||
        self.backgroundImage == nil ||
        self.numView.count < 0 ) {
        [SYToastView showToast:@"请完善信息"];
        return;
    }
    
    if (self.switchControl.on && self.passwordField.text.length < 4) {
        [SYToastView showToast:@"请补全密码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    void (^hideHUD)(void) = ^{
        [MBProgressHUD hideHUDForView:self.view
                             animated:NO];
    };

    __weak typeof(self) weakSelf = self;
    [self validContent:self.nameField.text
                 block:^(BOOL success) {
                     if (success) {
                         [self validContent:self.greetTextView.text
                                      block:^(BOOL success) {
                                          if (success) {
                                              [self validContent:self.playRuleTextView.text
                                                           block:^(BOOL success) {
                                                               if (success) {
                                                                   [self validateImages];
                                                               } else {
                                                                   NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:weakSelf.playRuleTextView.text],
                                                                                              @"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],
                                                                                              @"from":@"createroom"};
//                                                                   [MobClick event:@"textPorn" attributes:pubParam];
                                                                   [SYToastView showToast:@"玩法公告含有敏感信息"];
                                                                   hideHUD();
                                                               }
                                                           }];
                                          } else {
                                              NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:weakSelf.greetTextView.text],
                                                                         @"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],
                                                                         @"from":@"createroom"};
//                                              [MobClick event:@"textPorn" attributes:pubParam];
                                              [SYToastView showToast:@"欢迎语含有敏感信息"];
                                              hideHUD();
                                          }
                                      }];
                     } else {
                         NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:weakSelf.nameField.text],
                                                    @"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],
                                                    @"from":@"createroom"};
//                         [MobClick event:@"textPorn" attributes:pubParam];
                         [SYToastView showToast:@"房间名含有敏感信息"];
                         hideHUD();
                     }
                 }];
}

- (void)validateImages {
    void (^hideHUD)(void) = ^{
        [MBProgressHUD hideHUDForView:self.view
                             animated:NO];
    };
    NSData *data = UIImageJPEGRepresentation(self.avatarImage, 0.5);
    if (!data) {
        data = UIImagePNGRepresentation(self.avatarImage);
    }
    [self validImageData:data block:^(BOOL success) {
        if (success) {
//            NSData *data = UIImageJPEGRepresentation(self.avatarImage169, 0.5);
//            if (!data) {
//                data = UIImagePNGRepresentation(self.avatarImage169);
//            }
//            [self validImageData:data block:^(BOOL success) {
                if (success) {
                    [self confirmCreateRoom];
                } else {
                    hideHUD();
                    NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"createroom"};
//                    [MobClick event:@"imagePorn" attributes:pubParam];
                    [SYToastView showToast:@"封面图包含敏感信息，请重试~"];
                }
//            }];
        } else {
            hideHUD();
            NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"createroom"};
//            [MobClick event:@"imagePorn" attributes:pubParam];
            [SYToastView showToast:@"封面图包含敏感信息，请重试~"];
        }
    }];
}

- (void)validContent:(NSString *)string
               block:(void(^)(BOOL success))block {
    [self.viewModel requestValidContent:string
                                  block:block];
}

- (void)validImageData:(NSData *)data
               block:(void(^)(BOOL success))block {
    if (!data) {
        block(NO);
        return;
    }
    [self.viewModel requestValidateImageData:data
                                       block:block];
}

- (void)confirmCreateRoom {
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    NSData *data = UIImageJPEGRepresentation(self.avatarImage, 0.5);
    if (!data) {
        data = UIImagePNGRepresentation(self.avatarImage);
    }
//    NSData *data169 = UIImageJPEGRepresentation(self.avatarImage169, 0.5);
//    if (!data169) {
//        data169 = UIImagePNGRepresentation(self.avatarImage169);
//    }
    NSInteger category = [self.viewModel categoryIDAtIndex:self.typeChooseView.selectedIndex];
    NSString *micConfig = [[self.viewModel micCountArrayAtIndex:self.typeChooseView.selectedIndex] objectAtIndex:self.numView.micConfigIndex];
    NSInteger lock = self.switchControl.on ? 1 : 0;
    [netManager requestCreateChannelWithChannelName:self.nameField.text
                                           greeting:self.greetTextView.text
                                               desc:self.playRuleTextView.text
                                               icon:@""
                                           iconFile:data
                                        icon169File:nil
                                           category:category
                                          micConfig:micConfig
                                               lock:lock
                                           password:self.passwordField.text
                                         background:self.selectedBackImage
                                            success:^(id  _Nullable response) {
                                                [MBProgressHUD hideHUDForView:self.view
                                                                     animated:YES];
                                                [SYToastView showToast:@"创建成功"];
                                                [self back:nil];
                                            } failure:^(NSError * _Nullable error) {
                                                [MBProgressHUD hideHUDForView:self.view
                                                                     animated:YES];
                                                if (error.code == 4050) {
                                                    [SYToastView showToast:@"创建房间数量已达上限"];
                                                } else {
                                                    [SYToastView showToast:@"创建失败"];
                                                }
                                            }];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addAvatar:(id)sender {
    [self resignAllFirstResponder];
    [self.photoManager updateSYSystemPhotoRatioType:SYSystemPhotoRatio_OneToOne];
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

//- (void)addAvatar169:(id)sender {
//    [self resignAllFirstResponder];
//    NSArray *actions = @[@"拍照", @"从手机相册选择"];
//    __weak typeof(self) weakSelf = self;
//    SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
//                                                                  cancelTitle:@"取消"
//                                                                  selectBlock:^(NSInteger index) {
//                                                                      switch (index) {
//                                                                          case 0:
//                                                                          {
//                                                                              [weakSelf.photoManager169 openPhotoGraph];
//                                                                          }
//                                                                              break;
//                                                                          case 1:
//                                                                          {
//                                                                              [weakSelf.photoManager169 openPhotoAlbum];
//                                                                          }
//                                                                              break;
//                                                                          default:
//                                                                              break;
//                                                                      }
//                                                                  } cancelBlock:^{
//
//                                                                  }];
//    [sheet show];
//}

- (void)addRoomBackgroundImage {
    [self resignAllFirstResponder];
    SYVoiceChatRoomBackdropVC *vc = [SYVoiceChatRoomBackdropVC new];
    vc.delegate = self;
    vc.selectBackdrop = self.selectedBackImage;
    vc.usedByCreateRoomVC = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (SYSystemPhotoManager *)photoManager {
    if (!_photoManager) {
        __weak typeof(self) weakSelf = self;
        _photoManager = [[SYSystemPhotoManager alloc] initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image) {
            if (image) {
                weakSelf.avatarImage = image;
                weakSelf.avatarView.image = image;
            }
        }];
        [_photoManager updateSYSystemPhotoRatioType:SYSystemPhotoRatio_OneToOne];
    }
    return _photoManager;
}

//- (SYSystemPhotoManager *)photoManager169 {
//    if (!_photoManager169) {
//        __weak typeof(self) weakSelf = self;
//        _photoManager169 = [[SYSystemPhotoManager alloc]initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage *image) {
//            if (image) {
//                weakSelf.avatarImage169 = image;
//                weakSelf.avatarView169.image = image;
//            }
//        }];
//        [_photoManager169 updateSYSystemPhotoRatioType:SYSystemPhotoRatio_SixteenToNine];
//    }
//    return _photoManager169;
//}

- (void)switchAction:(id)sender {
    self.passwordField.hidden = !self.switchControl.on;
    self.passwordLabel.hidden = !self.switchControl.on;
    if (!self.switchControl.on) {
        [self.passwordField resignFirstResponder];
    }
}

- (void)tap:(id)sender {
    [self resignAllFirstResponder];
}

#pragma mark -

- (void)createVoiceRoomNumViewDidSelectNumButton {
    [self resignAllFirstResponder];
    SYPickerView *pickerView = [[SYPickerView alloc] initWithFrame:self.view.bounds];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
}

- (NSInteger)pickerView:(SYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self.viewModel micCountArrayAtIndex:self.typeChooseView.selectedIndex] count];
}
- (nullable NSString *)pickerView:(SYPickerView *)pickerView titleForRow:(NSInteger)row {
    NSString *micConfig = [[self.viewModel micCountArrayAtIndex:self.typeChooseView.selectedIndex] objectAtIndex:row];
    return [micConfig substringFromIndex:(micConfig.length - 1)];
}
- (void)pickerView:(SYPickerView *)pickerView didSelectRow:(NSInteger)row {
    NSString *micConfig = [[self.viewModel micCountArrayAtIndex:self.typeChooseView.selectedIndex] objectAtIndex:row];
    micConfig = [micConfig substringFromIndex:(micConfig.length - 1)];
    self.numView.count = [micConfig integerValue];
    self.numView.micConfigIndex = row;
}

#pragma mark -

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self resignAllFirstResponder];
}

- (void)resignAllFirstResponder {
    [self.nameField resignFirstResponder];
    [self.greetTextView resignFirstResponder];
    [self.playRuleTextView resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resignAllFirstResponder];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        [self.numView reset];
        [self resignAllFirstResponder];
    }
}

#pragma mark - SYVoiceChatRoomBackdropVCDelegate

- (void)SYVoiceChatRoomBackDropVCSelectedRoomBackGroundImageNum:(NSInteger)imageNum {
    self.selectedBackImage = imageNum;
    self.backgroundImage.image = [UIImage imageNamed_sy:[NSString stringWithFormat:@"voiceroom_bg_%ld",imageNum]];
}

@end
