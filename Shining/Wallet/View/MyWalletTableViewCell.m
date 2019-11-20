//
//  MyWalletTableViewCell.m
//  Shining
//
//  Created by letv_lzb on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "MyWalletTableViewCell.h"
#import "SYMyWalletModel.h"

@interface MyWalletTableViewCell ()
@property (nonatomic, strong)id model;
@property (nonatomic, strong)UIImageView *bgView;
@property (nonatomic, strong)UILabel *numberLbl;
@property (nonatomic, strong)UILabel *iconLbl;
@property (nonatomic, strong)UILabel *desLbl;
@property (nonatomic, strong)UIButton *actBtn;

@end

@implementation MyWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}


- (void)setUpView {
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
        [_bgView setImage:[UIImage imageNamed_sy:@"coin_bg"]];
    }
    if (nil == _bgView.superview) {
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(20, 20, 0, 20));
        }];
    }
    if (!_numberLbl) {
        _numberLbl = [[UILabel alloc] init];
        _numberLbl.backgroundColor = [UIColor clearColor];
        _numberLbl.textColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _numberLbl.font = [UIFont systemFontOfSize:40];
        _numberLbl.text = @"188";
    }
    if (!_numberLbl.superview) {
        [_bgView addSubview:_numberLbl];
        [_numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.bgView.mas_left).with.offset(20);
            make.top.mas_equalTo(weakSelf.bgView.mas_top).with.offset(29);
            make.size.mas_equalTo(CGSizeMake(70, 50));
        }];
    }
    if (!_iconLbl) {
        _iconLbl = [[UILabel alloc] init];
        _iconLbl.backgroundColor = [UIColor clearColor];
        _iconLbl.textColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _iconLbl.font = [UIFont systemFontOfSize:16];
        _iconLbl.text = @"蜜豆";
    }
    if (!_iconLbl.superview) {
        [_bgView addSubview:_iconLbl];
        [_iconLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.numberLbl.mas_right).with.offset(2);
            make.bottom.mas_equalTo(weakSelf.numberLbl.mas_bottom).with.offset(-8);
            make.size.mas_equalTo(CGSizeMake(60, 22));
        }];
    }
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.backgroundColor = [UIColor clearColor];
        _desLbl.textColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _desLbl.font = [UIFont systemFontOfSize:12];
        _desLbl.text = @"用于在聊天室中购买礼物～";
    }
    if (!_desLbl.superview) {
        [_bgView addSubview:_desLbl];
        [_desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.numberLbl.mas_left);
            make.top.mas_equalTo(weakSelf.numberLbl.mas_bottom).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(160, 18));

        }];
    }
    if (!_actBtn) {
        _actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _actBtn.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _actBtn.layer.cornerRadius = 14;
        [_actBtn setTitleColor:[UIColor sy_colorWithHexString:@"#7138EF"] forState:UIControlStateNormal];
        _actBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_actBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_actBtn addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    }

    if (!_actBtn.superview) {
        [_bgView addSubview:_actBtn];
        [_actBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.bgView.mas_right).with.offset(-10);
            make.bottom.mas_equalTo(weakSelf.bgView.mas_bottom).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(64, 28));
        }];
    }
}


- (void)doAction {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)bindData:(id)item {
    if (item == self.model) {
        return;
    }
    self.model = item;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self.model isKindOfClass:[SYMyWalletModel class]]) {
        SYMyWalletModel *item = self.model;
        NSString *bgImgName = @"coin_bg";
        if (item.type == 2) {
            bgImgName = @"shine_bg";
            _iconLbl.text = @"蜜糖";
            [_actBtn setTitle:@"查看" forState:UIControlStateNormal];
        }else{
            _iconLbl.text = @"蜜豆";
            [_actBtn setTitle:@"充值" forState:UIControlStateNormal];
        }
        [self.bgView setImage:[UIImage imageNamed_sy:bgImgName]];

        NSString *numberStr = item.number;
        CGSize numerSize = [numberStr boundingRectWithSize:CGSizeMake(300, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _numberLbl.font} context:nil].size;
        numerSize.width += 1;
        _numberLbl.text = numberStr;
        [_numberLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(numerSize);
        }];
        _desLbl.text = item.descrip;
        CGSize desSize = [item.descrip boundingRectWithSize:CGSizeMake(250, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _desLbl.font} context:nil].size;
        desSize.width += 1;
        [_desLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(desSize);
        }];
    }
}

@end
