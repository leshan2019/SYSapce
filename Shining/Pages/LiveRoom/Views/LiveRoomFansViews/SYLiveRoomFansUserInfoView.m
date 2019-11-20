//
//  SYLiveRoomFansUserInfoView.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansUserInfoView.h"
#import "SYLiveRoomFansLevelView.h"
#import "SYLiveRoomFansViewInfoModel.h"
@interface SYLiveRoomFansUserInfoView()
@property(nonatomic,strong)UIView*bgView;
@property(nonatomic,strong)UIImageView*avator;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)SYLiveRoomFansLevelView*levelLabel;
@property(nonatomic,strong)UILabel*infoLabel;
@property(nonatomic,strong)UILabel*infoScoreLabel;
@property(nonatomic,strong)UILabel*rankingScoreLabel;
@property(nonatomic,strong)UILabel*rankingLabel;
@end
@implementation SYLiveRoomFansUserInfoView
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
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.avator];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.levelLabel];
    [self.bgView addSubview:self.infoLabel];
    [self.bgView addSubview:self.infoScoreLabel];
    [self.bgView addSubview:self.rankingLabel];
    [self.bgView addSubview:self.rankingScoreLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.bgView.sy_top = 2;
    self.bgView.sy_left = 0;
    self.avator.sy_left = 17;
    self.avator.sy_centerY = self.bgView.sy_centerY;
    self.titleLabel.sy_left = self.avator.sy_right + 14;
    self.titleLabel.sy_bottom = self.bgView.sy_centerY;
    self.levelLabel.sy_left = self.titleLabel.sy_right+8;
    self.levelLabel.sy_centerY = self.titleLabel.sy_centerY;
    self.infoLabel.sy_left = self.avator.sy_right + 14;
    self.infoLabel.sy_top = self.bgView.sy_centerY +2;
    self.infoScoreLabel.sy_left = self.infoLabel.sy_right;
    self.infoScoreLabel.sy_centerY = self.infoLabel.sy_centerY;
    self.rankingLabel.sy_right = self.bgView.sy_right - 24;
    self.rankingLabel.sy_centerY = self.infoScoreLabel.sy_centerY;
    self.rankingScoreLabel.sy_centerX = self.rankingLabel.sy_centerX;
    self.rankingScoreLabel.sy_centerY = self.titleLabel.sy_centerY;
}
-(void)setUserInfos:(id)info{
    SYLiveRoomFansViewMemberModel*model = (SYLiveRoomFansViewMemberModel*)info;
    NSURL*url = [NSURL URLWithString:model.avatar_image];
    [self.avator sd_setImageWithURL:url];
    self.titleLabel.text = [NSString sy_isBlankString:model.name]?@"xxx":model.name;
    NSString*level = [NSString sy_isBlankString:model.level]?@"0":model.level;
    [self.levelLabel setViewInfoIconName:@"真爱团" andLevel:level];
    self.infoScoreLabel.text = [NSString sy_isBlankString: model.close_score]?@"0": model.close_score;
    self.rankingScoreLabel.text = [NSString sy_isBlankString:model.rank]?@"0":model.rank;
    [self.titleLabel sizeToFit];
    [self.infoScoreLabel sizeToFit];
    [self.rankingScoreLabel sizeToFit];
    [self resetSubViewsFrames];
}
#pragma mark --------lazy load ----------
- (UIView *)bgView{
    if (!_bgView ) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 2, self.sy_width, self.sy_height - 2)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = NO;
        // 阴影
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,-2);
        view.layer.shadowOpacity = 0.1;
        _bgView = view;
    }
    return _bgView;
}
- (UIImageView *)avator{
    if (!_avator) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [img setBackgroundColor:[UIColor sy_colorWithHexString:@"ECECEC"]];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = 40/2.f;
        _avator = img;
    }
    return _avator;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        lab.textColor = [UIColor sy_colorWithHexString:@"0B0B0B"];
        _titleLabel = lab;
    }
    return _titleLabel;
}
- (SYLiveRoomFansLevelView *)levelLabel{
    if (!_levelLabel) {
        SYLiveRoomFansLevelView*level = [[SYLiveRoomFansLevelView alloc]initWithFrame:CGRectMake(0, 0, 52, 14) andFontSize:10];
        _levelLabel = level;
    }
    return _levelLabel;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        lab.text = @"亲密度：";
        [lab sizeToFit];
        _infoLabel = lab;
    }
    return _infoLabel;
}
- (UILabel *)infoScoreLabel{
    if (!_infoScoreLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        lab.textColor = [UIColor sy_colorWithHexString:@"#FF3069"];
        _infoScoreLabel=lab;
    }
    return _infoScoreLabel;
}
- (UILabel *)rankingScoreLabel{
    if (!_rankingScoreLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        lab.textColor = [UIColor sy_colorWithHexString:@"0B0B0B"];
        lab.textAlignment = NSTextAlignmentCenter;
        _rankingScoreLabel = lab;
    }
    return _rankingScoreLabel;
}
- (UILabel *)rankingLabel{
    if (!_rankingLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        lab.text = @"我的排名";
        [lab sizeToFit];
        _rankingLabel = lab;
    }
    return _rankingLabel;
}
@end
