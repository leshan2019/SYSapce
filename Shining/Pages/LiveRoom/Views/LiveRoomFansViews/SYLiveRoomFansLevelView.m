//
//  SYLiveRoomFansLevelView.m
//  Shining
//
//  Created by leeco on 2019/11/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansLevelView.h"
@interface SYLiveRoomFansLevelView()
@property(nonatomic,strong)UIView*bgView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UILabel*levelLabel;
@property(nonatomic,assign)CGFloat fontSize;
@end
@implementation SYLiveRoomFansLevelView
- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fontSize = size;
        [self setupSubViews];
    }
    return self;
}
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
//    self.fontSize = 10;
    [self addSubview:self.bgView];
    [self.bgView.layer addSublayer:self.gradientLayer];
    [self addSubview:self.titleLabel];
    [self addSubview:self.levelLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    [self.titleLabel sizeToFit];
//    [self.levelLabel sizeToFit];
    CGFloat width = self.titleLabel.sy_width;
    CGFloat total = width +1 +self.levelLabel.sy_width;
    CGFloat x = (self.sy_width - total)/2.f;
    self.titleLabel.sy_left = x;
    self.levelLabel.sy_left = self.titleLabel.sy_right+1;
    self.titleLabel.sy_centerY = self.bounds.size.height/2.f;
    self.levelLabel.sy_centerY = self.bounds.size.height/2.f;
}
-(void)setViewInfoIconName:(NSString*)name andLevel:(NSString*)level{
    self.titleLabel.text = name;
    self.levelLabel.text = level;
    [self resetSubViewsFrames];
}
- (UIView *)bgView{
    if (!_bgView) {
        UIView*view = [[UIView alloc]initWithFrame:self.bounds];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = self.sy_height/2.f;
        _bgView = view;
    }
    return _bgView;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer*layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(0, 0, self.bgView.sy_width, self.bgView.sy_height);
        layer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#FFB0CC"].CGColor, (__bridge id)[UIColor  sy_colorWithHexString:@"#FF1453"].CGColor];
        layer.locations = @[@(0.1), @(1)];
        _gradientLayer = layer;
    }
    return _gradientLayer;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:self.fontSize];
        lab.textColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _titleLabel = lab;
    }
    return _titleLabel;
}
- (UILabel *)levelLabel{
    if (!_levelLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.fontSize+3), self.fontSize+1)];
        lab.font = [UIFont fontWithName:@"Arial-BoldMT" size:self.fontSize];
        lab.textColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor =[UIColor clearColor];
        _levelLabel = lab;
    }
    return _levelLabel;
}
@end
