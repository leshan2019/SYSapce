//
//  SYVoiceRoomEmojCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomEmojCell.h"

@interface SYVoiceRoomEmojCell ()

@property (nonatomic, strong) UILabel *emojLabel;

@end

@implementation SYVoiceRoomEmojCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.emojLabel];
    }
    return self;
}

- (void)showEmoj:(NSString *)emoj {
    self.emojLabel.text = emoj;
}

- (UILabel *)emojLabel {
    if (!_emojLabel) {
        _emojLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _emojLabel.font = [UIFont systemFontOfSize:20];
        _emojLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emojLabel;
}

@end
