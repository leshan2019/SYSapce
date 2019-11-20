//
//  SYCommentCell.m
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCommentCell.h"
#import "SYVoiceRoomSexView.h"

@interface SYCommentCell ()

@property (nonatomic, strong) UIImageView *avatarView;          // 头像
@property (nonatomic, strong) UILabel *nameLabel;               // 姓名
@property (strong, nonatomic) SYVoiceRoomSexView *sexView;      // 性别
@property (nonatomic, strong) UILabel *titleLabel;              // 主题
@property (nonatomic, strong) UILabel *timeLabel;               // 时间
@property (nonatomic, strong) UIView *bottomLine;               // 分割线

@end

@implementation SYCommentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

#pragma mark - Public

- (void)configueSYCommentCell:(NSString *)avatarUrl name:(NSString *)name gender:(NSString *)gender age:(NSInteger)age content:(NSString *)content time:(NSString *)time {
    // avatar
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:nil];
    // name
    self.nameLabel.text = name;
    CGFloat maxWidth = __MainScreen_Width - 51 - 40 - 20;
    CGFloat titleWidth = [name sizeWithAttributes:@{NSFontAttributeName: self.nameLabel.font}].width;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];
    // gender
    [self.sexView setSex:gender andAge:age];
    CGFloat sexWidth = self.sexView.frame.size.width;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sexWidth);
    }];
    // title
    self.titleLabel.text = content;
    CGFloat width = self.contentView.sy_width - 51 - 20;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([SYCommentCell heightForTitle:content withWidth:width font:self.titleLabel.font]);
    }];
    // time
    self.timeLabel.text = time;
}

+ (CGFloat)calculateSYCommentCellHeightWithTitleWidth:(CGFloat)width content:(NSString *)content {
    CGFloat cellHeight = 30;
    if (content.length > 0) {
        cellHeight += 3;
        cellHeight += [SYCommentCell heightForTitle:content withWidth:width font:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    }
    cellHeight += (3 + 17 + 10 + 1);
    return cellHeight;
}

+ (CGFloat)heightForTitle:(NSString *)title withWidth:(CGFloat)width font:(UIFont *)font{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    CGSize size =  [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    // 取整+1
    CGFloat height = ceil(size.height) + 1;
    return height;
}

#pragma mark - Private

- (void)initSubViews {
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.sexView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomLine];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(19);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(5);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(3);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.height.mas_equalTo(0);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(3);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.height.mas_equalTo(17);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - Lazyload

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.backgroundColor = [UIColor redColor];
        _avatarView.layer.cornerRadius = 13;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBACOLOR(144,144,144,1);
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc]initWithFrame:CGRectZero];
    }
    return _sexView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(48,48,48,1);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGBACOLOR(144,144,144,1);
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(242,242,242,1);
    }
    return _bottomLine;
}

@end
