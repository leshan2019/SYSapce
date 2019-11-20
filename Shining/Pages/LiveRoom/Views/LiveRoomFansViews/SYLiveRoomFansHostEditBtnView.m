//
//  SYLiveRoomFansHostEditBtnView.m
//  Shining
//
//  Created by leeco on 2019/11/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansHostEditBtnView.h"
#define spec 20.0

@interface SYLiveRoomFansHostEditBtnView()
@property(nonatomic,strong)UIView*bgView;
@property(nonatomic,strong)UIButton*actionBtn;
@end
@implementation SYLiveRoomFansHostEditBtnView
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
    self.backgroundColor= [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.bgView];
    [self addSubview:self.actionBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.actionBtn.sy_bottom = self.bounds.size.height - 14;

}
#pragma mark --------lazy load ----------
- (UIView *)bgView{
    if (!_bgView ) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height)];
        view.backgroundColor = [UIColor whiteColor];
//        view.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tapBlankView)];
        [view addGestureRecognizer:tap];
        _bgView = view;
    }
    return _bgView;
}
-(void)tapBlankView{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(liveRoomFansHostEditBtn_clickBlankView)]) {
        [self.delegate liveRoomFansHostEditBtn_clickBlankView];
    }
}
- (UIButton *)actionBtn{
    if (!_actionBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(spec, 0, self.sy_width - spec*2, 38);
        btn.backgroundColor = [UIColor sy_colorWithHexString:@"7B40FF"];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickActionBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 38/2.f;
        _actionBtn = btn;
    }
    return _actionBtn;
}
-(void)clickActionBtn{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(liveRoomFansHostEditBtn_clickSureBtn)]) {
        [self.delegate liveRoomFansHostEditBtn_clickSureBtn];
    }
}
@end
