//
//  SYVoiceChatRoomBackdropCell.m
//  Shining
//
//  Created by 杨玄 on 2019/4/17.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomBackdropCell.h"

@interface SYVoiceChatRoomBackdropCell ()

@property (nonatomic, strong) UIImageView *backDropImage;      // 图片
@property (nonatomic, strong) UILabel *backDropName;           // 名字
@property (nonatomic, strong) UIImageView *selectImage;        // 选中效果

@end

@implementation SYVoiceChatRoomBackdropCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.backDropImage];
        [self.contentView addSubview:self.backDropName];
        [self.contentView addSubview:self.selectImage];

        [self.backDropImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).with.offset(-38);
        }];

        [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(2);
            make.right.equalTo(self.contentView).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake(21, 21));
        }];

        [self.backDropName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.backDropImage.mas_bottom);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];

    }
    return self;
}

- (void)updateBackdropCellWithImage:(NSString *)imageUrl withSelect:(BOOL)selected withName:(NSString *)name {
    self.backDropImage.image = [UIImage imageNamed_sy:imageUrl];
    self.backDropName.text = [NSString sy_safeString:name];
    if (selected) {
        self.selectImage.image = [UIImage imageNamed_sy:@"voiceroom_backdrop_select"];
    } else {
        self.selectImage.image = [UIImage imageNamed_sy:@"voiceroom_backdrop_normal"];
    }
}

- (void)updateSelectedImageWithSelect:(BOOL)select {
    if (select) {
        self.selectImage.image = [UIImage imageNamed_sy:@"voiceroom_backdrop_select"];
    } else {
        self.selectImage.image = [UIImage imageNamed_sy:@"voiceroom_backdrop_normal"];
    }
}

#pragma mark - LazyLoad

- (UIImageView *)backDropImage {
    if (!_backDropImage) {
        _backDropImage = [UIImageView new];
        _backDropImage.clipsToBounds = YES;
        _backDropImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backDropImage;
}

- (UIImageView *)selectImage {
    if (!_selectImage) {
        _selectImage = [UIImageView new];
        _selectImage.clipsToBounds = YES;
        _selectImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _selectImage;
}

- (UILabel *)backDropName {
    if (!_backDropName) {
        _backDropName = [UILabel new];
        _backDropName.textColor = RGBACOLOR(11, 11, 11, 1);
        _backDropName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _backDropName.textAlignment = NSTextAlignmentCenter;
    }
    return _backDropName;
}

@end
