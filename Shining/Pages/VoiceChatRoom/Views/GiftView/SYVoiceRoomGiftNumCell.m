//
//  SYVoiceRoomGiftNumCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiftNumCell.h"

@interface SYVoiceRoomGiftNumCell ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation SYVoiceRoomGiftNumCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.numLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - 0.5, self.sy_width, 0.5)];
        _line.backgroundColor = [UIColor sam_colorWithHex:@"#D8D8D8"];
    }
    return _line;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sy_width / 2.f, self.sy_height)];
        _numLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _numLabel.textColor = [UIColor blackColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sy_width / 2.f, 0, self.sy_width / 2.f, self.sy_height)];
        _nameLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
        _nameLabel.textColor = [UIColor sam_colorWithHex:@"#888888"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (void)showWithNumer:(NSInteger)number name:(NSString *)name {
    self.numLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
    self.nameLabel.text = name;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor sam_colorWithHex:@"#D8D8D8"];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
