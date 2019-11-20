//
//  SYSystemMsgTableViewCell.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYSystemMsgTableViewCell.h"

//#import <Masonry.h>
//#import <UIImageView+WebCache.h>

@implementation SYSystemMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.linkBtn];
        [self.contentView addSubview:self.lineLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(18);
            
            make.right.equalTo(self.contentView).with.offset(-15);
            make.height.mas_equalTo(12);
        }];
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_top);
            make.left.equalTo(self.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).with.offset(14);
//            make.top.equalTo(self.timeLabel.mas_top);
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(-7);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).with.offset(-12);
            
        }];
        
        [self.linkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.mas_equalTo(14);
        }];
        
        [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_bottom).with.offset(-1);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    
    }
    return self;
}


#pragma mark - LazyLoad

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 21;
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _avatarView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLabel.backgroundColor = [UIColor clearColor];;
        _timeLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = RGBACOLOR(11, 11, 11, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 3 ;
        _titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    }
    return _titleLabel;
}

- (UIButton *)linkBtn {
    if (!_linkBtn) {
        _linkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _linkBtn.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"点击查看"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSFontAttributeName
                     value:[UIFont systemFontOfSize:14.0]
                     range:strRange];
        [str addAttribute:NSForegroundColorAttributeName
                     value:[UIColor sam_colorWithHex:@"#7138EF"]
                     range:strRange];
        [_linkBtn setAttributedTitle:str forState:UIControlStateNormal];
        _linkBtn.hidden = YES;
    }
    return _linkBtn;
}

- (UIView *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [UIView new];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineLabel;
}

- (void)reloadTitleLabelSize:(BOOL)isLinkBtnHidden
{
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (!isLinkBtnHidden) {
            make.centerY.equalTo(self.contentView.mas_centerY).with.offset(-7);
        }else{
            make.centerY.equalTo(self.contentView.mas_centerY);
        }
    }];
    if (!isLinkBtnHidden) {
        [self.linkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.mas_equalTo(14);
        }];
    }
}

@end
