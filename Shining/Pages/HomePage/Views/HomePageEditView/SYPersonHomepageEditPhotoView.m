//
//  SYPersonHomepageEditPhotoView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageEditPhotoView.h"

#define FirstImageTag   10000
#define SecondImageTag  20000
#define ThirdImageTag   30000

@interface SYPersonHomepageEditPhotoView ()

@property (nonatomic, strong) UILabel *titleLabel;              // "上传形象墙照(最多上传3张)"
@property (nonatomic, strong) UIImageView *firstImageView;      // 第一张形象照
@property (nonatomic, strong) UIImageView *secondImageView;     // 第二张形象照
@property (nonatomic, strong) UIImageView *thirdImageView;      // 第三张形象照
@property (nonatomic, strong) UIButton *uploadBtn;              // 上传照片
@property (nonatomic, strong) UIImageView *addImage;            // “+”
@property (nonatomic, strong) UILabel *addTitle;                // "上传照片"
@property (nonatomic, strong) UIView *horizonline;              // 分割线

@property (nonatomic, strong) NSArray *photoArrs;               // 形象照arr

// 形象照URL
@property (nonatomic, copy) NSString *photo1;
@property (nonatomic, copy) NSString *photo2;
@property (nonatomic, copy) NSString *photo3;

@end

@implementation SYPersonHomepageEditPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        [self addSubview:self.titleLabel];
        [self addSubview:self.firstImageView];
        [self addSubview:self.secondImageView];
        [self addSubview:self.thirdImageView];
        [self addSubview:self.uploadBtn];
        [self.uploadBtn addSubview:self.addImage];
        [self.uploadBtn addSubview:self.addTitle];
        [self addSubview:self.horizonline];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self).with.offset(15);
            make.right.equalTo(self).with.offset(-20);
            make.height.mas_equalTo(17);
        }];

        [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];

        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstImageView.mas_right).with.offset(16);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];

        [self.thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.secondImageView.mas_right).with.offset(16);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];

        [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];

        [self.addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerX.equalTo(self.uploadBtn);
            make.top.equalTo(self.uploadBtn).with.offset(16);
        }];

        [self.addTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 14));
            make.centerX.equalTo(self.uploadBtn);
            make.top.equalTo(self.addImage.mas_bottom).with.offset(6.4);
        }];

        [self.horizonline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(20);
            make.right.equalTo(self).with.offset(-20);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(1);
        }];

    }
    return self;
}

#pragma mark - Public

- (void)updateHomepageEditPhotoViewWithPhotoOne:(NSString *)photo1 photoTwo:(NSString *)photo2 photoThree:(NSString *)photo3 {
    self.photo1 = photo1;
    self.photo2 = photo2;
    self.photo3 = photo3;
    self.firstImageView.hidden = YES;
    self.secondImageView.hidden = YES;
    self.thirdImageView.hidden = YES;
    self.uploadBtn.hidden = NO;
    UIImage *defaultImage = [UIImage imageNamed_sy:@"homepage_photo_default_small"];
    if (![NSString sy_isBlankString:photo1]) {
        self.firstImageView.hidden = NO;
        [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:photo1] placeholderImage:defaultImage options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    }
    if (![NSString sy_isBlankString:photo2]) {
        self.secondImageView.hidden = NO;
        [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:photo2] placeholderImage:defaultImage options:SDWebImageRetryFailed|SDWebImageRefreshCached];
        [self.secondImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (photo1.length > 0) {
                make.left.equalTo(self.firstImageView.mas_right).with.offset(16);
            } else {
                make.left.equalTo(self).with.offset(20);
            }
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    if (![NSString sy_isBlankString:photo3]) {
        self.thirdImageView.hidden = NO;
        [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:photo3] placeholderImage:defaultImage options:SDWebImageRetryFailed|SDWebImageRefreshCached];
        [self.thirdImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (photo2.length > 0) {
                make.left.equalTo(self.secondImageView.mas_right).with.offset(16);
            } else if (photo1.length > 0) {
                make.left.equalTo(self.firstImageView.mas_right).with.offset(16);
            } else {
                make.left.equalTo(self).with.offset(20);
            }
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    if (![NSString sy_isBlankString:photo1]&&![NSString sy_isBlankString:photo2]&&![NSString sy_isBlankString:photo3]) {
        self.uploadBtn.hidden = YES;
        return;
    }
    [self.uploadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (![NSString sy_isBlankString:photo3]) {
            make.left.equalTo(self.thirdImageView.mas_right).with.offset(16);
        } else if (![NSString sy_isBlankString:photo2]) {
            make.left.equalTo(self.secondImageView.mas_right).with.offset(16);
        } else if (![NSString sy_isBlankString:photo1]) {
            make.left.equalTo(self.firstImageView.mas_right).with.offset(16);
        } else {
            make.left.equalTo(self).with.offset(20);
        }
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

#pragma mark - BtnClickEvent

- (void)handleImageTapClickEvent:(UITapGestureRecognizer *)gesture {
    NSString *photoUrl = @"";
    SYHomepagePhotoType type = SYHomepagePhotoType_Unknown;
    switch (gesture.view.tag) {
        case FirstImageTag:
        {
            photoUrl = self.photo1;
            type = SYHomepagePhotoType_First;
        }
            break;
        case SecondImageTag:
        {
            photoUrl = self.photo2;
            type = SYHomepagePhotoType_Second;
        }
            break;
        case ThirdImageTag:
        {
            photoUrl = self.photo3;
            type = SYHomepagePhotoType_Third;
        }
            break;
        default:
            break;
    }
    if (![NSString sy_isBlankString:photoUrl]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(handleHomepageEditPhotoViewPhotoClick:withType:)]) {
            [self.delegate handleHomepageEditPhotoViewPhotoClick:photoUrl withType:type];
        }
    }
}

// 点击上传照片
- (void)handleUploadBtnClickEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleHomepageEditPhotoViewUploadBtnCLickEvent)]) {
        [self.delegate handleHomepageEditPhotoViewUploadBtnCLickEvent];
    }
}

#pragma mark - LazyLoad

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _titleLabel.textColor = RGBACOLOR(11, 11, 11, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"上传形象墙照 （最多上传3张）";
    }
    return _titleLabel;
}

- (UIImageView *)firstImageView {
    if (!_firstImageView) {
        _firstImageView = [UIImageView new];
        _firstImageView.backgroundColor = [UIColor whiteColor];
        _firstImageView.clipsToBounds = YES;
        _firstImageView.layer.cornerRadius = 4;
        _firstImageView.tag = FirstImageTag;
        _firstImageView.userInteractionEnabled = YES;
        _firstImageView.hidden = YES;
        _firstImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTapClickEvent:)];
        [_firstImageView addGestureRecognizer:tapGesture];
    }
    return _firstImageView;
}

- (UIImageView *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [UIImageView new];
        _secondImageView.backgroundColor = [UIColor whiteColor];
        _secondImageView.clipsToBounds = YES;
        _secondImageView.layer.cornerRadius = 4;
        _secondImageView.tag = SecondImageTag;
        _secondImageView.userInteractionEnabled = YES;
        _secondImageView.hidden = YES;
        _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTapClickEvent:)];
        [_secondImageView addGestureRecognizer:tapGesture];
    }
    return _secondImageView;
}

- (UIImageView *)thirdImageView {
    if (!_thirdImageView) {
        _thirdImageView = [UIImageView new];
        _thirdImageView.backgroundColor = [UIColor whiteColor];
        _thirdImageView.clipsToBounds = YES;
        _thirdImageView.layer.cornerRadius = 4;
        _thirdImageView.tag = ThirdImageTag;
        _thirdImageView.userInteractionEnabled = YES;
        _thirdImageView.hidden = YES;
        _thirdImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTapClickEvent:)];
        [_thirdImageView addGestureRecognizer:tapGesture];
    }
    return _thirdImageView;
}

- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [UIButton new];
        _uploadBtn.backgroundColor = [UIColor whiteColor];
        _uploadBtn.clipsToBounds = YES;
        _uploadBtn.layer.cornerRadius = 4;
        [_uploadBtn addTarget:self action:@selector(handleUploadBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

- (UIImageView *)addImage {
    if (!_addImage) {
        _addImage = [UIImageView new];
        _addImage.image = [UIImage imageNamed_sy:@"homepage_photo_upload"];
    }
    return _addImage;
}

- (UILabel *)addTitle {
    if (!_addTitle) {
        _addTitle = [UILabel new];
        _addTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
        _addTitle.textColor = RGBACOLOR(68, 68, 68, 1);
        _addTitle.textAlignment = NSTextAlignmentCenter;
        _addTitle.text = @"上传照片";
    }
    return _addTitle;
}

- (UIView *)horizonline {
    if (!_horizonline) {
        _horizonline = [UIView new];
        _horizonline.backgroundColor = RGBACOLOR(238,238,238,1);
    }
    return _horizonline;
}

@end
