//
//  SYVoiceGiftMessageCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceGiftMessageCell.h"
#import "SYVoiceTextMessageViewModel.h"
#import "SYVIPLevelView.h"
#import "SYBroadcasterLevelView.h"

#define kLevelViewWidth 38.f

@interface SYVoiceGiftMessageCell ()

@property (nonatomic, strong) UIView *textShadow;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) SYVIPLevelView *senderVipView;
@property (nonatomic, strong) SYBroadcasterLevelView *broadcasterLevelView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *numsLabel;

@end

@implementation SYVoiceGiftMessageCell

+ (CGFloat)giftNumberWidthWithNum:(NSInteger)num {
    if (num <= 1) {
        return 0;
    }
    CGRect rect  = [[NSString stringWithFormat:@"x%ld", (long)num] boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [self messageFont]} context:nil];
    return rect.size.width;
}

+ (CGFloat)cellTextContentMaxWidthWithWidth:(CGFloat)width
                                    giftNum:(NSInteger)giftNum {
    CGFloat maxWidth = (width - 105.f - 6.f * 2);
    CGFloat giftwidth = 30.f * 70.f / 50.f ;
    maxWidth -= giftwidth;
    maxWidth -= [self giftNumberWidthWithNum:giftNum];
    return maxWidth;
}

+ (CGSize)cellSizeWithViewModel:(SYVoiceTextMessageViewModel *)viewModel
                          width:(CGFloat)width {
    CGSize size = CGSizeMake(0, 0);
    NSString *msg = [NSString stringWithFormat:@"%@打赏%@", viewModel.username, viewModel.receiverUsername];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
    [aString addAttribute:NSFontAttributeName
                    value:[self messageFont]
                    range:NSMakeRange(0, msg.length)];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    BOOL isBroadcaster = (viewModel.isBroadcaster == 1)|| (viewModel.isSuperAdmin ==1);
    NSInteger times = isBroadcaster ? 2 : 1;
    style.firstLineHeadIndent = kLevelViewWidth * times;
    style.lineSpacing = 3;
    [aString addAttribute:NSParagraphStyleAttributeName
                    value:style
                    range:NSMakeRange(0, msg.length)];
    CGFloat maxHeight = 999;
    CGRect rect = [aString boundingRectWithSize:CGSizeMake([self cellTextContentMaxWidthWithWidth:width giftNum:viewModel.giftNums], maxHeight)
                                        options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        context:nil];
    size = CGSizeMake(width, rect.size.height + 8.f + 2.f);
    return size;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textShadow];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.broadcasterLevelView];
        [self.contentView addSubview:self.senderVipView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.numsLabel];
    }
    return self;
}

- (void)showWithViewModel:(SYVoiceTextMessageViewModel *)viewModel {
    BOOL isBroadcaster = (viewModel.isBroadcaster == 1) || (viewModel.isSuperAdmin ==1);
    [self.senderVipView showWithVipLevel:viewModel.userLevel];
    [self.broadcasterLevelView showWithBroadcasterLevel:viewModel.broadcasterLevel];
    if (viewModel.isSuperAdmin ==1) {
        [self.broadcasterLevelView showWithSuperAdmin];
    }
    if (isBroadcaster) {
        self.senderVipView.sy_left = self.broadcasterLevelView.sy_right + 4.f;
    } else {
        self.senderVipView.sy_left = self.broadcasterLevelView.sy_left;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@打赏%@", viewModel.username, viewModel.receiverUsername];
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
    [aString addAttribute:NSFontAttributeName
                    value:[[self class] messageFont]
                    range:NSMakeRange(0, msg.length)];
    [aString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor whiteColor]
                    range:NSMakeRange(0, msg.length)];
    [aString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor sam_colorWithHex:@"#FE944E"]
                    range:[msg rangeOfString:@"打赏"]];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    NSInteger times = isBroadcaster ? 2 : 1;
    style.firstLineHeadIndent = kLevelViewWidth * times;
    style.lineSpacing = 3;
    [aString addAttribute:NSParagraphStyleAttributeName
                    value:style
                    range:NSMakeRange(0, msg.length)];
    self.messageLabel.attributedText = aString;
    
    CGRect rect = [aString boundingRectWithSize:CGSizeMake([[self class] cellTextContentMaxWidthWithWidth:self.sy_width giftNum:viewModel.giftNums], 999)
                                        options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        context:nil];
    CGSize size = CGSizeMake(rect.size.width, rect.size.height);
    if (size.height < 21) {
        BOOL isBroadcaster = (viewModel.isBroadcaster == 1)|| (viewModel.isSuperAdmin ==1);
        NSInteger times = isBroadcaster ? 2 : 1;
        size.width = size.width + kLevelViewWidth * times;
//        CGFloat maxWidth = [[self class] cellTextContentMaxWidthWithWidth:self.sy_width
//                                                                  giftNum:viewModel.giftNums];
//        if (size.width > maxWidth) {
//            size.width = maxWidth;
//            size.height += 21;
//        }
    }
    CGRect frame = CGRectMake(16.f, 6.f, size.width, MAX(size.height, 18.f));
    self.messageLabel.frame = frame;
    
    self.iconView.sy_left = self.messageLabel.sy_right;
    self.iconView.sy_top = (self.messageLabel.sy_height - self.iconView.sy_height) / 2.f + self.messageLabel.sy_top;
    [self.iconView setImageWithURL:[NSURL URLWithString:viewModel.giftURL]];
    
    NSInteger contentWidth = self.messageLabel.sy_width + self.iconView.sy_width;
    
    NSInteger giftNum = viewModel.giftNums;
    if (giftNum > 1) {
        self.numsLabel.sy_left = self.iconView.sy_right;
        self.numsLabel.sy_top = (self.messageLabel.sy_height - self.numsLabel.sy_height) / 2.f + self.messageLabel.sy_top;
        self.numsLabel.sy_width = [[self class] giftNumberWidthWithNum:giftNum];
        self.numsLabel.text = [NSString stringWithFormat:@"x%ld", (long)giftNum];
        self.numsLabel.hidden = NO;
        contentWidth += self.numsLabel.sy_width;
    } else {
        self.numsLabel.hidden = YES;
    }
    
    self.textShadow.frame = CGRectMake(10.f, 2.f, contentWidth + 12.f, self.messageLabel.sy_height + 8.f);
}

- (UIView *)textShadow {
    if (!_textShadow) {
        _textShadow = [[UIView alloc] initWithFrame:CGRectMake(10.f, 2.f, self.bounds.size.width - 20.f, self.sy_height - 2.f)];
        _textShadow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _textShadow.layer.cornerRadius = 13.f;
    }
    return _textShadow;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44.f)];
        _messageLabel.font = [[self class] messageFont];
        _messageLabel.numberOfLines = 0;
        _messageLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_messageLabel addGestureRecognizer:tap];
    }
    return _messageLabel;
}

- (SYVIPLevelView *)senderVipView {
    if (!_senderVipView) {
        _senderVipView = [[SYVIPLevelView alloc] initWithFrame:CGRectMake(16.f, 9, 34, 14)];
    }
    return _senderVipView;
}

- (SYBroadcasterLevelView *)broadcasterLevelView {
    if (!_broadcasterLevelView) {
        _broadcasterLevelView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectMake(16.f, 9, 0, 0)];
    }
    return _broadcasterLevelView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        CGFloat height = 30.f;
        CGFloat width = 30.f * 70.f / 50.f ;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.messageLabel.sy_right, 0, width, height)];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UILabel *)numsLabel {
    if (!_numsLabel) {
        _numsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.sy_right, 0, 0, 20)];
        _numsLabel.font = [[self class] messageFont];
        _numsLabel.textColor = [UIColor whiteColor];
    }
    return _numsLabel;
}

- (void)tap:(id)sender {
//    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
//    UIView *view = [tap view];
//    if (self.senderLabel == view) {
//        if ([self.delegate respondsToSelector:@selector(voiceTextMessageCellDidTapUsernameWithCell:)]) {
//            [self.delegate voiceTextMessageCellDidTapUsernameWithCell:self];
//        }
//    } else if (self.receiverLabel == view) {
//        if ([self.delegate respondsToSelector:@selector(voiceTextMessageCellDidTapReceiverNameWithCell:)]) {
//            [self.delegate voiceTextMessageCellDidTapReceiverNameWithCell:self];
//        }
//    }
    if ([self.delegate respondsToSelector:@selector(voiceTextMessageCellDidTapUsernameWithCell:)]) {
        [self.delegate voiceTextMessageCellDidTapUsernameWithCell:self];
    }
}

+ (UIFont *)messageFont {
    return [UIFont systemFontOfSize:14.f weight:UIFontWeightSemibold];
}

@end
