//
//  SYDynamicDeleteView.m
//  Shining
//
//  Created by yangxuan on 2019/10/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDynamicDeleteView.h"

@interface SYDynamicDeleteView ()

@property (nonatomic, strong) UIButton *bgView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *deleteLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, copy) DeleteBlock delete;
@property (nonatomic, copy) CancelBlock cancel;


@end

@implementation SYDynamicDeleteView

- (instancetype)initWithFrame:(CGRect)frame deleteBlock:(nonnull DeleteBlock)delete cancelBlock:(nonnull CancelBlock)cancel{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        self.delete = delete;
        self.cancel = cancel;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

- (void)initSubviews {
    self.backgroundColor = RGBACOLOR(0,0,0,0.35);
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.deleteBtn];
    [self.bgView addSubview:self.deleteLabel];
    [self.bgView addSubview:self.cancelBtn];
    [self mas_makeConstraint];
}

- (void)mas_makeConstraint {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(iPhoneX ? 126+34 : 126);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.equalTo(self.bgView);
    }];
    [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deleteBtn.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(20, 14));
        make.centerX.equalTo(self.bgView);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.deleteLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(48);
    }];
}

- (void)clickDeleteBtn {
    [self removeFromSuperview];
    if (self.delete) {
        self.delete();
    }
}

- (void)clickCancelBtn {
    [self removeFromSuperview];
    if (self.cancel) {
        self.cancel();
    }
}

#pragma mark - Lazyload

- (UIButton *)bgView {
    if (!_bgView) {
        _bgView = [UIButton new];
        _bgView.backgroundColor = RGBACOLOR(255,255,255,1);
    }
    return _bgView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_delete_window"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)deleteLabel {
    if (!_deleteLabel) {
        _deleteLabel = [UIButton new];
        _deleteLabel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        [_deleteLabel setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteLabel setTitleColor:RGBACOLOR(48,48,48,1) forState:UIControlStateNormal];
        [_deleteLabel addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBACOLOR(48,48,48,1) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
