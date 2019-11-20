//
//  SYFilterCollectionCell.m
//  Shining
//
//  Created by Zhang Qigang on 2019/10/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYFilterCollectionCell.h"

@interface SYFilterCollectionCell ()
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIStackView* mainLayout;
@property (nonatomic, strong) UIView* maskView;
@property (nonatomic, strong) UILabel* valueLabel;
@end


@implementation SYFilterCollectionCell
- (instancetype) initWithFrame: (CGRect) frame {
    if (self = [super initWithFrame: frame]) {
        _mark = NO;
        _value = 0;
        [self.contentView addSubview: self.mainLayout];
        [self.mainLayout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.contentView addSubview: self.maskView];
        [self.contentView addSubview: self.valueLabel];
        
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageView);
        }];
        
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageView);
        }];
    }
    return self;
}

- (void) setImage:(NSString*) image {
    if (_image != image) {
        _image = [image copy];
        UIImage* i = [UIImage imageNamed_sy: image];
        self.imageView.image = i;
    }
}

- (void) setTitle:(NSString*) title {
    if (_title != title) {
        _title = [title copy];
        self.titleLabel.text = title;
    }
}

- (void) setValue:(NSInteger) value {
    if (_value != value) {
        _value = value;
        self.valueLabel.text = [NSString stringWithFormat: @"%zd", value];
    }
}

- (void) setMark:(BOOL)mark {
    if (_mark != mark) {
        _mark = mark;
        self.maskView.hidden = !mark;
        //self.valueLabel.hidden = !mark;
    }
}

- (void) setShowValue:(BOOL) showValue {
    if (_showValue != showValue) {
        _showValue = showValue;
        self.valueLabel.hidden = !_showValue;
    }
    
}

- (UIImageView*) imageView {
    if (!_imageView) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
        imageView.layer.cornerRadius = 8.0f;
        imageView.clipsToBounds = YES;
        //imageView.backgroundColor = [UIColor blueColor];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        label.font = [UIFont systemFontOfSize: 12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        label.textColor = [UIColor sy_colorWithHexString: @"#444444"];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16.0f);
        }];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView*) maskView {
    if (!_maskView) {
        UIView* view = [[UIView alloc] initWithFrame: CGRectZero];
        view.layer.cornerRadius = 8.0f;
        view.backgroundColor = [UIColor sy_colorWithHexString: @"#000000" alpha: 0.5f];
        view.hidden = YES;
        _maskView = view;
    }
    return _maskView;
}

- (UIView*) valueLabel {
    if (!_valueLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        label.font = [UIFont systemFontOfSize: 14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        label.hidden = YES;
        label.textColor = [UIColor sy_colorWithHexString: @"#FFFFFF"];
        _valueLabel = label;
    }
    return _valueLabel;
}

- (UIStackView*) mainLayout {
    if (!_mainLayout) {
        UIView* space = [[UIView alloc] initWithFrame: CGRectZero];
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(6.0f);
        }];
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: @[
            self.imageView,
            space,
            self.titleLabel,
        ]];
        [self.titleLabel setContentHuggingPriority: UILayoutPriorityDefaultLow forAxis: UILayoutConstraintAxisVertical];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(54.0f);
            make.height.mas_equalTo(54.0f);
        }];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.distribution = UIStackViewDistributionFill;
        _mainLayout = stackView;
    }
    return _mainLayout;
}

@end
