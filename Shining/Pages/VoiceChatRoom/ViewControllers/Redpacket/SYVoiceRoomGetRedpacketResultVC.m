//
//  SYVoiceRoomGetRedpacketResultVC.m
//  Shining
//
//  Created by yangxuan on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGetRedpacketResultVC.h"
#import "SYVoiceRoomGetRedPacketUserCell.h"

#define SYVoiceRoomGetRedPacketUserCellId @"SYVoiceRoomGetRedPacketUserCellId"

@interface SYVoiceRoomGetRedpacketResultVC ()<UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *goBackBtn;
@property (nonatomic, strong) UILabel *titleLabel;      //@"倒计时红包"

@property (nonatomic, strong) UIView *resultBg;
@property (nonatomic, strong) UIImageView *ownerIcon;   // 奶茶头像
@property (nonatomic, strong) UILabel *ownerName;       // @"奶茶的红包"
@property (nonatomic, strong) UILabel *getCoinTip;      // @"抢到蜜豆"
@property (nonatomic, strong) UILabel *getCoinLabel;    // @"3333"
@property (nonatomic, strong) UILabel *coinHasGetTip;   // @"蜜豆已经打入红包"
@property (nonatomic, strong) UIView *otherGetBg;
@property (nonatomic, strong) UILabel *otherGetTip;     // @"大家的手气"
@property (nonatomic, strong) UIView *horizonLine;
@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) UILabel *otherEmptyLabel;     // @"你是第一个抢到此红包的人哦~"

@end

@implementation SYVoiceRoomGetRedpacketResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.resultModel) {
        [self configueData:self.resultModel.owner_avatar
                 ownerName:self.resultModel.owner_name
                   getCoin:self.resultModel.coins];
        [self.listView reloadData];
    }
}

- (void)configueData:(NSString *)ownerAvatar ownerName:(NSString *)name getCoin:(NSInteger)coinCount {
    // avatar
    [self.ownerIcon sd_setImageWithURL:[NSURL URLWithString:ownerAvatar]
                     placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    // name
    name = [NSString stringWithFormat:@"%@的红包",name];
    self.ownerName.text = name;
    CGFloat titleWidth = [name sizeWithAttributes:@{NSFontAttributeName: self.ownerName.font}].width+1;
    [self.ownerName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];
    // coinCount
    [self updateCoinLabel:coinCount];
    // emptyView
    if (!self.resultModel || self.resultModel.list.count == 0) {
        self.otherEmptyLabel.hidden = NO;
    } else {
        self.otherEmptyLabel.hidden = YES;
    }
}
#pragma mark - Init

- (void)initSubViews {
    self.view.backgroundColor = RGBACOLOR(245,246,247,1);
    [self.view addSubview:self.goBackBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.resultBg];
    [self.resultBg addSubview:self.ownerIcon];
    [self.resultBg addSubview:self.ownerName];
    [self.resultBg addSubview:self.getCoinTip];
    [self.resultBg addSubview:self.getCoinLabel];
    [self.resultBg addSubview:self.coinHasGetTip];
    [self.view addSubview:self.otherGetBg];
    [self.otherGetBg addSubview:self.otherGetTip];
    [self.otherGetBg addSubview:self.horizonLine];
    [self.otherGetBg addSubview:self.listView];
    [self.otherGetBg addSubview:self.otherEmptyLabel];
    [self mas_makeConstraintsWithSubViews];
}

- (void)mas_makeConstraintsWithSubViews {
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(4);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 24 + 20 : 20);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.goBackBtn);
        make.size.mas_equalTo(CGSizeMake(88, 22));
    }];
    
    [self.resultBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 24 + 64 : 64);
        make.height.mas_equalTo(203);
    }];
    [self.ownerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultBg).with.offset(17);
        make.centerX.equalTo(self.resultBg);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(22);
    }];
    [self.ownerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ownerName.mas_left).with.offset(-4);
        make.centerY.equalTo(self.ownerName);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.getCoinTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ownerName.mas_bottom).with.offset(41);
        make.centerX.equalTo(self.resultBg);
        make.size.mas_equalTo(CGSizeMake(80, 22));
    }];
    [self.getCoinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resultBg);
        make.right.equalTo(self.resultBg);
        make.top.equalTo(self.getCoinTip.mas_bottom).with.offset(10);
        make.height.mas_equalTo(44);
    }];
    [self.coinHasGetTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.getCoinLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.resultBg);
        make.size.mas_equalTo(CGSizeMake(96, 16));
    }];
    [self.otherGetBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.resultBg.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.view);
    }];
    [self.otherGetTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherGetBg).with.offset(14);
        make.left.equalTo(self.otherGetBg).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 16));
    }];
    [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.otherGetBg);
        make.right.equalTo(self.otherGetBg);
        make.top.equalTo(self.otherGetBg).with.offset(43.5);
        make.height.mas_equalTo(0.5);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.otherGetBg);
        make.right.equalTo(self.otherGetBg);
        make.top.equalTo(self.otherGetBg).with.offset(44);
        make.bottom.equalTo(self.otherGetBg).with.offset(iPhoneX ? -34 : 0);
    }];
    [self.otherEmptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.otherGetBg);
        make.right.equalTo(self.otherGetBg);
        make.height.mas_equalTo(22);
        make.centerY.equalTo(self.listView);
    }];
}

- (void)updateCoinLabel:(NSInteger)coinCount {
    if (coinCount < 0) {
        coinCount = 0;
    }
    NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",coinCount]];
    NSRange idRange = NSMakeRange(0, attrIdStr.length);
    // 设置字体大小
    [attrIdStr addAttribute:NSFontAttributeName value:self.getCoinLabel.font range:idRange];
    // 设置颜色
    [attrIdStr addAttribute:NSForegroundColorAttributeName value:self.getCoinLabel.textColor range:idRange];
    // 文字中加图片
    NSTextAttachment *attachmentID=[[NSTextAttachment alloc] init];
    UIImage *idImg=[UIImage imageNamed_sy:@"transgerBeeCoin"];
    attachmentID.image = idImg;
    attachmentID.bounds=CGRectMake(-4, 2, idImg.size.width, idImg.size.height);
    NSAttributedString *idImgStr = [NSAttributedString attributedStringWithAttachment:attachmentID];
    [idTextAttrStr appendAttributedString:idImgStr];
    [idTextAttrStr appendAttributedString:attrIdStr];
    
    self.getCoinLabel.attributedText = idTextAttrStr;
}

#pragma mark - Private

// 返回
- (void)handleGoBackBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionDelegate & UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.resultModel) {
        return self.resultModel.list.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomGetRedPacketUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYVoiceRoomGetRedPacketUserCellId forIndexPath:indexPath];
    SYRoomGroupRedpacketGetUserModel *model = [self.resultModel.list objectAtIndex:indexPath.item];
    [cell configueData:model.receiver_useravatar
                  name:model.receiver_username
             coinCount:model.coins
               getTime:model.create_time];
    return cell;
}

#pragma mark - Lazyload

- (UIButton *)goBackBtn {
    if (!_goBackBtn) {
        _goBackBtn = [UIButton new];
        [_goBackBtn addTarget:self action:@selector(handleGoBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_goBackBtn setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_back_normale"] forState:UIControlStateNormal];
        [_goBackBtn setImage:[UIImage imageNamed_sy:@"voiceroom_topnav_back_selected"] forState:UIControlStateHighlighted];
    }
    return _goBackBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(11,11,11,1);
        _titleLabel.text = @"倒计时红包";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _titleLabel;
}

- (UIView *)resultBg {
    if (!_resultBg) {
        _resultBg = [UIView new];
        _resultBg.backgroundColor = [UIColor whiteColor];
    }
    return _resultBg;
}

- (UIImageView *)ownerIcon {
    if (!_ownerIcon) {
        _ownerIcon = [UIImageView new];
        _ownerIcon.clipsToBounds = YES;
        _ownerIcon.layer.cornerRadius = 4;
    }
    return _ownerIcon;
}

- (UILabel *)ownerName {
    if (!_ownerName) {
        _ownerName = [UILabel new];
        _ownerName.textColor = RGBACOLOR(11,11,11,1);
        _ownerName.textAlignment = NSTextAlignmentCenter;
        _ownerName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _ownerName;
}

- (UILabel *)getCoinTip {
    if (!_getCoinTip) {
        _getCoinTip = [UILabel new];
        _getCoinTip.textColor = RGBACOLOR(11,11,11,1);
        _getCoinTip.text = @"抢到蜜豆";
        _getCoinTip.textAlignment = NSTextAlignmentCenter;
        _getCoinTip.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    }
    return _getCoinTip;
}

- (UILabel *)getCoinLabel {
    if (!_getCoinLabel) {
        _getCoinLabel = [UILabel new];
        _getCoinLabel.textColor = RGBACOLOR(11,11,11,1);
        _getCoinLabel.textAlignment = NSTextAlignmentCenter;
        _getCoinLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:50];
    }
    return _getCoinLabel;
}

- (UILabel *)coinHasGetTip {
    if (!_coinHasGetTip) {
        _coinHasGetTip = [UILabel new];
        _coinHasGetTip.textColor = RGBACOLOR(102,102,102,1);
        _coinHasGetTip.text = @"蜜豆已经打入钱包";
        _coinHasGetTip.textAlignment = NSTextAlignmentCenter;
        _coinHasGetTip.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    }
    return _coinHasGetTip;
}

- (UIView *)otherGetBg {
    if (!_otherGetBg) {
        _otherGetBg = [UIView new];
        _otherGetBg.backgroundColor = [UIColor whiteColor];
    }
    return _otherGetBg;
}

- (UILabel *)otherGetTip {
    if (!_otherGetTip) {
        _otherGetTip = [UILabel new];
        _otherGetTip.textColor = RGBACOLOR(102,102,102,1);
        _otherGetTip.text = @"大家的手气";
        _otherGetTip.textAlignment = NSTextAlignmentCenter;
        _otherGetTip.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    }
    return _otherGetTip;
}

- (UIView *)horizonLine {
    if (!_horizonLine) {
        _horizonLine = [UIView new];
        _horizonLine.backgroundColor = RGBACOLOR(0,0,0,0.08);
    }
    return _horizonLine;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(self.view.sy_width, 72);
        _listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.backgroundColor = [UIColor clearColor];
        _listView.delegate = self;
        _listView.dataSource = self;
        [_listView registerClass:[SYVoiceRoomGetRedPacketUserCell class] forCellWithReuseIdentifier:SYVoiceRoomGetRedPacketUserCellId];
    }
    return _listView;
}

- (UILabel *)otherEmptyLabel {
    if (!_otherEmptyLabel) {
        _otherEmptyLabel = [UILabel new];
        _otherEmptyLabel.textColor = RGBACOLOR(102,102,102,1);
        _otherEmptyLabel.text = @"你是第一个抢到此红包的人哦~";
        _otherEmptyLabel.textAlignment = NSTextAlignmentCenter;
        _otherEmptyLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    }
    return _otherEmptyLabel;
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

@end
