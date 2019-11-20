//
//  SYMessageCell.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMessageCell.h"
#import "ChatHelper.h"
#import "SYTransferPaymentModel.h"


@interface SYMessageCell ()
@property (nonatomic,strong)UIImageView *transferBackView;
@property (nonatomic,strong)UIImageView *transferIcon;
@property (nonatomic,strong)UILabel *transferCount;
@property (nonatomic,strong)UILabel *toUserName;
@property (nonatomic,strong)UILabel *redPackageLbl;
@end

@implementation SYMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id<IMessageModel>)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        [self setUpTransferView:model];
    }
    return self;
}


- (void)setUpTransferView:(id<IMessageModel>)model {
    if ([SYMessageCell isTransferViewCell:model]) {
        if (!self.transferBackView.superview) {
            [self.contentView addSubview:self.transferBackView];
            if (model.isSender) {
                [self.transferBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.avatarView.mas_left).with.offset(-8);
                    make.top.mas_equalTo(self.avatarView.mas_top);
                    make.size.mas_equalTo(CGSizeMake(241, 90));
                }];
            }else {
                [self.transferBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.avatarView.mas_right).with.offset(8);
                    make.top.mas_equalTo(self.avatarView.mas_top);
                    make.size.mas_equalTo(CGSizeMake(241, 90));
                }];
            }
        }

        if (!self.transferIcon.superview) {
            [self.transferBackView addSubview:self.transferIcon];
            [self.transferIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.transferBackView).with.offset(12);
                make.top.equalTo(self.transferBackView).with.offset(13);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
        }

        if (!self.transferCount.superview) {
            [self.transferBackView addSubview:self.transferCount];
            [self.transferCount mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.transferIcon.mas_right).with.offset(10);
                make.top.equalTo(self.transferBackView).with.offset(14);
                make.right.mas_equalTo(self.transferBackView.mas_right).with.offset(-12);
                make.height.mas_equalTo(22);
            }];
        }

        if (!self.toUserName.superview) {
            [self.transferBackView addSubview:self.toUserName];
            [self.toUserName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.transferIcon.mas_right).with.offset(10);
                make.top.mas_equalTo(self.transferCount.mas_bottom).with.offset(3);
                make.right.mas_equalTo(self.transferBackView.mas_right).with.offset(-12);
                make.height.mas_equalTo(17);
            }];
        }

        if (!self.redPackageLbl.superview) {
            [self.transferBackView addSubview:self.redPackageLbl];
            [self.redPackageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.transferBackView).with.offset(12);
                make.bottom.equalTo(self.transferBackView).with.offset(-5);
                make.size.mas_equalTo(CGSizeMake(26, 14));
            }];
        }

    }
}


- (UIImageView *)transferBackView {
    if (!_transferBackView) {
        _transferBackView = [UIImageView new];
        _transferBackView.backgroundColor = [UIColor clearColor];
    }
    return _transferBackView;
}

- (UIImageView *)transferIcon {
    if (!_transferIcon) {
        _transferIcon = [UIImageView new];
        _transferIcon.backgroundColor = [UIColor clearColor];
        _transferIcon.image = [UIImage imageNamed_sy:@"transferIcon"];
    }
    return _transferIcon;
}

- (UILabel *)transferCount {
    if (!_transferCount) {
        _transferCount = [UILabel new];
        _transferCount.backgroundColor = [UIColor clearColor];
        UIFont *font =  [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        if (nil == font) {
            font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        }
        _transferCount.font = font;
        _transferCount.textColor = [UIColor whiteColor];
        _transferCount.textAlignment = NSTextAlignmentLeft;
    }
    return _transferCount;
}


- (UILabel *)toUserName {
    if (!_toUserName) {
        _toUserName = [UILabel new];
        _toUserName.backgroundColor = [UIColor clearColor];
        UIFont *font =  [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        if (nil == font) {
            font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        }
        _toUserName.font = font;
        _toUserName.textColor = [UIColor whiteColor];
        _toUserName.textAlignment = NSTextAlignmentLeft;
    }
    return _toUserName;
}

- (UILabel *)redPackageLbl {
    if (!_redPackageLbl) {
        _redPackageLbl = [UILabel new];
        _redPackageLbl.backgroundColor = [UIColor clearColor];
        UIFont *font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _redPackageLbl.font = font;
        _redPackageLbl.textColor = [UIColor sy_colorWithHexString:@"#666666"];
        _redPackageLbl.textAlignment = NSTextAlignmentLeft;
        _redPackageLbl.text = @"红包";
    }
    return _redPackageLbl;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if ([SYMessageCell isTransferViewCell:self.model]) {
        UIImage *redPackageBgImg = self.model.isSender ? [UIImage imageNamed_sy:@"sendRedPackageBg"] : [UIImage imageNamed_sy:@"receiveRedPackageBg"];
        self.transferBackView.image = redPackageBgImg;
        if (self.model.isSender) {
            [self.transferBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.avatarView.mas_left).with.offset(-8);
                make.top.mas_equalTo(self.avatarView.mas_top);
                make.size.mas_equalTo(CGSizeMake(241, 90));
            }];
        }else {
            [self.transferBackView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.avatarView.mas_right).with.offset(8);
                make.top.mas_equalTo(self.avatarView.mas_top);
                make.size.mas_equalTo(CGSizeMake(241, 90));
            }];
        }
    }
}


#pragma mark - IModelCell

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    if ([SYMessageCell isTransferViewCell:model]) {
        if (!self.transferBackView.superview) {
            [self setUpTransferView:model];
        }
        return YES;
    }else {
        self.bubbleView.hidden = NO;
        self.transferBackView.hidden = YES;
        return NO;
    }
}


- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model {
    if ([SYMessageCell isTransferViewCell:model]) {
        
    }
}

- (void)setCustomModel:(id<IMessageModel>)model
{
    if ([SYMessageCell isTransferViewCell:model]) {
        NSDictionary *ext = model.message.ext;
        NSString *redPacketStr = [ext objectForKey:extRedPacket];
        SYTransferPaymentModel *payModel = [SYTransferPaymentModel yy_modelWithJSON:redPacketStr];
        self.bubbleView.hidden = YES;
        self.transferBackView.hidden = NO;
//        if (model.isSender) {
//            self.toUserName.text = [NSString stringWithFormat:@"发给%@",payModel.userInfo.username];
//        }else {
//            self.toUserName.text = @"发给你";
//        }
        self.toUserName.text = [NSString stringWithFormat:@"发给%@",payModel.userInfo.username];

        self.transferCount.text = payModel.acount;
    }else {
        self.bubbleView.hidden = NO;
        self.transferBackView.hidden = YES;
    }
}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
    if ([SYMessageCell isTransferViewCell:model]) {
        self.bubbleView.hidden = YES;
        self.transferBackView.hidden = NO;
    }else {
        self.bubbleView.hidden = NO;
        self.transferBackView.hidden = YES;
    }
}

/*!
 @method
 @brief 获取cell的重用标识
 @discussion
 @param model   消息model
 @return 返回cell的重用标识
 */
+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    if ([self isTransferViewCell:model]) {
        return model.isSender?@"EaseMessageCellSendTransfer":@"EaseMessageCellRecvTransfer";
    }else {
        return [EaseMessageCell cellIdentifierWithModel:model];
    }
}

/*!
 @method
 @brief 获取cell的高度
 @discussion
 @param model   消息model
 @return  返回cell的高度
 */
+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    if ([self isTransferViewCell:model]) {
        return 105;
    }else {
        return 0;
    }
}



+ (BOOL)isTransferViewCell:(id<IMessageModel>)model {
    NSDictionary *ext = model.message.ext;
    if (![NSString sy_empty:ext] && ![NSString sy_empty:[ext objectForKey:extRedPacket]]) {
        return YES;
    }else {
        return NO;
    }
}






@end
