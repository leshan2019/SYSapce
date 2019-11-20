//
//  SYMineVerifyIDCardVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineVerifyIDCardVC.h"
#import "SYCommonTopNavigationBar.h"
#import "SYMineVerifyIDCardViewModel.h"
#import "SYMineVerifyIDCardCell.h"
#import "SYMineVerifyIDCardPicCell.h"
#import "SYSystemPhotoManager.h"
#import "SYMineIDCardNameVC.h"
#import "SYMineIDCardNumberVC.h"
#import "SYUserServiceAPI.h"

#define SYMineVerifyIDCardCellID @"SYMineVerifyIDCardCellID"
#define SYMineVerifyIDCardPicCellID @"SYMineVerifyIDCardPicCellID"

@interface SYMineVerifyIDCardVC ()<SYCommonTopNavigationBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, SYMineIDCardNameVCDelegate, SYMineIDCardNumberVCDelegate>

@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UICollectionView *listView;               // listView
@property (nonatomic, strong) SYMineVerifyIDCardViewModel *viewModel;
@property (nonatomic, strong) UIButton *submitBtn;      // 提交
@property (nonatomic, strong) UILabel *serviceLabel;    // 若有疑问，请您添加客服QQ：1231423543

@property (nonatomic, strong) SYSystemPhotoManager *photoManager;

// 保存点击了哪个获取身份证图片的cell的索引
@property (nonatomic, assign) NSUInteger selectPhotoIndex;

// 上传身份证需要的信息
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *idCards;
@property (nonatomic, strong) UIImage *frontIDCardImage;
@property (nonatomic, strong) UIImage *backIDCardImage;
@property (nonatomic, strong) UIImage *handIDCardImage;

@end

@implementation SYMineVerifyIDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sy_configDataInfoPageName:SYPageNameType_Authentication];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.serviceLabel];
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
        make.bottom.equalTo(self.view);
    }];
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(192, 14));
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -54 : -20);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(295, 44));
        if (iPhone5) {
            make.bottom.equalTo(self.serviceLabel.mas_top).with.offset(-5);
        } else {
            make.bottom.equalTo(self.serviceLabel.mas_top).with.offset(-66);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SYMineVerifyIDCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMineVerifyIDCardCellID forIndexPath:indexPath];
        SYMineVerifyIDCardCellType type = [self.viewModel cellTypeForIndexPath:indexPath];
        NSString *title = [self.viewModel mainTitleForIndexPath:indexPath];
        NSString *subTitle = [self.viewModel subTitleForIndexPath:indexPath];
        [cell updateCellWithType:type withTitle:title withSubtitle:subTitle];
        return cell;
    } else {
        SYMineVerifyIDCardPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMineVerifyIDCardPicCellID forIndexPath:indexPath];
        SYMineVerifyIDCardCellType type = [self.viewModel cellTypeForIndexPath:indexPath];
        NSString *title = [self.viewModel mainTitleForIndexPath:indexPath];
        NSString *subTitle = [self.viewModel subTitleForIndexPath:indexPath];
        BOOL show = [self.viewModel showBottomLine:indexPath];
        [cell updateCellWithType:type withTitle:title withSubtitle:subTitle showBottomLine:show];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(section > 0 ? 10 : 0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(__MainScreen_Width, 52);
    } else if (indexPath.section == 1) {
        return CGSizeMake(__MainScreen_Width, 100);
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYMineVerifyIDCardCellType type = [self.viewModel cellTypeForIndexPath:indexPath];
    switch (type) {
        case SYMineVerifyIDCardCellType_IDCard_Name:
        {
            SYMineIDCardNameVC *VC = [SYMineIDCardNameVC new];
            VC.delegate = self;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case SYMineVerifyIDCardCellType_IDCard_Number:
        {
            SYMineIDCardNumberVC *VC = [SYMineIDCardNumberVC new];
            VC.delegate = self;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case SYMineVerifyIDCardCellType_IDCard_Front:
        case SYMineVerifyIDCardCellType_IDCard_Reverse:
        case SYMineVerifyIDCardCellType_IDCard_HandSelf:
        {
            [self handlePhotoViewWithIndex:indexPath.item];
        }
            break;
        default:
            break;
    }
}

#pragma mark - SYMineIDCardNameVCDelegate

- (void)saveIDCardName:(NSString *)name {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SYMineVerifyIDCardCell *cell = (SYMineVerifyIDCardCell*)[self.listView cellForItemAtIndexPath: indexPath];
    [cell updateSubtitle:name];
    self.realName = name;
}

#pragma mark - SYMineIDCardNumberVCDelegate

- (void)saveIDCardNumber:(NSString *)number {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    SYMineVerifyIDCardCell *cell = (SYMineVerifyIDCardCell*)[self.listView cellForItemAtIndexPath: indexPath];
    [cell updateSubtitle:number];
    self.idCards = number;
}

#pragma mark - Private

- (void)handlePhotoViewWithIndex:(NSUInteger)index {
    self.selectPhotoIndex = index;
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

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"个人身份信息" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(__MainScreen_Width, 52);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        [_listView registerClass:[SYMineVerifyIDCardCell class] forCellWithReuseIdentifier:SYMineVerifyIDCardCellID];
        [_listView registerClass:[SYMineVerifyIDCardPicCell class] forCellWithReuseIdentifier:SYMineVerifyIDCardPicCellID];
    }
    return _listView;
}

- (SYMineVerifyIDCardViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYMineVerifyIDCardViewModel new];
    }
    return _viewModel;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton new];
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[SYUtil imageFromColor:RGBACOLOR(123,64,255,1)] forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[SYUtil imageFromColor:RGBACOLOR(78,22,193,1)] forState:UIControlStateHighlighted];
        _submitBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _submitBtn.clipsToBounds = YES;
        _submitBtn.layer.cornerRadius = 22;
        [_submitBtn addTarget:self action:@selector(handleSubmitBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UILabel *)serviceLabel {
    if (!_serviceLabel) {
        _serviceLabel = [UILabel new];
        _serviceLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _serviceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
        _serviceLabel.text = @"若有疑问，请您添加客服QQ：1231423543";
    }
    return _serviceLabel;
}

- (SYSystemPhotoManager *)photoManager {
    if (!_photoManager) {
        __weak typeof(self)weakSelf = self;
        _photoManager = [[SYSystemPhotoManager alloc] initWithViewController:self withBlock:^(SYSystemPhotoSizeRatioType type, UIImage * _Nonnull image) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.selectPhotoIndex inSection:1];
            SYMineVerifyIDCardPicCell *cell = (SYMineVerifyIDCardPicCell*)[weakSelf.listView cellForItemAtIndexPath: indexPath];
            [cell updateCellImage:image];
            switch (weakSelf.selectPhotoIndex) {
                case 0:
                    weakSelf.frontIDCardImage = image;
                    break;
                case 1:
                    weakSelf.backIDCardImage = image;
                    break;
                case 2:
                    weakSelf.handIDCardImage = image;
                    break;
                default:
                    break;
            }
        }];
        [_photoManager updateSYSystemPhotoRatioType:SYSystemPhotoRatio_IDCard];
    }
    return _photoManager;
}

#pragma mark - SubmitClick

// 提交
- (void)handleSubmitBtnClickEvent {
    if ([NSString sy_isBlankString:self.realName]) {
        [SYToastView showToast:@"姓名不能为空"];
        return;
    }
    if ([NSString sy_isBlankString:self.idCards]) {
        [SYToastView showToast:@"身份证号不能为空"];
        return;
    }
    if (!self.frontIDCardImage) {
        [SYToastView showToast:@"身份证正面照为空"];
        return;
    }
    if (!self.backIDCardImage) {
        [SYToastView showToast:@"身份证反面照为空"];
        return;
    }
    if (!self.handIDCardImage) {
        [SYToastView showToast:@"手持身份证照为空"];
        return;
    }

    NSData *frontImage = [NSData data];
    if (self.frontIDCardImage) {
        frontImage = UIImageJPEGRepresentation(self.frontIDCardImage, 1.0f);
    }
    NSData *backImage = [NSData data];
    if (self.backIDCardImage) {
        backImage = UIImageJPEGRepresentation(self.backIDCardImage, 1.0f);
    }
    NSData *handImage = [NSData data];
    if (self.handIDCardImage) {
        handImage = UIImageJPEGRepresentation(self.handIDCardImage, 1.0f);
    }

    [[SYUserServiceAPI sharedInstance] verifyUserIDCardsWithRealName:self.realName withIDCards:self.idCards withIDCardFrontPic:frontImage withIDCardBackPic:backImage withIDCardHandPic:handImage success:^(BOOL success) {
        if (success) {
            [SYToastView showToast:@"提交成功"];
        } else {
            [SYToastView showToast:@"提交失败"];
        }
    }];
}


@end
