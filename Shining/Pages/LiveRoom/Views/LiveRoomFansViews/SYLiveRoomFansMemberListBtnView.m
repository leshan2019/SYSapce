//
//  SYLiveRoomFansMemberListBtnView.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansMemberListBtnView.h"
@interface SYLiveRoomFansMemberListBtnView()
@property(nonatomic,strong)UIButton*actionBtn;
@property(nonatomic,strong)UIImageView*btnIcon;
@end
@implementation SYLiveRoomFansMemberListBtnView
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
    [self addSubview:self.btnIcon];
    [self addSubview:self.actionBtn];
}
-(void)resetSubViewsFrame{
    self.btnIcon.sy_centerY = self.bounds.size.height/2.f;
    self.btnIcon.sy_right = self.bounds.size.width;
    self.actionBtn.frame = self.bounds;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetSubViewsFrame];
}
- (UIImageView *)btnIcon{
    if (!_btnIcon) {
        UIImageView*img = [[UIImageView alloc]initWithImage:[UIImage imageNamed_sy:@"liveRoom_enter"]];
        img.backgroundColor = [UIColor clearColor];
        img.tag = 0;
        img.frame = CGRectMake(0, 0, 14, 14);
        _btnIcon = img;
    }
    return _btnIcon;
}
- (UIButton *)actionBtn{
    if (!_actionBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickActionBtn) forControlEvents:UIControlEventTouchUpInside];
        _actionBtn = btn;
    }
    return _actionBtn;
}
-(void)clickActionBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomFansMemberListBtnView_clickActionBtn)]) {
        [self.delegate liveRoomFansMemberListBtnView_clickActionBtn];
    }
}
-(void)setupAvators:(NSArray*)arr{
    [self resetSubViewsFrame];

    for (UIImageView*tmp in self.subviews) {
        if (tmp.tag >=10) {
            [tmp removeFromSuperview];
        }
    }
    for (int i=0; i<arr.count; i++) {
        if (i>2) {
            break;
        }
        UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 29.f, 29.f)];
        img.backgroundColor = [UIColor sy_colorWithHexString:@"ECECEC"];
        img.layer.borderColor = [UIColor whiteColor].CGColor;
        img.layer.borderWidth = 1.f;
        img.tag = 10+i;
        img.layer.cornerRadius = 29.f/2.f;
        img.sy_centerY = self.bounds.size.height/2.f;
        img.sy_right = self.btnIcon.frame.origin.x-8 -i*22;
        NSURL*url = [NSURL URLWithString:arr[i]];
        [img sd_setImageWithURL:url];
        [self addSubview:img];
    }
    [self bringSubviewToFront:self.actionBtn];
}
@end
