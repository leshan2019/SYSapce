//
//  SYToastView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYToastView.h"
//#import <MBProgressHUD/MBProgressHUD.h>
@interface SYToastView ()
@property(nonatomic,strong)UILabel*label;
@property(nonatomic,strong)UIView*labelBg;
@property(nonatomic,assign)CGFloat fontSize;
@end
@implementation SYToastView
//
+ (void)showToast:(NSString *)toast {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window
                                              animated:YES];
    hud.labelText = toast;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.f];
}
//

+ (void)sy_showToast:(NSString *)toast{
    [self sy_showToast:toast onView:[UIApplication sharedApplication].keyWindow];
}
+ (void)sy_showToast:(NSString *)toast onView:(UIView *)view{
    SYToastView*hud = [[self alloc]initWithFrame:view.bounds];
    [hud resetLabelContent:toast];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = 0;
    [view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3.f];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.fontSize = 14.f;
        [self addSubview:self.labelBg];
        [self addSubview:self.label];
    }
    return self;
}
- (void)resetLabelContent:(NSString*)text{
    self.label.text = text;
    [self.label sizeToFit];
    if (text.length*self.fontSize>200) {
        self.label.sy_width = 200;
        self.label.sy_height = 40;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineSpacing = 4; // 调整行间距
        NSRange range = NSMakeRange(0, [text length]);
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        self.label.text = @"";
        self.label.attributedText = attributedString;
    }
    [self resetFrame];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetFrame];
}
-(void)resetFrame{
    self.label.sy_left = (self.sy_width - self.label.sy_width)/2.f;
    self.label.sy_top =(self.sy_height - self.label.sy_height)/2.f;
    self.labelBg.sy_width = self.label.sy_width+72;
    self.labelBg.sy_height = self.label.sy_height+28;
    self.labelBg.sy_left = (self.sy_width - self.labelBg.sy_width)/2.f;
    self.labelBg.sy_top =(self.sy_height - self.labelBg.sy_height)/2.f;
}
- (UILabel *)label{
    if (!_label) {
        UILabel*lab = [[UILabel alloc]init];
        lab.font = [UIFont systemFontOfSize:self.fontSize];
        lab.numberOfLines = 2;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.backgroundColor = [UIColor clearColor];
        _label = lab;
    }
    return _label;
}

- (UIView *)labelBg{
    if (!_labelBg) {
        UIView*bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 272*dp, 68)];
        bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        bg.layer.cornerRadius = 6;
        _labelBg = bg;
    }
    return _labelBg;
}
@end
