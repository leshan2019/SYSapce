//
//  SYLiveRoomFansTaskCell.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansTaskCell.h"
#import "SYLiveRoomFansViewInfoModel.h"
@interface SYLiveRoomFansTaskCell()
@property(nonatomic,strong)UIImageView*avator;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UIButton*actionBtn;
@property(nonatomic,strong)UILabel*infoLabel;
@property(nonatomic,strong)UILabel*resultLabel;

//
@property(nonatomic,strong)NSDictionary*btnTtileDic;
@end
@implementation SYLiveRoomFansTaskCell
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
    self.btnTtileDic = @{@"1":@"去观看",@"2":@"去聊天",@"3":@"去关注",@"4":@"去分享",@"5":@"去打赏",};
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.avator];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.actionBtn];
    [self.contentView addSubview:self.resultLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.avator.sy_left = 17;
    self.avator.sy_centerY = self.contentView.sy_centerY;
    self.titleLabel.sy_left = self.avator.sy_right + 14;
    self.titleLabel.sy_bottom = self.contentView.sy_centerY;
    
    self.infoLabel.sy_left = self.avator.sy_right + 14;
    self.infoLabel.sy_top = self.contentView.sy_centerY +2;
    self.actionBtn.sy_right = self.contentView.sy_right-16;
    self.actionBtn.sy_centerY = self.avator.sy_centerY;
    self.resultLabel.sy_centerY = self.avator.sy_centerY;
    self.resultLabel.sy_right = self.contentView.sy_right - 30;
    if (self.titleLabel.sy_right>(self.actionBtn.sy_left - 20)) {
        self.titleLabel.sy_width = self.actionBtn.sy_left - 20 - self.titleLabel.sy_left;
    }
    if (self.infoLabel.sy_right>(self.actionBtn.sy_left - 20)) {
        self.infoLabel.sy_width = self.actionBtn.sy_left - 20 - self.titleLabel.sy_left;
        [self.infoLabel sizeToFit];
        CGFloat totalHeight = self.titleLabel.sy_height+2+self.infoLabel.sy_height;
           CGFloat y = (self.sy_height-totalHeight)/2.f;
           self.titleLabel.sy_top = y;
           self.infoLabel.sy_top = self.titleLabel.sy_bottom+2;
    }
   
}
-(void)setCellInfo:(id)info{
    SYLiveRoomFansViewTaskInfoModel*model = (SYLiveRoomFansViewTaskInfoModel*)info;
    NSURL*url = [NSURL URLWithString:model.icon];
    [self.avator sd_setImageWithURL:url];
    self.titleLabel.text = [NSString stringWithFormat:@"%@（%@/%@）",model.name,model.complete_num,model.complete_criteria];
    [self.titleLabel sizeToFit];
    self.infoLabel.text = [NSString stringWithFormat:@"%@",model.des];
    [self.infoLabel sizeToFit];
    NSString*title = self.btnTtileDic[model.task_type];
    [self.actionBtn setTitle:title forState:UIControlStateNormal];
    if ([model.status integerValue] == 1) {
        self.resultLabel.hidden = YES;
        self.actionBtn.hidden = NO;
    }else if([model.status integerValue] == 2){
        self.resultLabel.hidden = NO;
        self.actionBtn.hidden = YES;
        self.resultLabel.text = model.rewards;
    }
    [self resetSubViewsFrames];
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

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        lab.numberOfLines = 2;
        _infoLabel = lab;
    }
    return _infoLabel;
}
- (UIButton *)actionBtn{
    if (!_actionBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 70, 28);
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.masksToBounds =YES;
        btn.layer.cornerRadius = 14;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor sy_colorWithHexString:@"#7B40FF"].CGColor;
        [btn setTitleColor:[UIColor sy_colorWithHexString:@"#7B40FF"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickActionBtn) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn = btn;
    }
    return _actionBtn;
}
-(void)clickActionBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomFansTask_clickActionBtn:)]) {
        [self.delegate liveRoomFansTask_clickActionBtn:@""];
    }
}
- (UILabel *)resultLabel{
    if (!_resultLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 18)];
        lab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
        lab.textColor = [UIColor sy_colorWithHexString:@"#FF0000"];
        lab.textAlignment = NSTextAlignmentRight;
        lab.hidden = YES;
        _resultLabel = lab;
    }
    return _resultLabel;
}
@end
