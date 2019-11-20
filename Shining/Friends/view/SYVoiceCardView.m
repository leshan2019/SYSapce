//
//  SYVoiceCardView.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceCardView.h"
#import <SVGAPlayer/SVGA.h>

@interface SYVoiceCardView(){
    CGPoint _originalCenter;
    CGFloat _currentAngle;
    BOOL _isLeft;
}
@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UIView *coverBgView;
@property (nonatomic, strong) UILabel *firstVoiceLabel;
@property (nonatomic, strong) UILabel *sencondVoiceLabel;
@property (nonatomic, strong) UILabel *contentTextView;
@property (nonatomic, strong) UIView *userInfoView;
@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, strong) SVGAPlayer *animationPlayer;
@end

@implementation SYVoiceCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        
        _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
        
        [self addPanGest];
        
        [self configLayer];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
}

- (void)initView{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgImg];
    [self addSubview:self.coverBgView];
    [self addSubview:self.firstVoiceLabel];
    [self addSubview:self.sencondVoiceLabel];
    [self addSubview:self.contentTextView];
    [self addSubview:self.animationPlayer];
    [self addSubview:self.userInfoView];
    [self.userInfoView addSubview:self.avatarImgView];
    [self.userInfoView addSubview:self.userNameLabel];
    [self.userInfoView addSubview:self.attentionBtn];
    [self addSubview:self.contactBtn];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.coverBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.firstVoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(18);
        make.top.equalTo(self).with.offset(18);
        make.size.mas_equalTo(CGSizeMake(53, 20));
    }];
    
    [self.sencondVoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstVoiceLabel.mas_right).with.offset(18);
        make.top.equalTo(self).with.offset(18);
        make.size.mas_equalTo(CGSizeMake(53, 20));
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(300, 160));
        
    }];
    
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.bottom.equalTo(self).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(150, 38));
    }];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userInfoView.mas_left);
        make.top.equalTo(self.userInfoView.mas_top);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userInfoView.mas_right).with.offset(-4);
        make.top.equalTo(self.userInfoView.mas_top).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.attentionBtn.mas_left).with.offset(-2);
        make.left.equalTo(self.avatarImgView.mas_right).with.offset(2);
        make.top.equalTo(self.userInfoView.mas_top);
        make.height.equalTo(self.userInfoView.mas_height);
    }];
    
    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-18);
        make.bottom.equalTo(self).with.offset(-16);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
        
}

- (void)updateUIByUser:(SYVoiceMatchUserModel *)userInfo
{
    [self.bgImg sd_setImageWithURL:[NSURL URLWithString:userInfo.background_imgurl] placeholderImage:[UIImage imageNamed_sy:@"voicecard_defalutbg"]];
    NSString *soundtone_word = [userInfo.soundtone_word stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    self.contentTextView.text = [NSString sy_safeString:soundtone_word];
    [self.contentTextView sizeToFit];
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.sy_width-20);
    }];

    self.userNameLabel.text = userInfo.username;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_imgurl] placeholderImage:[UIImage imageNamed_sy:@"letv_chatHome_user"]];
    if ([userInfo.is_concern isEqualToString:@"1"]) {
        [self.attentionBtn setImage:[UIImage imageNamed_sy:@"voice_attentioned"] forState:UIControlStateNormal];
    }else{
        [self.attentionBtn setImage:[UIImage imageNamed_sy:@"voice_attention"] forState:UIControlStateNormal];
    }
    
    NSArray *soundtoneList = [userInfo.soundtone_list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"%@ ~ %@", obj1, obj2);
        if (![obj1 isKindOfClass:[SYSoundtoneModel class]] || ![obj2 isKindOfClass:[SYSoundtoneModel class]]) {
            return NSOrderedDescending;
        }
        SYSoundtoneModel *model1 = (SYSoundtoneModel *)obj1;
        SYSoundtoneModel *model2 = (SYSoundtoneModel *)obj2;

        return [@(model2.score) compare:@(model1.score)];
    }];
    
    NSMutableArray *newSoundtoneList = [NSMutableArray array];
    NSInteger recScore = [SYSettingManager getSoundRecScore];
    for (int i=0; i<soundtoneList.count; i++) {
        SYSoundtoneModel *model = soundtoneList[i];
        if (model.score>recScore) {
            [newSoundtoneList addObject:model];
        }
    }
    if (newSoundtoneList.count == 1) {
        SYSoundtoneModel *model = newSoundtoneList[0];
        NSString *gender = model.sound_type;
        NSString *soundStoneString = [NSString stringWithFormat:@"平平无奇的%@音",gender];
        self.firstVoiceLabel.text = soundStoneString;
        self.sencondVoiceLabel.hidden = YES;
        CGSize numerSize = [soundStoneString boundingRectWithSize:CGSizeMake(300, 28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _firstVoiceLabel.font} context:nil].size;
        numerSize.width += 18;
        numerSize.height = 20;
        [self.firstVoiceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(numerSize);
        }];
    }else if (newSoundtoneList.count>1){
        SYSoundtoneModel *model = newSoundtoneList[1];
        NSString *soundStoneString = [NSString sy_safeString:model.sound_type];
        self.firstVoiceLabel.text = soundStoneString;
        CGSize numerSize = [soundStoneString boundingRectWithSize:CGSizeMake(300, 28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _firstVoiceLabel.font} context:nil].size;
        numerSize.width += 18;
        numerSize.height = 20;
        [self.firstVoiceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(numerSize);
        }];
        if (newSoundtoneList.count == 2) {
            self.sencondVoiceLabel.hidden = YES;
        }
    }else if (newSoundtoneList.count<=0){
        self.firstVoiceLabel.hidden = YES;
        self.sencondVoiceLabel.hidden = YES;
    }
    if (newSoundtoneList.count>2){
        SYSoundtoneModel *model = newSoundtoneList[2];
        self.sencondVoiceLabel.hidden = !(model.score>recScore);
        self.sencondVoiceLabel.text = model.sound_type;
        CGSize numerSize = [model.sound_type boundingRectWithSize:CGSizeMake(300, 28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _sencondVoiceLabel.font} context:nil].size;
        numerSize.width += 18;
        numerSize.height = 20;
        [self.sencondVoiceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstVoiceLabel.mas_right).with.offset(18);
            make.size.mas_equalTo(numerSize);
        }];
    }
}

- (void)addPanGest {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestHandle:)];
    [self addGestureRecognizer:pan];
}

- (void)configLayer {
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

- (void)showAnimationPlayer {
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"voiceplaying" ofType:@"svga"];
    NSURL *url=[NSURL fileURLWithPath:filePath];
    if ([NSObject sy_empty:url]) {
        return;
    }
    SVGAParser *parser = [[SVGAParser alloc] init];
    __weak typeof(self) weakSelf = self;
    [parser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        if (videoItem != nil) {
            CGFloat width = __MainScreen_Width*0.15;
            CGFloat height = width * videoItem.videoSize.height/videoItem.videoSize.width;

            [weakSelf.animationPlayer mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.userInfoView.mas_top).with.offset(20);
                make.left.equalTo(self.userInfoView.mas_left);
                make.size.mas_equalTo(CGSizeMake(width, height));
            }];
            weakSelf.animationPlayer.videoItem = videoItem;
            [weakSelf.animationPlayer startAnimation];
           
        } else {
            [self.animationPlayer stopAnimation];
            self.animationPlayer.videoItem = nil;
        }
    } failureBlock:nil];
}

#pragma mark lazyload
- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [UIImageView new];
        _bgImg.image = [UIImage imageNamed_sy:@"voicecard_defalutbg"];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImg;
}

- (UIView *)coverBgView {
    if (!_coverBgView) {
        _coverBgView = [UIView new];
        _coverBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _coverBgView;

}

- (UILabel *)firstVoiceLabel {
    if (!_firstVoiceLabel) {
        _firstVoiceLabel = [UILabel new];
        _firstVoiceLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _firstVoiceLabel.layer.cornerRadius = 10;
        _firstVoiceLabel.layer.masksToBounds = YES;
        _firstVoiceLabel.textColor = [UIColor whiteColor];
        _firstVoiceLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _firstVoiceLabel.textAlignment = NSTextAlignmentCenter;
//        _firstVoiceLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//        _firstVoiceLabel.layer.shadowOffset = CGSizeMake(0, 3);
//        _firstVoiceLabel.layer.shadowOpacity = 0.5;

    }
    return _firstVoiceLabel;
}

- (UILabel *)sencondVoiceLabel {
    if (!_sencondVoiceLabel) {
        _sencondVoiceLabel = [UILabel new];
        _sencondVoiceLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        _sencondVoiceLabel.layer.cornerRadius = 10;
        _sencondVoiceLabel.layer.masksToBounds = YES;
        _sencondVoiceLabel.textColor = [UIColor whiteColor];
        _sencondVoiceLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _sencondVoiceLabel.textAlignment = NSTextAlignmentCenter;
//        _sencondVoiceLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//        _sencondVoiceLabel.layer.shadowOffset = CGSizeMake(0, 3);
//        _sencondVoiceLabel.layer.shadowOpacity = 0.5;
    }
    return _sencondVoiceLabel;
}

- (UILabel *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [UILabel new];
        _contentTextView.backgroundColor =[UIColor clearColor];
        _contentTextView.textAlignment = NSTextAlignmentCenter;
        _contentTextView.textColor = [UIColor whiteColor];
        _contentTextView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _contentTextView.numberOfLines = 7;
    }
    return _contentTextView;
}

- (UIView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [UIView new];
        _userInfoView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _userInfoView.layer.cornerRadius = 19;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoUserinfo:)];
         [_userInfoView addGestureRecognizer:tap];
    }
    return _userInfoView;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        _avatarImgView.layer.masksToBounds = YES;
        _avatarImgView.layer.cornerRadius = 19;
        _avatarImgView.layer.borderWidth = 1;
        _avatarImgView.layer.borderColor = [[UIColor sam_colorWithHex:@"#E6E6E6"] CGColor];
    }
    return _avatarImgView;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [UILabel new];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];

    }
    return _userNameLabel;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [UIButton new];
        [_attentionBtn setImage:[UIImage imageNamed_sy:@"voice_attention"] forState:UIControlStateNormal];
        [_attentionBtn addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (UIButton *)contactBtn {
    if (!_contactBtn) {
        _contactBtn = [UIButton new];
        [_contactBtn setImage:[UIImage imageNamed_sy:@"voice_contact"] forState:UIControlStateNormal];
        [_contactBtn addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactBtn;
}

- (SVGAPlayer *)animationPlayer {
    if (!_animationPlayer) {
        _animationPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectZero];
        _animationPlayer.loops = 0;        
    }
    return _animationPlayer;
}

#pragma mark Gesture
- (void)panGestHandle:(UIPanGestureRecognizer *)panGest {
    if (panGest.state == UIGestureRecognizerStateChanged) {
        
        CGPoint movePoint = [panGest translationInView:self];
        _isLeft = (movePoint.x < 0);
        
        self.center = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);
        
        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 4.0;
        _currentAngle = angle;
 
        if (@available(iOS 11.0, *)) {
            self.transform = CGAffineTransformMakeRotation(angle);
            
        }

        [panGest setTranslation:CGPointZero inView:self];

        
        CGFloat width = self.frame.origin.x;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardItemViewPanGestureStateChanged:withMoveWidth:)]) {
             [self.delegate cardItemViewPanGestureStateChanged:self withMoveWidth:fabs(width)];
         }
        
    } else if (panGest.state == UIGestureRecognizerStateEnded) {
        
        CGPoint vel = [panGest velocityInView:self];
        if (vel.x > 800 || vel.x < - 800) {
            [self remove];
            return ;
        }
        if (self.frame.origin.x + self.frame.size.width > 150 && self.frame.origin.x < self.frame.size.width - 150) {
            [UIView animateWithDuration:0.1 animations:^{
                self.center = _originalCenter;
                self.transform = CGAffineTransformMakeRotation(0);
            }];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardItemViewPanGestureStateEnd:)]) {
                [self.delegate cardItemViewPanGestureStateEnd:self];
            }
        } else {
            [self remove];
        }
    }
}

- (void)remove {
    [UIView animateWithDuration:0.1 animations:^{
        
        // right
        if (!_isLeft) {
            self.center = CGPointMake(self.frame.size.width + 1000, ceilf(self.center.y + _currentAngle * self.frame.size.height));
        } else { // left
            self.center = CGPointMake(- 1000, ceilf(self.center.y - _currentAngle * self.frame.size.height));
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:)]) {
                [self.delegate cardItemViewDidRemoveFromSuperView:self];
            }
        }
    }];
    
}

- (void)removeWithLeft:(BOOL)left {
    [UIView animateWithDuration:0.1 animations:^{
        
        // right
        if (!left) {
            self.center = CGPointMake(self.frame.size.width + 1000, ceilf(self.center.y + _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0)));
        } else { // left
            self.center = CGPointMake(- 1000, ceilf(self.center.y - _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0)));
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardItemViewDidRemoveFromSuperView:)]) {
                [self.delegate cardItemViewDidRemoveFromSuperView:self];
            }
        }
    }];
}

-(void)attention:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(attentionUser:)]) {
        [self.delegate attentionUser:self];
    }
}

- (void)contact:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contact:)]) {
        [self.delegate contact:self];
    }
}

- (void)gotoUserinfo:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoUserinfo:)]) {
        [self.delegate gotoUserinfo:self];
    }
}
@end
