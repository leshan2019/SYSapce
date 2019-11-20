//
//  SYBeautifyConfigView.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SYFilterCollectionCell.h"
#import "SYLivingShowSlider.h"
#import "SYBeautifyConfigView.h"

#define SYFilterNameKey @"name"
#define SYFilterIconKey @"icon"
#define SYFilterIdKey @"id"
NSString* SYFilterNullId = @"filter.id==null";

static CGFloat SYEffectDefaultValueSmoothing = 0.30f;
static CGFloat SYEffectDefaultValueSlimming = 0.20f;
static CGFloat SYEffectDefaultValueEyelid = 0.30f;
static CGFloat SYEffectDefaultValueWhitening = 0.40f;
static CGFloat SYEffectDefaultValue = 0.75f;

@interface SYBeautifyConfigView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray* filterEffects;
@property (nonatomic, copy, readonly) NSString* currentEffectId;
@property (nonatomic, assign, readonly) CGFloat currentEffectValue;

@property (nonatomic, strong) UIView* titleDecorationView;
@property (nonatomic, strong) UILabel* titleLabel;

// Smoother: 磨皮
// Slimming: 瘦脸
// Eyelid: 大眼
// Whitening: 美白

@property (nonatomic, strong) UIStackView* mainLayout;
@property (nonatomic, strong) UIStackView* visibleLayout;

@property (nonatomic, strong) UIView* topActionView;
@property (nonatomic, strong) UIStackView* activateFilterLayout;
@property (nonatomic, strong) UILabel* activateFilterLabel;
@property (nonatomic, strong) UISlider* activateFilterSlider;

@property (nonatomic, strong) UIStackView* titleLayout;

@property (nonatomic, strong) UIStackView* resetLayout;
@property (nonatomic, strong) UIButton* resetButton;

@property (nonatomic, strong) UIStackView* spaceLineLayout;

@property (nonatomic, strong) UISlider* smootherSlider;
@property (nonatomic, strong) UIStackView* smootherLayout;
@property (nonatomic, assign) CGFloat smootherValue;

@property (nonatomic, strong) UISlider* slimmingSlider;
@property (nonatomic, strong) UIStackView* slimmingLayout;
@property (nonatomic, assign) CGFloat slimmingValue;

@property (nonatomic, strong) UISlider* eyelidSlider;
@property (nonatomic, strong) UIStackView* eyelidLayout;
@property (nonatomic, assign) CGFloat eyelidValue;

@property (nonatomic, strong) UISlider* whiteningSlider;
@property (nonatomic, strong) UIStackView* whiteningLayout;
@property (nonatomic, assign) CGFloat whiteningValue;

@property (nonatomic, strong) UIStackView* beautifyLayout;

@property (nonatomic, strong) UICollectionView* filterCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* flowLayout;

@property (nonatomic, strong) UIView* midSpaceView;

- (void) setCurrentEffectId: (NSString*) effectId withValue: (CGFloat) value;
@end

@implementation SYBeautifyConfigView

- (instancetype) initWithFrame: (CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        _currentEffectId = nil;
        _currentEffectValue = 0;

        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview: self.mainLayout];
        [self.mainLayout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void) setDelegate: (id<SYBeautifyConfigDelegate>) delegate {
    if (!delegate || _delegate == delegate) {
        return;
    }
    _delegate = delegate;

#define CALL_DELEGATE(name, Name) \
{ \
    if ([_delegate respondsToSelector: @selector(name)]) { \
        CGFloat value = [_delegate name]; \
        self.name##Slider.value = value * 100; \
        if (_delegate && [_delegate respondsToSelector: @selector(set##Name:)]) { \
            [_delegate set##Name: self.name##Slider.value / 100.f]; \
        } \
    } \
}
    CALL_DELEGATE(smoother, Smoother);
    CALL_DELEGATE(slimming, Slimming);
    CALL_DELEGATE(eyelid, Eyelid);
    CALL_DELEGATE(whitening, Whitening);
    
    if ([_delegate respondsToSelector: @selector(effectId)]) {
        NSString* effectId = [_delegate effectId];
        if (effectId.length) {
            if ([_delegate respondsToSelector: @selector(valueForEffectId:)]) {
                CGFloat value = [_delegate valueForEffectId: effectId];
                [self setCurrentEffectId: effectId withValue: value];
            }
        } else {
            [self setCurrentEffectId: @"SkinFair_2" withValue: 0.75];
        }
        //self.currentEffectId = effectId;
    }
#undef CALL_DELEGATE
}

- (UISlider*) createSlider {
    UISlider* slider = [[SYLivingShowSlider alloc] initWithFrame: CGRectZero];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.continuous = YES;
    //slider.thumbTintColor = [UIColor sy_colorWithHexString: @"#FF40A5"];
    //slider.tintColor = [UIColor sy_colorWithHexString: @"#FF40A5"];
    
    slider.minimumTrackTintColor = [UIColor sy_colorWithHexString: @"#FF40A5"];
    UIImage* trackImage = [[UIImage imageNamed_sy: @"slider_minimum_track"] stretchableImageWithLeftCapWidth: 1 topCapHeight: 0];
    [slider setMinimumTrackImage: trackImage forState: UIControlStateNormal];
    slider.maximumTrackTintColor = [UIColor sy_colorWithHexString: @"#EEEEEE"];
    UIImage* thumb = [UIImage imageNamed_sy: @"slider_thumb"];
    [slider setThumbImage: thumb forState: UIControlStateNormal];
    
    return slider;
}

- (UIStackView*) createSliderLayoutWithIcon: (NSString*) iconName title: (NSString*) title slider: (UISlider*) slider {
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed_sy: iconName]];
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
    label.text = title;
    label.font = [UIFont systemFontOfSize: 14.0f];
    label.textColor = [UIColor sy_colorWithHexString: @"#0B0B0B "];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    
    UIStackView* titleStack = [[UIStackView alloc] initWithArrangedSubviews: @[
        imageView,
        label,
    ]];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24.0f);
        make.width.mas_equalTo(24.0f);
    }];

    titleStack.axis = UILayoutConstraintAxisVertical;
    titleStack.alignment = UIStackViewAlignmentCenter;
    titleStack.distribution = UIStackViewDistributionFill;
    titleStack.layoutMarginsRelativeArrangement = YES;
    titleStack.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 8);
    
    UIStackView* mainStack = [[UIStackView alloc] initWithArrangedSubviews: @[
        titleStack,
        slider,
    ]];
    mainStack.axis = UILayoutConstraintAxisHorizontal;
    mainStack.alignment = UIStackViewAlignmentFill;
    mainStack.distribution = UIStackViewDistributionFill;
    [slider setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisHorizontal];
    return mainStack;
}

#pragma mark -
#pragma mark getter

- (NSArray*) filterEffects {
    if (!_filterEffects) {
#define SYEFFECT_ELEMENT(name, icon, id) \
@{ \
    SYFilterNameKey: name, \
    SYFilterIconKey: icon, \
    SYFilterIdKey: id, \
}
        NSArray* effects = @[
            SYEFFECT_ELEMENT(@"原画", @"tu_thumb_original", SYFilterNullId),
            SYEFFECT_ELEMENT(@"心动", @"tu_thumb_beckoning", @"SkinBeckoning_2"),
            SYEFFECT_ELEMENT(@"淡奶", @"tu_thumb_butter", @"SkinButter_2"),
            SYEFFECT_ELEMENT(@"清晰", @"tu_thumb_clear", @"SkinClear_2"),
            SYEFFECT_ELEMENT(@"告白", @"tu_thumb_confession", @"SkinConfession_2"),
            SYEFFECT_ELEMENT(@"曙光", @"tu_thumb_dawn", @"SkinDawn_2"),
            SYEFFECT_ELEMENT(@"黄昏", @"tu_thumb_dusk", @"SkinDusk_2"),
            SYEFFECT_ELEMENT(@"非凡", @"tu_thumb_extraordinary", @"SkinExtraordinary_2"),
            SYEFFECT_ELEMENT(@"白皙", @"tu_thumb_fair", @"SkinFair_2"),
            SYEFFECT_ELEMENT(@"蜜糖", @"tu_thumb_honey", @"SkinHoney_2"),
            SYEFFECT_ELEMENT(@"日系", @"tu_thumb_japanese", @"SkinJapanese_2"),
            SYEFFECT_ELEMENT(@"清逸", @"tu_thumb_leisurely", @"SkinLeisurely_2"),
            SYEFFECT_ELEMENT(@"莲花", @"tu_thumb_lotus", @"SkinLotus_2"),
            SYEFFECT_ELEMENT(@"自然", @"tu_thumb_natural", @"SkinNatural_2"),
            SYEFFECT_ELEMENT(@"怀旧", @"tu_thumb_nostalgia", @"SkinNostalgia_2"),
            SYEFFECT_ELEMENT(@"素净", @"tu_thumb_plain", @"SkinPlain_2"),
            SYEFFECT_ELEMENT(@"玫瑰", @"tu_thumb_rose", @"SkinRose_2"),
            SYEFFECT_ELEMENT(@"初夏", @"tu_thumb_summer", @"SkinSummer_2"),
            SYEFFECT_ELEMENT(@"甜蜜", @"tu_thumb_sweet", @"SkinSweet_2"),
            SYEFFECT_ELEMENT(@"粉嫩", @"tu_thumb_tender", @"SkinTender_2"),
            SYEFFECT_ELEMENT(@"温暖", @"tu_thumb_warm", @"SkinWarm_2"),
        ];
#undef SYEFFECT_ELEMENT
        _filterEffects = effects;
    }
    
    return _filterEffects;
}

- (UILabel*) activateFilterLabel {
    if (!_activateFilterLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        label.font = [UIFont systemFontOfSize: 14.0f];
        label.textColor = [UIColor sy_colorWithHexString: @"#FFFFFF"];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 16.0f);
        _activateFilterLabel = label;
    }
    
    return _activateFilterLabel;
}

- (UISlider*) activateFilterSlider {
    if (!_activateFilterSlider) {
        UISlider* slider = [self createSlider];
        [slider addTarget: self action: @selector(currentEffectValueChanged:) forControlEvents: UIControlEventValueChanged];
        _activateFilterSlider = slider;
    }
    return _activateFilterSlider;
}

- (UIView*) topActionView {
    if (!_topActionView) {
        UIView* view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview: self.activateFilterLayout];
        [self.activateFilterLayout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        _topActionView = view;
    }
    
    return _topActionView;
}

- (UIStackView*) activateFilterLayout {
    if (!_activateFilterLayout) {
        UIView* space = [[UIView alloc] initWithFrame: CGRectZero];
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(16.0f);
        }];
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: @[
            self.activateFilterLabel,
            space,
            self.activateFilterSlider,
        ]];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFill;
        stackView.layoutMarginsRelativeArrangement = YES;
        stackView.layoutMargins = UIEdgeInsetsMake(0, 16.0f, 14.0f, 60.f);
        stackView.hidden = YES;
        _activateFilterLayout = stackView;
    }
    
    return _activateFilterLayout;
}

- (UIButton*) resetButton {
    if (!_resetButton) {
        UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        NSAttributedString* titleString = [[NSAttributedString alloc] initWithString: @"重置" attributes: @{
            NSForegroundColorAttributeName: [UIColor sy_colorWithHexString: @"#888888"],
            NSFontAttributeName: [UIFont systemFontOfSize: 14.0f],
        }];
        [button setAttributedTitle: titleString forState: UIControlStateNormal];
        [button addTarget: self action: @selector(resetButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        
        UIImage* image = [[UIImage imageNamed_sy: @"reset_icon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [button setImage: image forState: UIControlStateNormal];
        [button setImageEdgeInsets: UIEdgeInsetsMake(0, 4, 0, 4)];
        [button setTitleEdgeInsets: UIEdgeInsetsMake(0, 10, 0, 10)];
        [button setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisHorizontal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _resetButton = button;
    }
    return _resetButton;
}

- (UIStackView*) resetLayout {
    if (!_resetLayout) {
        UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews: @[
            self.resetButton,
        ]];
        stack.axis = UILayoutConstraintAxisHorizontal;
        stack.alignment = UIStackViewAlignmentFill;
        stack.distribution = UIStackViewDistributionFill;
        stack.layoutMarginsRelativeArrangement = YES;
        stack.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 16);
        _resetLayout = stack;
    }
    
    return _resetLayout;
}

- (UIStackView*) spaceLineLayout {
    if (!_spaceLineLayout) {
        UIView* line = [[UIView alloc] initWithFrame: CGRectZero];
        line.backgroundColor = [UIColor sy_colorWithHexString: @"#F3F3F3"];

        UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews: @[
            line,
        ]];
        stack.axis = UILayoutConstraintAxisHorizontal;
        stack.alignment = UIStackViewAlignmentFill;
        stack.distribution = UIStackViewDistributionFill;
        stack.layoutMarginsRelativeArrangement = YES;
        stack.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 16);
        _spaceLineLayout = stack;
    }
    
    return _spaceLineLayout;
}

- (UIStackView*) titleLayout {
    if (!_titleLayout) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        label.text = @"美颜";
        label.font = [UIFont systemFontOfSize: 12.0f];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor sam_colorWithHex:@"#000000"];
        
        UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews: @[
            label,
        ]];
        stack.axis = UILayoutConstraintAxisHorizontal;
        stack.alignment = UIStackViewAlignmentCenter;
        stack.distribution = UIStackViewDistributionFill;
        stack.layoutMarginsRelativeArrangement = YES;
        stack.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 16);
        
        _titleLayout = stack;
    }
    
    return _titleLayout;
}

- (UISlider*) smootherSlider {
    if (!_smootherSlider) {
        UISlider* slider = [self createSlider];
        [slider addTarget: self action: @selector(smootherChanged:) forControlEvents: UIControlEventValueChanged];
        _smootherSlider = slider;
    }
    
    return _smootherSlider;
}

- (UIStackView*) smootherLayout {
    if (!_smootherLayout) {
        UIStackView* stack = [self createSliderLayoutWithIcon: @"smoother_icon" title: @"磨皮" slider: self.smootherSlider];
        _smootherLayout = stack;
    }
    
    return _smootherLayout;
}

- (UISlider*) slimmingSlider {
    if (!_slimmingSlider) {
        UISlider* slider = [self createSlider];
        [slider addTarget: self action: @selector(slimmingChanged:) forControlEvents: UIControlEventValueChanged];
        _slimmingSlider = slider;
    }
    
    return _slimmingSlider;
}

- (UIStackView*) slimmingLayout {
    if (!_slimmingLayout) {
        UIStackView* stack = [self createSliderLayoutWithIcon: @"slimming_icon" title: @"瘦脸" slider: self.slimmingSlider];
        
        _slimmingLayout = stack;
    }
    
    return _slimmingLayout;
}

- (UISlider*) eyelidSlider {
    if (!_eyelidSlider) {
        UISlider* slider = [self createSlider];
        [slider addTarget: self action: @selector(eyelidChanged:) forControlEvents: UIControlEventValueChanged];
        _eyelidSlider = slider;
    }
    
    return _eyelidSlider;
}

- (UIStackView*) eyelidLayout {
    if (!_eyelidLayout) {
        UIStackView* stack = [self createSliderLayoutWithIcon: @"eyelid_icon" title: @"大眼" slider: self.eyelidSlider];
        
        _eyelidLayout = stack;
    }
    
    return _eyelidLayout;
}

- (UISlider*) whiteningSlider {
    if (!_whiteningSlider) {
        UISlider* slider = [self createSlider];
        [slider addTarget: self action: @selector(whiteningChanged:) forControlEvents: UIControlEventValueChanged];
        _whiteningSlider = slider;
    }
    
    return _whiteningSlider;
}

- (UIStackView*) whiteningLayout {
    if (!_whiteningLayout) {
        UIStackView* stack = [self createSliderLayoutWithIcon: @"whitening_icon" title: @"美白" slider: self.whiteningSlider];
        
        _whiteningLayout = stack;
    }
    
    return _whiteningLayout;
}

- (UIStackView*) beautifyLayout {
    if (!_beautifyLayout) {
        UIStackView* (^createHLayoutBlock)(NSArray* views) = ^UIStackView*(NSArray* views) {
            UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews: views];
            stack.axis = UILayoutConstraintAxisHorizontal;
            stack.alignment = UIStackViewAlignmentFill;
            stack.distribution = UIStackViewDistributionFillEqually;
            stack.spacing = 27;
            return stack;
        };
        
        UIStackView* stack = [[UIStackView alloc] initWithArrangedSubviews: @[
            createHLayoutBlock(@[self.smootherLayout, self.slimmingLayout]),
            createHLayoutBlock(@[self.eyelidLayout, self.whiteningLayout]),
        ]];
        stack.axis = UILayoutConstraintAxisVertical;
        stack.alignment = UIStackViewAlignmentFill;
        stack.distribution = UIStackViewDistributionFillEqually;
        stack.layoutMarginsRelativeArrangement = YES;
        stack.layoutMargins = UIEdgeInsetsMake(0, 16, 0, 16);
        stack.spacing = 14;
        
        _beautifyLayout = stack;
    }
    return _beautifyLayout;
}

- (UICollectionViewFlowLayout*) flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 12.0f;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        flowLayout.itemSize = CGSizeMake(60.0f, 80.0f);
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

- (UICollectionView*) filterCollectionView {
    if (!_filterCollectionView) {
        UICollectionView* collection = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout: self.flowLayout];
        collection.showsHorizontalScrollIndicator = NO;
        collection.showsVerticalScrollIndicator = NO;
        collection.backgroundColor = [UIColor clearColor];
        [collection registerClass: [SYFilterCollectionCell class] forCellWithReuseIdentifier: @"cell"];
        [collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
        }];
        collection.dataSource = self;
        collection.delegate = self;
        _filterCollectionView = collection;
    }
    return _filterCollectionView;
}

- (UIView*) midSpaceView {
    if (!_midSpaceView) {
        UIView* spaceView = [[UIView alloc] initWithFrame: CGRectZero];
        [spaceView setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];
        _midSpaceView = spaceView;
    }

    return _midSpaceView;
}


- (UIStackView*) mainLayout {
    if (!_mainLayout) {
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: @[
            self.topActionView,
            self.visibleLayout,
        ]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFill;
//        [self.topActionView  mas_makeConstraints:^(MASConstraintMaker *make) {
//                   make.height.mas_equalTo(34.0f);
//        }];
        [self.topActionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20.0f);
        }];
//        [self.visibleLayout mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (iPhoneX) {
//                make.height.mas_equalTo(314.0f + 34.0f);
//            } else {
//                make.height.mas_equalTo(314.0f);
//            }
//        }];
        _mainLayout = stackView;
    }
    return _mainLayout;
}

- (UIStackView*) visibleLayout {
    if (!_visibleLayout) {
        UIView* backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        
        UIView* bottomSpacer = [[UIView alloc] initWithFrame: CGRectZero];
        
        //[self.midSpaceView setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: @[
                                                                self.resetLayout,
                                                                self.spaceLineLayout,
                                                                self.titleLayout,
                                                                self.beautifyLayout,
                                                                self.midSpaceView,
                                                                self.filterCollectionView,
                                                                bottomSpacer,
        ]];

        [self.resetLayout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48.0f);
        }];
        [self.spaceLineLayout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1.0f);
        }];
        [self.titleLayout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(11.0f + 17.0f + 13.0f);
        }];
        [self.beautifyLayout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(110.0f);
        }];
        [self.midSpaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(31.0f);
        }];

        [self.filterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(77.0f);
        }];
        
        [bottomSpacer mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.height.mas_equalTo(16.0f);
            } else {
                make.height.mas_equalTo(16.0f);
            }
        }];
        [bottomSpacer setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];

        stackView.layoutMargins = UIEdgeInsetsMake(0, 0, 0.f, 0);
        stackView.layoutMarginsRelativeArrangement = YES;
        stackView.spacing = 0;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFill;
        
        [stackView addSubview: backgroundView];
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(stackView);
        }];
        [stackView sendSubviewToBack: backgroundView];
        _visibleLayout = stackView;
    }
    return _visibleLayout;
}

#pragma mark setter

#define DEFINE_EFFECT_SETTER(name, Name) \
- (void) set##Name##Value:(CGFloat) name##Value { \
    if (_##name##Value != name##Value) { \
        _##name##Value = name##Value; \
        self.name##Slider.value = name##Value * 100; \
        if (self.delegate && [self.delegate respondsToSelector: @selector(set##Name:)]) { \
            [self.delegate set##Name: name##Value]; \
        } \
    } \
}

DEFINE_EFFECT_SETTER(smoother, Smoother)
DEFINE_EFFECT_SETTER(slimming, Slimming)
DEFINE_EFFECT_SETTER(eyelid, Eyelid)
DEFINE_EFFECT_SETTER(whitening, Whitening)

#undef DEFINE_EFFECT_SETTER

- (void) setCurrentEffectId:(NSString *)effectId withValue:(CGFloat)value {
    if ((_currentEffectId != effectId) || (_currentEffectValue != value)) {
        if (![_currentEffectId isEqualToString: effectId]) {
            NSString* oldEffectId = _currentEffectId;
            _currentEffectId = [effectId copy];
            if (_currentEffectId.length && ![_currentEffectId isEqualToString: SYFilterNullId]) {
                NSDictionary* __block effect = nil;
                [self.filterEffects enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([_currentEffectId isEqualToString: obj[SYFilterIdKey]]){
                        effect = obj;
                        *stop = YES;
                    }
                }];
                if (effect) {
                    self.activateFilterLabel.text = effect[SYFilterNameKey];
                    self.activateFilterLayout.hidden = NO;
                }

                // 视频直播1.7】滤镜从其他模式切换到原画，最上方滤镜进度条还展示上次的模式
#if 1
                if ([self.delegate respondsToSelector: @selector(valueForEffectId:)]) {
                    CGFloat effectValue = [self.delegate valueForEffectId: _currentEffectId];
                    if (_currentEffectValue != effectValue) {
                        _currentEffectValue = effectValue;
                        self.activateFilterSlider.value = effectValue * 100;
                    }
                }
#else
                CGFloat effectValue = SYEffectDefaultValue;
                if (_currentEffectValue != effectValue) {
                    _currentEffectValue = effectValue;
                    self.activateFilterSlider.value = effectValue * 100;
                }
#endif
                
                if (_currentEffectId && [self.delegate respondsToSelector: @selector(updateEffectValue:forEffectId:)]) {
                    [self.delegate updateEffectValue: _currentEffectValue forEffectId: _currentEffectId];
                }
            } else {
                self.activateFilterLayout.hidden = YES;
                if ([self.delegate respondsToSelector: @selector(updateEffectValue:forEffectId:)]) {
                    [self.delegate updateEffectValue: _currentEffectValue forEffectId: _currentEffectId];
                }
            }
        } else {
            _currentEffectValue = value;
            self.activateFilterSlider.value = _currentEffectValue * 100;
            if ([self.delegate respondsToSelector: @selector(updateEffectValue:forEffectId:)]) {
                [self.delegate updateEffectValue: _currentEffectValue forEffectId: _currentEffectId];
            }
        }
        
        [self.filterCollectionView reloadData];
    }
}

#if 0
- (void) setCurrentEffectId: (NSString*) currentEffectId {
    if (_currentEffectId != currentEffectId) {
        if ([self.delegate respondsToSelector: @selector(setEffectId:)]) {
            [self.delegate setEffectId: currentEffectId];
        }
        _currentEffectId = [currentEffectId copy];
        if (currentEffectId.length) {
            NSDictionary* __block effect = nil;
            [self.filterEffects enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([currentEffectId isEqualToString: obj[SYFilterIdKey]]){
                    effect = obj;
                    *stop = YES;
                }
            }];
            if (effect) {
                self.activateFilterLabel.text = effect[SYFilterNameKey];
                self.activateFilterLayout.hidden = NO;
                // TODO: value?
            }
            
            if (currentEffectId.length && [self.delegate respondsToSelector: @selector(valueForEffectId:)]) {
                CGFloat effectValue = [self.delegate valueForEffectId: currentEffectId];
                self.currentEffectValue = effectValue;
            }
        } else {
            self.activateFilterLayout.hidden = YES;
        }
        
        [self.filterCollectionView reloadData];
    }
}

- (void) setCurrentEffectValue:(CGFloat)currentEffectValue {
    if (_currentEffectValue != currentEffectValue) {
        _currentEffectValue = currentEffectValue;
        self.activateFilterSlider.value = currentEffectValue * 100.0f;
        if (self.currentEffectId && [self.delegate respondsToSelector: @selector(updateEffectValue:forEffectId:)]) {
            [self.delegate updateEffectValue: currentEffectValue forEffectId: self.currentEffectId];
        }
    }
}

#endif

#pragma mark -
#pragma mark selectors

#define DEFINE_SELECTOR_FOR_SLIDER(name, Name) \
- (void) name##Changed: (id) sender { \
    self.name##Value = self.name##Slider.value / 100.0f; \
}

DEFINE_SELECTOR_FOR_SLIDER(smoother, Smoother)
DEFINE_SELECTOR_FOR_SLIDER(slimming, Slimming)
DEFINE_SELECTOR_FOR_SLIDER(eyelid, Eyelid)
DEFINE_SELECTOR_FOR_SLIDER(whitening, Whitening)

#undef DEFINE_SELECTOR_FOR_SLIDER

- (void) currentEffectValueChanged: (id) sender {
    [self.filterCollectionView reloadData];
    CGFloat value = self.activateFilterSlider.value / 100.0f;
    
    [self setCurrentEffectId: self.currentEffectId withValue: value];
    //self.currentEffectValue = value;
}

- (void) resetButtonClicked: (id) sender {
    self.smootherValue = SYEffectDefaultValueSmoothing;
    self.slimmingValue = SYEffectDefaultValueSlimming;
    self.eyelidValue = SYEffectDefaultValueEyelid;
    self.whiteningValue = SYEffectDefaultValueWhitening;
    [self setCurrentEffectId: @"SkinFair_2" withValue: 0.75];
    //self.currentEffectId = nil;
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterEffects.count;
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYFilterCollectionCell *cell = (SYFilterCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary* effect = [self.filterEffects objectAtIndex: indexPath.row];
    cell.title = effect[SYFilterNameKey];
    cell.image = effect[SYFilterIconKey];
    if ((self.currentEffectId == nil || [self.currentEffectId isEqualToString: SYFilterNullId])
        && [SYFilterNullId isEqualToString: effect[SYFilterIdKey]]) {
        cell.mark = YES;
        cell.value = self.currentEffectValue * 100;
        cell.showValue = NO;
    } else if ([self.currentEffectId isEqualToString: effect[SYFilterIdKey]]) {
        cell.mark = YES;
        cell.value = self.currentEffectValue * 100;
        cell.showValue = YES;
    } else {
        cell.showValue = NO;
        cell.mark = NO;
        cell.value = 0;
    }
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath: indexPath animated: YES];
    NSInteger index = indexPath.row;
    NSDictionary* effect = [self.filterEffects objectAtIndex: index];
    NSString* effectId = effect[SYFilterIdKey];
    if ([effectId isEqualToString: SYFilterNullId]) {
        [self setCurrentEffectId: SYFilterNullId withValue: 0];
        //self.currentEffectId = nil;
    } else {
        [self setCurrentEffectId: effectId withValue: self.currentEffectValue];
        //self.currentEffectId = effectId;
    }
}
@end
