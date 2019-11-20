//
//  ViewController.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLaunchAdViewController.h"
#import "SYVoiceChatRoomVC.h"
#import "SYWebViewController.h"
#import "SYVoiceChatRoomManager.h"
#import "SYNavigationController.h"
#import "SYConfigManager.h"

@implementation SYLaunchAdModel

@end


@interface SYLaunchAdViewController ()
@property (nonatomic, strong)UIImageView *launchImgView;
@property (nonatomic, strong)SYLaunchAdModel *adModel;
@property (nonatomic, strong)NSTimer *loadAdTimer;

@end

@implementation SYLaunchAdViewController


-(instancetype)initWithLaunchAdData:(id)adData {
    self = [super init];
    if (self) {
        if (adData && [adData isKindOfClass:[NSDictionary class]]) {
            self.adModel = [SYLaunchAdModel yy_modelWithDictionary:adData];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.launchImgView];
    [self.launchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view, typically from a nib.
    if (self.adModel && ![NSString sy_isBlankString:self.adModel.image]) {
        [self.launchImgView sd_setImageWithURL:[NSURL URLWithString:self.adModel.image] placeholderImage:[UIImage imageNamed_sy:@"sy_launch"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self setLoadAdTimer];
            }else {
                [self loadovertimeAd];
            }
        }];
    }
    if (!self.adModel) {
        [self requestAdData];
    }
}

- (void)requestAdData {
    [SYConfigManager requestLaunchAdData:^(BOOL success, id  _Nonnull response) {
        if (success) {
            if (response && [response isKindOfClass:[NSDictionary class]]) {
                self.adModel = [SYLaunchAdModel yy_modelWithDictionary:response];
            }
            if (self.adModel && ![NSString sy_isBlankString:self.adModel.image]) {
                [self.launchImgView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.adModel.image] placeholderImage:[UIImage imageNamed_sy:@"sy_launch"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image) {
                        [self setLoadAdTimer];
                    }else {
                        [self loadovertimeAd];
                    }
                }];
            }else {
                [self loadovertimeAd];
            }
        }else {
            [self loadovertimeAd];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}



-(void)setLoadAdTimer{
    /**
     * 定时器是为了防止SDK 强制结束广告流程添加
     * 冲突，gdt SDK 时间过多时   提前结束会使GDT controllor 移除出现错误，SDK 控制不了
     * 增大时间差 保证逻辑严谨性
     * timer 不是必须增加 为保证严谨性增加
     */
    int timeInterval = [SYSettingManager syIsTestApi]? 3.0f : 3.0f;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                      target:self
                                                    selector:@selector(loadovertimeAd)
                                                    userInfo:nil
                                                     repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.loadAdTimer = timer;

}


- (void)loadovertimeAd {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf timerInvalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LuanchAdFinishedNotification"
                                                            object:nil];
        [weakSelf.view removeFromSuperview];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    });
}


-(void)timerInvalidate {
    if (self.loadAdTimer) {
        [self.loadAdTimer invalidate];
        self.loadAdTimer = nil;
    }
}

- (UIImageView *)launchImgView {
    if (!_launchImgView) {
        _launchImgView = [UIImageView new];
        _launchImgView.backgroundColor = [UIColor clearColor];
        _launchImgView.image = [UIImage imageNamed_sy:@"sy_launch"];
        _launchImgView.userInteractionEnabled = YES;
        [_launchImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction:)]];
    }
    return _launchImgView;
}

- (void)buttonAction:(UITapGestureRecognizer *)gestureRecognizer {
    void (^actionBlock)(SYLaunchAdType) = ^(SYLaunchAdType type) {
        if (type == SYLaunchAdTypeWebUrl) {
            SYWebViewController *vc = [[SYWebViewController alloc] initWithURL:self.adModel.jump_link];
            UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
            while (rootVC.presentedViewController) {
                rootVC = rootVC.presentedViewController;
            }
            if (vc) {
                SYNavigationController *naviVC = [[SYNavigationController alloc] initWithRootViewController:vc];
                naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
                [rootVC presentViewController:naviVC
                                     animated:YES
                                   completion:nil];
            }
        }else if(type == SYLaunchAdTypeRoomID) {
            [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:self.adModel.jump_link from:SYVoiceChatRoomFromTagLaunchAd];
        }
        [self loadovertimeAd];
    };
    actionBlock([self.adModel.jump_type integerValue]);
}


@end
