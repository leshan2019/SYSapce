//
//  SYGamebeeView.m
//  DemobeeOC
//
//  Created by leeco on 2019/8/14.
//  Copyright © 2019 JiangYue. All rights reserved.
//

#import "SYGameBeeView.h"
#import "IFMMenu.h"
#import "SYGiftInfoManager.h"
#import "FXKeyframeAnimation.h"
#import "CALayer+FXAnimationEngine.h"
@interface SYGameBeeView ()<FXAnimationDelegate>
@property (nonatomic, strong) UIImageView *gameBeeBg;

// 序列帧
@property (nonatomic, strong) UIImageView *gameBee;

@property (nonatomic, strong) UIButton *btnStart;
//  蜜豆桶
@property (nonatomic, strong) UIButton *btnBucket;

// 蜜豆图标
@property (nonatomic, strong) UIImageView *gameBeIicon;
// 账户蜜豆
@property (nonatomic, strong) UILabel *labPrice;

// 礼物说明
@property (nonatomic, strong) UIButton *btnExplain;
// 礼物列表
@property (nonatomic, strong) UIButton *btnGiftList;

// 采蜜桶数
@property (nonatomic, assign, readwrite) BeeBucketType beeBucketType;

// 采蜜状态
@property (nonatomic, assign, readwrite) BOOL beeStatus;

//  蜜豆数量 进入收银台
@property (nonatomic, strong) UIButton *btnPrice;

@property (nonatomic, strong) UIButton *dropDownBtn;

@property (nonatomic, assign) BeeBucketColorType beeBucketColorType;
@end

@implementation SYGameBeeView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SYGameBeeViewDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        _beeStatus = NO;
        [self buildUI];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)buildUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]init];
    [tap addTarget:self action:@selector(closebee)];
    [self addGestureRecognizer:tap];
    
    CGSize size = self.frame.size;
    
    UIImageView *gameBeeBg = [[UIImageView alloc ]initWithFrame:self.bounds];
    gameBeeBg.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.85f];
    gameBeeBg.backgroundColor = RGBACOLOR(1, 1, 1, 0.85f);
    gameBeeBg.layer.cornerRadius = 10;
    gameBeeBg.layer.borderWidth = 1.f;
    gameBeeBg.layer.borderColor = [UIColor sam_colorWithHex:@"#39236A"].CGColor;
    gameBeeBg.layer.masksToBounds = YES;
    _gameBeeBg = gameBeeBg;
    [self addSubview:gameBeeBg];
    
    UIImageView *gameBee = [[UIImageView alloc]initWithFrame:CGRectMake(0, 16, 320, 230)];
    _gameBee = gameBee;
    [self addSubview:gameBee];
    
    UIButton *btnStart = [[UIButton alloc]init];
    [btnStart setImage:[UIImage imageNamed_sy:@"game-bee-btn"] forState:UIControlStateNormal];
    [btnStart setImage:[UIImage imageNamed_sy:@"game-bee-btn"] forState:UIControlStateHighlighted];
    [btnStart setImage:[UIImage imageNamed_sy:@"game-bee-btn"] forState:UIControlStateDisabled];
    [btnStart addTarget:self action:@selector(startBee:) forControlEvents:UIControlEventTouchUpInside];
    _btnStart = btnStart;
    [self addSubview:btnStart];
    
    _btnStart.frame = CGRectMake((size.width - 270)/2, size.height - (size.width - 270)/2 - 44, 270, 44);
    
    
    for (int i = 0; i<=2;i++) {
        UIButton *btnBucket = [[UIButton alloc]init];
        
        [btnBucket setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnBucket setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btnBucket setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btnBucket addTarget:self action:@selector(bucket:) forControlEvents:UIControlEventTouchUpInside];
        btnBucket.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        btnBucket.tag = i+10;
        btnBucket.backgroundColor = [UIColor clearColor];
        [self addSubview:btnBucket];
        if (i == 0) {
            [btnBucket setTitle:@"1朵/10豆" forState:UIControlStateNormal];
            [btnBucket setTitle:@"1朵/10豆" forState:UIControlStateHighlighted];
            [btnBucket setTitle:@"1朵/10豆" forState:UIControlStateSelected];
        }else if (i == 1){
            [btnBucket setTitle:@"10朵/100豆" forState:UIControlStateNormal];
            [btnBucket setTitle:@"10朵/100豆" forState:UIControlStateHighlighted];
            [btnBucket setTitle:@"10朵/100豆" forState:UIControlStateSelected];
            
            _btnBucket = btnBucket;
            _btnBucket.selected = YES;
            _beeBucketType = BeeBucketType_middle;
            btnBucket.backgroundColor = RGBACOLOR(126, 69, 253, 1);
            [_gameBee setImage:[UIImage imageNamed_sy:@"m001"]];
            
        }else if (i == 2){
            [btnBucket setTitle:@"30朵/300豆" forState:UIControlStateNormal];
            [btnBucket setTitle:@"30朵/300豆" forState:UIControlStateHighlighted];
            [btnBucket setTitle:@"30朵/300豆" forState:UIControlStateSelected];
        }
        btnBucket.frame = CGRectMake((size.width - 83*3 - 10*2)/2 + (10 + 83)*i, _btnStart.frame.origin.y - 20 - 30, 83, 30);
        btnBucket.layer.borderColor = RGBACOLOR(126, 69, 253, 1).CGColor;
        btnBucket.layer.borderWidth = 1.5;
        btnBucket.layer.cornerRadius = 15;
        btnBucket.layer.masksToBounds = YES;
    }
    
    
    UIImageView *gameBeIicon = [[UIImageView alloc]initWithFrame:CGRectZero];
    _gameBeIicon = gameBeIicon;
    [gameBeIicon setImage:[UIImage imageNamed_sy:@"game-bee-peas"]];
    [self addSubview:gameBeIicon];
    
    UILabel *label = [[UILabel alloc ]init];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.text = @" ";
    [label sizeToFit];
    _labPrice = label;
    [self addSubview:label];
    gameBeIicon.frame  =CGRectMake((size.width - 12 - 3 - label.frame.size.width)/2, 25, 12, 12);
    label.frame  =CGRectMake(gameBeIicon.frame.origin.x + 12 + 3, 25 - 1, label.frame.size.width, 12);
    _labPrice.hidden = YES;
    _gameBeIicon.hidden = YES;
    
    UIButton *btnExplain = [[UIButton alloc]init];
    [btnExplain setTitle:@"活动规则" forState:UIControlStateNormal];
    [btnExplain setTitle:@"活动规则" forState:UIControlStateHighlighted];
    [btnExplain setTitleColor:RGBACOLOR(194, 167, 255, 1) forState:UIControlStateNormal];
    [btnExplain setTitleColor:RGBACOLOR(194, 167, 255, 1) forState:UIControlStateHighlighted];
    btnExplain.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [btnExplain addTarget:self action:@selector(gameBeeExplain:) forControlEvents:UIControlEventTouchUpInside];
    btnExplain.frame = CGRectMake(16, 18, 72, 26);
    btnExplain.layer.cornerRadius = 13;
    btnExplain.backgroundColor = RGBACOLOR(67, 15, 189, 0.3);
    _btnExplain = btnExplain;
    [self addSubview:btnExplain];
    
    UIButton *btnGiftList = [[UIButton alloc]init];
    [btnGiftList setBackgroundImage:[UIImage imageNamed_sy:@"game-bee-gift-btn"] forState:UIControlStateNormal];
    [btnGiftList setBackgroundImage:[UIImage imageNamed_sy:@"game-bee-gift-btn"] forState:UIControlStateHighlighted];
    [btnGiftList addTarget:self action:@selector(gameBeeGiftList:) forControlEvents:UIControlEventTouchUpInside];
    btnGiftList.frame = CGRectMake(273, 16, 30, 30);
    _btnGiftList = btnGiftList;
    [self addSubview:btnGiftList];
    
    UIButton *btnDropDown = [[UIButton alloc]init];
    [btnDropDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDropDown setTitle:@"铜桶" forState:UIControlStateNormal];
    btnDropDown.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    btnDropDown.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    btnDropDown.backgroundColor = [UIColor clearColor];
    btnDropDown.layer.borderColor = RGBACOLOR(126, 69, 253, 1).CGColor;
    btnDropDown.layer.borderWidth = 1.5;
    btnDropDown.layer.cornerRadius = 15;
    btnDropDown.layer.masksToBounds = YES;
    [btnDropDown addTarget:self action:@selector(dropDownBucket:) forControlEvents:UIControlEventTouchUpInside];
    btnDropDown.frame = CGRectMake(self.frame.size.width-83-16,CGRectGetMaxY(_btnGiftList.frame)+16 , 83, 30);
    _dropDownBtn = btnDropDown;
    [self addSubview:btnDropDown];
    
    UIImageView *arrow = [[UIImageView alloc]init];
    arrow.frame = CGRectMake(btnDropDown.frame.size.width-12-10, 11, 12, 7.5);
    arrow.image = [UIImage imageNamed_sy:@"beegame_arrow_down"];
    [btnDropDown addSubview:arrow];
    
    UIButton *btnPrice = [[UIButton alloc]init];
    [btnPrice addTarget:self action:@selector(btnPrice:) forControlEvents:UIControlEventTouchUpInside];
    _btnPrice.backgroundColor = [UIColor clearColor];
    _btnPrice = btnPrice;
    [self addSubview:btnPrice];
    
}

- (void)bucket:(UIButton *)senter{
    if (_beeStatus) {
        return ;
    }
    _btnBucket.selected = NO;
    _btnBucket.backgroundColor = [UIColor clearColor];
    _btnBucket = senter;
    _btnBucket.selected = YES;
    _btnBucket.backgroundColor = RGBACOLOR(126, 69, 253, 1);
    if (senter.tag == 10) {
        _beeBucketType = BeeBucketType_small;

    }else if (senter.tag == 11){
        _beeBucketType = BeeBucketType_middle;

    }else if (senter.tag == 12){
        _beeBucketType = BeeBucketType_big;

    }
    [self resetDefaultAnimationPoster];
}

- (void)btnPrice:(UIButton *)senter{
    if ([self.delegate respondsToSelector:@selector(gameBeeInCashierDesk)]) {
        [self.delegate gameBeeInCashierDesk];
    }
}


- (void)gameBeeExplain:(UIButton *)senter{
    if (_beeStatus) {
        return ;
    }
    if ([self.delegate respondsToSelector:@selector(gameBeeExplain)]) {
        [self.delegate gameBeeExplain];
    }
}

// 礼物列表
- (void)gameBeeGiftList:(UIButton *)senter{
    if (_beeStatus) {
        return ;
    }
    if ([self.delegate respondsToSelector:@selector(gameBeeGiftList)]) {
        [self.delegate gameBeeGiftList];
    }
}

// 礼物列表
- (void)startBee:(UIButton *)senter{
    if (_beeStatus) {
        return ;
    }
    
    if ([self.delegate respondsToSelector:@selector(startBee:)]) {
        _beeStatus = YES;
        [self newAnimationBee];
        
//        NSInteger time = arc4random() % 10;
        
        if(![SYSettingManager userHasLogin]){
            [self.delegate startBee:_beeBucketType];
        }else
        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1 + time/10.0f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.delegate startBee:_beeBucketType];
//            });
        }
        
    }
}

- (void)newAnimationBee {
    NSInteger giftID  = [self getCurrentGiftId];
    NSArray *images = [[SYGiftInfoManager sharedManager] giftAnimationImagesWithGiftID:giftID];
    
    if ([images count] == 0) {
        return;
    }
     float duration = (float)[images count] / 20.f;
    FXKeyframeAnimation *animation = [FXKeyframeAnimation animationWithIdentifier:@"beegamegift"];
    animation.delegate = self;
    animation.frames = images;
    animation.duration = duration;
    animation.repeats = 1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = _gameBee.frame;
    [self.layer addSublayer:layer];
    [layer fx_playAnimationAsyncDecodeImage:animation];
    
    _gameBee.hidden = YES;
}

/**
 * 停止采蜜
 */
- (void)stopBeeAnimation{
    _beeStatus = NO;
//    [_gameBee stopAnimating];
//    [_gameBee setAnimationImages:nil];
//    [self resetDefaultAnimationPoster];
}

- (void)updateBeeCoin:(NSInteger )num{
    if (num) {
        _labPrice.hidden = NO;
        _gameBeIicon.hidden = NO;
        _labPrice.text = [NSString stringWithFormat:@"%ld", num];
        [_labPrice sizeToFit];
        CGFloat labPricewidth = _labPrice.frame.size.width;
        CGSize size = self.frame.size;
        _gameBeIicon.frame  =CGRectMake((size.width - 12 - 3 - _labPrice.frame.size.width)/2, 25, 12, 12);
        _labPrice.frame = CGRectMake(_gameBeIicon.frame.origin.x + 12 + 3, 25 - 1, _labPrice.frame.size.width, 12);
        _btnPrice.frame = _labPrice.frame;
    }
}

/**
 * 采蜜游戏关闭
 */
- (void)closebee{
    
}

- (void)dropDownBucket:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    __weak typeof(self) weakSelf = self;
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithObjects:
                                 
                                 [IFMMenuItem itemWithImage:[UIImage imageNamed:@"address_icon_share"]
                                                      title:@"铜桶"
                                                     action:^(IFMMenuItem *item) {
                                                         [weakSelf.dropDownBtn setTitle:@"铜桶" forState:UIControlStateNormal];
                                                         weakSelf.beeBucketColorType = BeeBucketColorType_default;
                                                         [weakSelf resetPriceUI];
                                                         
                                                     }],
                                 [IFMMenuItem itemWithImage:[UIImage imageNamed:@"address_icon_modify"]
                                                      title:@"银桶"
                                                     action:^(IFMMenuItem *item) {
                                                         [weakSelf.dropDownBtn setTitle:@"银桶" forState:UIControlStateNormal];
                                                         weakSelf.beeBucketColorType = BeeBucketColorType_silvery;
                                                         [weakSelf resetPriceUI];
                                                     }],
                                 [IFMMenuItem itemWithImage:[UIImage imageNamed:@"address_icon_modify"]
                                                      title:@"金桶"
                                                     action:^(IFMMenuItem *item) {
                                                         [weakSelf.dropDownBtn setTitle:@"金桶" forState:UIControlStateNormal];
                                                         weakSelf.beeBucketColorType = BeeBucketColorType_gold;
                                                         [weakSelf resetPriceUI];
                                                     }],nil];
    
    
    IFMMenu *menu = [[IFMMenu alloc] initWithItems:menuItems];
    menu.menuBackgroundStyle = IFMMenuBackgroundStyleDark; //menu样式
    menu.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5); //下拉框的内边距
    menu.gapBetweenImageTitle = 23; //图片和标题间距
    menu.arrowHight = 5;   //指向控件的箭头的高度
    menu.menuBackGroundColor = [UIColor sy_colorWithHexString:@"#430FB9" alpha:1];   //背景颜色
    menu.minMenuItemHeight = 30;    //Item最小高度
    menu.minMenuItemWidth = 83;    //Item最小宽度
    menu.titleFont = [UIFont systemFontOfSize:12];  //Item字体
    menu.segmenteLineColor = [UIColor whiteColor];   //分割线颜色
    menu.titleColor = [UIColor sy_colorWithHexString:@"#FFFFFF" alpha:0.7]; //Item颜色
    menu.menuSegmenteLineStyle = IFMMenuSegmenteLineStyleFill;  //分割线类型
    menu.menuCornerRadiu = 15;  //menu的圆角大小
    menu.showShadow = NO;   //是否显示阴影
    
    [menu showFromRect:btn.frame inView:self];

}

- (void)resetPriceUI {
    UIButton *btnBucketOne = [self viewWithTag:10];
    UIButton *btnBucketTwo = [self viewWithTag:11];
    UIButton *btnBucketThree = [self viewWithTag:12];
    SYGiftModel *giftModel = [[SYGiftInfoManager sharedManager]giftWithGiftID:[self getCurrentBucketid]];

    if (giftModel) {
        if (btnBucketOne) {
            [btnBucketOne setTitle:[NSString stringWithFormat:@"1朵/%ld豆",(long)giftModel.price] forState:UIControlStateNormal];
            [btnBucketOne setTitle:[NSString stringWithFormat:@"1朵/%ld豆",(long)giftModel.price] forState:UIControlStateSelected];
        }
        if (btnBucketTwo) {
            [btnBucketTwo setTitle:[NSString stringWithFormat:@"10朵/%ld豆",(long)giftModel.price * 10] forState:UIControlStateNormal];
             [btnBucketTwo setTitle:[NSString stringWithFormat:@"10朵/%ld豆",(long)giftModel.price * 10] forState:UIControlStateSelected];
        }
        if (btnBucketThree) {
            [btnBucketThree setTitle:[NSString stringWithFormat:@"30朵/%ld豆",(long)giftModel.price * 30] forState:UIControlStateNormal];
            [btnBucketThree setTitle:[NSString stringWithFormat:@"30朵/%ld豆",(long)giftModel.price * 30] forState:UIControlStateSelected];
        }
        [self resetDefaultAnimationPoster];
    }

}

- (void)resetDefaultAnimationPoster {
    if (self.beeBucketType == BeeBucketType_small) {
        if (self.beeBucketColorType == BeeBucketColorType_default) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"s001"]];
        }else if (self.beeBucketColorType == BeeBucketColorType_silvery) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"s002"]];
        }else if (self.beeBucketColorType == BeeBucketColorType_gold) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"s003"]];
        }
    }else if (self.beeBucketType == BeeBucketType_middle){
        if (self.beeBucketColorType == BeeBucketColorType_default) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"m001"]];
        }else if (self.beeBucketColorType == BeeBucketColorType_silvery) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"m002"]];
        }else if (self.beeBucketColorType == BeeBucketColorType_gold) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"m003"]];
        }
    }else if (self.beeBucketType == BeeBucketType_big){
        if (self.beeBucketColorType == BeeBucketColorType_default) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"b001"]];
        }else if (self.beeBucketColorType == BeeBucketColorType_silvery) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"b002"]];
        }else if (self.beeBucketColorType == BeeBucketColorType_gold) {
            [_gameBee setImage:[UIImage imageNamed_sy:@"b003"]];
        }
    }
}

- (NSInteger)getCurrentBucketid {
    NSInteger bucketId = [SYSettingManager syIsTestApi]? 73:68;
    switch (self.beeBucketColorType) {
        case BeeBucketColorType_default:
            bucketId = [SYSettingManager syIsTestApi]? 73:68;
            break;
        case BeeBucketColorType_silvery:
            bucketId = [SYSettingManager syIsTestApi]?90:75;
            break;
        case BeeBucketColorType_gold:
            bucketId = [SYSettingManager syIsTestApi]?91:76;
            break;
        default:
            break;
    }
    return bucketId;
}

- (NSInteger)getCurrentGiftId {
    NSInteger giftId = [SYSettingManager syIsTestApi]? 74:70;
    switch (self.beeBucketType) {
        case BeeBucketType_small:
            if (self.beeBucketColorType == BeeBucketColorType_default) {
                giftId = [SYSettingManager syIsTestApi]? 74:70;
            }else if (self.beeBucketColorType == BeeBucketColorType_silvery) {
                giftId = [SYSettingManager syIsTestApi]? 84:77;
            }else if (self.beeBucketColorType == BeeBucketColorType_gold) {
                giftId = [SYSettingManager syIsTestApi]? 87:80;
            }
            break;
        case BeeBucketType_middle:
            if (self.beeBucketColorType == BeeBucketColorType_default) {
                giftId = [SYSettingManager syIsTestApi]? 75:71;
            }else if (self.beeBucketColorType == BeeBucketColorType_silvery) {
                giftId = [SYSettingManager syIsTestApi]? 85:78;
            }else if (self.beeBucketColorType == BeeBucketColorType_gold) {
                giftId = [SYSettingManager syIsTestApi]? 88:81;
            }
            break;
        case BeeBucketType_big:
            if (self.beeBucketColorType == BeeBucketColorType_default) {
                giftId = [SYSettingManager syIsTestApi]? 76:72;
            }else if (self.beeBucketColorType == BeeBucketColorType_silvery) {
                giftId = [SYSettingManager syIsTestApi]? 86:79;
            }else if (self.beeBucketColorType == BeeBucketColorType_gold) {
                giftId = [SYSettingManager syIsTestApi]? 89:82;
            }
            break;
        default:
            break;
    }
    return giftId;
}

#pragma mark - FXAnimationDelegate

- (void)fxAnimationDidStart:(FXAnimation *)anim {
}

- (void)fxAnimationDidStop:(FXAnimation *)anim finished:(BOOL)finished {
    _beeStatus = NO;
    _gameBee.hidden = NO;
    [self resetDefaultAnimationPoster];
    [self.delegate startBee:_beeBucketType];
}
@end
