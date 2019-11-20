//
//  SYLiveRoomFansLevelCell.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansLevelCell.h"
#import "SYLiveRoomFansLevelView.h"
#import "SYLiveRoomFansViewInfoModel.h"
@interface SYLiveRoomFansLevelCell()
@property(nonatomic,strong)SYLiveRoomFansLevelView*levelView;
@property(nonatomic,strong)UILabel*infoLabel;
@property(nonatomic,strong)UILabel*leftLabel;
@property(nonatomic,strong)UILabel*rightLabel;
@property(nonatomic,strong)SYLiveRoomFansProgressView*progressView;
@end
@implementation SYLiveRoomFansLevelCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setupSubViews{
    self.clipsToBounds = YES;
    [self addSubview:self.levelView];
    [self addSubview:self.infoLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.levelView.sy_left = 16;
    self.levelView.sy_centerY = self.sy_height/2.f;
    self.progressView.sy_left = self.levelView.sy_right+18;
    self.progressView.sy_width = self.sy_width - self.progressView.sy_left - 16;
    self.progressView.sy_centerY = self.levelView.sy_centerY;
    [self.infoLabel sizeToFit];
    self.infoLabel.sy_left = self.levelView.sy_right+18;
    self.infoLabel.sy_bottom = self.progressView.sy_top-5;
    [self.leftLabel sizeToFit];
    self.leftLabel.sy_left = self.progressView.sy_left+3;
    self.leftLabel.sy_top = self.progressView.sy_bottom+5;
    [self.rightLabel sizeToFit];
    self.rightLabel.sy_right = self.progressView.sy_right-3;
    self.rightLabel.sy_top = self.progressView.sy_bottom+5;
}
-(void)resetFansLevelCellInfo:(id)info{
    SYLiveRoomFansViewLevelInfoModel*model = (SYLiveRoomFansViewLevelInfoModel*)info;
    NSString*level = [NSString sy_isBlankString:model.level]?@"0":model.level;
    [self.levelView setViewInfoIconName:@"真爱团" andLevel:level];
    self.infoLabel.text = model.gift_unlock;
    self.leftLabel.text = [NSString stringWithFormat:@"LV%@",level];
    self.rightLabel.text = [NSString stringWithFormat:@"LV%ld",[level integerValue]+1];;
    [self resetSubViewsFrames];
    NSString*left = [NSString sy_isBlankString:model.close_score]?@"0":model.close_score;
    NSString*right = [NSString sy_isBlankString:model.next_level_score]?@"1":model.next_level_score;
    [self.progressView setProgressViewInfo:[NSString stringWithFormat:@"%@/%@",left,right]];
    
}
- (SYLiveRoomFansLevelView *)levelView{
    if (!_levelView) {
        SYLiveRoomFansLevelView*level = [[SYLiveRoomFansLevelView alloc]initWithFrame:CGRectMake(0, 0, 85, 32) andFontSize:16];
        _levelView = level;
    }
    return _levelView;
}
- (SYLiveRoomFansProgressView *)progressView{
    if (!_progressView) {
        SYLiveRoomFansProgressView* p = [[SYLiveRoomFansProgressView alloc]initWithFrame:CGRectMake(0, 0, 0, 12)];
        _progressView = p;
    }
    return _progressView;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        _infoLabel = lab;
    }
    return _infoLabel;
}
- (UILabel *)leftLabel{
    if (!_leftLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        _leftLabel = lab;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel{
    if (!_rightLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        _rightLabel = lab;
    }
    return _rightLabel;
}
@end
@interface SYLiveRoomFansProgressView()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property(nonatomic,strong)UIView*progressView;
@property(nonatomic,strong)UILabel*progressLabel;
@end
@implementation SYLiveRoomFansProgressView
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
    self.backgroundColor = [UIColor sy_colorWithHexString:@"#D8D8D8"];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.sy_height/2.f;
    
    [self addSubview:self.progressView];
    [self.progressView.layer addSublayer:self.gradientLayer];
    [self addSubview:self.progressLabel];
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.progressView.sy_left = 0;
    self.progressView.sy_top = 0;
    self.progressLabel.bounds = self.bounds;
    self.progressLabel.sy_top = 0;
    self.progressLabel.sy_left = 0;
    self.gradientLayer.frame = CGRectMake(0, 0, self.progressView.sy_width, self.progressView.sy_height);
    
}
-(void)setProgressViewInfo:(NSString*)info{
    [self resetSubViewsFrames];
    self.progressLabel.text = info;
    CGFloat pro= [info floatValue];
    self.progressView.sy_width = self.sy_width*pro;
    
}
- (UILabel *)progressLabel{
    if (!_progressLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:self.bounds];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment =NSTextAlignmentCenter;
        _progressLabel = lab;
    }
    return _progressLabel;
}
- (UIView *)progressView{
    if (!_progressView) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.sy_height)];
        view.layer.cornerRadius = self.sy_height/2.f;
        view.layer.masksToBounds = YES;
        _progressView = view;
    }
    return _progressView;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer*layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, self.progressView.sy_width, self.progressView.sy_height);
        layer.colors = @[(__bridge id)[UIColor  sy_colorWithHexString:@"#FF51AD"].CGColor,(__bridge id)[UIColor sy_colorWithHexString:@"#7138EF"].CGColor];
        layer.locations = @[@(0.1), @(1)];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 0);
        _gradientLayer = layer;
    }
    return _gradientLayer;
}
@end
