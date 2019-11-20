//
//  SYVoiceRoomMusicVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomMusicVC.h"
#import "SYVoiceRoomNavBar.h"
#import "SYVoiceRoomMusicViewModel.h"
#import "SYVoiceRoomMusicCell.h"
#import "SYVoiceRoomMusicPanel.h"
#import "SYCustomSlider.h"
#import "SYVoiceRoomMusicTutorVC.h"

@interface SYVoiceRoomMusicVC () <SYVoiceRoomNavBarDelegate, MPMediaPickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, SYVoiceRoomMusicPanelDelegate>

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) SYVoiceRoomNavBar *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *tutorLabel;
@property (nonatomic, strong) SYVoiceRoomMusicViewModel *viewModel;
@property (nonatomic, strong) SYVoiceRoomMusicPanel *controlPanel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) long long musicId; // 当前播放音乐id
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *maskView;
//@property (nonatomic, strong) UISlider *sliderView;

@property (nonatomic, strong) SYCustomSlider *customSlider;

@end

@implementation SYVoiceRoomMusicVC

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _musicId = 0;
        _viewModel = [[SYVoiceRoomMusicViewModel alloc] init];
        _currentIndex = -1;
    }
    return self;
}

+ (instancetype)sharedVC {
    static SYVoiceRoomMusicVC *vc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [SYVoiceRoomMusicVC new];
    });
    return vc;
}

- (void)reset {
    [self stopTimer];
    self.currentIndex = -1;
    self.musicId = 0;
    [self.tableView reloadData];
    [self.controlPanel stopPlay];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.controlPanel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef ShiningSdk
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
    [self sy_setStatusBarLight];
    [self.viewModel requestMusicList];
    if ([self.viewModel songsCount] == 0) {
        self.tutorLabel.hidden = NO;
    } else {
        self.tutorLabel.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.navBar];
    [self.navBar setTitle:@"BGM设置"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tutorLabel];
    [self.view addSubview:self.controlPanel];
    [self.view addSubview:self.maskView];
//    [self.maskView addSubview:self.sliderView];
    [self.maskView addSubview:self.customSlider];
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat top = iPhoneX ? 88.f : 64.f;
        CGFloat bottom = iPhoneX ? 34.f : 0.f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.sy_width, self.view.sy_height - top - bottom)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[SYVoiceRoomMusicCell class]
           forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (SYVoiceRoomMusicPanel *)controlPanel {
    if (!_controlPanel) {
        CGFloat bottom = iPhoneX ? 178.f : 144.f;
        _controlPanel = [[SYVoiceRoomMusicPanel alloc] initWithFrame:CGRectMake(0, self.view.sy_height - bottom, self.view.sy_width, bottom)];
        _controlPanel.delegate = self;
        _controlPanel.hidden = YES;
    }
    return _controlPanel;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backImageView.image = [UIImage imageNamed_sy:@"voiceroom_music_bg"];
    }
    return _backImageView;
}

- (SYVoiceRoomNavBar *)navBar {
    if (!_navBar) {
        CGFloat height = iPhoneX ? 88.f : 64.f;
        _navBar = [[SYVoiceRoomNavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
        _navBar.delegate = self;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 80, 44);
        [button setTitle:@"导入本地音乐" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [button setTitleColor:[UIColor sam_colorWithHex:@"#D8D8D8"] forState:UIControlStateNormal];
        [_navBar setRightBarButton:button];
    }
    return _navBar;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_maskView addGestureRecognizer:tap];
        _maskView.hidden = YES;
    }
    return _maskView;
}

//- (UISlider *)sliderView {
//    if (!_sliderView) {
//        _sliderView = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
//        _sliderView.center = CGPointMake(self.maskView.sy_centerX, self.maskView.sy_centerY);
//        _sliderView.minimumTrackTintColor = [UIColor sam_colorWithHex:@"#7138EF"];
//        _sliderView.maximumTrackTintColor = [UIColor sam_colorWithHex:@"#999999"];
//        _sliderView.thumbTintColor = [UIColor sam_colorWithHex:@"#EFEFEF"];
//        [_sliderView addTarget:self
//                        action:@selector(changeSliderValue:)
//              forControlEvents:UIControlEventValueChanged];
//    }
//    return _sliderView;
//}

- (SYCustomSlider *)customSlider {
    if (!_customSlider) {
        _customSlider = [[SYCustomSlider alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
        _customSlider.center = CGPointMake(self.maskView.sy_centerX, self.maskView.sy_centerY);
        [_customSlider addTarget:self
                          action:@selector(changeSliderValue:)
                forControlEvents:UIControlEventValueChanged];
    }
    return _customSlider;
}

- (UILabel *)tutorLabel {
    if (!_tutorLabel) {
        _tutorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.sy_width, 23.f)];
        _tutorLabel.center = self.view.center;
        _tutorLabel.textColor = [UIColor sam_colorWithHex:@"#FFF974"];
        _tutorLabel.text = @"当前没有歌曲，点击这里查看歌曲导入教程";
        _tutorLabel.font = [UIFont systemFontOfSize:12.f];
        _tutorLabel.textAlignment = NSTextAlignmentCenter;
        _tutorLabel.hidden = YES;
        _tutorLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(showTutor:)];
        [_tutorLabel addGestureRecognizer:tap];
    }
    return _tutorLabel;
}

- (void)voiceRoomBarDidTapBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)voiceRoomBarDidTapMore {
#ifdef ShiningSdk
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"导入背景音乐";
    //  UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:mediaPicker];
    mediaPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - media picker

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [self.viewModel addSongsWithCollection:mediaItemCollection completion:^{
        [weakSelf.tableView reloadData];
        weakSelf.tutorLabel.hidden = ([weakSelf.viewModel songsCount] > 0);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview datasource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel songsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    [cell showWithTitle:[self.viewModel songTitleAtIndex:indexPath.row]
               fileSize:[self.viewModel songSizeAtIndex:indexPath.row]
              isPlaying:([self.viewModel songIdAtIndex:indexPath.row] == self.musicId)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteSongAtIndex:indexPath.row];
        [self.tableView reloadData];
        self.tutorLabel.hidden = ([self.viewModel songsCount] > 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playSongAtIndex:indexPath.row];
}

#pragma mark - private

- (void)playNext:(BOOL)isForce {
    if (self.controlPanel.currentPlayMode == SYVoiceRoomMusicPlayModeLoop) {
        NSInteger nextIndex = self.currentIndex + 1;
        if (nextIndex >= [self.viewModel songsCount]) {
            nextIndex = 0;
        }
        [self playSongAtIndex:nextIndex];
    } else if (self.controlPanel.currentPlayMode == SYVoiceRoomMusicPlayModeSingleLoop) {
        if (isForce) {
            NSInteger nextIndex = self.currentIndex + 1;
            if (nextIndex >= [self.viewModel songsCount]) {
                nextIndex = 0;
            }
            [self playSongAtIndex:nextIndex];
        } else {
            [self playSongAtIndex:self.currentIndex];
        }
    } else if (self.controlPanel.currentPlayMode == SYVoiceRoomMusicPlayModeRandom) {
        // 随机逻辑，纯随机
        NSInteger nextIndex = arc4random_uniform((uint32_t)[self.viewModel songsCount]);
        [self playSongAtIndex:nextIndex];
    }
}

- (void)playSongAtIndex:(NSInteger)index {
    self.currentIndex = index;
    self.musicId = [self.viewModel songIdAtIndex:index];
    NSString *filePath = [self.viewModel songFilePathAtIndex:index];
    if ([self.playControlDelegate respondsToSelector:@selector(voiceRoomPlayerControlDidPlayWithFilePath:)]) {
        [self.playControlDelegate voiceRoomPlayerControlDidPlayWithFilePath:filePath];
    }
    [self.controlPanel playWithSongTitle:[self.viewModel songTitleAtIndex:index]
                                    size:[self.viewModel songSizeAtIndex:index]];
    [self.tableView reloadData];
    
    [self startTimer];
    if ([self.playControlDelegate respondsToSelector:@selector(voiceRoomPlayerControlDidGetDuration)]) {
        NSTimeInterval duration = [self.playControlDelegate voiceRoomPlayerControlDidGetDuration];
        [self.controlPanel changeDuration:duration];
    }
    self.controlPanel.hidden = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 144.f, 0);
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)stopTimer {
    if (self.timer && [self.timer isKindOfClass:[NSTimer class]] && [self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)timerAction:(id)sender {
    if ([self.playControlDelegate respondsToSelector:@selector(voiceRoomPlayerControlDidGetCurrentPlaybackTime)]) {
        NSTimeInterval time = [self.playControlDelegate voiceRoomPlayerControlDidGetCurrentPlaybackTime];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.controlPanel changeCurrentPlaybackTime:time];
        });
    }
}

- (void)tap:(id)sender {
    self.maskView.hidden = YES;
}

- (void)changeSliderValue:(id)sender {
    if ([self.playControlDelegate respondsToSelector:@selector(voiceRoomPlayerControlDidChangeVolumeWithProgress:)]) {
        [self.playControlDelegate voiceRoomPlayerControlDidChangeVolumeWithProgress:self.customSlider.value];
    }
    [SYSettingManager setVoiceRoomMixingAudioVolume:self.customSlider.value];
}

- (void)showTutor:(id)sender {
    NSLog(@"给你教程");
    SYVoiceRoomMusicTutorVC *vc = [[SYVoiceRoomMusicTutorVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - set play control delgate

- (void)setPlayControlDelegate:(id<SYVoiceRoomPlayerControlProtocol>)playControlDelegate {
    _playControlDelegate = playControlDelegate;
    [playControlDelegate voiceRoomPlayerSetObserver:self];
}

#pragma mark - panel delegate

- (void)voiceRoomMusicPanelDidPlay {
    if ([self.playControlDelegate respondsToSelector:@selector(voiceRoomPlayerControlDidResume)]) {
        [self.playControlDelegate voiceRoomPlayerControlDidResume];
    }
    [self startTimer];
}

- (void)voiceRoomMusicPanelDidPause {
    if ([self.playControlDelegate respondsToSelector:@selector(voiceRoomPlayerControlDidPause)]) {
        [self.playControlDelegate voiceRoomPlayerControlDidPause];
    }
    [self stopTimer];
}

- (void)voiceRoomMusicPanelDidPlayNext {
    [self playNext:YES];
}

- (void)voiceRoomMusicPanelDidSeekToTime:(NSTimeInterval)time {
    if ([self.playControlDelegate respondsToSelector:@selector(voiceRoomPlayerControlDidChangePlaybackTime:)]) {
        [self.playControlDelegate voiceRoomPlayerControlDidChangePlaybackTime:time];
    }
}

- (void)voiceRoomMusicPanelDidSelectVolumeButton {
    self.maskView.hidden = NO;
    [self.view bringSubviewToFront:self.maskView];
    self.customSlider.value = [SYSettingManager voiceRoomMixingAudioVolume];
}

#pragma mark - protocol

- (void)voiceRoomPlayerDidStartPlay {
    
}

- (void)voiceRoomPlayerDidFinishPlay {
    [self playNext:NO];
}

- (void)voiceRoomPlayerDidErrorPlay {
    
}

- (void)voiceRoomPlayerDidGetCurrentPlaybackTime:(NSTimeInterval)time {
    [self.controlPanel changeCurrentPlaybackTime:time];
}

@end
