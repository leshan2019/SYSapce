//
//  SYMyShineViewController.m
//  Shining
//
//  Created by letv_lzb on 2019/3/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMyShineViewController.h"
#import "SYMyShineDetailViewController.h"
#import "SYGiftNetManager.h"
#import "SYShineIncomeModel.h"
#import "MyShineIncomeView.h"

@interface SYMyShineViewController () <SYCommonTopNavigationBarDelegate,SYNoNetworkViewDelegate>
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIImageView *shineLogoView;
@property (nonatomic, strong) UILabel *shineNumberLbl;
@property (nonatomic, strong) UILabel *shineDesTitleLbl;
@property (nonatomic, strong) UILabel *shineDesLbl;
@property (nonatomic, strong) UIButton *shineBtn;
@property (nonatomic, strong)SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) SYShineIncomeModel *model;
@property (nonatomic, strong) MyShineIncomeView *myIncomeView;
@property (nonatomic, strong)SYNoNetworkView *noNetworkView;

@end

@implementation SYMyShineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
    [self setUpView];
    [self.view addSubview:self.topNavBar];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self sy_configDataInfoPageName:SYPageNameType_Shining];
}

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"蜜糖" rightTitle:@"明细" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
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


#pragma mark - SYCommonTopNavigationBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSaveBtnClick {
    SYMyShineDetailViewController *detail = [SYMyShineDetailViewController new];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)setUpView
{
    if (self.headView.superview == nil) {

    }
    if (self.alertView.superview == nil) {

    }
    if (self.shineLogoView.superview == nil) {

    }
    if (!_shineNumberLbl) {
        _shineNumberLbl = [[UILabel alloc] init];
        _shineNumberLbl.backgroundColor = [UIColor clearColor];
        _shineNumberLbl.font = [UIFont systemFontOfSize:32];
        _shineNumberLbl.textColor = [UIColor sy_colorWithHexString:@"#43496A"];
        _shineNumberLbl.text = self.shineValue;
    }
    if (!_shineNumberLbl.superview) {
        [self.alertView addSubview:_shineNumberLbl];
        [_shineNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.shineLogoView.mas_centerX);
            make.top.mas_equalTo(self.shineLogoView.mas_bottom).with.offset(-15);
            CGSize size = [self.shineValue boundingRectWithSize:CGSizeMake(self.alertView.bounds.size.width, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.shineNumberLbl.font} context:nil].size;
            size.width += 1;
            size.height = 40;
            make.size.mas_equalTo(size);
        }];
    }
    
    [self.alertView addSubview:self.myIncomeView];
    [self.myIncomeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView.mas_left);
        make.top.equalTo(self.shineNumberLbl.mas_bottom).with.offset(15);
        make.right.equalTo(self.alertView.mas_right);
        make.height.mas_equalTo(54);
    }];
    

    if (!_shineDesTitleLbl) {
        _shineDesTitleLbl = [UILabel new];
        _shineDesTitleLbl.backgroundColor = [UIColor clearColor];
        _shineDesTitleLbl.font= [UIFont systemFontOfSize:15];
        _shineDesTitleLbl.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
        _shineDesTitleLbl.textAlignment = NSTextAlignmentLeft;
        _shineDesTitleLbl.text = @"蜜糖说明";
    }
    if (!_shineDesTitleLbl.superview) {
        [self.alertView addSubview:_shineDesTitleLbl];
        [_shineDesTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.alertView.mas_left);
            make.top.mas_equalTo(self.alertView.mas_bottom).with.offset(80);
            make.size.mas_equalTo(CGSizeMake(254, 20));
        }];
    }
    
    
    if (!_shineDesLbl) {
        _shineDesLbl = [UILabel new];
        _shineDesLbl.backgroundColor = [UIColor clearColor];
        _shineDesLbl.font= [UIFont systemFontOfSize:12];
        _shineDesLbl.numberOfLines = 0;
        _shineDesLbl.lineBreakMode = NSLineBreakByCharWrapping;
        _shineDesLbl.textColor = [UIColor sy_colorWithHexString:@"#000000"];
        _shineDesLbl.textAlignment = NSTextAlignmentLeft;

    }
    if (!_shineDesLbl.superview) {
        [self.alertView addSubview:_shineDesLbl];
        [_shineDesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.shineDesTitleLbl.mas_left);
            make.top.mas_equalTo(self.shineDesTitleLbl.mas_bottom).with.offset(15);
//            make.size.mas_equalTo(CGSizeMake(260, 106));
            make.right.mas_equalTo(self.alertView.mas_right);
        }];
        NSMutableParagraphStyle *muParagraph = [[NSMutableParagraphStyle alloc]init];
        muParagraph.lineSpacing = 6; // 行距
//        muParagraph.paragraphSpacing = 8;
        // 2.蜜糖未来可以兑换蜜豆，以及针对个人主播的提现功能，但目前暂未开放。
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[@"1.蜜糖是用户在Bee语音中“魅力”的体现，用户收到的礼物，会按照一定的比例，转化为蜜糖。" dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        NSRange range = NSMakeRange(0, attrStr.length);
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#000000"] range:range];
        // 设置段落样式
        [attrStr addAttribute:NSParagraphStyleAttributeName value:muParagraph range:range];
        _shineDesLbl.attributedText = attrStr;
        [_shineDesLbl sizeToFit];
    }

    if (!_shineBtn) {
        _shineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shineBtn.layer.borderColor = [UIColor sy_colorWithHexString:@"#A1A1A1"].CGColor;
        _shineBtn.layer.borderWidth = 1;
        _shineBtn.layer.cornerRadius = 14;
        [_shineBtn setTitle:@"敬请期待" forState:UIControlStateNormal];
        [_shineBtn setTitleColor:[UIColor sy_colorWithHexString:@"#A1A1A1"] forState:UIControlStateNormal];
        _shineBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _shineBtn.hidden = YES;
    }
    if (!_shineBtn.superview) {
        [self.alertView addSubview:_shineBtn];
        [_shineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView.mas_centerX);
            make.bottom.mas_equalTo(self.alertView.mas_bottom).with.offset(-59);
            make.size.mas_equalTo(CGSizeMake(100, 28));
        }];
    }

}



- (UIImageView *)headView
{
    if (!_headView) {
        _headView = [[UIImageView alloc] init];
        _headView.image = [UIImage imageNamed_sy:@"voiceroom_create_head"];
    }
    if(!_headView.superview){
        [self.view addSubview:_headView];
        CGFloat ratio = 750.f/564.f;
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat height = width / ratio;
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }
    return _headView;
}


- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _alertView.layer.cornerRadius = 10;
        _alertView.layer.shadowColor = [UIColor blackColor].CGColor;
        // 设置阴影偏移量
        _alertView.layer.shadowOffset = CGSizeMake(0,10);
        // 设置阴影透明度
        _alertView.layer.shadowOpacity = 0.1;
        // 设置阴影半径
        _alertView.layer.shadowRadius = 5;
        _alertView.clipsToBounds = NO;
    }
    if (!_alertView.superview) {
        [self.view addSubview:_alertView];
        [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(self.view.mas_top).with.offset(139+40);
            make.left.equalTo(self.view).with.offset(20);
            make.right.equalTo(self.view).with.offset(-20);
            make.height.mas_equalTo(168);
//            make.size.mas_equalTo(CGSizeMake(295, 361));
        }];
    }
    return _alertView;
}


- (UIImageView *)shineLogoView
{
    if (!_shineLogoView) {
        _shineLogoView = [[UIImageView alloc] init];
        _shineLogoView.backgroundColor = [UIColor clearColor];
    }
    if (!_shineLogoView.superview) {
        [self.alertView addSubview:_shineLogoView];
        UIImage *img = [UIImage imageNamed_sy:@"shangyaozhi"];
        [_shineLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.alertView.mas_centerX);
            make.top.mas_equalTo(self.alertView.mas_top).with.offset(-(img.size.height/2));
            make.size.mas_equalTo(img.size);
        }];
        _shineLogoView.image = img;
    }
    return _shineLogoView;
}

- (MyShineIncomeView *)myIncomeView {
    if (!_myIncomeView) {
        _myIncomeView = [[MyShineIncomeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shineNumberLbl.frame)+20, __MainScreen_Width-20*2, 54)];
        _myIncomeView.backgroundColor = [UIColor clearColor];
    }
    return _myIncomeView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self requestShineValue];
}

- (void)requestShineValue {
    if (![SYNetworkReachability isNetworkReachable]) {
        self.noNetworkView.hidden = NO;
        self.alertView.hidden =YES;
        self.headView.hidden = YES;
        return;
    }
    SYGiftNetManager *manager = [SYGiftNetManager new];
    [manager requestMyIncomeWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            SYShineIncomeModel *model = [SYShineIncomeModel yy_modelWithDictionary:response];
            self.model = model;
            [self updateUI];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (void)updateUI {
    self.noNetworkView.hidden = [SYNetworkReachability isNetworkReachable];
    self.alertView.hidden = ![SYNetworkReachability isNetworkReachable];
    self.headView.hidden = ![SYNetworkReachability isNetworkReachable];

    [self.myIncomeView setDayIncomeCount:self.model.daily_shine];
    [self.myIncomeView setWeekIncomeCount:self.model.weekly_shine];
}


#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    [self requestShineValue];
}
@end
