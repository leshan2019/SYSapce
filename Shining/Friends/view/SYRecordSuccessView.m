//
//  SYRecordSuccessVIew.m
//  Shining
//
//  Created by letv_lzb on 2019/4/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRecordSuccessView.h"
#import "SYAudioPlayer.h"

@interface SYRecordSuccessView ()
@property (nonatomic, strong)UILabel *timeLbl;
@property (nonatomic, strong)UIButton *reRecordBtn;
@property (nonatomic, strong)UIButton *playBtn;
@property (nonatomic, strong)UIButton *completeBtn;
@property (nonatomic, strong)SYAudioPlayer *player;

@end

@implementation SYRecordSuccessView


- (instancetype)init {
    self = [super init];
    if(self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}


- (void)setUpView {
    [self addSubview:self.timeLbl];
    [self addSubview:self.reRecordBtn];
    [self addSubview:self.playBtn];
    [self addSubview:self.completeBtn];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(200, 16));
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.timeLbl.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [self.reRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(40);
        make.centerY.equalTo(self.playBtn);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.right.equalTo(self).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

}

- (UILabel *)timeLbl {
    if (!_timeLbl) {
        _timeLbl = [UILabel new];//[[UILabel alloc] initWithFrame:CGRectMake(self.center.x, 5, 200, 16)];
        _timeLbl.backgroundColor = [UIColor clearColor];
        _timeLbl.textColor = [UIColor whiteColor];
        _timeLbl.font = [UIFont systemFontOfSize:15];
        _timeLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLbl;
}


- (UIButton *)reRecordBtn {
    if (!_reRecordBtn) {
        _reRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _reRecordBtn.frame = CGRectMake(20, CGRectGetMaxY(self.timeLbl.frame) +20, 50, 50);
        _reRecordBtn.layer.cornerRadius = 50/2;
        [_reRecordBtn setBackgroundColor:[UIColor whiteColor]];
        [_reRecordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_reRecordBtn addTarget:self action:@selector(doReRecord) forControlEvents:UIControlEventTouchUpInside];
        _reRecordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_reRecordBtn setTitle:@"重录" forState:UIControlStateNormal];
    }
    return _reRecordBtn;
}


- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _playBtn.frame = CGRectMake(self.center.x, CGRectGetMaxY(self.timeLbl.frame) +10, 70, 70);
        _playBtn.layer.cornerRadius = 70/2;
        [_playBtn setBackgroundColor:[UIColor whiteColor]];
        [_playBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(doPlay) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_playBtn setTitle:@"试听" forState:UIControlStateNormal];
    }
    return _playBtn;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeBtn.layer.cornerRadius = 50/2;
//        _playBtn.frame = CGRectMake(self.sy_width - 20 - 50, CGRectGetMaxY(self.timeLbl.frame) +20, 50, 50);
        [_completeBtn setBackgroundColor:[UIColor whiteColor]];
        [_completeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_completeBtn addTarget:self action:@selector(doComplete) forControlEvents:UIControlEventTouchUpInside];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    return _completeBtn;
}


- (void)doReRecord {
    
}

- (void)doPlay {
    if (self.audioUrl && self.audioUrl.length > 0) {
        if (!_player) {
            _player = [[SYAudioPlayer alloc] initWithUrls:@[self.audioUrl] seekDuration:0 duration:self.audioDuration];
        }
        [self.player play];
    }
}

- (void)doComplete {

}


- (void)setAudioUrl:(NSString *)audioUrl {
    if (_audioUrl != audioUrl) {
        _audioUrl = audioUrl;
    }
}

- (void)setAudioDuration:(NSTimeInterval)audioDuration {
    if (_audioDuration != audioDuration) {
        _audioDuration = audioDuration;
        self.timeLbl.text = [NSString stringWithFormat:@"%.2f",audioDuration];
    }
}

@end
