//
//  SYStartRecorderViewController.m
//  Shining
//
//  Created by letv_lzb on 2019/3/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYStartRecorderViewController.h"
//#import <Masonry.h>
#import "SYRecoderViewController.h"

@interface SYStartRecorderViewController ()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitleLbl;
@property (nonatomic, strong) UIImageView *centerLogoView;
@property (nonatomic, strong) UILabel *descLal;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *backgroundImage;

@property (nonatomic, strong) id model;

@end

@implementation SYStartRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.backgroundImage) {}
    if (!self.backButton) {}
    if (!self.titleLbl.superview) {}
    if (!self.subTitleLbl.superview) {}
    if (!self.startBtn.superview) {}
    if (!self.descLal.superview) {}
    if (!self.centerLogoView) {}
}


- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont boldSystemFontOfSize:28];
        _titleLbl.text = @"录制声音";
    }
    if (!_titleLbl.superview) {
        [self.view addSubview:_titleLbl];
        __weak typeof(self) weakSelf = self;
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(85);
            make.left.equalTo(weakSelf.view).offset(20);
            make.right.equalTo(weakSelf.view).offset(20);
            make.height.mas_equalTo(@50);
        }];
    }
    return _titleLbl;
}


- (UIImageView *)backgroundImage
{
    if (!_backgroundImage) {
        _backgroundImage = [UIImageView new];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = [UIImage imageNamed_sy:@"mine_background"];
    }
    if (!_backgroundImage.superview) {
        [self.view addSubview:_backgroundImage];
        [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _backgroundImage;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat top = 22.f;
        if (iPhoneX) {
            top += 24;
        }
        _backButton.frame = CGRectMake(14.f, top, 36, 44);
        [_backButton setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"]
                     forState:UIControlStateNormal];
        [_backButton addTarget:self
                        action:@selector(back)
              forControlEvents:UIControlEventTouchUpInside];
    }
    if (!_backButton.superview) {
        [self.view addSubview:_backButton];
    }
    return _backButton;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}



- (UILabel *)subTitleLbl
{
    if (!_subTitleLbl) {
        _subTitleLbl = [[UILabel alloc] init];
        _subTitleLbl.backgroundColor = [UIColor clearColor];
        _subTitleLbl.textColor = [UIColor whiteColor];
        _subTitleLbl.textAlignment = NSTextAlignmentLeft;
        _subTitleLbl.font = [UIFont boldSystemFontOfSize:28];
        _subTitleLbl.text = @"开始交友的旅程";
    }
    if (!_subTitleLbl.superview) {
        [self.view addSubview:_subTitleLbl];
        __weak typeof(self) weakSelf = self;
        [_subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLbl.mas_bottom).with.offset(10);
            make.left.right.height.equalTo(weakSelf.titleLbl);
        }];
    }
    return _subTitleLbl;
}


- (UILabel *)descLal
{
    if (!_descLal) {
        _descLal = [[UILabel alloc] init];
        _descLal.backgroundColor = [UIColor clearColor];
        _descLal.textColor = [UIColor whiteColor];
        _descLal.textAlignment = NSTextAlignmentCenter;
        _descLal.font = [UIFont boldSystemFontOfSize:15];
        _descLal.text = @"通过声音，让更多的陌生人了解并喜欢你。";
    }
    if (!_descLal.superview) {
        [self.view addSubview:_descLal];
        __weak typeof(self) weakSelf = self;
        [_descLal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.startBtn.mas_top).with.offset(-40);
            make.size.mas_equalTo(CGSizeMake(weakSelf.view.frame.size.width, 20));
        }];
    }
    return _descLal;
}


- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.layer.cornerRadius = 20;
        _startBtn.layer.masksToBounds = YES;
        _startBtn.backgroundColor = [UIColor whiteColor];
        _startBtn.titleLabel.textColor = [UIColor blueColor];
        [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor colorWithRed:0/255 green:191/255 blue:255/255 alpha:1] forState:UIControlStateNormal];
        _startBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    if (!_startBtn.superview) {
        __weak typeof(self) weakSelf = self;
        [self.view addSubview:_startBtn];
        [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(160, 50));
        }];
    }
    return _startBtn;
}


- (UIImageView *)centerLogoView
{
    if (!_centerLogoView) {
        _centerLogoView = [[UIImageView alloc] init];
        _centerLogoView.backgroundColor = [UIColor whiteColor];
    }
    if (!_centerLogoView.superview) {
        __weak typeof(self) weakSelf = self;
        [self.view addSubview:_centerLogoView];
        [_centerLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.view);
            make.size.mas_equalTo(CGSizeMake(250, 150));
        }];
    }
    return _centerLogoView;
}

- (void)start
{
//    SYRecoderViewController *recoredVc = [[SYRecoderViewController alloc] init];
//    [self.navigationController pushViewController:recoredVc animated:YES];
}


- (void)bindData:(id)data
{
    self.model = data;
    [self.view setNeedsLayout];
}

@end
