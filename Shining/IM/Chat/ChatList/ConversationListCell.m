//
//  ConversationListCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "ConversationListCell.h"

@implementation ConversationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.sexView];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.badgeView];
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

        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).with.offset(14);
            make.bottom.equalTo(self.contentView).with.offset(-15);
            make.height.mas_equalTo(18);
            make.right.equalTo(self.badgeView.mas_left).with.offset(-10);
        }];

        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-15);
            make.bottom.equalTo(self.contentView).with.offset(-41);
            make.size.mas_equalTo(CGSizeMake(67, 16));
        }];
        
        [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-15);
            make.top.equalTo(self.timeLabel.mas_bottom).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(25, 18));
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

- (void)setModel:(id<IConversationModel>)model
{
    _model = model;

    NSString *titleText = @"";

    if ([_model.title length] > 0) {
        titleText = _model.title;
    } else{
        titleText = _model.conversation.conversationId;
    }

    CGFloat maxWidth = __MainScreen_Width - 71 - 34 - 4 - 67 - 15 - 4;
    CGFloat titleWidth = [titleText sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}].width;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    self.titleLabel.text = titleText;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];

    if ([_model.avatarURLPath length] > 0){
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_model.avatarURLPath] placeholderImage:_model.avatarImage];
    } else {
        if (_model.avatarImage) {
            self.avatarView.image = _model.avatarImage;
        }
    }

    // TODO：sex 和  age 没有数据啊
    NSDictionary *dict = _model.conversation.ext;
    NSString *ageStr = dict[@"age"];
    NSString *gender = dict[@"gender"];
    BOOL isFemale = NO;
    NSInteger age = 0;
    if (![NSString sy_isBlankString:gender]) {
        isFemale =  [gender isEqualToString:@"female"];
    }
    if (![NSString sy_isBlankString:ageStr]) {
        age = [ageStr integerValue];
    }
    [self.sexView setSex:gender andAge:age];
    CGSize size = self.sexView.frame.size;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];

    [self setBadgeCount:_model.conversation.unreadMessagesCount];
}

- (void)setBadgeCount:(NSUInteger)count {

    _badgeView.hidden = (count <= 0);

    if (count > 99) {
        _badgeView.text = @"99+";
    } else{
        _badgeView.text = [NSString stringWithFormat:@"%ld", (long)count];
    }
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

- (UILabel *)badgeView {
    if (!_badgeView) {
        _badgeView = [UILabel new];
        _badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        _badgeView.backgroundColor = RGBACOLOR(255, 0, 0, 1);
        _badgeView.textColor = [UIColor whiteColor];
        _badgeView.clipsToBounds = YES;
        _badgeView.layer.cornerRadius = 8.5;
        _badgeView.textAlignment = NSTextAlignmentCenter;
        _badgeView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    }
    return _badgeView;
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

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        _detailLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _detailLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLabel.backgroundColor = [UIColor clearColor];;
        _timeLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    }
    return _timeLabel;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc]initWithFrame:CGRectZero];
    }
    return _sexView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

@end
