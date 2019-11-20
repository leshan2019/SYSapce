//
//  SYVoiceRoomMusicTutorVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/6/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomMusicTutorVC.h"

@interface SYVoiceRoomMusicTutorVC ()

@property (nonatomic, strong) UIScrollView *tutorScrollView;
@property (nonatomic, strong) UIImageView *tutorView;

@end

@implementation SYVoiceRoomMusicTutorVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
#ifdef ShiningSdk
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 36, 44);
    [back setImage:[UIImage imageNamed_sy:@"voiceroom_back"]
          forState:UIControlStateNormal];
    [back addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"歌曲导入教程";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!self.tutorScrollView) {
        CGFloat y = iPhoneX ? 88.f : 64;
        self.tutorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y)];
    }
    if (!self.tutorView) {
        self.tutorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tutorScrollView.sy_width, 0)];
    }
    UIImage *image = [UIImage imageNamed_sy:@"voiceroom_music_tutor"];
    CGFloat ratio = image.size.width / image.size.height;
    self.tutorView.sy_height = self.tutorView.sy_width / ratio;
    
    [self.view addSubview:self.tutorScrollView];
    [self.tutorScrollView addSubview:self.tutorView];
    self.tutorView.image = image;
    
    self.tutorScrollView.contentSize = CGSizeMake(self.tutorScrollView.sy_width, self.tutorView.sy_height);
    self.tutorScrollView.contentOffset = CGPointZero;
    
    if (@available(iOS 11.0, *)) {
        self.tutorScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
