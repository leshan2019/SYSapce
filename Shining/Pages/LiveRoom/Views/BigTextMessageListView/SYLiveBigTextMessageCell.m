//
//  SYLiveBigTextMessageCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveBigTextMessageCell.h"

#import "SYVoiceTextMessageViewModel.h"
#import "SYLiveBigGiftMessageCell.h"

#define kMessageCellSingleLineHeight 34
#define kLevelViewWidth 48.f

@implementation SYLiveBigTextMessageCell
@synthesize vipView=_vipView,broadcasterLevelView=_broadcasterLevelView,textShadow=_textShadow,messageLabel=_messageLabel;

+ (CGFloat)cellTextContentMaxWidthWithWidth:(CGFloat)width {
    CGFloat maxWidth = (width - 20.f - 6.f * 2);
    return maxWidth;
}

+ (CGSize)cellSizeWithViewModel:(SYVoiceTextMessageViewModel *)viewModel
                          width:(CGFloat)width {
    CGSize size = CGSizeMake(0, 0);
    switch (viewModel.messageType) {
        case SYVoiceTextMessageTypeGift:
        {
            return [SYLiveBigGiftMessageCell cellSizeWithViewModel:viewModel
                                                           width:width];
        }
            break;
        case SYVoiceTextMessageTypeGame:
        case SYVoiceTextMessageTypeExpression:
        {
            size = CGSizeMake(width, kMessageCellSingleLineHeight);
        }
            break;
        case SYVoiceTextMessageTypeDefault:
        case SYVoiceTextMessageTypeDanmaku:
        case SYVoiceTextMessageTypeSuperDanmaku:
        case SYVoiceTextMessageTypeVipDanmaku:
        case SYVoiceTextMessageTypeBreakEgg:
        case SYVoiceTextMessageTypeBeeHoney:
        case SYVoiceTextMessageTypeSendRedpacket:
        case SYVoiceTextMessageTypeInfo:
        case SYVoiceTextMessageTypeJoinChannel:
        case SYVoiceTextMessageTypeVipUpgrade:
        case SYVoiceTextMessageTypeGreeting:
        case SYVoiceTextMessageTypeSystem:
        case SYVoiceTextMessageTypePost:
        case SYVoiceTextMessageTypeGetRedpacket:
        case SYVoiceTextMessageTypeFollow:
        {
            CGFloat maxHeight = 999.f;
            CGFloat maxWidth = [self cellTextContentMaxWidthWithWidth:width];
            
            NSString *uName = viewModel.username;
            NSString *msg = [NSString stringWithFormat:@"%@：%@", uName, viewModel.message];
            msg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            if (viewModel.messageType == SYVoiceTextMessageTypeBreakEgg) {
                msg = [NSString stringWithFormat:@"%@在%@中开出价值%ld蜜豆礼物，撒花恭喜~", uName, viewModel.gameName, (long)viewModel.giftPrice];
            } else if (viewModel.messageType == SYVoiceTextMessageTypeBeeHoney) {
                msg = [NSString stringWithFormat:@"恭喜%@在%@中获得了%@", uName, viewModel.gameName, viewModel.giftName];
            } else if (viewModel.messageType == SYVoiceTextMessageTypeSendRedpacket) {
                msg = viewModel.message;
            } else if (viewModel.messageType == SYVoiceTextMessageTypeJoinChannel ||
                       viewModel.messageType == SYVoiceTextMessageTypeGreeting||
                       viewModel.messageType == SYVoiceTextMessageTypeInfo||
                       viewModel.messageType == SYVoiceTextMessageTypeSystem||
                       viewModel.messageType == SYVoiceTextMessageTypePost) {
                msg = viewModel.message;
            } else if (viewModel.messageType == SYVoiceTextMessageTypeGetRedpacket) {
                NSString *userName = viewModel.username;
                NSString *senderName = viewModel.receiverUsername;
                NSInteger coinCount = viewModel.coinCount;
                msg = [NSString stringWithFormat:@"%@在%@的红包领取了%ld蜜豆，感谢老板~", userName, senderName, (long)coinCount];
            }
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
            [aString addAttribute:NSFontAttributeName value:[self fontWithMessageType:viewModel.messageType]
                            range:NSMakeRange(0, msg.length)];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            BOOL isBroadcaster = (viewModel.isBroadcaster == 1)|| (viewModel.isSuperAdmin ==1);
            NSInteger times = isBroadcaster ? 2 : 1;
            if (![self isUserIconsNeededWithMessageType:viewModel.messageType]) {
                times = 0;
            }
            style.firstLineHeadIndent = kLevelViewWidth * times;
            style.lineSpacing = 3;
            [aString addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, msg.length)];
            
            CGRect rect = [aString boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                                options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                context:nil];
            size = CGSizeMake(width, rect.size.height + 8.f + 2.f);
        }
            break;
        default:
            break;
    }
    return size;
}

+ (BOOL)isUserIconsNeededWithMessageType:(SYVoiceTextMessageType)messageType {
    switch (messageType) {
        case SYVoiceTextMessageTypeBeeHoney:
        case SYVoiceTextMessageTypePost:
        case SYVoiceTextMessageTypeSystem:
        case SYVoiceTextMessageTypeVipUpgrade:
        case SYVoiceTextMessageTypeGreeting:
        case SYVoiceTextMessageTypeGetRedpacket:
        {
            return NO;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textShadow];
        [self.contentView addSubview:self.vipView];
        [self.contentView addSubview:self.broadcasterLevelView];
        [self.contentView addSubview:self.messageLabel];
    }
    return self;
}

- (SYVIPLevelView *)vipView {
    if (!_vipView) {
        _vipView = [[SYVIPLevelView alloc] initWithFrame:CGRectMake(16.f, 8.f, 34.f, 14.f)];
        [_vipView makeBiger];
    }
    return _vipView;
}

- (SYBroadcasterLevelView *)broadcasterLevelView {
    if (!_broadcasterLevelView) {
        _broadcasterLevelView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectMake(16.f, 8, 0, 0)];
        [_broadcasterLevelView makeBiger];
    }
    return _broadcasterLevelView;
}

- (UIView *)textShadow {
    if (!_textShadow) {
        _textShadow = [[UIView alloc] initWithFrame:CGRectMake(10.f, 2.f, self.bounds.size.width - 20.f, 0)];
        _textShadow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _textShadow.layer.cornerRadius = 13.f;
    }
    return _textShadow;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44.f)];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.numberOfLines = 0;
        _messageLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_messageLabel addGestureRecognizer:tap];
    }
    return _messageLabel;
}

- (void)showWithViewModel:(SYVoiceTextMessageViewModel *)viewModel {
    self.messageType = viewModel.messageType;
    BOOL isBroadcaster = (viewModel.isBroadcaster == 1) || (viewModel.isSuperAdmin ==1);
    self.messageLabel.frame = [self messageLabelFrameWithViewModel:viewModel];
    self.messageLabel.font = [[self class] fontWithMessageType:viewModel.messageType];
    self.textShadow.frame = [self messageShadowViewFrameWithMessageType:viewModel.messageType
                                                          isBroadcaster:isBroadcaster];
    [self.vipView showWithVipLevel:viewModel.userLevel];
    [self.broadcasterLevelView showWithBroadcasterLevel:viewModel.broadcasterLevel];
    if (viewModel.isSuperAdmin ==1) {
        [self.broadcasterLevelView showWithSuperAdmin];
    }
    if (isBroadcaster) {
        self.vipView.sy_left = self.broadcasterLevelView.sy_right + 4.f;
    } else {
        self.vipView.sy_left = self.broadcasterLevelView.sy_left;
    }
    self.vipView.hidden = NO;
    self.broadcasterLevelView.hidden = !isBroadcaster;
    BOOL isUserIconsNeeded = [[self class] isUserIconsNeededWithMessageType:viewModel.messageType];
    if (!isUserIconsNeeded) {
        self.vipView.hidden = YES;
        self.broadcasterLevelView.hidden = YES;
    }
    switch (viewModel.messageType) {
        case SYVoiceTextMessageTypeDefault:
        case SYVoiceTextMessageTypeDanmaku:
        case SYVoiceTextMessageTypeSuperDanmaku:
        case SYVoiceTextMessageTypeVipDanmaku:
        case SYVoiceTextMessageTypeBreakEgg:
        case SYVoiceTextMessageTypeBeeHoney:
        {
            self.messageLabel.attributedText = nil;
            self.messageLabel.text = nil;
//            self.messageLabel.text = viewModel.message;
            self.messageLabel.textColor = [UIColor whiteColor];
            
            NSString *uName = viewModel.username;
            NSString *msg = [NSString stringWithFormat:@"%@：%@", uName, viewModel.message];
            msg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            if (viewModel.messageType == SYVoiceTextMessageTypeBreakEgg) {
                msg = [NSString stringWithFormat:@"%@在%@中开出价值%ld蜜豆礼物，撒花恭喜~", uName, viewModel.gameName, (long)viewModel.giftPrice];
            } else if (viewModel.messageType == SYVoiceTextMessageTypeBeeHoney) {
                msg = [NSString stringWithFormat:@"恭喜%@在%@中获得了%@", uName, viewModel.gameName, viewModel.giftName];
            }
            
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
            [aString addAttribute:NSFontAttributeName value:[[self class] fontWithMessageType:viewModel.messageType]
                            range:NSMakeRange(0, msg.length)];
            if (viewModel.messageType == SYVoiceTextMessageTypeBreakEgg ||
                viewModel.messageType == SYVoiceTextMessageTypeBeeHoney) {
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FE944E"]
                                range:NSMakeRange(0, msg.length)];
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                                range:[msg rangeOfString:uName?:@""]];
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                                range:[msg rangeOfString:viewModel.gameName?:@""]];
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                                range:[msg rangeOfString:[NSString stringWithFormat:@"%ld", (long)viewModel.giftPrice]]];
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                                range:[msg rangeOfString:viewModel.giftName?:@""]];
            } else {
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]
                                range:NSMakeRange(0, msg.length)];
                [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                                range:[msg rangeOfString:[NSString stringWithFormat:@"%@：", uName?:@""]]];
            }
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            NSInteger times = isBroadcaster ? 2 : 1;
            if (!isUserIconsNeeded) {
                times = 0;
            }
            style.firstLineHeadIndent = kLevelViewWidth * times;
            style.lineSpacing = 3;
            [aString addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, msg.length)];
            self.messageLabel.attributedText = aString;
        }
            break;
        case SYVoiceTextMessageTypeJoinChannel:
        case SYVoiceTextMessageTypeGreeting:
        case SYVoiceTextMessageTypeInfo:
        case SYVoiceTextMessageTypeSystem:
        case SYVoiceTextMessageTypePost:
        {
            self.messageLabel.attributedText = nil;
            UIColor *textColor = [UIColor sam_colorWithHex:@"#FE944E"];
            if (viewModel.messageType == SYVoiceTextMessageTypeJoinChannel ||
                viewModel.messageType == SYVoiceTextMessageTypeInfo) {
                textColor = [UIColor sam_colorWithHex:@"#FBE797"];
            }
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:viewModel.message];
            [string setAttributes:@{NSFontAttributeName: self.messageLabel.font,
                                    NSForegroundColorAttributeName: textColor
                                    } range:NSMakeRange(0, viewModel.message.length)];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            NSInteger times = isBroadcaster ? 2 : 1;
            if (!isUserIconsNeeded) {
                times = 0;
            }
            style.firstLineHeadIndent = kLevelViewWidth * times;
            style.lineSpacing = 3;
            [string addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, viewModel.message.length)];
            self.messageLabel.attributedText = string;
        }
            break;
        case SYVoiceTextMessageTypeVipUpgrade:
        {
            self.messageLabel.attributedText = nil;
            NSString *uName = viewModel.username;
            NSString *msg = [NSString stringWithFormat:@"恭喜%@升级至%ld级", uName, (long)viewModel.userLevel];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:msg];
            [string setAttributes:@{NSFontAttributeName: self.messageLabel.font,
                                    NSForegroundColorAttributeName: [UIColor sam_colorWithHex:@"#FE944E"]
                                    } range:NSMakeRange(0, msg.length)];
            [string setAttributes:@{NSForegroundColorAttributeName: [UIColor sam_colorWithHex:@"#FBE797"]} range:[msg rangeOfString:uName?:@""]];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            NSInteger times = isBroadcaster ? 2 : 1;
            if (!isUserIconsNeeded) {
                times = 0;
            }
            style.firstLineHeadIndent = kLevelViewWidth * times;
            style.lineSpacing = 3;
            [string addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, msg.length)];
            self.messageLabel.attributedText = string;
        }
            break;
        case SYVoiceTextMessageTypeSendRedpacket: {
            self.messageLabel.attributedText = nil;
            self.messageLabel.textColor = [UIColor sam_colorWithHex:@"#FBE797"];
            NSString *msg = viewModel.message;
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
            [aString addAttribute:NSFontAttributeName value:[[self class] fontWithMessageType:viewModel.messageType]
                            range:NSMakeRange(0, msg.length)];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                            range:NSMakeRange(0, msg.length)];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            NSInteger times = isBroadcaster ? 2 : 1;
            if (!isUserIconsNeeded) {
                times = 0;
            }
            style.firstLineHeadIndent = kLevelViewWidth * times;
            style.lineSpacing = 3;
            [aString addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, msg.length)];
            self.messageLabel.attributedText = aString;
        }
            break;
        case SYVoiceTextMessageTypeGetRedpacket: {
            self.messageLabel.attributedText = nil;
            NSString *userName = viewModel.username;
            NSString *senderName = viewModel.receiverUsername;
            NSInteger coinCount = viewModel.coinCount;
            NSString *msg = [NSString stringWithFormat:@"%@在%@的红包领取了%ld蜜豆，感谢老板~", userName, senderName, (long)coinCount];
            NSString *coinStr = [NSString stringWithFormat:@"%ld",(long)coinCount];
            NSRange senderRange = [msg rangeOfString:userName];
            NSRange redPacketOwner = NSMakeRange(senderRange.length + 1, senderName.length);
            NSRange coinCountRange = NSMakeRange(redPacketOwner.location + redPacketOwner.length - 1 + 7, coinStr.length);
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
            [aString addAttribute:NSFontAttributeName value:[[self class] fontWithMessageType:viewModel.messageType] range:NSMakeRange(0, msg.length)];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FE944E"]
                            range:NSMakeRange(0, msg.length)];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                            range:senderRange];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                            range:redPacketOwner];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FBE797"]
                            range:coinCountRange];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            NSInteger times = isBroadcaster ? 2 : 1;
            if (!isUserIconsNeeded) {
                times = 0;
            }
            style.firstLineHeadIndent = kLevelViewWidth * times;
            style.lineSpacing = 3;
            [aString addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, msg.length)];
            self.messageLabel.attributedText = aString;
        }
            break;
        case SYVoiceTextMessageTypeFollow:
        {
            self.messageLabel.attributedText = nil;
            NSString *userName = viewModel.username;
            NSString *senderName = viewModel.receiverUsername;
            NSString *msg = [NSString stringWithFormat:@"%@关注了%@，求互关注~", userName, senderName];
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
            
            [aString addAttribute:NSFontAttributeName value:[[self class] fontWithMessageType:viewModel.messageType] range:NSMakeRange(0, msg.length)];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FFFFFF"]
                            range:NSMakeRange(0, msg.length)];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FE944E"]
                            range:[msg rangeOfString:userName?:@""]];
            [aString addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#FE944E"]
            range:[msg rangeOfString:senderName?:@""]];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            NSInteger times = isBroadcaster ? 2 : 1;
            if (!isUserIconsNeeded) {
                times = 0;
            }
            style.firstLineHeadIndent = kLevelViewWidth * times;
            style.lineSpacing = 3;
            [aString addAttribute:NSParagraphStyleAttributeName
                            value:style
                            range:NSMakeRange(0, msg.length)];
            self.messageLabel.attributedText = aString;
        }
            break;
        default:
            break;
    }
}

- (CGRect)messageLabelFrameWithViewModel:(SYVoiceTextMessageViewModel *)viewModel {
    CGRect frame = CGRectZero;
    BOOL isBroadcaster = (viewModel.isBroadcaster == 1)|| (viewModel.isSuperAdmin ==1);
    CGFloat maxHeight = 999.f;
    CGFloat maxWidth = [[self class] cellTextContentMaxWidthWithWidth:self.sy_width];
    NSString *uName = viewModel.username;
    NSString *msg = [NSString stringWithFormat:@"%@：%@", uName, viewModel.message];
    msg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    if (viewModel.messageType == SYVoiceTextMessageTypeBreakEgg) {
        msg = [NSString stringWithFormat:@"%@在%@中开出价值%ld蜜豆礼物，撒花恭喜~", uName, viewModel.gameName, (long)viewModel.giftPrice];
    } else if (viewModel.messageType == SYVoiceTextMessageTypeBeeHoney) {
        msg = [NSString stringWithFormat:@"恭喜%@在%@中获得了%@", uName, viewModel.gameName, viewModel.giftName];
    } else if (viewModel.messageType == SYVoiceTextMessageTypeSendRedpacket) {
        msg = viewModel.message;
    }else if (viewModel.messageType == SYVoiceTextMessageTypeVipUpgrade) {
        msg = [NSString stringWithFormat:@"恭喜%@升级至%ld级", uName, (long)viewModel.userLevel];
    } else if (viewModel.messageType == SYVoiceTextMessageTypeJoinChannel ||
               viewModel.messageType == SYVoiceTextMessageTypeGreeting||
               viewModel.messageType == SYVoiceTextMessageTypeInfo||
               viewModel.messageType == SYVoiceTextMessageTypeSystem||
               viewModel.messageType == SYVoiceTextMessageTypePost) {
        msg = viewModel.message;
    } else if (viewModel.messageType == SYVoiceTextMessageTypeGetRedpacket) {
        NSString *userName = viewModel.username;
        NSString *senderName = viewModel.receiverUsername;
        NSInteger coinCount = viewModel.coinCount;
        msg = [NSString stringWithFormat:@"%@在%@的红包领取了%ld蜜豆，感谢老板~", userName, senderName, (long)coinCount];
    } else if (viewModel.messageType == SYVoiceTextMessageTypeFollow) {
        NSString *userName = viewModel.username;
        NSString *senderName = viewModel.receiverUsername;
        msg = [NSString stringWithFormat:@"%@关注了%@，求互关注~", userName, senderName];
    }
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:msg];
    [aString addAttribute:NSFontAttributeName value:[[self class] fontWithMessageType:viewModel.messageType]
                    range:NSMakeRange(0, msg.length)];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    NSInteger times = isBroadcaster ? 2 : 1;
    if (![[self class] isUserIconsNeededWithMessageType:viewModel.messageType]) {
        times = 0;
    }
    style.firstLineHeadIndent = kLevelViewWidth * times;
    style.lineSpacing = 3;
    [aString addAttribute:NSParagraphStyleAttributeName
                    value:style
                    range:NSMakeRange(0, msg.length)];
    CGRect rect = [aString boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                        options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        context:nil];
    CGSize size = CGSizeMake(rect.size.width, rect.size.height);
    if (size.height < 28) {
        BOOL isBroadcaster = (viewModel.isBroadcaster == 1)|| (viewModel.isSuperAdmin ==1);
        NSInteger times = isBroadcaster ? 2 : 1;
        if (![[self class] isUserIconsNeededWithMessageType:viewModel.messageType]) {
            times = 0;
        }
        size.width = size.width + kLevelViewWidth * times;
//        if (size.width > [[self class] cellTextContentMaxWidthWithWidth:self.sy_width]) {
//            size.width = [[self class] cellTextContentMaxWidthWithWidth:self.sy_width];
//            size.height += 50;
//        }
    }
    frame = CGRectMake(16.f, 6.f, size.width, MAX(size.height, 18.f));
    return frame;
}

- (CGRect)messageShadowViewFrameWithMessageType:(SYVoiceTextMessageType)type
                                  isBroadcaster:(BOOL)isBroadcaster {
    return CGRectMake(10.f, 2.f, self.messageLabel.sy_width + 12.f, self.messageLabel.sy_height + 8.f);
}

+ (UIFont *)fontWithMessageType:(SYVoiceTextMessageType)type {
    return [UIFont systemFontOfSize:18.f weight:UIFontWeightSemibold];
}

- (void)tap:(id)sender {
    if (self.messageType == SYVoiceTextMessageTypeGreeting ||
        self.messageType == SYVoiceTextMessageTypeSystem ||
        self.messageType == SYVoiceTextMessageTypeSendRedpacket ||
        self.messageType == SYVoiceTextMessageTypeGetRedpacket) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(voiceTextMessageCellDidTapUsernameWithCell:)]) {
        [self.delegate voiceTextMessageCellDidTapUsernameWithCell:self];
    }
}
@end
