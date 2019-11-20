//
//  SYLivingShowBeautifyViewController.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYBeautifyConfigView.h"
#import "SYLivingShowBeautifyViewController.h"

@interface SYLivingShowBeautifyViewController () <SYBeautifyConfigDelegate>
@property (nonatomic, weak) id<SYLivingShowBeautifyViewControllerDelegate> delegate;

@property (nonatomic, strong) SYBeautifyConfigView* beautifyConfigView;
@property (nonatomic, strong) UIControl* backgroundTapControl;
@property (nonatomic, strong) UIStackView* mainVLayoutView;
@end

@implementation SYLivingShowBeautifyViewController

- (instancetype) initWithDelegate: (id<SYLivingShowBeautifyViewControllerDelegate>) delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview: self.mainVLayoutView];
    [self.mainVLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -
#pragma mark getter

- (SYBeautifyConfigView*) beautifyConfigView {
    if (!_beautifyConfigView) {
        SYBeautifyConfigView* configView = [[SYBeautifyConfigView alloc] initWithFrame: CGRectZero];
        configView.delegate = self;
        _beautifyConfigView = configView;
    }
    return _beautifyConfigView;
}

- (UIControl*) backgroundTapControl {
    if (!_backgroundTapControl) {
        UIControl* control = [[UIControl alloc] initWithFrame: CGRectZero];
        [control setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];
        [control addTarget: self action: @selector(backgroundTapped:) forControlEvents: UIControlEventTouchUpInside];
        _backgroundTapControl = control;
    }
    return _backgroundTapControl;
}

- (UIStackView*) mainVLayoutView {
    if (!_mainVLayoutView) {
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: @[
                                                                                  self.backgroundTapControl,
                                                                                  self.beautifyConfigView,
                                                                                  ]];
        
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFill;
        
        [self.beautifyConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.height.mas_equalTo(360.0f);
            //make.bottom.equalTo(self.view);
        }];
        
        
        _mainVLayoutView = stackView;
    }
    return _mainVLayoutView;
}

- (void) backgroundTapped: (id) sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(beautifyViewControllerClosed:)]) {
        [self.delegate beautifyViewControllerClosed: self];
    }
}
#pragma mark -
#pragma mark SYBeautifyConfigDelegate

#define DEFINE_DELEGATE_GETTER(name,Name) \
- (CGFloat) name { \
    if (self.delegate && [self.delegate respondsToSelector: @selector(beautifyViewController##Name:)]) { \
        return [self.delegate beautifyViewController##Name: self]; \
    } else { \
        return 0.0f; \
    } \
}

#define DEFINE_DELEGATE_SETTER(name,Name) \
- (void) set##Name: (CGFloat) value { \
    if (self.delegate && [self.delegate respondsToSelector: @selector(beautifyViewController:set##Name:)]) { \
        [self.delegate beautifyViewController: self set##Name: value]; \
    } \
}


DEFINE_DELEGATE_GETTER(smoother, Smoother)
DEFINE_DELEGATE_GETTER(slimming, Slimming)
DEFINE_DELEGATE_GETTER(eyelid, Eyelid)
DEFINE_DELEGATE_GETTER(whitening, Whitening)

DEFINE_DELEGATE_SETTER(smoother, Smoother)
DEFINE_DELEGATE_SETTER(slimming, Slimming)
DEFINE_DELEGATE_SETTER(eyelid, Eyelid)
DEFINE_DELEGATE_SETTER(whitening, Whitening)

#undef DEFINE_DELEGATE_GETTER
#undef DEFINE_DELEGATE_SETTER

- (NSString*) effectId {
    if ([self.delegate respondsToSelector: @selector(beautifyViewControllerCurrentEffectId:)]) {
        return [self.delegate beautifyViewControllerCurrentEffectId: self];
    } else {
        return nil;
    }
}

- (void) setEffectId: (NSString*) effectId {
    if ([self.delegate respondsToSelector: @selector(beautifyViewController:setCurrentEffectId:)]) {
        [self.delegate beautifyViewController: self setCurrentEffectId: effectId];
    } 
}
- (CGFloat) valueForEffectId:(NSString*) effectId {
    if ([self.delegate respondsToSelector: @selector(beautifyViewController:effectValueForId:)]) {
        return [self.delegate beautifyViewController: self effectValueForId: effectId];
    } else {
        return 0.0f;
    }
}

- (void) updateEffectValue:(CGFloat)value forEffectId:(NSString *)effectId {
    if ([self.delegate respondsToSelector: @selector(beautifyViewController:updateCurrentEffectId:withValue:)]) {
        [self.delegate beautifyViewController: self updateCurrentEffectId: effectId withValue: value];
    }
}
@end
