//
//  SYVoiceChatRoomManagerCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//


#import "SYVoiceChatRoomManagerCell.h"
//#import <Masonry.h>
#import "SYVoiceRoomSexView.h"
//#import <UIImageView+WebCache.h>

@interface SYVoiceChatRoomManagerCell ()

@property (nonatomic, strong) UIImageView *headerIcon;      // 头像
@property (nonatomic, strong) UILabel *nameLabel;           // 名字
@property (nonatomic, strong) SYVoiceRoomSexView *sexView;  // 性别
@property (nonatomic, strong) UIImageView *idImage;         // idImage
@property (nonatomic, strong) UILabel *idLabel;             // idLabel

@property (nonatomic, strong) UIView *bottomLine;           //分割线

@end

@implementation SYVoiceChatRoomManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headerIcon];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.sexView];
        [self.contentView addSubview:self.idImage];
        [self.contentView addSubview:self.idLabel];
        [self.contentView addSubview:self.bottomLine];

        [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(52, 52));
        }];

        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerIcon.mas_right).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(28);
            make.size.mas_equalTo(CGSizeMake(86, 16));
        }];

        [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(34, 14));
            make.centerY.equalTo(self.nameLabel.mas_centerY);
        }];

        [self.idImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerIcon.mas_right).with.offset(11);
            make.bottom.equalTo(self.contentView).with.offset(-29);
            make.size.mas_equalTo(CGSizeMake(13, 13));
        }];

        [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.idImage.mas_right).with.offset(4);
            make.centerY.equalTo(self.idImage.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(51, 14));
        }];

        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)updateCellWithHeadImageUrl:(NSString *)imageUrl withName:(NSString *)name withGender:(NSString *)gender withAge:(NSUInteger)age withId:(NSString *)idText showSpaceLine:(BOOL)show {
    self.bottomLine.hidden = !show;

    // HeaderIcon
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    // Name
    self.nameLabel.text = name;
    CGFloat maxWidth = __MainScreen_Width - 77 - 34 - 4 - 20;
    NSInteger titleWidth = [name sizeWithAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14]}].width;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];
    // SexView
    [self.sexView setSex:gender andAge:age];
    CGSize size = self.sexView.frame.size;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
    // ID
    self.idLabel.text = idText;
    CGFloat idWidth = [idText sizeWithAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:12]}].width;
    [self.idLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(idWidth+1);
    }];
}

#pragma mark - LazyLoad

- (UIImageView *)headerIcon {
    if (!_headerIcon) {
        _headerIcon = [UIImageView new];
        _headerIcon.contentMode = UIViewContentModeScaleAspectFill;
        _headerIcon.clipsToBounds = YES;
        _headerIcon.layer.cornerRadius = 26;
        _headerIcon.layer.borderWidth = 0.87;
        _headerIcon.layer.borderColor = RGBACOLOR(123, 64, 255, 1).CGColor;
    }
    return _headerIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _nameLabel.textColor = RGBACOLOR(0, 0, 0, 1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc] initWithFrame:CGRectZero];
    }
    return _sexView;
}

- (UIImageView *)idImage {
    if (!_idImage) {
        _idImage = [UIImageView new];
        _idImage.contentMode = UIViewContentModeScaleAspectFit;
        _idImage.image = [UIImage imageNamed_sy:@"voiceroom_id"];
    }
    return _idImage;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [UILabel new];
        _idLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _idLabel.textColor = RGBACOLOR(0, 0, 0, 1);
        _idLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _idLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}
@end
