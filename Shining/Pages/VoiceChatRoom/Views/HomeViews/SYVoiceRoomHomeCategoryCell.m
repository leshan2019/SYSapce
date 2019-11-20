//
//  SYVoiceRoomHomeCategoryCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomHomeCategoryCell.h"

#define VoiceRoomHomeCategoryStartTag 9768

@implementation SYVoiceRoomHomeCategoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *titleArray = @[@"全部分类",@"叫醒",@"交朋友",@"闲聊"];
        CGFloat x = 24.f;
        CGFloat y = 24.f;
        CGFloat titleY = 96.f;
        CGFloat itemWidth = 60.f;
        CGFloat padding = (self.sy_width - x * 2 - itemWidth * 4) / 3.f;
        for (int i = 0; i < [titleArray count]; i ++) {
            NSString *imageName = [NSString stringWithFormat:@"voiceroom_home_%ld", (long)i];
            UIButton *button = [self buttonWithIndex:i frame:CGRectMake(x, y, itemWidth, itemWidth)
                                               image:[UIImage imageNamed_sy:imageName]];
            [self.contentView addSubview:button];
            
            UILabel *label = [self titleLabelWithTitle:titleArray[i]
                                                 frame:CGRectMake(x, titleY, itemWidth, 20.f)];
            [self.contentView addSubview:label];
            
            x += (itemWidth + padding);
        }
    }
    return self;
}

- (UILabel *)titleLabelWithTitle:(NSString *)title
                          frame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor sam_colorWithHex:@"#444444"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    return label;
}

- (UIButton *)buttonWithIndex:(NSInteger)index
                        frame:(CGRect)frame
                        image:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:image forState:UIControlStateNormal];
    button.tag = VoiceRoomHomeCategoryStartTag + index;
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - VoiceRoomHomeCategoryStartTag;
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
}

@end
