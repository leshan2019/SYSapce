//
//  SYCreateLivingRoomVC.m
//  Shining
//
//  Created by yangxuan on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateLivingRoomVC.h"
#import "SYCreateLivingRoomViewModel.h"
#import "SYCreateVoiceRoomTypeView.h"
#import "SYPlaceholderTextView.h"
#import "SYSystemPhotoManager.h"
#import "SYVoiceChatNetManager.h"

#define ScrollTitleWidth  65.f
#define ScrollTitleHeight 15.f

@interface SYCreateLivingRoomVC ()<UIScrollViewDelegate,
UITextFieldDelegate,
SYPlaceholderTextViewDelegate>

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIButton *backButton;     // 返回按钮
@property (nonatomic, strong) UILabel *titleLabel;      // @"创建房间"
@property (nonatomic, strong) UIButton *submitButton;   // "创建"
@property (nonatomic, strong) UIView *contentView;      // 阴影view
@property (nonatomic, strong) UIScrollView *scrollView; // 滚动列表

@property (nonatomic, strong) SYCreateLivingRoomViewModel *viewModel;
@property (nonatomic, strong) SYSystemPhotoManager *photoManager;

// ContentView
@property (nonatomic, strong) UITextField *nameField;   // 房间名称
@property (nonatomic, strong) UIImageView *roomCover;   // 房间封面
@property (nonatomic, strong) SYCreateVoiceRoomTypeView *typeChooseView;
@property (nonatomic, strong) SYPlaceholderTextView *greetTextView;
@property (nonatomic, strong) UIImage *roomCoverImage;  // 房间封面

@end

@implementation SYCreateLivingRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    [self.viewModel requestCategoryListWithBlock:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.contentView animated:YES];
        if (success) {
            [self initContentViews];
        } else {
            [SYToastView showToast:@"网络异常，请退出重试！"];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarLight];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)dealloc {
    [self.typeChooseView removeObserver:self forKeyPath:@"selectedIndex"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resignAllFirstResponder];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        [self resignAllFirstResponder];
    }
}

#pragma mark - Private

- (void)initSubViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.scrollView];
    [self.view addSubview:self.submitButton];
    [self mas_makeConstraintsSubViews];
}

- (void)mas_makeConstraintsSubViews {
    CGFloat ratio = 750.f/564.f;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = width / ratio;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 44));
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 20 + 24 :20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 32));
        make.left.equalTo(self.view).with.offset(22);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 62 + 24 :62);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.view).with.offset(-40);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -(20+34) : -(20));
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.submitButton.mas_top).with.offset(-20);
    }];
}

- (void)initContentViews {
    
    CGFloat top = 39;
    UILabel *titleLabel = nil;
    UIImageView *assistView = nil;
    // 房间名称
    titleLabel = [self labelWithText:@"房间名称" frameTop:top];
    [self.scrollView addSubview:titleLabel];
    [self.scrollView addSubview:self.nameField];
    // 房间封面
    top = titleLabel.sy_bottom + 36;
    titleLabel = [self labelWithText:@"房间封面" frameTop:top];
    [self.scrollView addSubview:titleLabel];
    assistView = [self imageViewWithName:@"voiceroom_right_icon" frame:CGRectMake(self.scrollView.sy_width - 16 - 20, 0, 16, 16)];
    assistView.sy_centerY = titleLabel.sy_centerY;
    [self.scrollView addSubview:assistView];
    titleLabel = [self hintLabelWithText:@"1:1" top:top];
    [self.scrollView addSubview:titleLabel];
    self.roomCover.frame = CGRectMake(assistView.sy_left - 2 - 32, 0, 32, 32);
    self.roomCover.sy_centerY = assistView.sy_centerY;
    [self.scrollView addSubview:self.roomCover];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.nameField.sy_left, 0, self.nameField.sy_width, self.nameField.sy_height);
    button.sy_centerY = assistView.sy_centerY;
    [button addTarget:self action:@selector(tapSelectRoomCover) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    // 房间类型
    top = titleLabel.sy_bottom + 36;
    titleLabel = [self labelWithText:@"房间类型" frameTop:top];
    [self.scrollView addSubview:titleLabel];
    [self.scrollView addSubview:self.typeChooseView];
    NSInteger count = [self.viewModel categoryCount];
    NSMutableArray *names = [NSMutableArray new];
    for (int i = 0; i < count; i ++) {
        [names addObject:[self.viewModel categoryStringAtIndex:i]];
    }
    [self.typeChooseView showWithCategoryNames:names];
    self.typeChooseView.sy_top = titleLabel.sy_bottom + 12;
    // 欢迎语
    top = self.typeChooseView.sy_bottom + 26;
    titleLabel = [self labelWithText:@"欢迎语" frameTop:top];
    [self.scrollView addSubview:titleLabel];
    [self.scrollView addSubview:self.greetTextView];
    self.greetTextView.frame = CGRectMake(titleLabel.sy_right + 10, top, self.scrollView.sy_width - (titleLabel.sy_right + 10) - 20, 60);

    // contentSize
    self.scrollView.contentSize = CGSizeMake(0, top + self.greetTextView.sy_height + 20);
}

// 创建title
- (UILabel *)labelWithText:(NSString *)text frameTop:(CGFloat)top {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, top, ScrollTitleWidth, ScrollTitleHeight)];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor sam_colorWithHex:@"#0B0B0B"];
    label.font = [UIFont systemFontOfSize:15.f];
    return label;
}

// 创建image
- (UIImageView*)imageViewWithName:(NSString *)imageName frame:(CGRect)frame {
    UIImageView *imageView = [UIImageView new];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed_sy:imageName];
    return imageView;
}

// 提示label
- (UILabel *)hintLabelWithText:(NSString *)text
                           top:(CGFloat)top {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.scrollView.sy_width - 38.f - 76, top, 76, ScrollTitleHeight)];
    label.text = text;
    label.textColor = [UIColor sam_colorWithHex:@"#999999"];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:11.f];
    return label;
}

- (void)resignAllFirstResponder {
    [self.nameField resignFirstResponder];
    [self.greetTextView resignFirstResponder];
}

// 文字鉴黄
- (void)validContent:(NSString *)string
               block:(void(^)(BOOL success))block {
    [self.viewModel requestValidContent:string
                                  block:block];
}

// 图片鉴黄
- (void)validImageData:(NSData *)data
                 block:(void(^)(BOOL success))block {
    if (!data) {
        block(NO);
        return;
    }
    [self.viewModel requestValidateImageData:data
                                       block:block];
}

#pragma mark - ClickEvent

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tap:(id)sender {
    [self resignAllFirstResponder];
}

- (void)tapSelectRoomCover {
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

- (void)submit:(id)sender {
    if ([NSString sy_isBlankString:self.nameField.text]) {
        [SYToastView showToast:@"请输入房间名称"];
        return;
    }
    if (!self.roomCoverImage) {
        [SYToastView showToast:@"请选择房间封面"];
        return;
    }
    if (!self.greetTextView.hasContent) {
        [SYToastView showToast:@"请输入欢迎语"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:NO];
    
    void (^hideHUD)(void) = ^{
        [MBProgressHUD hideHUDForView:self.contentView
                             animated:NO];
    };
    
    [self validContent:self.nameField.text
                 block:^(BOOL success) {
                     if (success) {
                         [self validContent:self.greetTextView.text
                                      block:^(BOOL success) {
                                          if (success) {
                                              [self validateImages];
                                          } else {
                                              NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:self.greetTextView.text],
                                                                         @"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],
                                                                         @"from":@"createroom"};
//                                              [MobClick event:@"textPorn" attributes:pubParam];
                                              [SYToastView showToast:@"欢迎语含有敏感信息"];
                                              hideHUD();
                                          }
                                      }];
                     } else {
                         NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:self.nameField.text],
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
        [MBProgressHUD hideHUDForView:self.contentView
                             animated:NO];
    };
    NSData *data = UIImageJPEGRepresentation(self.roomCoverImage, 0.5);
    if (!data) {
        data = UIImagePNGRepresentation(self.roomCoverImage);
    }
    [self validImageData:data block:^(BOOL success) {
        if (success) {
            if (success) {
                [self confirmCreateRoom];
            } else {
                hideHUD();
                NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"createroom"};
//                [MobClick event:@"imagePorn" attributes:pubParam];
                [SYToastView showToast:@"封面图包含敏感信息，请重试~"];
            }
        } else {
            hideHUD();
            NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"createroom"};
//            [MobClick event:@"imagePorn" attributes:pubParam];
            [SYToastView showToast:@"封面图包含敏感信息，请重试~"];
        }
    }];
}

- (void)confirmCreateRoom {
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    NSData *data = UIImageJPEGRepresentation(self.roomCoverImage, 0.5);
    if (!data) {
        data = UIImagePNGRepresentation(self.roomCoverImage);
    }
    NSInteger category = [self.viewModel categoryIDAtIndex:self.typeChooseView.selectedIndex];
    NSString *micConfig = [[self.viewModel micCountArrayAtIndex:self.typeChooseView.selectedIndex] objectAtIndex:0];
    [netManager requestCreateChannelWithChannelName:self.nameField.text
                                           greeting:self.greetTextView.text
                                               desc:@""
                                               icon:@""
                                           iconFile:data
                                        icon169File:nil
                                           category:category
                                          micConfig:micConfig
                                               lock:0
                                           password:nil
                                         background:0
                                            success:^(id  _Nullable response) {
                                                [MBProgressHUD hideHUDForView:self.contentView             animated:YES];
                                                [SYToastView showToast:@"创建成功"];
                                                [self back:nil];
                                            } failure:^(NSError * _Nullable error) {
                                                [MBProgressHUD hideHUDForView:self.contentView
                                                                animated:YES];
                                                if (error.code == 4050) {
                                                    [SYToastView showToast:@"创建房间数量已达上限"];
                                                } else {
                                                    [SYToastView showToast:@"创建失败"];
                                                }
                                            }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self resignAllFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
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
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SYPlaceholderTextViewDelegate

- (void)placeholderTextViewDidBeginEditingWithTextView:(SYPlaceholderTextView *)textView {
    CGFloat y = 0;
    if (self.greetTextView.isFirstResponder) {
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

#pragma mark - Lazyload

- (SYCreateLivingRoomViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYCreateLivingRoomViewModel new];
    }
    return _viewModel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
        _headView = [UIImageView new];
        _headView.image = [UIImage imageNamed_sy:@"voiceroom_create_head"];
    }
    return _headView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"创建直播间";
    }
    return _titleLabel;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
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

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(0, 10);
        _contentView.layer.shadowRadius = 24.f;
        _contentView.layer.shadowOpacity = 0.1;
        _contentView.layer.cornerRadius = 10.f;
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat top = iPhoneX ? 104 + 24 : 104;
        CGFloat height = self.view.sy_height - top - (iPhoneX ? 84 + 34 : 84);
        CGRect frame = CGRectMake(0, 0, self.view.sy_width - 20 * 2, height);
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate = self;
        _scrollView.layer.cornerRadius = 10.f;
        _scrollView.showsVerticalScrollIndicator = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UITextField *)nameField {
    if (!_nameField) {
        CGFloat x = 20 + ScrollTitleWidth + 10;
        CGFloat w = self.scrollView.sy_width - x - 20;
        CGFloat h = 40;
        CGFloat y = (52 - h)/2.f + 20;
        CGRect frame = CGRectMake(x, y, w, h);
        _nameField = [[UITextField alloc] initWithFrame:frame];
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

- (UIImageView *)roomCover {
    if (!_roomCover) {
        _roomCover = [UIImageView new];
    }
    return _roomCover;
}

- (SYPlaceholderTextView *)greetTextView {
    if (!_greetTextView) {
        _greetTextView = [[SYPlaceholderTextView alloc] initWithFrame:CGRectZero limitedTextLength:80];
        _greetTextView.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
        _greetTextView.layer.cornerRadius = 4.f;
        _greetTextView.textDelegate = self;
    }
    return _greetTextView;
}

- (SYCreateVoiceRoomTypeView *)typeChooseView {
    if (!_typeChooseView) {
        _typeChooseView = [[SYCreateVoiceRoomTypeView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.sy_width, 0)];
        [_typeChooseView addObserver:self
                          forKeyPath:@"selectedIndex"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
    }
    return _typeChooseView;
}

- (SYSystemPhotoManager *)photoManager {
    if (!_photoManager) {
        __weak typeof(self) weakSelf = self;
        _photoManager = [[SYSystemPhotoManager alloc] initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image) {
            if (image) {
                weakSelf.roomCoverImage = image;
                weakSelf.roomCover.image = image;
            }
        }];
        [_photoManager updateSYSystemPhotoRatioType:SYSystemPhotoRatio_OneToOne];
    }
    return _photoManager;
}

@end
