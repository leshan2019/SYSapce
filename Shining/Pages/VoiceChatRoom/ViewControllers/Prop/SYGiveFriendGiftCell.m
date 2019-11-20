//
//  SYGiveFriendGiftCell.m
//  Shining
//
//  Created by 杨玄 on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiveFriendGiftCell.h"
#import "SYVoiceRoomSexView.h"

@interface SYGiveFriendGiftCell ()

@property (strong, nonatomic) UIImageView *avatarView;      //头像
@property (strong, nonatomic) UILabel *titleLabel;          //name
@property (strong, nonatomic) SYVoiceRoomSexView *sexView;  //性别
@property (strong, nonatomic) UIImageView *idImage;         //id图片
@property (strong, nonatomic) UILabel *idLabel;             //id
@property (strong, nonatomic) UIImageView *selectImage;     //选中状态
@property (strong, nonatomic) UIView *bottomLine;           //分割线

@end

@implementation SYGiveFriendGiftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.sexView];
        [self.contentView addSubview:self.idImage];
        [self.contentView addSubview:self.idLabel];
        [self.contentView addSubview:self.selectImage];
        [self.contentView addSubview:self.bottomLine];

        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).with.offset(14);
            make.top.equalTo(self.contentView).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 21));
        }];

        [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).with.offset(4);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(34, 14));
        }];

        [self.idImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).with.offset(14);
            make.bottom.equalTo(self.contentView).with.offset(-18);
            make.size.mas_equalTo(CGSizeMake(13, 13));
        }];

        [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.idImage.mas_right).with.offset(4);
            make.centerY.equalTo(self.idImage.mas_centerY);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(14);
        }];

        [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(21, 21));
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

- (void)updateCellWithHeaderImage:(NSString *)imageUrl withName:(NSString *)name withGender:(NSString *)gender withAge:(NSUInteger)age withId:(NSString *)idText {

    // icon
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];

    // sex
    [self.sexView setSex:gender andAge:age];
    CGFloat sexWidth = self.sexView.frame.size.width;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sexWidth);
    }];

    // name
    self.titleLabel.text = name;
    CGFloat maxWidth = __MainScreen_Width - 71 - sexWidth - 4 - 21 - 20 - 20;
    CGFloat titleWidth = [name sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}].width;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];

    // id
    self.idLabel.text = idText;
}

- (void)updateSyGiveFriendCellSelectState:(BOOL)select {
    if (select) {
        self.selectImage.image = [UIImage imageNamed_sy:@"im_select"];
    } else {
        self.selectImage.image = [UIImage imageNamed_sy:@"im_no_select"];
    }
}

#pragma mark - LazyLoad

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 21;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _avatarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];;
        _titleLabel.textColor = RGBACOLOR(11, 11, 11, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _titleLabel;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [UILabel new];
        _idLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _idLabel.backgroundColor = [UIColor clearColor];
        _idLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        _idLabel.textColor = RGBACOLOR(0, 0, 0, 1);
        _idLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _idLabel;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc]initWithFrame:CGRectZero];
    }
    return _sexView;
}

- (UIImageView *)idImage {
    if (!_idImage) {
        _idImage = [UIImageView new];
        _idImage.image = [UIImage imageNamed_sy:@"voiceroom_id"];
    }
    return _idImage;
}

- (UIImageView *)selectImage {
    if (!_selectImage) {
        _selectImage = [UIImageView new];
    }
    return _selectImage;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

@end
