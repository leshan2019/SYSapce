//
//  SYActivityLocationCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYActivityLocationCell.h"

@interface SYActivityLocationCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation SYActivityLocationCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addressLabel];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat x = 20.f;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 7.f, self.sy_width - 2 * x, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor sam_colorWithHex:@"#303030"];
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGFloat x = 20.f;
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, self.nameLabel.sy_bottom, self.sy_width - 2 * x, 14)];
        _addressLabel.font = [UIFont systemFontOfSize:10];
        _addressLabel.textColor = [UIColor sam_colorWithHex:@"#909090"];
    }
    return _addressLabel;
}

- (void)showWithName:(NSString *)name
             address:(NSString *)address {
    self.nameLabel.text = name;
    self.addressLabel.text = address;
}

@end
