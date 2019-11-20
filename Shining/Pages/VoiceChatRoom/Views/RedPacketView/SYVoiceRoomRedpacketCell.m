//
//  SYVoiceRoomRedpacketCell.m
//  Shining
//
//  Created by yangxuan on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomRedpacketCell.h"
#import "SYRoomGroupRedpacketModel.h"

@interface SYVoiceRoomRedpacketCell ()
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *leaveTime;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger leftTime;

@property (nonatomic, strong) SYRoomGroupRedpacketModel *model;

@end

@implementation SYVoiceRoomRedpacketCell

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)configueModel:(id)model {
    if (model && [model isKindOfClass:[SYRoomGroupRedpacketModel class]]) {
        self.model = model;
        [self configueData:self.model.owner_avatar
                  userName:self.model.owner_name
                 leaveTime:self.model.start_time_now_diff];
    } else {
        [self configueData:@"" userName:@"" leaveTime:0];
    }
}

- (void)configueData:(NSString *)userIcon userName:(NSString *)userName leaveTime:(NSInteger)leaveTime{
    [self stopTimer];
    SYRoomRedpacketState redPacketState;
    if (leaveTime <= 0) {
        redPacketState = SYRoomRedpacketState_Can_Get;
    } else {
        NSInteger hasPassTime = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(hasPassedTime)]) {
            hasPassTime = [self.delegate hasPassedTime];
        }
        self.leftTime = leaveTime - hasPassTime;
        if (self.leftTime <= 0) {
            redPacketState = SYRoomRedpacketState_Can_Get;
        } else {
            redPacketState = SYRoomRedpacketState_Cannot_Get;
        }
    }
    switch (redPacketState) {
        case SYRoomRedpacketState_Can_Get:
        {
            self.getBtn.hidden = NO;
            self.leaveTime.hidden = YES;
        }
            break;
        case SYRoomRedpacketState_Cannot_Get:
        {
            self.getBtn.hidden = YES;
            self.leaveTime.hidden = NO;
            [self startTimer];
        }
            break;
        default:
            break;
    }
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:userIcon] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    self.userName.text = userName;
}

- (void)releaseTimer {
    [self stopTimer];
}

#pragma mark - Timer

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateRedpacketLeaveTime)
                                                userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)stopTimer {
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)updateRedpacketLeaveTime {
    self.leftTime -= 1;
    NSInteger realLeftTime = self.leftTime;
    
    if (realLeftTime <= 0) {
        [self stopTimer];
        self.getBtn.hidden = NO;
        self.leaveTime.hidden = YES;
    } else { // 还没到领取的时候，直接换算成分钟
        NSString *leftTime = [NSString sy_safeString:[SYUtil getTimeStrWithSeconds:self.leftTime]];
        self.leaveTime.text = leftTime;
    }
}

#pragma mark - Private

- (void)initSubViews {
    [self.contentView addSubview:self.userIcon];
    [self.contentView addSubview:self.userName];
    [self.contentView addSubview:self.getBtn];
    [self.contentView addSubview:self.leaveTime];
    [self.contentView addSubview:self.bottomLine];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).with.offset(14);
        make.centerY.equalTo(self.userIcon);
        make.right.equalTo(self.contentView).with.offset(-100);
        make.height.mas_equalTo(21);
    }];
    
    [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon);
        make.size.mas_equalTo(CGSizeMake(68, 28));
        make.right.equalTo(self.contentView).with.offset(-16);
    }];
    
    [self.leaveTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIcon);
        make.size.mas_equalTo(CGSizeMake(68, 28));
        make.right.equalTo(self.contentView).with.offset(-16);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)getRedpacketClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYVoiceRoomRedpackeCellClickGetBtn:)]) {
        [self.delegate SYVoiceRoomRedpackeCellClickGetBtn:self.model];
    }
}

#pragma mark - LazyLoad

- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        _userIcon.clipsToBounds = YES;
        _userIcon.layer.cornerRadius = 21;
    }
    return _userIcon;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [UILabel new];
        _userName.textColor = RGBACOLOR(11,11,11,1);
        _userName.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _userName.textAlignment = NSTextAlignmentLeft;
    }
    return _userName;
}

- (UILabel *)leaveTime {
    if (!_leaveTime) {
        _leaveTime = [UILabel new];
        _leaveTime.textColor = RGBACOLOR(68,68,68,1);
        _leaveTime.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _leaveTime.textAlignment = NSTextAlignmentCenter;
    }
    return _leaveTime;
}

- (UIButton *)getBtn {
    if (!_getBtn) {
        _getBtn = [UIButton new];
        _getBtn.layer.cornerRadius = 14;
        _getBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getBtn.backgroundColor = RGBACOLOR(113,56,239,1);
        [_getBtn setTitle:@"领取" forState:UIControlStateNormal];
        [_getBtn addTarget:self action:@selector(getRedpacketClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

@end
