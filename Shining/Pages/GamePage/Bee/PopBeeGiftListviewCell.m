//
//  PopBeeGiftListviewCell.m
//  Shining
//
//  Created by leeco on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "PopBeeGiftListviewCell.h"

@interface PopBeeGiftListviewCell ()

// 蜜豆图标
@property (nonatomic, strong) UIImageView *gameBeIicon;
// 账户蜜豆
@property (nonatomic, strong) UILabel *labPrice;

@property (nonatomic, strong) UILabel *labTime;
@property (nonatomic, strong) UILabel *labName;
// 蜜豆图标
@property (nonatomic, strong) UIImageView *giftIicon;

@property (nonatomic, strong) UIView *line;

@end

@implementation PopBeeGiftListviewCell
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
    UIImageView *gameBeIicon = [[UIImageView alloc]initWithFrame:CGRectZero];
    _gameBeIicon = gameBeIicon;
    [gameBeIicon setImage:[UIImage imageNamed_sy:@"game-bee-peas"]];
    [self.contentView addSubview:gameBeIicon];
    
    UILabel *label = [[UILabel alloc ]init];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.text = @" ";
    _labPrice = label;
    [self.contentView addSubview:label];
    gameBeIicon.frame  =CGRectMake((self.sy_width - 12 - 3 - label.frame.size.width)/2, 25, 12, 12);
    label.frame  =CGRectMake(gameBeIicon.frame.origin.x + 12 + 3, 25 - 1, label.frame.size.width, 12);
    
    
    _labTime = [[UILabel alloc ]init];
    _labTime.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    _labTime.textAlignment = NSTextAlignmentRight;
    _labTime.textColor = RGBACOLOR(255, 255, 255, 0.3f);
    _labTime.text = @" ";
    [self.contentView addSubview:_labTime];
    
    _labName = [[UILabel alloc ]init];
    _labName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _labName.textAlignment = NSTextAlignmentLeft;
    _labName.textColor = [UIColor whiteColor];
    _labName.text = @" ";
    [self.contentView addSubview:_labName];
    
    _giftIicon = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_giftIicon];
    
    _line = [[UIView alloc ] initWithFrame:CGRectZero];
    _line.backgroundColor = RGBACOLOR(255, 255, 255, 0.1f);
    [self.contentView addSubview:_line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setGiftModel:(SYGiftModel *)giftModel
{
    _giftModel = giftModel;
    [_giftIicon sd_setImageWithURL:[NSURL URLWithString:_giftModel.icon]];
    _labName.text = _giftModel.name;
    _labTime.text = _giftModel.create_time;
    _labPrice.text = [NSString stringWithFormat:@"%ld",_giftModel.price];
    
    _labPrice.frame = CGRectMake(self.sy_width - 30 - 36, (40 - 12)/2, 36, 12);
    _gameBeIicon.frame = CGRectMake(_labPrice.sy_left - 12 - 4, (40 - 12)/2, 12, 12);
    
    _labTime.frame = CGRectMake(_gameBeIicon.sy_left - 6 - 105 , (40 - 12)/2, 105, 12);
    
    _giftIicon.frame = CGRectMake(30, (40 - 22)/2, 22, 22);
    _labName.frame = CGRectMake(_giftIicon.sy_right + 6, (40 - 12)/2, _labTime.sy_left - 4 - (_giftIicon.sy_right + 6), 12);
    _line.frame = CGRectMake(20, 39, self.sy_width - 40, 1);
}

@end
