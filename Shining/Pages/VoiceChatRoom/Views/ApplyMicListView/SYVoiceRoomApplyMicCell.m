//
//  SYVoiceRoomApplyListCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomApplyMicCell.h"
#import "SYVoiceChatUserViewModel.h"
#import "SYVoiceRoomSexView.h"
#import "SYVIPLevelView.h"

@interface SYVoiceRoomApplyMicCell ()

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *avatarBox;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) SYVoiceRoomSexView *sexView;
@property (nonatomic, strong) SYVIPLevelView *vipView;

@end

@implementation SYVoiceRoomApplyMicCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.avatarBox];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.vipView];
        [self.contentView addSubview:self.sexView];
        [self.contentView addSubview:self.idLabel];
        [self.contentView addSubview:self.confirmButton];
    }
    return self;
}

- (void)drawWithUserViewModel:(SYVoiceChatUserViewModel *)userViewModel
                        index:(NSInteger)index
            needConfirmButton:(BOOL)needConfirmButton {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:userViewModel.avatarURL]
                       placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    [self.avatarBox sd_setImageWithURL:[NSURL URLWithString:userViewModel.avatarBox]];
    self.nameLabel.text = userViewModel.name;
    self.confirmButton.hidden = !needConfirmButton;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",(long)index];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@",userViewModel.uid];
    
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds) - CGRectGetMinX(self.nameLabel.frame) - 20.f - CGRectGetWidth(self.confirmButton.frame) - 80.f, CGRectGetHeight(self.nameLabel.frame));
    CGRect rect = [userViewModel.name boundingRectWithSize:maxSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: self.nameLabel.font}
                                                   context:nil];
    CGRect frame = self.nameLabel.frame;
    frame.size.width = rect.size.width;
    self.nameLabel.frame = frame;
    
    self.vipView.sy_left = self.nameLabel.sy_right + 4;
    [self.vipView showWithVipLevel:userViewModel.level];
    self.sexView.sy_left = self.vipView.sy_right + 4;
    [self.sexView setSex:userViewModel.gender
                     andAge:userViewModel.age];
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 30, 20)];
        _indexLabel.font = [UIFont systemFontOfSize:14.f];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentRight;
    }
    return _indexLabel;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        CGFloat width = 40.f;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(40.f, 10.f, width, width)];
        _avatarView.layer.cornerRadius = width / 2.f;
        _avatarView.clipsToBounds = YES;
//        _avatarView.layer.borderWidth = 1.f;
//        UIColor *purple = [UIColor colorWithRed:123/255.0 green:64/255.0 blue:255/255.0 alpha:1/1.0];
//        _avatarView.layer.borderColor = [purple CGColor];
    }
    return _avatarView;
}

- (UIImageView *)avatarBox {
    if (!_avatarBox) {
        _avatarBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52.f, 52.f)];
        _avatarBox.center = self.avatarView.center;
    }
    return _avatarBox;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarView.frame) + 6.f, 13.f, self.bounds.size.width - 144.f, 16.f)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _nameLabel;
}

- (SYVIPLevelView *)vipView {
    if (!_vipView) {
        _vipView = [[SYVIPLevelView alloc] initWithFrame:CGRectMake(self.avatarView.sy_right + 4, 13.f, 30, 14)];
    }
    return _vipView;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 13.f, 40.f, 14.f)];
    }
    return _sexView;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 4, 100, 14)];
        _idLabel.font = [UIFont systemFontOfSize:10.f];
        _idLabel.textColor = [UIColor grayColor];
    }
    return _idLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat height = 34.f;
        CGFloat width = 34.f;
        _confirmButton.frame = CGRectMake(self.bounds.size.width - width - 20.f, (self.bounds.size.height - height) / 2.f, width, height);
        _confirmButton.clipsToBounds = YES;
        _confirmButton.layer.cornerRadius = height / 2.f;
        [_confirmButton setTitle:@"抱Ta" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_confirmButton setBackgroundImage:[SYUtil imageFromColor:[UIColor sam_colorWithHex:@"#7B40FF"]] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self
                           action:@selector(confirm:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomApplyMicCellDidSelectConfirmButtonWithCell:)]) {
        [self.delegate voiceRoomApplyMicCellDidSelectConfirmButtonWithCell:self];
    }
}

@end
