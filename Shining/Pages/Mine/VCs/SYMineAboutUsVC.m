//
//  SYMineAboutUsVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineAboutUsVC.h"
#import "SYCommonTopNavigationBar.h"
//#import <Masonry.h>
#import "SYMineAboutUsViewModel.h"
#import "SYMineAboutUsCell.h"
#import "SYWebViewController.h"

#define SYMineAboutUsCellID @"SYMineAboutUsCellID"

@interface SYMineAboutUsVC () <SYCommonTopNavigationBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIImageView *logoImage;       // logo
@property (nonatomic, strong) UILabel *versionLabel;        // 版本号
@property (nonatomic, strong) UICollectionView *listView;   // listView
@property (nonatomic, strong) UILabel *copyrightLabel;      // 版权
@property (nonatomic, strong) UILabel *companyLabel;        // 公司
@property (nonatomic, strong) SYMineAboutUsViewModel *viewModel;

@end

@implementation SYMineAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sy_configDataInfoPageName:SYPageNameType_About_us];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.copyrightLabel];
    [self.view addSubview:self.companyLabel];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topNavBar.mas_bottom).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.view);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImage.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(118, 16));
    }];
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -68: -34);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(118, 16));
    }];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -52: -18);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(176, 16));
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.versionLabel.mas_bottom).with.offset(26);
        make.bottom.equalTo(self.copyrightLabel.mas_top).with.offset(-26);
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
    SYMineAboutUsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMineAboutUsCellID forIndexPath:indexPath];
    SYMineAboutUsCellType type = [self.viewModel cellTypeForIndexPath:indexPath];
    NSString *title = [self.viewModel mainTitleForIndexPath:indexPath];
    NSString *subTitle = [self.viewModel subTitleForIndexPath:indexPath];
    [cell updateCellWithType:type withTitle:title withSubtitle:subTitle];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYMineAboutUsCellType type = [self.viewModel cellTypeForIndexPath:indexPath];
    switch (type) {
        case SYMineAboutUsCellType_Community:
        {
            NSString *communityUrl = @"https://mp-cdn.le.com/web/doc/be/community_norms";
            SYWebViewController *vc = [[SYWebViewController alloc] initWithURL:communityUrl];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
        case SYMineAboutUsCellType_UserAgreement:
        {
            NSString *agreementUrl = @"https://mp-cdn.le.com/web/doc/be/user_agreement";
            SYWebViewController *vc = [[SYWebViewController alloc] initWithURL:agreementUrl];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
            break;
        case SYMineAboutUsCellType_ServiceQQ:{}
            break;
        default:
            break;
    }
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"关于我们" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _topLine;
}

- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [UIImageView new];
        _logoImage.image = [UIImage imageNamed_sy:@"mine_aboutus_logo"];
    }
    return _logoImage;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [UILabel new];
        _versionLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _versionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.text = SHANYIN_VERSION;
    }
    return _versionLabel;
}

- (UILabel *)copyrightLabel {
    if (!_copyrightLabel) {
        _copyrightLabel = [UILabel new];
        _copyrightLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _copyrightLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.text = @"Copyright@ 2013-2019";
    }
    return _copyrightLabel;
}

- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [UILabel new];
        _companyLabel.textColor = RGBACOLOR(102, 102, 102, 1);
        _companyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _companyLabel.textAlignment = NSTextAlignmentCenter;
        _companyLabel.text = @"乐视网新媒体文化（天津）有限公司";
    }
    return _companyLabel;
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
        [_listView registerClass:[SYMineAboutUsCell class] forCellWithReuseIdentifier: SYMineAboutUsCellID];
    }
    return _listView;
}

- (SYMineAboutUsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYMineAboutUsViewModel new];
    }
    return _viewModel;
}

@end
