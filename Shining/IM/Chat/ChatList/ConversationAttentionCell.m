//
//  ConversationAttentionCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "ConversationAttentionCell.h"
#import "SYVoiceRoomSexView.h"

@interface ConversationAttentionCell ()

@property (strong, nonatomic) UIImageView *avatarView;      //头像
@property (strong, nonatomic) UILabel *titleLabel;          //name
@property (strong, nonatomic) SYVoiceRoomSexView *sexView;  //性别
@property (strong, nonatomic) UIImageView *idImage;         //id图片
@property (strong, nonatomic) UILabel *idLabel;             //id
@property (strong, nonatomic) UIView *bottomLine;           //分割线
@property (strong, nonatomic) UIButton *enterChatRoomBtn;   //聊天室内显示按钮

@property (copy, nonatomic) NSString *chatRoomId;          //所在房间id

@end

@implementation ConversationAttentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.sexView];
        [self.contentView addSubview:self.idImage];
        [self.contentView addSubview:self.idLabel];
        [self.contentView addSubview:self.enterChatRoomBtn];
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

        [self.enterChatRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-32);
            make.size.mas_equalTo(CGSizeMake(62, 22));
        }];

        [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.idImage.mas_right).with.offset(4);
            make.centerY.equalTo(self.idImage.mas_centerY);
            make.right.equalTo(self.enterChatRoomBtn.mas_left).with.offset(-4);
            make.height.mas_equalTo(14);
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

- (void)updateCellWithHeaderImage:(NSString *)imageUrl withName:(NSString *)name withGender:(NSString *)gender withAge:(NSUInteger)age withId:(NSString *)idText withRoomId:(nonnull NSString *)roomId{

    // roomId
    self.chatRoomId = roomId;

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
    CGFloat maxWidth = __MainScreen_Width - 71 - sexWidth - 4 - 30 - 94;
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

- (void)setChatRoomId:(NSString *)chatRoomId {
    _chatRoomId = chatRoomId;
    self.enterChatRoomBtn.hidden = [NSString sy_isBlankString:chatRoomId];
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

- (UIButton *)enterChatRoomBtn {
    if (!_enterChatRoomBtn) {
        _enterChatRoomBtn = [UIButton new];
        [_enterChatRoomBtn setTitle:@"直播中" forState:UIControlStateNormal];
        [_enterChatRoomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterChatRoomBtn setTitleColor:RGBACOLOR(255, 255, 255, 0.8) forState:UIControlStateHighlighted];
        _enterChatRoomBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        [_enterChatRoomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
        [_enterChatRoomBtn setBackgroundImage:[UIImage imageNamed_sy:@"im_attention_list_living"] forState:UIControlStateNormal];
        [_enterChatRoomBtn setBackgroundImage:[UIImage imageNamed_sy:@"im_attention_list_living_high"] forState:UIControlStateHighlighted];
        [_enterChatRoomBtn addTarget:self action:@selector(handleEnterChatRoomBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _enterChatRoomBtn.hidden = YES;
    }
    return _enterChatRoomBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

- (void)handleEnterChatRoomBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ConversationAttentionCellClickEnterChatRoomWithRoomId:)]) {
        [self.delegate ConversationAttentionCellClickEnterChatRoomWithRoomId:self.chatRoomId];
    }
}

@end
