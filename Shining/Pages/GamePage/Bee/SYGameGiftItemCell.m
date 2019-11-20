//
//  SYGameGiftItemCell.m
//  Shining
//
//  Created by leeco on 2019/8/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGameGiftItemCell.h"


@interface SYGameGiftItemCell ()
// 礼物数量和额  礼物图像
@property (nonatomic, strong)UILabel *giftCount;
@property (nonatomic, strong)UIImageView *gifticon;

@end

@implementation SYGameGiftItemCell

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    _gifticon = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 0, 80, 58)];
//    _gifticon.backgroundColor = [UIColor clearColor];
    _gifticon.layer.cornerRadius = 10;
    _gifticon.layer.masksToBounds = YES;
    [self.contentView addSubview:_gifticon];
    
    
    _giftCount = [[UILabel alloc ]initWithFrame:CGRectMake(0,_gifticon.sy_bottom +  6, _gifticon.sy_width, 16)];
    _giftCount.text = @"";
    _giftCount.textAlignment = NSTextAlignmentCenter;
    _giftCount.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    _giftCount.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_giftCount];
    
}

- (void)setGiftModel:(SYGiftModel *)giftModel
{
    _giftModel = giftModel;
    [self.gifticon sd_setImageWithURL:[NSURL URLWithString:_giftModel.icon]];
    _giftCount.text = [NSString stringWithFormat:@"X%ld",(long)_giftModel.nums];
}

@end
