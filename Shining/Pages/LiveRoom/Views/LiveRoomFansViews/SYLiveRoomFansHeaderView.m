//
//  SYLiveRoomFansHeaderView.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansHeaderView.h"
#import "SYLiveRoomFansMemberListBtnView.h"
#import "SYLiveRoomFansViewInfoModel.h"
@interface SYLiveRoomFansHeaderView()<LiveRoomFansMemberListBtnViewDelegate>
@property(nonatomic,assign)LiveRoomFansViewHeaderStatus headerStatus;
//frist level
@property(nonatomic,strong)UIView*bgView;
@property(nonatomic,strong)UIButton*avator;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UILabel*infoLabel;
@property(nonatomic,strong)SYLiveRoomFansMemberListBtnView*listBtn;
@property(nonatomic,strong)UIButton*helpBtn;
@property(nonatomic,strong)UIButton*editBtn;
//second level
@property(nonatomic,strong)UIView*secondBgView;
@property(nonatomic,strong)UILabel*nameLabel;
@property(nonatomic,strong)UILabel*countLabel;
@property(nonatomic,strong)UIButton*backBtn;
@property(nonatomic,strong)UIView*line;
@end
@implementation SYLiveRoomFansHeaderView
- (instancetype)initWithFrame:(CGRect)frame andStatus:(LiveRoomFansViewHeaderStatus)status{
    {
        self = [super initWithFrame:frame];
        if (self) {
            self.headerStatus = status;
            [self setupSubViews];
        }
        return self;
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    self.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.avator];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.infoLabel];
    [self.bgView addSubview:self.listBtn];
    [self.bgView addSubview:self.helpBtn];
    [self.bgView addSubview:self.editBtn];
    //
    [self addSubview:self.secondBgView];
    [self.secondBgView addSubview:self.backBtn];
    [self.secondBgView addSubview:self.nameLabel];
    [self.secondBgView addSubview:self.countLabel];
    [self.secondBgView addSubview:self.line];
}
-(void)fristLevelSubviewHidden:(BOOL)hide{
    self.bgView.hidden = hide;
    self.avator.hidden = hide;
    self.titleLabel.hidden = hide;
    self.infoLabel.hidden = hide || (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host);
    self.listBtn.hidden = hide || (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host);
    self.helpBtn.hidden = hide;
    self.editBtn.hidden = hide || (self.headerStatus != LiveRoomFansViewHeaderStatus_firstLevel_host);
    
}
-(void)secondeLevelSubviewsHidden:(BOOL)hide{
    self.secondBgView.hidden = hide;
    self.backBtn.hidden = hide;
    self.nameLabel.hidden = hide;
    self.countLabel.hidden = hide;
    self.line.hidden = hide;
}
-(void)resetFristLevelSubViewsFrames{
    self.bgView.sy_top = 0;
    self.bgView.sy_left = 10;
    self.avator.sy_left = 20;
    self.avator.sy_centerY = self.bgView.sy_centerY;
    self.titleLabel.sy_left = self.avator.sy_right+8;
    self.titleLabel.sy_bottom = self.bgView.sy_centerY;
    if (self.headerStatus == LiveRoomFansViewHeaderStatus_firstLevel_host) {
        self.titleLabel.sy_centerY = self.avator.sy_centerY;
        self.editBtn.sy_left = self.titleLabel.sy_right;
        self.editBtn.sy_centerY = self.titleLabel.sy_centerY;
    }
    self.infoLabel.sy_left = self.avator.sy_right+8;
    self.infoLabel.sy_top = self.bgView.sy_centerY+3;
    self.listBtn.sy_right = self.bgView.bounds.size.width - 10;
    self.listBtn.sy_centerY = self.bgView.sy_centerY;
    self.helpBtn.sy_left = 6;
    self.helpBtn.sy_top = 6;
}
-(void)resetSecondLevelSubViewsFrames{
    [self.nameLabel sizeToFit];
    [self.countLabel sizeToFit];
    self.secondBgView.sy_top = 0;
    self.secondBgView.sy_left = 0;
    self.backBtn.sy_left = 0;
    self.backBtn.sy_centerY = self.sy_centerY+2;
    self.line.sy_left = 0;
    self.line.sy_bottom = self.sy_bottom;
    CGFloat width = self.nameLabel.sy_width;
    CGFloat total = width +self.countLabel.sy_width;
    CGFloat x = (self.sy_width - total)/2.f;
    self.nameLabel.sy_left = x;
    self.countLabel.sy_left = self.nameLabel.sy_right;
    self.nameLabel.sy_centerY = self.backBtn.sy_centerY;
    self.countLabel.sy_centerY = self.backBtn.sy_centerY;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetFristLevelSubViewsFrames];
}
-(void)setHeaderInfo:(id)infoModel andStatus:(LiveRoomFansViewHeaderStatus)status{
    self.headerStatus = status;
    SYLiveRoomFansViewInfoModel*model = (SYLiveRoomFansViewInfoModel*)infoModel;

    if (status == LiveRoomFansViewHeaderStatus_firstLevel_guest) {
        [self fristLevelSubviewHidden:NO];
        [self secondeLevelSubviewsHidden:YES];
        //
        NSURL*url = [NSURL URLWithString:model.image];
        [self.avator sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        //
        self.titleLabel.text = model.name;
        [self.titleLabel sizeToFit];
        //
        NSString*count = [NSString sy_isBlankString:model.number]?@"0":model.number;
        self.infoLabel.text = [NSString stringWithFormat:@"%@名真爱粉",count];
        [self.infoLabel sizeToFit];
        //
        NSMutableArray*iconUrls = @[].mutableCopy;
        for (SYLiveRoomFansViewInfoTopListModel*tmp in model.top_list) {
            [iconUrls addObject:tmp.avatar_imgurl];
        }
        [self.listBtn setupAvators:iconUrls];
        [self resetFristLevelSubViewsFrames];
        //
    }else if(status == LiveRoomFansViewHeaderStatus_firstLevel_host){
        SYLiveRoomFansViewInfoModel*model = (SYLiveRoomFansViewInfoModel*)infoModel;
        [self fristLevelSubviewHidden:NO];
        [self secondeLevelSubviewsHidden:YES];
        //
        NSURL*url = [NSURL URLWithString:model.image];
        [self.avator sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        self.titleLabel.text = model.name;
        [self.titleLabel sizeToFit];
        [self resetFristLevelSubViewsFrames];
    }else if (status == LiveRoomFansViewHeaderStatus_secondLevel_guest){
        [self fristLevelSubviewHidden:YES];
        [self secondeLevelSubviewsHidden:NO];
        self.nameLabel.text = @"真爱团成员";
        self.countLabel.text = [NSString stringWithFormat:@"（%@）",model.number];
        [self resetSecondLevelSubViewsFrames];
    }else if (status == LiveRoomFansViewHeaderStatus_secondLevel_host){
        [self fristLevelSubviewHidden:YES];
        [self secondeLevelSubviewsHidden:NO];
        self.nameLabel.text = @"修改团名称";
        [self resetSecondLevelSubViewsFrames];
    }else if (status == LiveRoomFansViewHeaderStatus_secondLevel_help){
        [self fristLevelSubviewHidden:YES];
        [self secondeLevelSubviewsHidden:NO];
        self.nameLabel.text = @"真爱团规则说明";
        [self resetSecondLevelSubViewsFrames];
    }
}
#pragma mark --------lazy load ----------
- (UIView *)bgView{
    if (!_bgView ) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.sy_width-20, self.sy_height - 5)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 6;
        view.layer.masksToBounds = NO;
        // 阴影
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,2);
        view.layer.shadowOpacity = 0.1;
        view.layer.shadowRadius = 8;
        _bgView = view;
    }
    return _bgView;
}
- (UIButton *)avator{
    if (!_avator) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 56, 56);
        [btn setBackgroundColor:[UIColor sy_colorWithHexString:@"ECECEC"]];
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor sy_colorWithHexString:@"E6E6E6"].CGColor;
        btn.layer.cornerRadius = 56/2.f;
        [btn addTarget:self action:@selector(clickAvator) forControlEvents:UIControlEventTouchUpInside];
        _avator = btn;
    }
    return _avator;
}
-(void)clickAvator{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(liveRoomFansHeaderView_avatorClick)]) {
        [self.delegate liveRoomFansHeaderView_avatorClick];
    }
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
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
        _infoLabel = lab;
    }
    return _infoLabel;
}
- (SYLiveRoomFansMemberListBtnView *)listBtn{
    if (!_listBtn) {
        SYLiveRoomFansMemberListBtnView*btn = [[SYLiveRoomFansMemberListBtnView alloc]initWithFrame:CGRectMake(0, 0, 95, 29)];
        btn.delegate = self;
        _listBtn = btn;
    }
    return _listBtn;
}
- (void)liveRoomFansMemberListBtnView_clickActionBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomFansHeaderView_memberList)]) {
        [self.delegate liveRoomFansHeaderView_memberList];
    }
}
- (UIButton *)helpBtn{
    if (!_helpBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 12, 12);
        [btn setImage:[UIImage imageNamed_sy:@"liveRoom_fans_help"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickHelpBtn) forControlEvents:UIControlEventTouchUpInside];
        _helpBtn = btn;
    }
    return _helpBtn;
}
-(void)clickHelpBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomFansHeaderView_help)]) {
        [self.delegate liveRoomFansHeaderView_help];
    }
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 22, 32);
        [btn setImage:[UIImage imageNamed_sy:@"liveRoom_fans_edit"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickEditBtn) forControlEvents:UIControlEventTouchUpInside];
        _editBtn = btn;
    }
    return _editBtn;
}
-(void)clickEditBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomFansHeaderView_edit)]) {
        [self.delegate liveRoomFansHeaderView_edit];
    }
}
- (UIView *)secondBgView{
    if (!_secondBgView ) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height + 10)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 6;
        view.layer.masksToBounds = YES;
        _secondBgView = view;
    }
    return _secondBgView;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 46, 52);
        [btn setImage:[UIImage imageNamed_sy:@"liveRoom_back"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
        _backBtn=btn;
    }
    return _backBtn;
}
-(void)clickBackBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomFansHeaderView_back)]) {
        [self.delegate liveRoomFansHeaderView_back];
    }
}
- (UIView *)line{
    if (!_line) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 0.5)];
        view.backgroundColor = [UIColor sy_colorWithHexString:@"E0E0E0"];
        _line=view;
    }
    return _line;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        lab.textColor = [UIColor sy_colorWithHexString:@"0B0B0B"];
        _nameLabel = lab;
    }
    return _nameLabel;
}
- (UILabel *)countLabel{
    if (!_countLabel) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        _countLabel = lab;
    }
    return _countLabel;
}
@end
