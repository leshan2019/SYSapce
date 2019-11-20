//
//  SYPersonHomepageEditVC.m
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageEditVC.h"
#import "SYPersonHomepageEditViewModel.h"
#import "SYPersonHomepageIntroView.h"
#import "SYPersonHomepageEditPhotoView.h"
#import "SYPersonHomepageInfoVC.h"
#import "SYPersonHomepageVoiceView.h"
#import "SYSystemPhotoManager.h"
#import "SYUserServiceAPI.h"
#import "SYPersonHomepageLookPhotoView.h"
#import "SYAPPServiceAPI.h"
#import "SYPersonHomepageVoiceCardView.h"
#import "SYPersonHomepageVoiceCardVC.h"
#define SYHomepageAvatarPhotoHeight 300/375.0f*__MainScreen_Width

@interface SYPersonHomepageEditVC ()
<SYPersonHomepageEditPhotoViewDelegate,
SYPersonHomepageVoiceViewDelegate,
SYPopUpWindowsDelegate,
SYPersonHomepageLookPhotoViewDelegate,
SYPersonHomepageEditViewModelDelegate>

@property (nonatomic, strong) SYPersonHomepageEditViewModel *viewModel;            // ViewModel

@property (nonatomic, strong) UIScrollView *scrollView;                     // 滚动view
@property (nonatomic, strong) UIView *scrollContainerView;                  // Scroll上的view
@property (nonatomic, strong) UIButton *backBtn;                            // 返回btn
@property (nonatomic, strong) UIImageView *avatarImage;                     // 照片墙
@property (nonatomic, strong) SYPersonHomepageIntroView *introView;         // 简介
@property (nonatomic, strong) UIButton *editInfoBtn;                        // 编辑资料
@property (nonatomic, strong) SYPersonHomepageEditPhotoView *editPhotoView; // 形象照编辑view
@property (nonatomic, strong) SYPersonHomepageVoiceCardView *voiceCardView; // 声音卡片

@property (nonatomic, strong) SYPopUpWindows *popupWindow;                  // 删除本地录音弹窗
@property (nonatomic, copy) NSString *localVoiceUrl;                        // 本地录制的声音

@property (nonatomic, strong) SYSystemPhotoManager *photoManager;
@property (nonatomic, assign) NSInteger editPhotoNum;
@property (nonatomic, strong) SYPersonHomepageLookPhotoView *lookPhotoView; // 查看形象照view
@property (nonatomic, assign) SYHomepagePhotoType lookPhotoType;            // 查看的形象照类型
@property (nonatomic, copy) NSString *lookPhotoUrl;                         // 查看的形象照url

@end

@implementation SYPersonHomepageEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sy_configDataInfoPageName:SYPageNameType_HomePageEdit];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarLight];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    __weak typeof(self) weakSelf = self;
    [self.viewModel requestHomepageData:^(BOOL success) {
        if (success) {
            [weakSelf updateDataAfterSuccess];
        }
    }];
    [self.viewModel requestHomepageUserAttentionAndFansCount:^(BOOL success) {
        if (success) {
            [weakSelf updateAttentionAndFansCount];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat sizeY = 0;
    sizeY = CGRectGetMaxY(self.voiceCardView.frame);
    self.scrollView.contentSize = CGSizeMake(0, sizeY);
    [self.scrollContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sizeY);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - PrivateMethod

- (void)initSubviews {
    self.view.backgroundColor = RGBACOLOR(242, 244, 245, 1);

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContainerView];

    [self.scrollContainerView addSubview:self.avatarImage];
    [self.scrollContainerView addSubview:self.introView];
    [self.scrollContainerView addSubview:self.editInfoBtn];
    [self.scrollContainerView addSubview:self.editPhotoView];
    [self.scrollContainerView addSubview:self.voiceCardView];

    // layout

    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(__MainScreen_Width);
        make.height.mas_equalTo(1000);
    }];

    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.scrollContainerView);
        make.right.equalTo(self.scrollContainerView);
        make.height.mas_equalTo(SYHomepageAvatarPhotoHeight);
    }];

    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.avatarImage.mas_bottom);
        make.right.equalTo(self.scrollContainerView);
        make.height.mas_equalTo(98+22);
    }];

    [self.editInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(104, 30));
        make.top.equalTo(self.avatarImage.mas_bottom).with.offset(10);
        make.right.equalTo(self.scrollContainerView).with.offset(-20);
    }];

    [self.editPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.introView.mas_bottom);
        make.right.equalTo(self.scrollContainerView);
        make.height.mas_equalTo(124);
    }];

    [self.voiceCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.editPhotoView.mas_bottom);
        make.right.equalTo(self.scrollContainerView);
        make.height.mas_equalTo(46);
    }];

    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(6);
        make.top.equalTo(self.view).with.offset(iPhoneX ? (24+20) : 20);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];
}

// 获取数据成功后调用
- (void)updateDataAfterSuccess {

    UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];

    // 头像
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:userModel.avatar_imgurl] placeholderImage:[UIImage imageNamed_sy:@"homepage_photo_wall_default"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];

    // 简介
    NSString *userName = userModel.username;
    NSString *gender = userModel.gender;
    NSInteger age = [SYUtil ageWithBirthdayString:userModel.birthday];
    NSInteger vipLevel = userModel.level;
    NSInteger broadCasterLevel = userModel.streamer_level;
    NSInteger isBroadcaster = userModel.is_streamer;
    NSInteger isSuperAdmin = userModel.is_super_admin;
    NSString *signature = [NSString sy_safeString:userModel.signature];

    if (signature.length > 0) {
        [self.introView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(98+22);
        }];
    } else {
        [self.introView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(98);
        }];
    }
    [self.introView updateHomepageIntroViewWithName:userName gender:gender age:age viplevel:vipLevel broadCasterLevel:broadCasterLevel isBroadcaster:isBroadcaster signatureStr:signature isSuperAdmin:isSuperAdmin];

    // 形象照
    NSString *photo1 = userModel.photo_imgurl1;
    NSString *photo2 = userModel.photo_imgurl2;
    NSString *photo3 = userModel.photo_imgurl3;
    [self.editPhotoView updateHomepageEditPhotoViewWithPhotoOne:photo1 photoTwo:photo2 photoThree:photo3];

    // 声音
    NSString *voiceUrl = [self.viewModel getVoiceUrl];
    NSInteger voiceDuration = [self.viewModel getVoiceDuration];
    [self.voiceCardView updateVoiceControl:voiceUrl voiceDuration:voiceDuration];
}

- (void)updateAttentionAndFansCount {
    NSInteger attentionCount = [self.viewModel getUserAttentionCount];
    NSInteger fansCount = [self.viewModel getUserFansCount];
    [self.introView updateHomepageIntrolViewWithAttentionCount:attentionCount fansCount:fansCount];
}

// 上传形象照
- (void)uploadPhoto:(UIImage *)image {
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestUploadPhoto:image success:^(BOOL success) {
        if (success) {
            [SYToastView showToast:@"上传形象照成功"];
            [weakSelf updateUserPhotosAfterUploadPhoto];
        } else {
            [SYToastView showToast:@"上传形象照失败"];
        }
    }];
}

// 上传形象照成功后刷新形象照view
- (void)updateUserPhotosAfterUploadPhoto {
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestHomepageData:^(BOOL success) {
        if (success) {
            UserProfileEntity *userModel = [weakSelf.viewModel getHomepageUserModel];
            // 更新形象墙照
            NSString *photo1 = userModel.photo_imgurl1;
            NSString *photo2 = userModel.photo_imgurl2;
            NSString *photo3 = userModel.photo_imgurl3;
            [weakSelf.editPhotoView updateHomepageEditPhotoViewWithPhotoOne:photo1 photoTwo:photo2 photoThree:photo3];
        }
    }];
}

// 上传本地录音文件后刷新录音view
- (void)updateUserVoiceViewAfterUploadVoice {
//    __weak typeof(self) weakSelf = self;
//    [self.viewModel requestHomepageData:^(BOOL success) {
//        if (success) {
//            NSString *voiceUrl = [weakSelf.viewModel getVoiceUrl];
//            NSInteger voiceDuration = [weakSelf.viewModel getVoiceDuration];
//            [weakSelf.editVoiceView updateVoiceViewWithVoiceUrl:voiceUrl voiceDuration:voiceDuration];
//        } else {
//            [weakSelf.editVoiceView updateVoiceViewWithVoiceUrl:@"" voiceDuration:0];
//        }
//    }];
}

- (void)stopPlayRecord {
//    [self.editVoiceView stopPlay];
}

#pragma mark - SYPersonHomepageEditPhotoViewDelegate

// 弹出相册选择器
- (void)handleHomepageEditPhotoViewUploadBtnCLickEvent {
    [self stopPlayRecord];
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

// 查看形象照
- (void)handleHomepageEditPhotoViewPhotoClick:(NSString *)photoUrl withType:(SYHomepagePhotoType)type{
    [self stopPlayRecord];
    self.lookPhotoUrl = photoUrl;
    self.lookPhotoType = type;
    if (self.lookPhotoView) {
        [self.lookPhotoView removeFromSuperview];
        self.lookPhotoView = nil;
    }
    self.lookPhotoView = [[SYPersonHomepageLookPhotoView alloc] initWithFrame:self.view.bounds withPhotoUrl:photoUrl canDelete:YES];
    self.lookPhotoView.delegate = self;
    [self.view addSubview:self.lookPhotoView];
}

#pragma mark - SYPersonHomepageLookPhotoViewDelegate

// 删除形象照
- (void)SYPersonHomepageLookPhotoViewDeletePhoto:(NSString *)photoUrl {
    if ([self.lookPhotoUrl isEqualToString:photoUrl] && self.lookPhotoType != SYHomepagePhotoType_Unknown) {
        __weak typeof(self) weakSelf = self;
        [self.viewModel requestDeletePhoto:self.lookPhotoType success:^(BOOL success) {
            if (success) {
                [SYToastView showToast:@"删除形象照成功"];
                [weakSelf updateUserPhotosAfterUploadPhoto];
            } else {
                [SYToastView showToast:@"删除形象照失败"];
            }
        }];
    }
}

#pragma mark - SYPersonHomepageVoiceViewDelegate

// 删除server端语音文件
- (void)SYPersonHomepageVoiceViewDeleteServerVoice {
//    __weak typeof(self) weakSelf = self;
//    [self.viewModel requestDeleteVoice:^(BOOL success) {
//        if (success) {
//            [SYToastView showToast:@"删除录音成功"];
//            [weakSelf.editVoiceView updateVoiceViewWithVoiceUrl:@"" voiceDuration:0];
//        } else {
//            [SYToastView showToast:@"删除录音失败，请重试！"];
//        }
//    }];
}

// 删除本地录音文件
- (void)SYPersonHomepageVoiceViewDeleteLocalVoice:(NSString *)localVoiceUrl {
    [self stopPlayRecord];
    self.localVoiceUrl = localVoiceUrl;
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
    [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:@"是否放弃当前录音" withSubTitle:@"" withBtnTexts:@[@"取消",@"放弃"] withBtnTextColors:@[RGBACOLOR(123,64,255,1),RGBACOLOR(123,64,255,1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

// 上传本地录音文件
- (void)SYPersonHomepageVoiceViewSaveLocalVoice:(NSString *)localVoiceUrl voiceDuration:(NSInteger)duration{
//    [self stopPlayRecord];
//    __weak typeof(self) weakSelf = self;
//    [self.viewModel requestUploadVoice:localVoiceUrl duration:duration success:^(BOOL success) {
//        if (success) {
//            [SYToastView showToast:@"保存录音成功!"];
//            [weakSelf.editVoiceView setVoiceViewToRecordState];
//            [weakSelf updateUserVoiceViewAfterUploadVoice];
//        } else {
//            [SYToastView showToast:@"保存录音失败，请重试!"];
//        }
//    }];
}

// 打开录音权限
- (void)SYPersonHomepageVoiceViewLeadUserToOpenRecordPermission {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您没有麦克风权限"
                                                                   message:@"请开启麦克风权限"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {

                                                   }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开启"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                            [[UIApplication sharedApplication] openURL:url];
                                                        }
                                                    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - SYPersonHomepageEditViewModelDelegate

- (void)SYPersonHomepageEditViewModelStopPlayRecord {
//    [self.editVoiceView stopPlay];
}

#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsLeftBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
}

- (void)handlePopUpWindowsRightBtnClickEvent {
//    if (self.popupWindow && self.popupWindow.superview) {
//        [self.popupWindow removeFromSuperview];
//        self.popupWindow = nil;
//    }
//    [self.editVoiceView setVoiceViewToRecordState];
//    if (![NSString sy_isBlankString:self.localVoiceUrl]) {
//        NSFileManager *fm = [NSFileManager defaultManager];
//        NSError *error;
//        [fm removeItemAtPath:self.localVoiceUrl error:&error];
//        if (error == nil) {
//            NSLog(@"录音文件删除成功，path：%@",self.localVoiceUrl);
//        }
//    }
}

#pragma mark - BtnClickEvent

// 点击返回按钮
- (void)handleGoBackBtnClickEvent {
    [self stopPlayRecord];
    [self.navigationController popViewControllerAnimated:YES];
}

// 编辑个人资料点击
- (void)handleEditInfoBtnClickEvent {
    [self stopPlayRecord];
    SYPersonHomepageInfoVC *vc = [SYPersonHomepageInfoVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LazyLoad

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.contentSize = CGSizeMake(__MainScreen_Width, 0);
        _scrollView.backgroundColor = RGBACOLOR(242, 244, 245, 1);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)scrollContainerView {
    if (!_scrollContainerView) {
        _scrollContainerView = [UIView new];
        _scrollContainerView.backgroundColor = RGBACOLOR(242, 244, 245, 1);
    }
    return _scrollContainerView;
}

- (SYPersonHomepageEditViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYPersonHomepageEditViewModel new];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIImageView new];
        _avatarImage.clipsToBounds = YES;
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImage.image = [UIImage imageNamed_sy:@"homepage_photo_wall_default"];
    }
    return _avatarImage;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn addTarget:self action:@selector(handleGoBackBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"voiceroom_back"] forState:UIControlStateHighlighted];
    }
    return _backBtn;
}

- (SYPersonHomepageIntroView *)introView {
    if (!_introView) {
        _introView = [[SYPersonHomepageIntroView alloc] initWithFrame:CGRectZero];
        _introView.backgroundColor = RGBACOLOR(242, 244, 245, 1);
        _introView.userInteractionEnabled = YES;
    }
    return _introView;
}

- (UIButton *)editInfoBtn {
    if (!_editInfoBtn) {
        _editInfoBtn = [UIButton new];
        _editInfoBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [_editInfoBtn setTitle:@"编辑个人资料" forState:UIControlStateNormal];
        [_editInfoBtn setTitleColor:RGBACOLOR(123,64,255,1) forState:UIControlStateNormal];
        _editInfoBtn.backgroundColor = [UIColor whiteColor];
        _editInfoBtn.clipsToBounds = YES;
        _editInfoBtn.layer.cornerRadius = 15;
        [_editInfoBtn addTarget:self action:@selector(handleEditInfoBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editInfoBtn;
}

- (SYPersonHomepageEditPhotoView *)editPhotoView {
    if (!_editPhotoView) {
        _editPhotoView = [[SYPersonHomepageEditPhotoView alloc] initWithFrame:CGRectZero];
        _editPhotoView.delegate = self;
    }
    return _editPhotoView;
}

- (SYPersonHomepageVoiceCardView *)voiceCardView {
    if (!_voiceCardView) {
        _voiceCardView = [[SYPersonHomepageVoiceCardView alloc] initVoiceCardViewWithFrame:CGRectZero recordVoice:^{
            // 首次录制
            SYPersonHomepageVoiceCardVC*vc = [[SYPersonHomepageVoiceCardVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        } tapArrowBlock:^{
            // 再次录制
            SYPersonHomepageVoiceCardVC*vc = [[SYPersonHomepageVoiceCardVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [_voiceCardView updateTitle:@"声音"];
        [_voiceCardView showBottomLine:NO];
    }
    return _voiceCardView;
}

- (SYSystemPhotoManager *)photoManager {
    if (!_photoManager) {
        __weak typeof(self)weakSelf = self;
        _photoManager = [[SYSystemPhotoManager alloc] initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image) {
            if (image) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5f);
                [[SYAPPServiceAPI sharedInstance] requestValidateImage:imageData success:^(id  _Nullable response) {
                    [weakSelf uploadPhoto:image];
                } failure:^(NSError * _Nullable error) {
                    NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"person"};
//                    [MobClick event:@"imagePorn" attributes:pubParam];
                    [SYToastView showToast:@"形象照包含敏感信息，请重新上传~"];
                }];
            }
        }];
     }
    return _photoManager;
}


@end
