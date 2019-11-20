//
//  SYLiveRoomFansHostScoreCell.m
//  Shining
//
//  Created by leeco on 2019/11/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansHostScoreCell.h"
@interface SYLiveRoomFansHostScoreCell()
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UILabel*scoreLabel;
@end
@implementation SYLiveRoomFansHostScoreCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setupSubViews{
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.scoreLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.titleLabel.sy_top = 14;
    self.titleLabel.sy_centerX = self.contentView.sy_centerX;
    [self.scoreLabel sizeToFit];
    self.scoreLabel.sy_top = self.titleLabel.sy_bottom+10;
    self.scoreLabel.sy_centerX = self.contentView.sy_centerX;
}
- (void)setHostFansGroupScore:(NSString *)score{
    self.scoreLabel.text = score;
    [self resetSubViewsFrames];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        lab.textColor = [UIColor sy_colorWithHexString:@"444444"];
        lab.text = @"真爱团总积分";
        [lab sizeToFit];
        _titleLabel = lab;
    }
    return _titleLabel;
}
- (UILabel *)scoreLabel{
    if (!_scoreLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        lab.textColor = [UIColor sy_colorWithHexString:@"0B0B0B"];
        _scoreLabel = lab;
    }
    return _scoreLabel;
}
@end
