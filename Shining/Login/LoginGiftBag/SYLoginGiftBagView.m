//
//  SYLoginGiftBagView.m
//  Shining
//
//  Created by 杨玄 on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLoginGiftBagView.h"
#import "SYLoginGiftBagViewCell.h"
#import "SYGiftModel.h"

#define SYLoginGiftViewCellID @"SYLoginGiftViewCellID"

@interface SYLoginGiftBagView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// UI
@property (nonatomic, strong) UIButton *boxView;        // 底部白框
@property (nonatomic, strong) UIImageView *tipImageView;        // @"首次登录APP，即可获取大礼包哦~"
@property (nonatomic, strong) UICollectionView *listView;    // 礼物列表
@property (nonatomic, strong) UIView *loginBackView;    // 登录按钮渐变view
@property (nonatomic, strong) UIButton *loginBtn;       // 登录按钮

@property (nonatomic, copy) tapLoginBlock loginBlock;

// Data
@property (nonatomic, strong) NSArray *giftArr;

@end

@implementation SYLoginGiftBagView

- (instancetype)initWithFrame:(CGRect)frame withBlock:(nonnull tapLoginBlock)block {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.loginBlock = block;
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    return self;
}

#pragma mark - Public

- (void)updateGiftBags:(NSArray *)gifts {
    self.giftArr = gifts;
    if (!gifts || gifts.count == 0) {
        [self removeFromSuperview];
        return;
    }
    [self initSubViews];
    [self mas_makeConstraints];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - Private

- (void)initSubViews {
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.tipImageView];
    [self.boxView addSubview:self.listView];
    [self.boxView addSubview:self.loginBackView];
    [self.loginBackView addSubview:self.loginBtn];
}

- (void)mas_makeConstraints {
    NSInteger gitCount = self.giftArr.count;
    CGFloat listHeight = 77;               // 单行高度，最多显示4个礼物
    if (gitCount > 4) {
        listHeight = 77 + 12 + 77;                 // 超过4个礼物，在另启一行
    }
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).with.offset(-14);
        make.size.mas_equalTo(CGSizeMake(276, 193 + listHeight));
    }];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.boxView);
        make.size.mas_equalTo(CGSizeMake(304, 113));
        make.top.equalTo(self.boxView).with.offset(-14);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxView).with.offset(14);
        make.right.equalTo(self.boxView).with.offset(-14);
        make.top.equalTo(self.tipImageView.mas_bottom).with.offset(17);
        make.height.mas_equalTo(listHeight);
    }];
    [self.loginBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.boxView);
        make.bottom.equalTo(self.boxView.mas_bottom).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(128, 34));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.loginBackView);
        make.size.mas_equalTo(CGSizeMake(128, 34));
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.giftArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYLoginGiftBagViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYLoginGiftViewCellID forIndexPath:indexPath];
    SYGiftModel *model = [self.giftArr objectAtIndex:indexPath.item];
    [cell updateSyLoginGiftBagViewCell:[NSString sy_safeString:model.icon]
                             withTitle:[NSString sy_safeString:model.name]];
    return cell;
}

#pragma mark - LazyLoad

- (UIButton *)boxView {
    if (!_boxView) {
        _boxView = [UIButton new];
        _boxView.backgroundColor = [UIColor whiteColor];
        _boxView.layer.cornerRadius = 10;
    }
    return _boxView;
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [UIImageView new];
        _tipImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tipImageView.image = [UIImage imageNamed_sy:@"sy_login_gift"];
    }
    return _tipImageView;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 12;
        layout.itemSize = CGSizeMake(56, 77);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.scrollEnabled = NO;
        [_listView registerClass:[SYLoginGiftBagViewCell class] forCellWithReuseIdentifier:SYLoginGiftViewCellID];
    }
    return _listView;
}

- (UIView *)loginBackView {
    if (!_loginBackView) {
        _loginBackView = [UIView new];
        [_loginBackView.layer addSublayer:[self gradientLayer]];
    }
    return _loginBackView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        [_loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(handleLoginBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (CAGradientLayer *)gradientLayer {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, 128, 34);
    layer.cornerRadius = 17;
    layer.colors = @[(__bridge id)RGBACOLOR(215,109,214,1).CGColor, (__bridge id)RGBACOLOR(123,37,220,1).CGColor];
    return layer;
}

- (void)handleLoginBtnClickEvent {
    if (self && !self.hidden && self.loginBlock) {
        self.loginBlock();
        [self removeFromSuperview];
    }
}

@end
