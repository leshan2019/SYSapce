//
//  SYPersonHomepageVoiceCardShowView.m
//  Shining
//
//  Created by leeco on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVoiceCardShowView.h"
#import "SYVoiceCardSoundResultModel.h"
@interface SYPersonHomepageVoiceCardShowView ()
@property(nonatomic,strong)UIImageView*bgImageView;
@property(nonatomic,strong)UIButton*recodeBtn;
@property(nonatomic,strong)UILabel*wordLabel;
@property(nonatomic,strong)SYVoiceCardUserHeaderView*headerView;
@property(nonatomic,strong)AVPlayer * player;
@end
@implementation SYPersonHomepageVoiceCardShowView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    self.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self addSubview:self.recodeBtn];
    [self.bgImageView addSubview:self.wordLabel];
    [self.bgImageView addSubview:self.headerView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgImageView.sy_top = 0;
    self.bgImageView.sy_centerX = self.sy_centerX;
    self.recodeBtn.sy_centerX = self.sy_centerX;
    self.recodeBtn.sy_top = self.bgImageView.sy_bottom+35*dp;
    self.headerView.sy_left = 10;
    self.headerView.sy_bottom = self.bgImageView.sy_bottom - 16;
}
-(void)resetViewInfos:(SYMyVoiceCardSoundModel*)info{
    //
    NSString*text = [info.soundtone_word stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    self.wordLabel.text =text;
    [self.wordLabel sizeToFit];
    if (self.wordLabel.sy_width>self.bgImageView.sy_width-20) {
        self.wordLabel.sy_width = self.bgImageView.sy_width-20;
    }
    self.wordLabel.center = CGPointMake(self.bgImageView.sy_width/2.f, self.bgImageView.sy_height/2.f) ;
    //
    NSString*urlStr = info.background_imgurl;
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak typeof(self) weakSelf = self;
    self.bgImageView.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.superview animated:NO];
    [self.bgImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideHUDForView:weakSelf.superview animated:NO];
        weakSelf.headerView.hidden = NO;
        weakSelf.bgImageView.hidden = NO;
        if (!image) {
            [weakSelf.bgImageView setImage:[UIImage imageNamed_sy:@"voiceCard_default"]];
        }
    }];
    //
    for (UILabel *tmp in self.bgImageView.subviews) {
        if (tmp.sy_y == 18*dp) {
            [tmp removeFromSuperview];
        }
    }
    
    NSArray*arr = [info.soundtone_list sortedArrayUsingComparator:^NSComparisonResult(SYVoiceCardSoundResultModel*  _Nonnull obj1, SYVoiceCardSoundResultModel*  _Nonnull obj2) {
        if( obj1.score < obj2.score){
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    NSInteger recScore = [SYSettingManager getSoundRecScore];
    NSMutableArray*tipArr= @[].mutableCopy;
    NSInteger index = 0;
    for (int i = 0;i<arr.count;i++) {
        SYVoiceCardSoundResultModel*model = arr[i];
        if ([model.sound_type isEqualToString:@"男性"]||[model.sound_type isEqualToString:@"女性"]) {
            continue;
        }
        if (arr.count>3) {
            
            if (tipArr.count==0||(tipArr.count>0 && model.score >recScore)) {
                [tipArr addObject:model];
                UILabel*lab = [self setupTipLabel:index];
                lab.text = [NSString stringWithFormat:@"%@音",model.sound_type];
                [self.bgImageView addSubview:lab];
                index++;
            }
            if (tipArr.count>=2) {
                break;
            }
        }else{
            UILabel*lab = [self setupTipLabel:index];
            lab.text = [NSString stringWithFormat:@"%@",model.sound_type];
            [self.bgImageView addSubview:lab];
        }
        
    }
    //
    if (info.username.length>0) {
        CGFloat width = info.username.length *13;
        if (width>72){
            width = 72;
        }
            self.headerView.sy_width = 38 + width +8;
    }
    [self.headerView setHeader:info.avatar_imgurl andName:info.username];
    //
    if (![NSString sy_isBlankString:info.voice_url]) {
        NSURL*voice = [NSURL URLWithString:info.voice_url];
        self.player = [[AVPlayer alloc] initWithURL:voice];
        [self.player play];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    }
    
}
-(UILabel*)setupTipLabel:(NSInteger)index{
    UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(18*dp+index*(53+6), 18*dp, 53, 20)];
    lab.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 10;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}
- (void)playbackFinished:(NSNotification *)notification {
    [self.player seekToTime: kCMTimeZero];
    [self.player play];
}
- (void)dealloc
{
    self.player = nil;
}
- (SYVoiceCardUserHeaderView *)headerView{
    if (!_headerView) {
        SYVoiceCardUserHeaderView*view = [[SYVoiceCardUserHeaderView alloc]initWithFrame:CGRectMake(0, 0, 118, 38)];
        view.hidden = YES;
        _headerView = view;
    }
    return _headerView;
}
- (UILabel *)wordLabel{
    if (!_wordLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectZero];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:20];
        lab.textColor = [UIColor whiteColor];
        lab.numberOfLines = 7;
        lab.textAlignment = NSTextAlignmentCenter;
        _wordLabel = lab;
    }
    return _wordLabel;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView*img = [[UIImageView alloc]init];
        img.frame = CGRectMake(0, 0, 335*dp, 465*dp);
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = 6;
        _bgImageView = img;
    }
    return _bgImageView;
}
- (UIButton *)recodeBtn{
    if (!_recodeBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 114*dp, 36*dp)];
        btn.layer.cornerRadius = 36*dp/2.f;
        btn.layer.masksToBounds = YES;
        //
        CAGradientLayer*gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, btn.sy_width, btn.sy_height);
        gradientLayer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#FFA198"].CGColor, (__bridge id)[UIColor sy_colorWithHexString:@"#FE3D6C"].CGColor];
        gradientLayer.locations = @[@(0.1), @(1)];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        [btn.layer addSublayer:gradientLayer];
        //
        [btn setTitle:@"录制新名片" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16.8];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(recodeAction) forControlEvents:UIControlEventTouchUpInside];
        
        //
        _recodeBtn = btn;
    }
    return _recodeBtn;
}
-(void)recodeAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showView_retryRecode)]) {
        [self.delegate showView_retryRecode];
    }
}
- (void)resetViewState:(BOOL)hidden andHideRecodeBtn:(BOOL)buttonHidden{
    self.hidden = hidden;
    [self.player pause];
    self.player = nil;
    self.recodeBtn.hidden = buttonHidden || hidden;
}
@end


@interface SYVoiceCardUserHeaderView ()
@property(nonatomic,strong)UIImageView*header;
@property(nonatomic,strong)UILabel*nameLabel;
@end
@implementation SYVoiceCardUserHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.sy_height/2.f;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:self.header];
        [self addSubview:self.nameLabel];
    }
    return self;
}
- (void)setHeader:(NSString *)headerUrl andName:(NSString *)name{
    NSURL*url = [NSURL URLWithString:headerUrl];
    [self.header sd_setImageWithURL:url placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    self.nameLabel.text = name;
    [self resetFrames];

}
-(void)resetFrames{
    self.header.sy_top = 0;
    self.header.sy_left = 0;
    self.nameLabel.sy_centerY = self.header.sy_centerY;
    self.nameLabel.sy_left = self.header.sy_right+4;
    CGFloat width = self.nameLabel.text.length*13 > 72 ? 72:self.nameLabel.text.length*13;
    self.nameLabel.sy_width = width;

}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetFrames];
}
- (UIImageView *)header{
    if (!_header) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.clipsToBounds = YES;
        img.layer.masksToBounds = YES;
        img.layer.borderColor = [UIColor sy_colorWithHexString:@"#E6E6E6"].CGColor;
        img.layer.borderWidth = 1;
        img.layer.cornerRadius = 19;
        img.image = [UIImage imageNamed_sy:@"mine_head_default"];
        _header = img;
    }
    return  _header;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.sy_width - 38-8, 17)];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        lab.backgroundColor = [UIColor clearColor];
        _nameLabel = lab;
    }
    return _nameLabel;
}
@end
