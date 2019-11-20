//
//  SYMyCoinViewController.m
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMyCoinViewController.h"
#import "SYMyCoinDetailViewController.h"
#import "MyCoinCollectionViewCell.h"
#import "MyCoinViewModel.h"
#import "SYCoinPackageModel.h"
#import "SYCoinPackageListModel.h"
#import "SYLepayIpaPayManager.h"
#import "SYWebViewController.h"
#import "SYChildProtectManager.h"

@interface SYMyCoinViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SYNoNetworkViewDelegate,SYCommonTopNavigationBarDelegate>
@property(nonatomic, strong)UILabel *accountLbl;
@property(nonatomic, strong)UIButton *rechargeTipBtn;
@property(nonatomic, strong)UILabel *rechargeLbl;
@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)UIButton *rechargeBtn;
@property(nonatomic, strong)UILabel *agreementBtn;
@property(nonatomic, strong)UILabel *helpBtn;
@property(nonatomic, assign)NSInteger selectIndexRow;

@property(nonatomic, strong)MyCoinViewModel *viewModel;

@property(nonatomic, strong)SYLepayIpaPayManager *payManager;
@property(nonatomic, strong)SYNoNetworkView *noNetworkView;
@property(nonatomic, strong)SYDataEmptyView *emptyView;
@property(nonatomic, strong)MBProgressHUD *loadingView;
@property(nonatomic, strong)SYCommonTopNavigationBar *topNavBar;
@property(nonatomic, assign)NSInteger defalutSelectPrice;

@end

@implementation SYMyCoinViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewModel = [[MyCoinViewModel alloc] init];
        self.defalutSelectPrice = 1;
    }
    return self;
}


- (instancetype)initWithSelectPrice:(NSInteger)price {
    self = [super init];
    if (self) {
        _viewModel = [[MyCoinViewModel alloc] init];
        self.defalutSelectPrice = price;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
    self.selectIndexRow = -1;
    [self.view addSubview:self.topNavBar];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self setUpView];
    [self.view bringSubviewToFront:self.topNavBar];
    [self sy_configDataInfoPageName:SYPageNameType_Wallet_Recharge];
    [self.viewModel addObserver:self
                   forKeyPath:@"varifyIapSuccess"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"充值" rightTitle:@"明细" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

#pragma mark - SYCommonTopNavigationBarDelegate

- (void)handleGoBackBtnClick {
    [self back:nil];
}

- (void)handleSaveBtnClick {
    SYMyCoinDetailViewController *detail = [SYMyCoinDetailViewController new];
    [self.navigationController pushViewController:detail animated:YES];
}

/**
 无数据View

 @return view
 */
- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[SYDataEmptyView alloc] initWithFrame:CGRectZero withTipImage:@"myWalletEmpty" withTipStr:@"暂无记录哦～"];
        _emptyView.hidden = YES;
    }
    if (!_emptyView.superview) {
        [self.view addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(280, 124));
        }];
    }
    return _emptyView;
}

- (SYNoNetworkView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
    }
    if (!_noNetworkView.superview) {
        [self.view addSubview:_noNetworkView];
        _noNetworkView.hidden = YES;
        [_noNetworkView mas_makeConstraints:^(MASConstraintMaker    *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view).with.offset(iPhoneX ? 88 : 64);
            make.bottom.equalTo(self.view);
        }];
    }
    return _noNetworkView;
}


#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    [self requestWalletList];
}


- (void)requestMyCoin {
    [self.viewModel requestMyCoinWithSuccess:^(NSNumber * _Nonnull coin) {
        NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *firtAttrStr = [[NSMutableAttributedString alloc] initWithString:@"账号余额："];
        [firtAttrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor sy_colorWithHexString:@"#444444"],NSFontAttributeName:self.accountLbl.font} range:NSMakeRange(0, firtAttrStr.length)];
        NSMutableAttributedString *lastAttrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 蜜豆",coin]];
        [lastAttrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor sy_colorWithHexString:@"#7B40FF"],NSFontAttributeName:self.accountLbl.font} range:NSMakeRange(0, lastAttrStr.length)];
        
        [textAttrStr appendAttributedString:firtAttrStr];
        [textAttrStr appendAttributedString:lastAttrStr];
        self.accountLbl.attributedText = textAttrStr;
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"varifyIapSuccess"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.collectionView) {
                [self.collectionView reloadData];
            }
        });
    }
}

- (void)setUpView
{
    if (!self.accountLbl) {}
#ifdef ShiningSdk
    // 配置了，才显示
    BOOL hasTip = [SYSettingManager getChargeTipOn];
    if (hasTip) {
        if (!self.rechargeTipBtn) {}
    }
#endif
    if (!self.rechargeLbl) {}
    if (!self.collectionView) {}
    if (!self.rechargeBtn) {}
    if (!self.agreementBtn) {}
    if (!self.helpBtn) {}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self sy_setStatusBarDard];
    if ([NSString sy_isBlankString:self.coin]) {
        [self requestMyCoin];
    }
    [self requestWalletList];
}


- (void)requestWalletList {
    if ([self.viewModel isLepayCoinPackageEmptyData]) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.opacity = 0.7;
        hud.removeFromSuperViewOnHide = YES;
        [self.view insertSubview:hud belowSubview:self.topNavBar];
        self.loadingView = hud;
        [self.loadingView show:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.viewModel getLepayCoinPackageList:^(BOOL isSuccess) {
        if ([self.viewModel isLepayCoinPackageEmptyData]) {
            if (![SYNetworkReachability isNetworkReachable]) {
                [SYToastView showToast:@"网络异常"];
                weakSelf.noNetworkView.hidden = NO;
                weakSelf.accountLbl.hidden = YES;
                weakSelf.rechargeLbl.hidden = YES;
                weakSelf.collectionView.hidden = YES;
                weakSelf.rechargeBtn.hidden = YES;
                weakSelf.agreementBtn.hidden = YES;
                weakSelf.emptyView.hidden = YES;
                weakSelf.helpBtn.hidden = YES;
            }else {
                weakSelf.noNetworkView.hidden = YES;
                weakSelf.accountLbl.hidden = YES;
                weakSelf.rechargeLbl.hidden = YES;
                weakSelf.collectionView.hidden = YES;
                weakSelf.rechargeBtn.hidden = YES;
                weakSelf.agreementBtn.hidden = YES;
                weakSelf.emptyView.hidden = NO;
                weakSelf.helpBtn.hidden = YES;
            }
        } else {
            weakSelf.noNetworkView.hidden = YES;
            weakSelf.emptyView.hidden = YES;
            weakSelf.accountLbl.hidden = NO;
            weakSelf.rechargeLbl.hidden = NO;
            weakSelf.collectionView.hidden = NO;
            weakSelf.rechargeBtn.hidden = NO;
            weakSelf.agreementBtn.hidden = NO;
            weakSelf.helpBtn.hidden = NO;
            NSInteger row = weakSelf.viewModel.lepayListModel.list.count / 3 + (weakSelf.viewModel.lepayListModel.list.count % 3 > 0 ? 1 : 0);
            if (row > 4) {
                row = 4;
            }
            if (row > 2) {
                NSInteger height = (row * 57) + ((row - 1) * 8);
                [weakSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
            }
            if (weakSelf.selectIndexRow < 0) {
                [weakSelf.viewModel.lepayListModel.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SYCoinPackageModel *model = obj;
                    if ([model.validatePrice integerValue] == weakSelf.defalutSelectPrice) {
                        weakSelf.selectIndexRow = idx;
                        *stop = YES;
                    }
                }];
            }
            if (weakSelf.selectIndexRow < 0) {
                weakSelf.selectIndexRow = 0;
            }
            [weakSelf.collectionView reloadData];
        }
        if (weakSelf.loadingView) {
            [weakSelf.loadingView hide:YES];
            weakSelf.loadingView = nil;
        }
    }];
}

- (void)back:(id)sender
{
    if ([self.navigationController.viewControllers count] > 0) {
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:0];
        if (vc == self) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (self.resultBlock) {
        self.resultBlock();
    }
}

- (UILabel *)accountLbl
{
    if (!_accountLbl) {
        _accountLbl = [UILabel new];
        _accountLbl.backgroundColor = [UIColor clearColor];
        _accountLbl.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        _accountLbl.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _accountLbl.textAlignment = NSTextAlignmentLeft;
        if (![NSString sy_isBlankString:self.coin]) {
            NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
            NSMutableAttributedString *firtAttrStr = [[NSMutableAttributedString alloc] initWithString:@"账号余额："];
            [firtAttrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor sy_colorWithHexString:@"#444444"],NSFontAttributeName:_accountLbl.font} range:NSMakeRange(0, firtAttrStr.length)];
            NSMutableAttributedString *lastAttrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 蜜豆",self.coin]];
            [lastAttrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor sy_colorWithHexString:@"#7B40FF"],NSFontAttributeName:_accountLbl.font} range:NSMakeRange(0, lastAttrStr.length)];

            [textAttrStr appendAttributedString:firtAttrStr];
            [textAttrStr appendAttributedString:lastAttrStr];
            _accountLbl.attributedText = textAttrStr;
        }
    }
    if (!_accountLbl.superview) {
        [self.view addSubview:_accountLbl];
        [_accountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(300, 20));
            make.top.equalTo(self.topNavBar.mas_bottom).with.offset(26);
        }];
    }
    return _accountLbl;
}


- (SYLepayIpaPayManager *)payManager {
    if (!_payManager) {
        _payManager = [[SYLepayIpaPayManager alloc] initWithToastParentVC:self];
    }
    return _payManager;
}

- (UIButton *)rechargeTipBtn {
    if (!_rechargeTipBtn) {
        _rechargeTipBtn = [UIButton new];
        [_rechargeTipBtn setTitleColor:RGBACOLOR(113,56,239,1) forState:UIControlStateNormal];
        _rechargeTipBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        NSString *tipStr = [SYSettingManager getChargeTip];
        [_rechargeTipBtn setTitle:tipStr forState:UIControlStateNormal];
        [_rechargeTipBtn addTarget:self action:@selector(handleRechargeTipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!_rechargeTipBtn.superview) {
        [self.view addSubview:_rechargeTipBtn];
        [_rechargeTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.top.mas_equalTo(self.accountLbl.mas_bottom).with.offset(16);
            make.height.mas_equalTo(17);
        }];
    }
    return _rechargeTipBtn;
}

- (void)handleRechargeTipBtnClick {
    NSString *downloadUrl = [SYSettingManager getChargeDonwloadUrl];
    SYWebViewController *vc = [[SYWebViewController alloc] initWithURL:downloadUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel *)rechargeLbl
{
    if (!_rechargeLbl) {
        _rechargeLbl = [UILabel new];
        _rechargeLbl.backgroundColor = [UIColor clearColor];
        _rechargeLbl.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        _rechargeLbl.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _rechargeLbl.textAlignment = NSTextAlignmentLeft;
        _rechargeLbl.text = @"充值蜜豆";
    }
    if (!_rechargeLbl.superview) {
        [self.view addSubview:_rechargeLbl];
        [_rechargeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(15);
#ifdef ShiningSdk
            BOOL hasTip = [SYSettingManager getChargeTipOn];
            if (hasTip) {
                make.top.mas_equalTo(self.rechargeTipBtn.mas_bottom).with.offset(30);
            } else {
                make.top.mas_equalTo(self.accountLbl.mas_bottom).with.offset(32);
            }
#else
            make.top.mas_equalTo(self.accountLbl.mas_bottom).with.offset(32);
#endif
            make.size.mas_equalTo(CGSizeMake(300, 20));
        }];
    }
    return _rechargeLbl;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 22;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(97, 57);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MyCoinCollectionViewCell class]
            forCellWithReuseIdentifier:@"MyCoinCollectionViewCell"];
    }
    if (!_collectionView.superview) {
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.top.mas_equalTo(self.rechargeLbl.mas_bottom).with.offset(12);
            make.height.mas_equalTo(122);
        }];
    }
    return _collectionView;
}

- (UIButton *)rechargeBtn
{
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setBackgroundColor:[UIColor sy_colorWithHexString:@"#7B40FF"]];
        [_rechargeBtn setTitleColor:[UIColor sy_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _rechargeBtn.layer.cornerRadius = 20.5f;
        [_rechargeBtn addTarget:self action:@selector(doRecharge) forControlEvents:UIControlEventTouchUpInside];
        [_rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    }
    if (!_rechargeBtn.superview) {
        [self.view addSubview:_rechargeBtn];
        [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.top.mas_equalTo(self.collectionView.mas_bottom).with.offset(44);
            make.height.mas_equalTo(38);
        }];
    }
    return _rechargeBtn;
}

- (UILabel *)agreementBtn
{
    if (!_agreementBtn) {
        _agreementBtn = [UILabel new];
        [_agreementBtn setBackgroundColor:[UIColor clearColor]];
        _agreementBtn.textColor = [UIColor sy_colorWithHexString:@"#888888"];
        _agreementBtn.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
        //点击手势
        _agreementBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAgreement)];
        r5.numberOfTapsRequired = 1;
        [_agreementBtn addGestureRecognizer:r5];

        NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:@"点击充值，表示同意《充值协议》"];
        NSRange idRange = NSMakeRange(0, attrIdStr.length);
        // 设置字体大小
        [attrIdStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:10] range:idRange];
        // 设置颜色
        [attrIdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#888888"] range:NSMakeRange(0, 9)];
        // 设置颜色
        [attrIdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#000000"] range:NSMakeRange(9, attrIdStr.length - 9)];
        [idTextAttrStr appendAttributedString:attrIdStr];
        _agreementBtn.attributedText = idTextAttrStr;
        /*
        [_agreementBtn setTitle:@"点击充值，表示同意《充值协议》" forState:UIControlStateNormal];
         */
    }
    if (!_agreementBtn.superview) {
        [self.view addSubview:_agreementBtn];
        [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(self.rechargeBtn.mas_bottom).with.offset(10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(150);
        }];
    }
    return _agreementBtn;
}


- (UILabel *)helpBtn
{
    if (!_helpBtn) {
        _helpBtn = [UILabel new];
        [_helpBtn setBackgroundColor:[UIColor clearColor]];
        _helpBtn.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        _helpBtn.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];

        NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:@" 充值帮助"];
        NSRange idRange = NSMakeRange(0, attrIdStr.length);
        // 设置字体大小
        [attrIdStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:10] range:idRange];
        // 设置颜色
        [attrIdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#444444"] range:idRange];
        // 文字中加图片
        NSTextAttachment *attachmentID=[[NSTextAttachment alloc] init];
        UIImage *idImg=[UIImage imageNamed_sy:@"wenti"];
        attachmentID.bounds=CGRectMake(0, -2, idImg.size.width, idImg.size.height);
        attachmentID.image = idImg;
        NSAttributedString *idImgStr = [NSAttributedString attributedStringWithAttachment:attachmentID];

        [idTextAttrStr appendAttributedString:idImgStr];
        [idTextAttrStr appendAttributedString:attrIdStr];
        _helpBtn.attributedText = idTextAttrStr;

        //点击手势
        _helpBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *r5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doHelp)];
        r5.numberOfTapsRequired = 1;
        [_helpBtn addGestureRecognizer:r5];

        /*
        [_helpBtn addTarget:self action:@selector(doHelp) forControlEvents:UIControlEventTouchUpInside];
        [_helpBtn setTitle:@"充值帮助" forState:UIControlStateNormal];
         */
    }
    if (!_helpBtn.superview) {
        [self.view addSubview:_helpBtn];
        [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(self.agreementBtn.mas_bottom).with.offset(25);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(60);
        }];
    }
    return _helpBtn;
}

- (void)doAgreement
{
    SYWebViewController *controller = [[SYWebViewController alloc] initWithURL:@"https://mp-cdn.le.com/sy/w/recharge_agreement.html"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)doRecharge {
    if ([self.viewModel isLepayCoinPackageEmptyData]) {
        return;
    }
//    if ([[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:self.navigationController]) {
//        return;
//    }
    SYCoinPackageModel *model = [self.viewModel.lepayListModel.list objectAtIndex:self.selectIndexRow];
    NSDictionary *pubParam = @{@"roomID":[NSString sy_safeString:self.roomId],@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"payType":@"apple",@"chargeID":[NSString sy_safeString:model.cid],@"chargeCount":[NSString sy_safeString:model.coin]};
//    [MobClick event:@"chargeBtnClick" attributes:pubParam];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:model,@"product", nil];
    if (self.roomId) {
        [params setObject:self.roomId forKey:@"roomId"];
    }
    __weak typeof(self) weakSelf = self;
    [self.payManager buyVipProduct:params andFinishBlock:^(SY_PayResultType code, NSDictionary *resultDic) {
        if (code == SY_PayResult_Success) {
//            [MobClick event:@"chargeSuccess" attributes:pubParam];
            NSLog(@"支付成功------@ dict is %@",resultDic);
            [weakSelf requestMyCoin];
            [weakSelf requestWalletList];
        }else{
//            [MobClick event:@"chargeFailed" attributes:pubParam];
            NSLog(@"支付失败------@ code is %lu, dict is %@",(unsigned long)code,resultDic);
        }

    }];

}

- (void)doHelp
{
    SYWebViewController *controller = [[SYWebViewController alloc] initWithURL:@"https://mp-cdn.le.com/sy/w/recharge_help.html"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UICollentViewDelegate
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.viewModel isLepayCoinPackageEmptyData]) {
        return 0;
    }else{
        return self.viewModel.lepayListModel.list.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCoinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCoinCollectionViewCell" forIndexPath:indexPath];
    SYCoinPackageModel *model = [self.viewModel.lepayListModel.list objectAtIndex:indexPath.row];
    if (model) {
        [cell bindData:model];
    }
    if (indexPath.row == self.selectIndexRow) {
        [cell setSelected:YES];
    }else{
        [cell setSelected:NO];
    }
    return cell;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectIndexRow != indexPath.row) {
        MyCoinCollectionViewCell *cell = (MyCoinCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndexRow inSection:0]];
        [cell setSelected:NO];
        self.selectIndexRow = indexPath.row;
    }
}

- (void)dealloc
{
    [self.viewModel removeObserver:self forKeyPath:@"varifyIapSuccess"];
    self.payManager = nil;
}

@end
