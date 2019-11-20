//
//  SYVideoRoomConfigView.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVideoRoomConfigView.h"

@interface SYVideoRoomConfigMainLayoutView : UIStackView
@end

@implementation SYVideoRoomConfigMainLayoutView
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing: YES];
}
@end

@interface SYVideoRoomConfigView () <UITextFieldDelegate>
@property (nonatomic, strong) UIControl* backgroundTapView;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextField* titleField;
@property (nonatomic, strong) UIButton* beautifyButton;
@property (nonatomic, strong) UIButton* startShowButton;
@property (nonatomic, strong) UIButton* roomSettingsButton;

@property (nonatomic, strong) UIView* titleDecorationView;
@property (nonatomic, strong) UIView* titleLineView;

@property (nonatomic, strong) UIStackView* mainVLayoutView; // 主布局容器
@property (nonatomic, strong) UIStackView* closeHLayoutView; // 关闭按钮布局容器
@property (nonatomic, strong) UIStackView* titleVLayoutView; // 标题布局容器
@property (nonatomic, strong) UIStackView* buttonHLayoutView; // 按钮布局容器

@property (nonatomic, strong) UIView* closeSpaceView; // 顶部空白
@property (nonatomic, strong) UIView* topSpaceView; // 顶部空白
@property (nonatomic, strong) UIView* midSpaceView1; // 中部空白
@property (nonatomic, strong) UIView* midSpaceView2; // 中部空白
@property (nonatomic, strong) UIView* bottomSpaceView; // 中部空白
@end

@implementation SYVideoRoomConfigView

- (instancetype) initWithFrame: (CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self addSubview: self.mainVLayoutView];
        [self.mainVLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void) backgroundTapped: (id) sender {
    [self endEditing: YES];
}

#pragma mark -
#pragma mark getter

- (UIControl*) backgroundTapView {
    if (!_backgroundTapView) {
        UIControl* control = [[UIControl alloc] initWithFrame: CGRectZero];
        [control addTarget: self action: @selector(backgroundTapped:) forControlEvents: UIControlEventTouchUpInside];
        _backgroundTapView = control;
    }
    return _backgroundTapView;
}

- (UIStackView*) mainVLayoutView {
    if (!_mainVLayoutView) {
        UIStackView* view = [[UIStackView alloc] initWithFrame: CGRectZero];
        view.layoutMarginsRelativeArrangement = YES;
        view.layoutMargins = UIEdgeInsetsMake( 0 , 16,  56, 16);
        view.axis = UILayoutConstraintAxisVertical;
        view.alignment = UIStackViewAlignmentFill;
        view.distribution = UIStackViewDistributionFill;
        view.spacing = 18.0f;
        
        [view addSubview: self.backgroundTapView];
        [self.backgroundTapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        
        [view addArrangedSubview: self.closeHLayoutView];
        
        [view addArrangedSubview: self.midSpaceView1];
        [view addArrangedSubview: self.titleVLayoutView];
        [view addArrangedSubview: self.midSpaceView2];
        [view addArrangedSubview: self.buttonHLayoutView];
        
        [view addArrangedSubview: self.roomSettingsButton];
        
        _mainVLayoutView = view;
    }
    return _mainVLayoutView;
}

- (UIStackView*) closeHLayoutView {
    if (!_closeHLayoutView) {
        UIStackView* view = [[UIStackView alloc] initWithArrangedSubviews: @[
                                                                             self.closeSpaceView,
                                                                             self.closeButton,
                                                                             ]];
        view.axis = UILayoutConstraintAxisHorizontal;
        view.alignment = UIStackViewAlignmentFill;
        view.distribution = UIStackViewDistributionFill;
        _closeHLayoutView = view;
    }
    
    return _closeHLayoutView;
}

- (UIStackView*) titleVLayoutView {
    if (!_titleVLayoutView) {
        UIStackView* stack = [[UIStackView alloc] initWithFrame: CGRectZero];
        [stack addSubview: self.titleDecorationView];
        for (UIView* v in @[
                            self.titleLabel,
                            self.titleLineView,
                            self.titleField,
                            ]) {
            [stack addArrangedSubview: v];
        }
        stack.layoutMarginsRelativeArrangement = YES;
        stack.layoutMargins = UIEdgeInsetsMake(22, 14, 22, 14);
        stack.axis = UILayoutConstraintAxisVertical;
        stack.alignment = UIStackViewAlignmentFill;
        stack.distribution = UIStackViewDistributionFill;
        stack.spacing = 20.0f;
        [self.titleDecorationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(stack);
        }];
        _titleVLayoutView = stack;
    }
    return _titleVLayoutView;
}

- (UIStackView*) buttonHLayoutView {
    if (!_buttonHLayoutView) {
        UIStackView* view = [[UIStackView alloc] initWithArrangedSubviews: @[
                                                                             self.beautifyButton,
                                                                             self.startShowButton,
                                                                             ]];
        view.axis = UILayoutConstraintAxisHorizontal;
        view.alignment = UIStackViewAlignmentFill;
        //view.distribution = UIStackViewDistributionFillEqually;
        view.distribution = UIStackViewDistributionFillProportionally;
        view.spacing = 6.0f;
        _buttonHLayoutView = view;
    }
    return _buttonHLayoutView;
}

- (UIView*) closeSpaceView {
    if (!_closeSpaceView) {
        UIView* view = [[UIView alloc] initWithFrame: CGRectZero];
        view.userInteractionEnabled = NO;
        [view setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];
        _closeSpaceView = view;
    }
    return _closeSpaceView;
}

- (UIView*) midSpaceView1 {
    if (!_midSpaceView1) {
        UIView* view = [[UIView alloc] initWithFrame: CGRectZero];
        view.userInteractionEnabled = NO;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(74.0f);
        }];
        //[view setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];
        _midSpaceView1 = view;
    }
    return _midSpaceView1;
}

- (UIView*) midSpaceView2 {
    if (!_midSpaceView2) {
        UIView* view = [[UIView alloc] initWithFrame: CGRectZero];
        view.userInteractionEnabled = NO;
        [view setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];
        _midSpaceView2 = view;
    }
    return _midSpaceView2;
}

- (UIButton*) closeButton {
    if (!_closeButton) {
        UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [button addTarget: self action: @selector(closeButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        UIImage* image = [[UIImage imageNamed_sy: @"close_icon"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [button setImage: image forState: UIControlStateNormal];
        // TODO: add image.
        _closeButton = button;
    }
    return _closeButton;
}

- (UIView*) titleDecorationView {
    if (!_titleDecorationView) {
        UIView* view = [[UIView alloc] initWithFrame: CGRectZero];
        view.backgroundColor = [UIColor sy_colorWithHexString: @"#000000"];
        view.alpha = 0.30f;
        view.layer.cornerRadius = 6.0f;
        _titleDecorationView = view;
    }
    
    return _titleDecorationView;
}

- (UIView*) titleLineView {
    if (!_titleLineView) {
        UIView* view = [[UIView alloc] initWithFrame: CGRectZero];
        CGRect r = view.frame;
        r.size.height = 0.5f;
        view.frame = r;
        view.backgroundColor = [UIColor sy_colorWithHexString: @"#B0B0B0"];
        view.alpha = 0.44f;
        view.userInteractionEnabled = NO;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5f);
        }];
        _titleLineView = view;
    }
    
    return _titleLineView;
}

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        UILayoutGuide* guide = [[UILayoutGuide alloc] init];
        [label addLayoutGuide: guide];
        label.text = @"直播标题";
        label.font = [UIFont systemFontOfSize: 14.0f];
        label.textColor = [UIColor sy_colorWithHexString: @"#EBEBEB"];
        [label addLayoutGuide: [[UILayoutGuide alloc] init]];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UITextField*) titleField {
    if (!_titleField) {
        UITextField* field = [[UITextField alloc] initWithFrame: CGRectZero];
        CGRect r = field.frame;
        r.size.height = 60.0f;
        field.frame = r;
        field.placeholder = @"房间标题";
        field.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @"给直播写个标题吧"
                                                                      attributes: @{
                                                                                    NSForegroundColorAttributeName: [UIColor sy_colorWithHexString: @"#F6F6F6"]
                                                                                    }];
        field.minimumFontSize = 24.0f;
        field.font = [UIFont systemFontOfSize: 24.0f];
        field.textColor = [UIColor sy_colorWithHexString: @"#F6F6F6"];
        field.delegate = self;
        _titleField = field;
    }
    
    return _titleField;
}

- (UIButton*) beautifyButton {
    if (!_beautifyButton) {
        UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        UIImage* image = [[UIImage imageNamed_sy: @"beautify_image"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [button setImage: image forState: UIControlStateNormal];
        //[button setTitle: @"美颜" forState: UIControlStateNormal];
        //button.layer.borderWidth = 0.5f;
        //button.layer.borderColor = [UIColor grayColor].CGColor;
        //button.layer.cornerRadius = 4.0f;
        [button addTarget: self action: @selector(beautifyButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        _beautifyButton = button;
    }
    
    return _beautifyButton;
}

- (UIButton*) startShowButton {
    if (!_startShowButton) {
        UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        UIImage* image = [[UIImage imageNamed_sy: @"startshow_image"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        [button setImage: image forState: UIControlStateNormal];
        //[button setTitle: @"开始直播" forState: UIControlStateNormal];
        //button.layer.borderWidth = 0.5f;
        //button.layer.borderColor = [UIColor grayColor].CGColor;
        //button.layer.cornerRadius = 4.0f;
        [button addTarget: self action: @selector(startShowButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        _startShowButton = button;
    }
    
    return _startShowButton;
}

- (UIButton*) roomSettingsButton {
    if (!_roomSettingsButton) {
        UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [button setTitle: @"房间信息设定 >" forState: UIControlStateNormal];
        [button setTitleColor: [UIColor sy_colorWithHexString: @"#FFFFFF "] forState: UIControlStateNormal];
        [button addTarget: self action: @selector(roomConfigButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
        _roomSettingsButton = button;
    }
    
    return _roomSettingsButton;
}

- (void) callDelegate: (SEL) sel {
    if (self.delegate && [self.delegate respondsToSelector: sel]) {
        [self.delegate performSelector: sel];
    }
}

- (void) closeButtonClicked: (id) sender {
    [self callDelegate: @selector(closeButtonClicked)];
}

- (void) beautifyButtonClicked: (id) sender {
    [self callDelegate: @selector(beautifyButtonClicked)];
}

- (void) startShowButtonClicked: (id) sender {
    [self callDelegate: @selector(startShowButtonClicked)];
}

- (void) roomConfigButtonClicked: (id) sender {
    [self callDelegate: @selector(roomConfigButtonClicked)];
}

- (NSString*) title {
    return self.titleField.text;
}

#pragma mark setter

- (void) setTitle: (NSString *)title {
    self.titleField.text = title;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector: @selector(roomTitleChanged:)]) {
        [self.delegate performSelector: @selector(roomTitleChanged:) withObject: self.titleField.text];
    }
}
@end
