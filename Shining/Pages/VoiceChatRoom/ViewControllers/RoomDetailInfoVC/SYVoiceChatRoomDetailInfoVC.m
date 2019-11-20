//
//  SYVoiceChatRoomInfoVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/12.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomDetailInfoVC.h"
#import "SYVoiceChatRoomDetailInfoViewModel.h"
#import "SYVoiceChatRoomDetailInfoCell.h"
#import "SYCommonTopNavigationBar.h"
#import "SYVoiceChatRoomRenameVC.h"
#import "SYVoiceChatRoomPlayMethodVC.h"
#import "SYVoiceChatRoomWelcomeVC.h"
#import "SYSystemPhotoManager.h"
#import "SYVoiceChatRoomManagerVC.h"
#import "SYVoiceChatRoomForbidChatVC.h"
#import "SYVoiceChatRoomForbidEnterVC.h"
#import "SYVoiceChatNetManager.h"
#import "SYVoiceChatRoomBackdropVC.h"
#import "SYVoiceChatRoomPasswordVC.h"
#import "SYAPPServiceAPI.h"

#define SYVoiceChatRoomDetailInfoCellID @"SYVoiceChatRoomDetailInfoCellID"

@interface SYVoiceChatRoomDetailInfoVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SYCommonTopNavigationBarDelegate, SYVoiceChatRoomDetailInfoViewModelDelegate, SYVoiceChatRoomBackdropVCDelegate, SYVoiceChatRoomDetailInfoCellDelegate,SYPasswordInputViewDelegate>

@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;

@property (nonatomic, strong) SYVoiceChatRoomDetailInfoViewModel *viewModel;

@property (nonatomic, strong) SYSystemPhotoManager *photoManager_1_1;
@property (nonatomic, strong) SYSystemPhotoManager *photoManager_16_9;

@property (nonatomic, strong) SYVoiceChatNetManager *netManager;

@end

@implementation SYVoiceChatRoomDetailInfoVC

- (void)dealloc {
    NSLog(@"SYVoiceChatRoomDetailInfoVC - Dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.listView];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -34 : 0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    [self.viewModel requestChannelInfoWithChannelID:self.channelId];
}

#pragma mark - PrivateMethod

- (void)selectSyVoiceRoomCoverOneToOne {
    NSArray *actions = @[@"拍照", @"从手机相册选择"];
    __weak typeof(self) weakSelf = self;
    SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
                                                                  cancelTitle:@"取消"
                                                                  selectBlock:^(NSInteger index) {
                                                                      switch (index) {
                                                                          case 0:
                                                                          {
                                                                              [weakSelf.photoManager_1_1 openPhotoGraph];
                                                                          }
                                                                              break;
                                                                          case 1:
                                                                          {
                                                                              [weakSelf.photoManager_1_1 openPhotoAlbum];
                                                                          }
                                                                              break;
                                                                          default:
                                                                              break;
                                                                      }
                                                                  } cancelBlock:^{

                                                                  }];
    [sheet show];
}

- (void)selectSyVoiceRoomCoverSexteenToNine {
    NSArray *actions = @[@"拍照", @"从手机相册选择"];
    __weak typeof(self) weakSelf = self;
    SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
                                                                  cancelTitle:@"取消"
                                                                  selectBlock:^(NSInteger index) {
                                                                      switch (index) {
                                                                          case 0:
                                                                          {
                                                                              [weakSelf.photoManager_16_9 openPhotoGraph];
                                                                          }
                                                                              break;
                                                                          case 1:
                                                                          {
                                                                              [weakSelf.photoManager_16_9 openPhotoAlbum];
                                                                          }
                                                                              break;
                                                                          default:
                                                                              break;
                                                                      }
                                                                  } cancelBlock:^{

                                                                  }];
    [sheet show];
}

// 上传1:1封面图
- (void)uploadSYVoiceRoomOneToOneCover:(UIImage *)coverImage {
    NSData *imageData =UIImageJPEGRepresentation(coverImage, 1.0f);
    [self.netManager requestUpdateChannelInfoWithChannelID:self.channelId name:@"" greeting:@"" desc:@"" icon:@"" iconFile:imageData iconFile_16_9:[NSData data] backgroundImage:nil success:^(id  _Nullable response) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
        if (self.isLiving) {
            indexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        }
        SYVoiceChatRoomDetailInfoCell *cell = (SYVoiceChatRoomDetailInfoCell*)[self.listView cellForItemAtIndexPath: indexPath];
        [cell updateImage:coverImage];
    } failure:^(NSError * _Nullable error) {
    }];
}

// 上传16:9封面图
- (void)uploadSyVoiceRoomSixteenToNineCover:(UIImage *)coverImage {
    NSData *imageData =UIImageJPEGRepresentation(coverImage, 1.0f);
    [self.netManager requestUpdateChannelInfoWithChannelID:self.channelId name:@"" greeting:@"" desc:@"" icon:@"" iconFile:[NSData data] iconFile_16_9:imageData backgroundImage:nil success:^(id  _Nullable response) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        SYVoiceChatRoomDetailInfoCell *cell = (SYVoiceChatRoomDetailInfoCell*)[self.listView cellForItemAtIndexPath: indexPath];
        [cell updateImage:coverImage];
    } failure:^(NSError * _Nullable error) {
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceChatRoomDetailInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYVoiceChatRoomDetailInfoCellID forIndexPath:indexPath];
    NSString *title = [self.viewModel mainTitleWithIndexPath:indexPath];
    NSString *subTitle = [self.viewModel subTitleWithIndexPath:indexPath];
    NSString *imageUrl = [self.viewModel subImageUrlStrWithIndexPath:indexPath];
    BOOL show = [self.viewModel showBottomLine:indexPath];
    BOOL hasSwitchBtn = [self.viewModel showUISwitchBtn:indexPath];
    SYVoiceChatRoomDetailInfoType type = [self.viewModel cellTypeWithIndexPath:indexPath];
//    BOOL subImage16_9 = type == SYVoiceChatRoomCover_16_9;
    BOOL subImage16_9 = NO;
    [cell updateCellTitle:title SubTitle:subTitle SubImage:imageUrl showBottomLine: show withSwitchBtn:hasSwitchBtn subImage_16_9:subImage16_9];
    if (type == SYVoiceChatRoomEncryption) {
        cell.delegate = self;
        BOOL openSwitBtn = [self.viewModel judgeUISwitchBtnOpenState:indexPath];
        [cell openUISwitBtn:openSwitBtn];
    } else {
        cell.delegate = nil;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceChatRoomDetailInfoType type = [self.viewModel cellTypeWithIndexPath:indexPath];
    switch (type) {
        case SYVoiceChatRoomName: {
            // 房间名称
            SYVoiceChatRoomRenameVC *vc = [[SYVoiceChatRoomRenameVC alloc]init];
            vc.originRoomName = [self.viewModel subTitleWithIndexPath:indexPath];
            vc.channelId = self.channelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYVoiceChatRoomPlay: {
            // 玩法公告
            SYVoiceChatRoomPlayMethodVC *vc = [[SYVoiceChatRoomPlayMethodVC alloc]init];
            vc.playMethod = [self.viewModel subTitleWithIndexPath:indexPath];
            vc.channelId = self.channelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYVoiceChatRoomWelcome: {
            // 欢迎语
            SYVoiceChatRoomWelcomeVC *vc = [[SYVoiceChatRoomWelcomeVC alloc]init];
            vc.welCome = [self.viewModel subTitleWithIndexPath:indexPath];
            vc.channelId = self.channelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYVoiceChatRoomCover_1_1: {
            // 房间封面1:1
            [self selectSyVoiceRoomCoverOneToOne];
        }
            break;
//        case SYVoiceChatRoomCover_16_9: {
//            // 房间封面16:9
//            [self selectSyVoiceRoomCoverSexteenToNine];
//        }
//            break;
        case SYVoiceChatRoomBackdrop: {
            // 房间背景
            SYVoiceChatRoomBackdropVC *vc = [SYVoiceChatRoomBackdropVC new];
            vc.delegate = self;
            vc.selectBackdrop = [self.viewModel roomBackDropNum];
            vc.channelId = self.channelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYVoiceChatRoomManagerList: {
            // 管理员列表
            SYVoiceChatRoomManagerVC *vc = [SYVoiceChatRoomManagerVC new];
            vc.channelId = self.channelId;
            vc.delegate = self.delegate;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYVoiceChatRoomForbideChat: {
            // 禁言名单
            SYVoiceChatRoomForbidChatVC *vc = [SYVoiceChatRoomForbidChatVC new];
            vc.channelId = self.channelId;
            vc.delegate = self.delegate;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYVoiceChatRoomForbideEnter: {
            // 禁入名单
            SYVoiceChatRoomForbidEnterVC *vc = [SYVoiceChatRoomForbidEnterVC new];
            vc.channelId = self.channelId;
            vc.delegate = self.delegate;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYVoiceChatRoomPassword: {
            // 房间密码
            SYVoiceChatRoomPasswordVC *vc = [SYVoiceChatRoomPasswordVC new];
            vc.originPassword = [self.viewModel subTitleWithIndexPath:indexPath];
            vc.channelId = self.channelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(section == 0 ? 0 : 10, 0, 0, 0);
}

#pragma mark - SYCommonTopNavigationBarDelegate

- (void)handleGoBackBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomInfoDidChange)]) {
        [self.delegate voiceRoomInfoDidChange];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SYVoiceChatRoomDetailInfoViewModelDelegate

- (void)getChannelInfoSuccess {
    [self.listView reloadData];
}

- (void)getChannelInfoFailed {
    [SYToastView showToast:@"获取房间信息失败"];
}

#pragma mark - SYVoiceChatRoomBackdropVCDelegate

- (void)SYVoiceChatRoomBackDropVCSelectedRoomBackGroundImageNum:(NSInteger)imageNum {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomInfoDidChangeRoomBackgroundImage:)]) {
        [self.delegate voiceRoomInfoDidChangeRoomBackgroundImage:imageNum];
    }
}

#pragma mark - SYPasswordInputViewDelegate

- (void)passwordInputViewDidEnterPassword:(NSString *)password {
    __weak typeof(self) weakSelf = self;
    [self.viewModel openRoomEncryptionWithChannelId:self.channelId password:password success:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.isRoomOwner) {
                [weakSelf.listView reloadSections:[NSIndexSet indexSetWithIndex:3]];
            } else {
                [weakSelf.listView reloadSections:[NSIndexSet indexSetWithIndex:2]];
            }
            if (!success) {
                [SYToastView showToast:@"打开房间加密开关失败"];
            }
        });
    }];
}

- (void)passwordInputViewDidCancelEnter {
    if (self.isRoomOwner) {
        [self.listView reloadSections:[NSIndexSet indexSetWithIndex:3]];
    } else {
        [self.listView reloadSections:[NSIndexSet indexSetWithIndex:2]];
    }
}

#pragma mark - SYVoiceChatRoomDetailInfoCellDelegate

// 房间加密开关
- (void)SYVoiceChatRoomDetailInfoCellOpenUISwitchBtn:(BOOL)open {
    if (open) { // 打开房间密码开关，需要弹出密码框，输入密码
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (window) {
            SYPasswordInputView *view = [[SYPasswordInputView alloc] initWithFrame:window.bounds];
            view.delegate = self;
            [window addSubview:view];
        }
    } else {
        __weak typeof(self) weakSelf = self;
        [self.viewModel closeRoomEncryptionWithChannelId:self.channelId success:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.isRoomOwner) {
                    [weakSelf.listView reloadSections:[NSIndexSet indexSetWithIndex:3]];
                } else {
                    [weakSelf.listView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                }
                if (!success) {
                    [SYToastView showToast:@"关闭房间加密开关失败"];
                }
            });
        }];
    }
}

#pragma mark - LazyLoad

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(__MainScreen_Width, 52);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_listView registerClass:[SYVoiceChatRoomDetailInfoCell class] forCellWithReuseIdentifier:SYVoiceChatRoomDetailInfoCellID];
        _listView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"房间信息" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (SYSystemPhotoManager *)photoManager_1_1 {
    if (!_photoManager_1_1) {
        __weak typeof(self)weakSelf = self;
        _photoManager_1_1 = [[SYSystemPhotoManager alloc] initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image) {
            if (weakSelf.listView && image) {
                switch (type) {
                    case SYSystemPhotoRatio_OneToOne:
                    {
                        NSData *imageData =UIImageJPEGRepresentation(image, 0.5f);
                        [[SYAPPServiceAPI sharedInstance] requestValidateImage:imageData success:^(id  _Nullable response) {
                            [weakSelf uploadSYVoiceRoomOneToOneCover:image];
                        } failure:^(NSError * _Nullable error) {
                            NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"voiceroom"};
//                            [MobClick event:@"imagePorn" attributes:pubParam];
                            [SYToastView showToast:@"封面图包含敏感信息，请重试~"];
                        }];
                    }
                        break;
                    default:
                        break;
                }

            }
        }];
        [_photoManager_1_1 updateSYSystemPhotoRatioType:SYSystemPhotoRatio_OneToOne];
    }
    return _photoManager_1_1;
}

- (SYSystemPhotoManager *)photoManager_16_9 {
    if (!_photoManager_16_9) {
        __weak typeof(self)weakSelf = self;
        _photoManager_16_9 = [[SYSystemPhotoManager alloc] initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image) {
            if (weakSelf.listView && image) {
                switch (type) {
                    case SYSystemPhotoRatio_SixteenToNine:
                    {
                        NSData *imageData =UIImageJPEGRepresentation(image, 0.5f);
                        [[SYAPPServiceAPI sharedInstance] requestValidateImage:imageData success:^(id  _Nullable response) {
                            [weakSelf uploadSyVoiceRoomSixteenToNineCover:image];
                        } failure:^(NSError * _Nullable error) {
                            NSDictionary *pubParam = @{@"url":@"",@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"from":@"voiceroom"};
//                            [MobClick event:@"imagePorn" attributes:pubParam];
                            [SYToastView showToast:@"封面图包含敏感信息，请重试~"];
                        }];
                    }
                        break;
                    default:
                        break;
                }

            }
        }];
        [_photoManager_16_9 updateSYSystemPhotoRatioType:SYSystemPhotoRatio_SixteenToNine];
    }
    return _photoManager_16_9;
}

- (SYVoiceChatRoomDetailInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYVoiceChatRoomDetailInfoViewModel new];
        _viewModel.isLiving = self.isLiving;
        _viewModel.delegate = self;
        _viewModel.isRoomOwner = self.isRoomOwner;
    }
    return _viewModel;
}

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
