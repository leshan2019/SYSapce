//
//  SYStatusBarNotificationView.m
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/7/9.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import "SYStatusBarNotificationView.h"


@interface SYStatusBarNotificationView ()
@property (nonatomic, strong)UIImageView *iconView;
@property (nonatomic, strong)UILabel *appNameLbl;
@property (nonatomic, strong)UILabel *titleLbl;
@property (nonatomic, strong)UILabel *bodyLbl;

@end

@implementation SYStatusBarNotificationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)setupView {

    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.offset(-5);
        make.bottom.equalTo(self);
    }];

    [self.backView addSubview:self.iconView];
    self.iconView.layer.cornerRadius = 5;
    self.iconView.layer.masksToBounds = YES;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(5);
        make.top.equalTo(self.backView).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [self.backView addSubview:self.appNameLbl];
    [self.appNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).with.offset(5);
        make.top.equalTo(self.backView).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];

    [self.backView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(5);
        make.top.mas_equalTo(self.iconView.mas_bottom).with.offset(2);
        make.right.mas_equalTo(self.backView.mas_right).with.offset(-5);
        make.height.mas_equalTo(14);
    }];
    [self.backView addSubview:self.bodyLbl];
    [self.bodyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).with.offset(5);
        make.top.mas_equalTo(self.titleLbl.mas_bottom);
        make.right.mas_equalTo(self.backView.mas_right).with.offset(-5);
        make.bottom.mas_equalTo(self.backView.mas_bottom).with.offset(-3);
    }];
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85];
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.backgroundColor = [UIColor clearColor];
        [_iconView setImage:[UIImage imageNamed:@"AppIcon"]];
    }
    return _iconView;
}

- (UILabel *)appNameLbl {
    if (!_appNameLbl) {
        _appNameLbl = [UILabel new];
        _appNameLbl.backgroundColor = [UIColor clearColor];
        _appNameLbl.textColor = [UIColor blackColor];
        _appNameLbl.font = [UIFont systemFontOfSize:12];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        _appNameLbl.text = app_Name;
    }
    return _appNameLbl;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLbl;
}

- (UILabel *)bodyLbl {
    if (!_bodyLbl) {
        _bodyLbl = [UILabel new];
        _bodyLbl.backgroundColor = [UIColor clearColor];
        _bodyLbl.textColor = [UIColor blackColor];
        _bodyLbl.font = [UIFont systemFontOfSize:14];
        _bodyLbl.numberOfLines = 0;
        _bodyLbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _bodyLbl;
}



- (void)bindDataWithTitle:(NSString *)title body:(NSString *)body {
    if ([NSString sy_isBlankString:title]) {
        self.titleLbl.hidden = YES;
        [self.titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        self.titleLbl.text = @"";
    }else {
        self.titleLbl.hidden = NO;
        [self.titleLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        self.titleLbl.text = [NSString sy_safeString:title];
    }
    self.bodyLbl.text = [NSString sy_safeString:body];
}

@end
