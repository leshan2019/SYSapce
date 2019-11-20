//
//  SYVoiceChatRoomListViewCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomListViewCell.h"

@interface SYVoiceChatRoomListViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation SYVoiceChatRoomListViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}

- (void)showCellWithName:(NSString *)name
                    icon:(NSString *)icon
                    desc:(NSString *)desc {
    self.nameLabel.text = name;
    self.descLabel.text = desc;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200.f, 20.f)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _nameLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300.f, 20.f)];
        _descLabel.textColor = [UIColor grayColor];
        _descLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _descLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        
    }
    return _iconView;
}

@end
