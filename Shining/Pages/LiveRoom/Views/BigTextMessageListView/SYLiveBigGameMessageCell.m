//
//  SYVLiveBigGameMessageCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveBigGameMessageCell.h"
#import "SYChatEngineEnum.h"
#import "SYVIPLevelView.h"
#import "SYVoiceTextMessageViewModel.h"
#import "SYVoiceRoomGameManager.h"
#import "SYBroadcasterLevelView.h"

@interface SYLiveBigGameMessageCell ()

@property (nonatomic, strong) UIView *textShadow;
@property (nonatomic, strong) SYBroadcasterLevelView *broadcasterLevelView;
@property (nonatomic, strong) SYVIPLevelView *senderVipView;
@property (nonatomic, strong) UILabel *senderLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation SYLiveBigGameMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textShadow];
        [self.contentView addSubview:self.broadcasterLevelView];
        [self.contentView addSubview:self.senderVipView];
        [self.contentView addSubview:self.senderLabel];
        [self.contentView addSubview:self.iconView];
    }
    return self;
}

- (void)showWithViewModel:(SYVoiceTextMessageViewModel *)viewModel {
    BOOL isBroadcaster = (viewModel.isBroadcaster == 1) || (viewModel.isSuperAdmin == 1);
    if (isBroadcaster) {
        self.broadcasterLevelView.hidden = NO;
        self.senderVipView.sy_left = self.broadcasterLevelView.sy_right + 4.f;
        [self.broadcasterLevelView showWithBroadcasterLevel:viewModel.broadcasterLevel];
       
    } else {
        self.broadcasterLevelView.hidden = YES;
        self.senderVipView.sy_left = self.broadcasterLevelView.sy_left;
    }
    [self.broadcasterLevelView showWithBroadcasterLevel:viewModel.broadcasterLevel];
    [self.senderVipView showWithVipLevel:viewModel.userLevel];
    if(viewModel.isSuperAdmin == 1){
        [self.broadcasterLevelView showWithSuperAdmin];
    }
    NSString *gameString = @"";
    
    if (viewModel.messageType == SYVoiceTextMessageTypeGame) {
        NSInteger gameValue = viewModel.gameValue;
        SYVoiceRoomGameType gameType = viewModel.gameType;
        if (gameType == SYVoiceRoomGameTouzi) {
            gameString = @"掷骰子结果";
        } else if (gameType == SYVoiceRoomGameCaiquan) {
            gameString = @"猜拳出了";
        } else if (gameType == SYVoiceRoomGameNumber) {
            gameString = @"摇数字结果";
        } else if (gameType == SYVoiceRoomGameBaodeng) {
            gameString = @"爆灯了";
        }
        NSString *imageName = [SYVoiceRoomGameManager gameImageNameWithGameType:gameType
                                                                          value:gameValue];
        self.iconView.image = [UIImage imageNamed_sy:imageName];
    } else if (viewModel.messageType == SYVoiceTextMessageTypeExpression) {
        gameString = @"";
        [self.iconView setImageWithURL:[NSURL URLWithString:viewModel.expressionIcon]];
    }
    
    CGFloat textMaxWidth = (self.sy_width - 20.f - 80.f);
    if (isBroadcaster) {
        textMaxWidth -= 48.f;
    }
    
    NSString *message = @"";
    CGFloat textWidth = 0;
    if (viewModel.messageType == SYVoiceTextMessageTypeGame) {
        self.senderLabel.textColor = [UIColor whiteColor];
        message = [NSString stringWithFormat:@"%@ %@ ",viewModel.username, gameString];
        CGRect rect = [message boundingRectWithSize:CGSizeMake(999, self.senderLabel.sy_height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.senderLabel.font}
                                            context:nil];
        textWidth = rect.size.width;
        if (textMaxWidth < textWidth) {
            if (viewModel.username.length > 4) {
                NSString *replace = [[viewModel.username substringToIndex:4] stringByAppendingString:@"..."];
                message = [NSString stringWithFormat:@"%@ %@ ",replace, gameString];
                rect = [message boundingRectWithSize:CGSizeMake(textMaxWidth, self.senderLabel.sy_height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: self.senderLabel.font}
                                             context:nil];
                textWidth = rect.size.width;
            }
        }
    } else if (viewModel.messageType == SYVoiceTextMessageTypeExpression) {
        self.senderLabel.textColor = [UIColor sam_colorWithHex:@"#FBE797"];
        NSString *uName = viewModel.username;
        if (iPhone5) {
            if (viewModel.username.length > 5) {
                uName = [[viewModel.username substringToIndex:5] stringByAppendingString:@"..."];
            }
        } else {
            if (viewModel.username.length > 9) {
                uName = [[viewModel.username substringToIndex:9] stringByAppendingString:@"..."];
            }
        }
        message = [NSString stringWithFormat:@"%@: ",uName];
        CGRect rect = [message boundingRectWithSize:CGSizeMake(999, self.senderLabel.sy_height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.senderLabel.font}
                                            context:nil];
        textWidth = rect.size.width;
    }
    
    self.senderLabel.sy_left = self.senderVipView.sy_right + 4.f;
    self.senderLabel.sy_width = textWidth;
    self.senderLabel.text = message;
    self.iconView.sy_left = self.senderLabel.sy_right + 2.f;
    
    CGFloat width = self.iconView.sy_right - self.broadcasterLevelView.sy_left;
    width += 12.f;
    self.textShadow.sy_width = width;
}

- (UIView *)textShadow {
    if (!_textShadow) {
        _textShadow = [[UIView alloc] initWithFrame:CGRectMake(10.f, 2.f, self.bounds.size.width - 20.f, self.sy_height - 2.f)];
        _textShadow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _textShadow.layer.cornerRadius = 13.f;
    }
    return _textShadow;
}

- (SYVIPLevelView *)senderVipView {
    if (!_senderVipView) {
        _senderVipView = [[SYVIPLevelView alloc] initWithFrame:CGRectMake(16, 9, 34, 14)];
        [_senderVipView makeBiger];
    }
    return _senderVipView;
}

- (SYBroadcasterLevelView *)broadcasterLevelView {
    if (!_broadcasterLevelView) {
        _broadcasterLevelView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectMake(16.f, 9, 0, 0)];
        [_broadcasterLevelView makeBiger];
    }
    return _broadcasterLevelView;
}

- (UILabel *)senderLabel {
    if (!_senderLabel) {
        _senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 6.f, 0, 26.f)];
        _senderLabel.font = [UIFont systemFontOfSize:18.f weight:UIFontWeightSemibold];
        _senderLabel.textColor = [UIColor whiteColor];
        _senderLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_senderLabel addGestureRecognizer:tap];
    }
    return _senderLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        CGFloat side = 24.f;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.senderLabel.sy_right, (self.sy_height - side) / 2.f, side, side)];
    }
    return _iconView;
}

- (void)tap:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = [tap view];
    if (self.senderLabel == view) {
        if ([self.delegate respondsToSelector:@selector(voiceTextMessageCellDidTapUsernameWithCell:)]) {
            [self.delegate voiceTextMessageCellDidTapUsernameWithCell:self];
        }
    }
}

@end
