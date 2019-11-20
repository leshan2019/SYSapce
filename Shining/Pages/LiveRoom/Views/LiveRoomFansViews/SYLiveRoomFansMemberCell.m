//
//  SYLiveRoomFansMemberCell.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansMemberCell.h"
#import "SYLiveRoomFansLevelView.h"
#import "SYLiveRoomFansViewInfoModel.h"
@interface SYLiveRoomFansMemberCell()
@property(nonatomic,strong)UILabel*secionLabel;
@property(nonatomic,strong)UIImageView*avator;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)SYLiveRoomFansLevelView*levelLabel;
@property(nonatomic,strong)UILabel*infoLabel;
@property(nonatomic,strong)UILabel*infoScoreLabel;
@end
@implementation SYLiveRoomFansMemberCell
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setupSubViews{
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.secionLabel];
    [self.contentView addSubview:self.avator];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.infoScoreLabel];
    [self hideSubViews:YES];
    self.secionLabel.hidden = YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.secionLabel.sy_left = 17;
    self.secionLabel.sy_centerY = self.contentView.sy_centerY;
    self.avator.sy_left = 17;
    self.avator.sy_centerY = self.contentView.sy_centerY;
    self.titleLabel.sy_left = self.avator.sy_right + 14;
    self.titleLabel.sy_bottom = self.contentView.sy_centerY;
    self.levelLabel.sy_right = self.contentView.sy_right-21;
    self.levelLabel.sy_centerY = self.contentView.sy_centerY;
    self.infoLabel.sy_left = self.avator.sy_right + 14;
    self.infoLabel.sy_top = self.contentView.sy_centerY +2;
    self.infoScoreLabel.sy_left = self.infoLabel.sy_right;
    self.infoScoreLabel.sy_centerY = self.infoLabel.sy_centerY;
  
}
-(void)isSectionLabelCell:(BOOL)hide{
    self.secionLabel.hidden = !hide;
    self.avator.hidden = hide;
    self.titleLabel.hidden = hide;
    self.levelLabel.hidden = hide;
    self.infoLabel.hidden = hide;
    self.infoScoreLabel.hidden = hide;
}
- (void)setSectionLabelCellText:(NSString *)title isHost:(BOOL)ishost{
    self.secionLabel.text = ishost ?[NSString stringWithFormat:@"粉丝团成员%@人",title]:@"成员列表";
}
-(void)hideSubViews:(BOOL)hide{
    self.avator.hidden = hide;
    self.titleLabel.hidden = hide;
    self.levelLabel.hidden = hide;
    self.infoLabel.hidden = hide;
    self.infoScoreLabel.hidden = hide;
}
-(void)setCellInfos:(id)info isHost:(BOOL)ishost count:(NSInteger)count{
    [self hideSubViews:!info];
    SYLiveRoomFansViewMemberModel*model = (SYLiveRoomFansViewMemberModel*)info;
    NSURL*url = [NSURL URLWithString:model.avatar_image];
    [self.avator sd_setImageWithURL:url];
    self.titleLabel.text = model.name;
    [self.levelLabel setViewInfoIconName:@"真爱团" andLevel:model.level];
    self.infoScoreLabel.text = model.close_score;
    [self.titleLabel sizeToFit];
    [self.infoScoreLabel sizeToFit];
    self.secionLabel.text = ishost ?[NSString stringWithFormat:@"粉丝团成员%ld人",(long)count]:@"成员列表";
    [self resetSubViewsFrames];
}
- (UILabel *)secionLabel{
    if (!_secionLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        lab.textColor = [UIColor sy_colorWithHexString:@"444444"];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"成员列表";
        _secionLabel = lab;
    }
    return _secionLabel;
}
- (UIImageView *)avator{
    if (!_avator) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [img setBackgroundColor:[UIColor sy_colorWithHexString:@"ECECEC"]];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = 40/2.f;
        _avator = img;
    }
    return _avator;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        lab.textColor = [UIColor sy_colorWithHexString:@"0B0B0B"];
        _titleLabel = lab;
    }
    return _titleLabel;
}
- (SYLiveRoomFansLevelView *)levelLabel{
    if (!_levelLabel) {
        SYLiveRoomFansLevelView*level = [[SYLiveRoomFansLevelView alloc]initWithFrame:CGRectMake(0, 0, 52, 14) andFontSize:10];
        _levelLabel = level;
    }
    return _levelLabel;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        lab.text = @"亲密度：";
        [lab sizeToFit];
        _infoLabel = lab;
    }
    return _infoLabel;
}
- (UILabel *)infoScoreLabel{
    if (!_infoScoreLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        lab.textColor = [UIColor sy_colorWithHexString:@"#FF3069"];
        _infoScoreLabel=lab;
    }
    return _infoScoreLabel;
}
@end
