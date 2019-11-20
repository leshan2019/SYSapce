//
//  SYCreateActivityVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateActivityVC.h"
#import "SYPlaceholderTextView.h"
#import "SYCreateActivityViewModel.h"
#import "SYCustomActionSheet.h"
#import <Photos/Photos.h>
#import "TZImagePickerController.h"
#import "SYCreateActivityImageCell.h"
#import "SYLocationManager.h"
#import "SYActivityLocationView.h"
#import "SYLocationSearchVC.h"
#import "SYNavigationController.h"
#import "SYPersonHomepageLookPhotoView.h"
#import "SYActivityVideoPlayView.h"
#import <AVKit/AVKit.h>
#import "SDAVAssetExportSession.h"
#import <HUPhotoBrowser.h>

#define MAX_IMAGE_COUNT 9

@interface SYCreateActivityVC () <SYPlaceholderTextViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate,
UICollectionViewDelegate, UICollectionViewDataSource,
SYCreateActivityImageCellDelegate,
SYActivityVideoPlayViewDelegate,
SYActivityLocationViewDelegate,
SYLocationSearchVCDelegate,
SYPersonHomepageLookPhotoViewDelegate>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) CAGradientLayer *progressLayer;
@property (nonatomic, strong) SYPlaceholderTextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SYActivityVideoPlayView *videoView;
@property (nonatomic, strong) SYActivityLocationView *locationView;

@property (nonatomic, assign) BOOL isVideoPost; // 发布视频
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) UIImage *videoCover;

@property (nonatomic, strong) SYCreateActivityViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *selectedPhotoArray;
@property (nonatomic, strong) NSMutableArray *selectedAssetArray;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) NSIndexPath *oldIndexPath;
@property (nonatomic, strong) NSIndexPath *moveIndexPath;
@property (nonatomic, strong) UIView *snapShotView;

@property (nonatomic, strong) SYLocationManager *locationManager;
@property (nonatomic, assign) CGPoint currentLocation;
@property (nonatomic, assign) NSInteger detailIndex;

@property (nonatomic, copy) SendSuccessBlock sendSuccess;

@property (nonatomic, weak) AVPlayerViewController *avPlayer;

// 正在发布动态
@property (nonatomic, assign) BOOL isSendActivity;
@property (nonatomic, strong) UIView *forbidHitView;

@end

@implementation SYCreateActivityVC

- (void)dealloc {
    [self removePlayerNotification];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isVideoPost = NO;
        _isSendActivity = NO;
        _viewModel = [SYCreateActivityViewModel new];
        _selectedPhotoArray = [NSMutableArray new];
        _selectedAssetArray = [NSMutableArray new];
        _oldIndexPath = nil;
        _locationManager = [SYLocationManager new];
        _currentLocation = CGPointZero;
        [self addPlayerNotification];
    }
    return self;
}

- (instancetype)initCreateActivityVCWithBlock:(SendSuccessBlock)block {
    self = [self init];
    if (self) {
        self.sendSuccess = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布动态";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButtonItems];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.locationView];
    [self.view addSubview:self.forbidHitView];
    /*
    __weak typeof(self) weakSelf = self;
    [self.locationManager requestLocationWithCompletion:^(NSString * _Nonnull locationName,  CGPoint location) {
        weakSelf.locationView.address = locationName;
        weakSelf.currentLocation = location;
    }];
     */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self sy_setStatusBarDard];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

#pragma mark - Setter

- (void)setIsSendActivity:(BOOL)isSendActivity {
    _isSendActivity = isSendActivity;
    self.forbidHitView.hidden = !isSendActivity;
}

#pragma mark - Private

- (void)setupBarButtonItems {
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.postButton];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)cancel:(id)sender {
    if (self.isSendActivity) {
        return;
    }
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

- (void)post:(id)sender {
    if (self.isSendActivity) {
        return;
    }
    [self.textView resignFirstResponder];
    if (!self.isVideoPost && !self.textView.hasContent && [self.selectedPhotoArray count] == 0) {
        [SYToastView showToast:@"请添加文字或图片"];
        return;
    }
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络~"];
        return;
    }
    self.isSendActivity = YES;
    [self.postButton setTitle:@"发布中" forState:UIControlStateNormal];
    if (self.isVideoPost) {
        [self postVideo];
    } else {
        [self postContentAndPhotos];
    }
}

// 上传图片，文字
- (void)postContentAndPhotos {
    NSString *text = nil;
    if (self.textView.hasContent) {
        text = self.textView.text;
    }
    NSMutableArray *imageURLs = [NSMutableArray new];
    NSData *imageData;
    for (int i = 0; i < self.selectedPhotoArray.count; i++) {
        imageData = UIImageJPEGRepresentation([self.selectedPhotoArray objectAtIndex:i], 1);
        [imageURLs addObject:imageData];
    }
    [self.viewModel requestSendActivityWithText:text imageURLs:imageURLs video:[NSData data] videoCover:[NSData data] location:self.locationView.address progress:^(CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateContentAndPhotosPostProgress:progress];
        });
    } block:^(BOOL success, BOOL isShowTip) {
        self.isSendActivity = NO;
        [self.postButton setTitle:@"发动态" forState:UIControlStateNormal];
        if (success) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                if (isShowTip) {
                    [SYToastView showToast:@"发布成功"];
                }
            }];
            if (self.sendSuccess) {
                self.sendSuccess();
            }
        } else {
            if (isShowTip) {
                [SYToastView showToast:@"发布失败"];
            }
        }
    }];
}

// 上传视频
- (void)postVideo {
    NSString *text = nil;
    if (self.textView.hasContent) {
        text = self.textView.text;
    }
    [self sy_video_convert_to_mp4:[NSURL URLWithString:self.videoFilePath] progress:^(CGFloat progress) {
        [self updateVideoCompressionProgress:progress];
    } block:^(BOOL success, NSString *compressPath) {
        if (success && compressPath.length > 0) {
            NSData *videoData = nil;
            NSData *videoCoverData = nil;
            videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:compressPath]];
            videoCoverData = UIImageJPEGRepresentation(self.videoCover, 1);
            [self.viewModel requestSendActivityWithText:text imageURLs:@[] video:videoData videoCover:videoCoverData location:self.locationView.address progress:^(CGFloat progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateVideoPostProgress:progress];
                });
            } block:^(BOOL success, BOOL isShowTip) {
                self.isSendActivity = NO;
                [self.postButton setTitle:@"发动态" forState:UIControlStateNormal];
                if (success) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        if (isShowTip) {
                            [SYToastView showToast:@"发布成功"];
                        }
                    }];
                    if (self.sendSuccess) {
                        self.sendSuccess();
                    }
                } else {
                    if (isShowTip) {
                        [SYToastView showToast:@"发布失败"];
                    }
                }
            }];
        } else {
            self.isSendActivity = NO;
            [self.postButton setTitle:@"发动态" forState:UIControlStateNormal];
            [SYToastView showToast:@"视频上传失败，请换个视频试试~"];
        }
    }];
}

- (void)updateContentAndPhotosPostProgress:(CGFloat)progress {
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    NSLog(@"progress = %f",progress);
    CGFloat layerWidth = self.view.sy_width * progress;
    self.progressLayer.frame = CGRectMake(0, 0, layerWidth, 2);
}

- (void)updateVideoCompressionProgress:(CGFloat)progress {
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    CGFloat layerWidth = self.view.sy_width / 2.0;
    self.progressLayer.frame = CGRectMake(0, 0, layerWidth, 2);
}

- (void)updateVideoPostProgress:(CGFloat)progress {
    if (progress < 0) {
        progress = 0;
    }
    if (progress > 1) {
        progress = 1;
    }
    CGFloat halfWidth = self.view.sy_width / 2.0;
    CGFloat layerWidth = halfWidth + halfWidth * progress;
    self.progressLayer.frame = CGRectMake(0, 0, layerWidth, 2);
}

#pragma mark - Video -> mp4

- (NSString *)sy_video_temp_path {
    NSString *tempDirectory = NSTemporaryDirectory();
    NSString *videoDirectory = [NSString stringWithFormat:@"%@%@",tempDirectory,@"SYActivityVideo"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:videoDirectory]){
        [fm createDirectoryAtPath:videoDirectory
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    } else {
        NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:videoDirectory];
        NSString *fileName;
        while (fileName= [dirEnum nextObject]) {
            [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@",videoDirectory,fileName] error:nil];
        }
    }
    return videoDirectory;
}

- (void)sy_video_convert_to_mp4:(NSURL *)movUrl progress:(void(^)(CGFloat))progress block:(void(^)(BOOL,NSString *))success {
    NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [self sy_video_temp_path], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
    NSURL *mp4Url = [NSURL fileURLWithPath:mp4Path];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    SDAVAssetExportSession *encoder = [[SDAVAssetExportSession alloc] initWithAsset:avAsset];
    encoder.outputFileType = AVFileTypeMPEG4;
    encoder.outputURL = mp4Url;
    CGFloat bitsPerPixel = 6;
    encoder.videoSettings = @
    {
        AVVideoCodecKey: AVVideoCodecH264,
        AVVideoWidthKey: @(__MainScreen_Width * 2),
        AVVideoHeightKey: @(__MainScreen_Height * 2),
//        AVVideoScalingModeKey: AVVideoScalingModeResizeAspectFill,
        AVVideoCompressionPropertiesKey: @
        {
            AVVideoAverageBitRateKey: @(__MainScreen_Width * __MainScreen_Height * bitsPerPixel),
            AVVideoExpectedSourceFrameRateKey : @(10),
            AVVideoMaxKeyFrameIntervalKey : @(10),
            AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel,
        },
    };
    encoder.audioSettings = @
    {
        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
        AVNumberOfChannelsKey: @2,
        AVSampleRateKey: @44100,
        AVEncoderBitRateKey: @128000,
    };
    [encoder exportAsynchronouslyWithCompletionHandler:^
    {
        if (encoder.status == AVAssetExportSessionStatusCompleted){
            NSLog(@"Video export succeeded");
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     success(YES,mp4Path);
                });
            }
        } else if (encoder.status == AVAssetExportSessionStatusExporting) {
            NSLog(@"Video export cancelled");
            if (progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     progress(0.5);
                });
            }
        } else if (encoder.status == AVAssetExportSessionStatusCancelled) {
            NSLog(@"Video export cancelled");
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(NO,@"");
                });
            }
        } else {
            NSLog(@"Video export failed with error: %@ (%ld)", encoder.error.localizedDescription, encoder.error.code);
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(NO,@"");
                });
            }
        }
    }];
}


//{
//        NSURL *mp4Url = nil;
//        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
//        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//
//        if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
//            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
//                                                                                  presetName:AVAssetExportPresetHighestQuality];
//            NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [self sy_video_temp_path], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
//            mp4Url = [NSURL fileURLWithPath:mp4Path];
//            exportSession.outputURL = mp4Url;
//            exportSession.shouldOptimizeForNetworkUse = YES;
//            exportSession.outputFileType = AVFileTypeMPEG4;
//            dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
//            [exportSession exportAsynchronouslyWithCompletionHandler:^{
//                switch ([exportSession status]) {
//                    case AVAssetExportSessionStatusFailed: {
//                        NSLog(@"failed, error:%@.", exportSession.error);
//                    } break;
//                    case AVAssetExportSessionStatusCancelled: {
//                        NSLog(@"cancelled.");
//                    } break;
//                    case AVAssetExportSessionStatusCompleted: {
//                        CGFloat size = [SYUtil getFileSize:mp4Path];
//                        NSLog(@"completed.");
//                    } break;
//                    default: {
//                        NSLog(@"others.");
//                    } break;
//                }
//                dispatch_semaphore_signal(wait);
//            }];
//            long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
//            if (timeout) {
//                NSLog(@"timeout.");
//            }
//            if (wait) {
//                //dispatch_release(wait);
//                wait = nil;
//            }
//        }
//}

#pragma mark - PlayerNotification

- (void)addPlayerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reCyclePlay)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)removePlayerNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)reCyclePlay {
    if (self.avPlayer) {
        [self.avPlayer.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self.avPlayer.player play];
    }
}

#pragma mark - PhotoAbout

- (void)buttonAction:(id)sender {
    if ([self.selectedPhotoArray count] >= MAX_IMAGE_COUNT) {
        return;
    }
    [self.textView resignFirstResponder];
    NSArray *actions = @[@"拍照", @"从手机相册选择"];
    __weak typeof(self) weakSelf = self;
    SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
                                                                  cancelTitle:@"取消"
                                                                  selectBlock:^(NSInteger index) {
                                                                      switch (index) {
                                                                              case 0:
                                                                          {
                                                                              [weakSelf openImagePicker:YES];
                                                                          }
                                                                              break;
                                                                              case 1:
                                                                          {
                                                                              [weakSelf openImagePicker:NO];
                                                                          }
                                                                              break;
                                                                          default:
                                                                              break;
                                                                      }
                                                                  } cancelBlock:^{

                                                                  }];
    [sheet show];
}

- (void)openImagePicker:(BOOL)isCamera {
    if (isCamera) {
        [self sy_pushCameraVc];
    } else {
        [self sy_pushPhotoAlbumsVc];
    }
}

- (void)sy_pushCameraVc {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sy_pushCameraVc];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self sy_pushCameraVc];
        }];
    } else {
        // 提前定位
        __weak typeof(self) weakSelf = self;
        [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.location = [locations firstObject];
        } failureBlock:^(NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.location = nil;
        }];
        // 打开摄像头
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = sourceType;
            NSMutableArray *mediaTypes = [NSMutableArray array];
            if (self.selectedPhotoArray.count == 0) {
                [mediaTypes addObject:(NSString *)kUTTypeMovie];
            }
            [mediaTypes addObject:(NSString *)kUTTypeImage];
            self.imagePicker.mediaTypes = mediaTypes;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机");
        }
    }
}

- (void)sy_pushPhotoAlbumsVc {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.naviTitleColor = [UIColor blackColor];
    imagePickerVc.barItemTextColor = [UIColor blackColor];
    if (self.selectedAssetArray.count > 0) {
        imagePickerVc.selectedAssets = self.selectedAssetArray;
    }
    imagePickerVc.allowPickingOriginalPhoto = NO;
    if (@available(iOS 13.0, *)) {
        imagePickerVc.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    }
    __weak typeof(self) weakSelf = self;
    imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        // 获取图片
        weakSelf.selectedAssetArray = [NSMutableArray arrayWithArray:assets];
        [weakSelf showImageFromPhotoLibrary:photos];
    };
    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {
        // 获取视频
        [[TZImageManager manager] getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            if (playerItem) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
                    NSString *videoUrl = [urlAsset.URL absoluteString];
                    [self showVideo:videoUrl videoCover:coverImage];
                });
            }
        }];
    };
    imagePickerVc.imagePickerControllerDidCancelHandle = ^{
        // 取消
    };
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)showImageFromPhotoLibrary:(NSArray *)photos {
    self.isVideoPost = NO;
    self.videoView.hidden = YES;
    self.collectionView.hidden = NO;
    if (photos && photos.count > 0) {
        [self.selectedPhotoArray removeAllObjects];
        [self.selectedPhotoArray addObjectsFromArray:photos];
        [self.collectionView reloadData];
        NSInteger item = MIN([self.selectedPhotoArray count] + 1, MAX_IMAGE_COUNT);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
}

- (void)showImageFromCamera:(PHAsset *)asset image:(UIImage *)image {
    self.isVideoPost = NO;
    self.videoView.hidden = YES;
    [self.selectedPhotoArray addObject:image];
    [self.selectedAssetArray addObject:asset];
    [self.collectionView reloadData];
    NSInteger item = MIN([self.selectedPhotoArray count] + 1, MAX_IMAGE_COUNT);
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)showVideo:(NSString *)videoUrl videoCover:(UIImage *)videoCover {
    self.isVideoPost = YES;
    self.videoView.hidden = NO;
    [self.videoView configueVideo:videoUrl videoCover:videoCover];
    self.videoFilePath = videoUrl;
    self.videoCover = videoCover;
    self.collectionView.hidden = YES;
    [self.selectedPhotoArray removeAllObjects];
    [self.selectedAssetArray removeAllObjects];
    [self updateLocationPosition];
}

- (void)updateLocationPosition {
    if (self.isVideoPost) {
        self.locationView.sy_y = self.videoView.sy_bottom + 10.f;
    } else {
        self.locationView.sy_y = self.collectionView.sy_bottom + 10.f;
    }
}

#pragma mark 长按响应方法

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longPress {
    [self action:longPress];
}

- (void)action:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
            case UIGestureRecognizerStateBegan:
                {
                    //手势开始 判断手势落点位置是否在row上
                    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
                    if (indexPath == nil || indexPath.item >= [self.selectedPhotoArray count]) {
                        break;
                    }
                    self.oldIndexPath = indexPath;
                    SYCreateActivityImageCell *cell = (SYCreateActivityImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                    //使用系统的截图功能 得到cell的截图视图
                    UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
                    snapshotView.frame = cell.frame;
                    self.snapShotView = snapshotView;
                    [self.collectionView addSubview:snapshotView];
                    //截图后隐藏当前cell
                    cell.hidden = YES;
                    
                    CGPoint currentPoint = [longPress locationInView:self.collectionView];
                    [UIView animateWithDuration:0.25 animations:^{
                        snapshotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        snapshotView.center = currentPoint;
                    }];
                    
                }
                break;
            case UIGestureRecognizerStateChanged:
                {
                    //手势改变 当前手指位置 截图视图位置随着手指移动而移动
                    CGPoint currentPoint = [longPress locationInView:self.collectionView];
                    self.snapShotView.center = currentPoint;
                    //计算截图视图和哪个可见cell相交
                    for (SYCreateActivityImageCell *cell in self.collectionView.visibleCells) {
                        //当前隐藏的cell就不需要交换了 直接continue
                        if ([self.collectionView indexPathForCell:cell] == self.oldIndexPath) {
                            continue;
                        }
                        //计算中心距
                        CGFloat space = sqrt(pow(self.snapShotView.center.x-cell.center.x, 2) + powf(self.snapShotView.center.y - cell.center.y, 2));
                        //如果相交一半就移动
                        if (space <= self.snapShotView.bounds.size.width/2) {
                            NSIndexPath *currentIndexPath = [self.collectionView indexPathForCell:cell];
                            if (currentIndexPath.item >= [self.selectedPhotoArray count]) {
                                continue;
                            }
                            self.moveIndexPath = currentIndexPath;
                           /*更新数据源 须在移动之前*/
                            //取出移动row 数据
                            UIImage *image = [self.selectedPhotoArray objectAtIndex:self.oldIndexPath.item];
                            //从数据源中移除该数据
                            [self.selectedPhotoArray removeObjectAtIndex:self.oldIndexPath.item];
                            //将数据插入到数据源中目标位置
                            [self.selectedPhotoArray insertObject:image atIndex:self.moveIndexPath.item];
                            // 修改selectAssetArray
                            id asset = [self.selectedAssetArray objectAtIndex:self.oldIndexPath.item];
                            [self.selectedAssetArray removeObjectAtIndex:self.oldIndexPath.item];
                            [self.selectedAssetArray insertObject:asset atIndex:self.moveIndexPath.item];
                            //移动 会调用MoveToIndexPath方法更新数据源
                            [self.collectionView moveItemAtIndexPath:self.oldIndexPath toIndexPath:self.moveIndexPath];
                            
                            //设置移动后的起始indexPath
                            self.oldIndexPath = self.moveIndexPath;
                            break;
                        }
                    }
                }
                break;
            default:
                {
                 //手势结束和其他状态
                    SYCreateActivityImageCell *cell = (SYCreateActivityImageCell *)[self.collectionView cellForItemAtIndexPath:self.oldIndexPath];
                    //结束动画过程中停止交互，防止出问题
                    self.collectionView.userInteractionEnabled = NO;
                    //给截图视图一个动画移动到隐藏cell的新位置
                    [UIView animateWithDuration:0.25 animations:^{
                        self.snapShotView.center = cell.center;
                        self.snapShotView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    } completion:^(BOOL finished) {
                        //移除截图视图，显示隐藏的cell并开始交互
                        [self.snapShotView removeFromSuperview];
                        cell.hidden = NO;
                        self.collectionView.userInteractionEnabled = YES;
                    }];
                }
                break;
        }
}

#pragma mark - SYPlaceholderTextViewDelegate

- (void)textViewDidOutLimitedLength:(SYPlaceholderTextView *)textView limitedTextLength:(NSInteger)limitedTextLength {
    NSString *msg = [NSString stringWithFormat:@"字数不能超过%ld字哦~",(long)limitedTextLength];
    [SYToastView showToast:msg];
}

- (void)placeholderTextView:(nonnull SYPlaceholderTextView *)textView didFinishWithText:(nonnull NSString *)text {
    
}


- (void)placeholderTextViewDidBeginEditingWithTextView:(nonnull SYPlaceholderTextView *)textView {
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:self.location completion:^(PHAsset *asset, NSError *error){
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                [self showImageFromCamera:assetModel.asset image:image];
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self showVideo:[videoUrl absoluteString] videoCover:photo];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN([self.selectedPhotoArray count] + 1, MAX_IMAGE_COUNT);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCreateActivityImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                forIndexPath:indexPath];
    cell.delegate = self;
    NSData *data = nil;
    BOOL isPlus = NO;
    if (indexPath.item < [self.selectedPhotoArray count]) {
        data = UIImageJPEGRepresentation([self.selectedPhotoArray objectAtIndex:indexPath.item], 1);
    } else if (indexPath.item == [self.selectedPhotoArray count] && [self.selectedPhotoArray count] < MAX_IMAGE_COUNT) {
        isPlus = YES;
    }
    [cell showWithImageData:data
                 plusButton:isPlus];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < [self.selectedPhotoArray count]) {
        SYCreateActivityImageCell *cell = (SYCreateActivityImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [HUPhotoBrowser showFromImageView:[cell getClickImageView] withImages:self.selectedPhotoArray atIndex:indexPath.item];
    } else {
        [self buttonAction:nil];
    }
}

//开启collectionView可以移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < [self.selectedPhotoArray count]) {
        return YES;
    }
    return NO;
}

//处理collectionView移动过程中的数据操作
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //取出移动row 数据
    UIImage *image = [self.selectedPhotoArray objectAtIndex:sourceIndexPath.item];
    //从数据源中移除该数据
    [self.selectedPhotoArray removeObjectAtIndex:sourceIndexPath.item];
    //将数据插入到数据源中目标位置
    [self.selectedPhotoArray insertObject:image atIndex:destinationIndexPath.row];
    
    // 修改assetarray
    id asset = [self.selectedAssetArray objectAtIndex:sourceIndexPath.item];
    [self.selectedAssetArray removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedAssetArray insertObject:asset atIndex:destinationIndexPath.row];
}

#pragma mark - SYCreateActivityImageCellDelegate

- (void)createActivityImageCellDidCancelWithCell:(SYCreateActivityImageCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.item < [self.selectedPhotoArray count]) {
        [self.selectedPhotoArray removeObjectAtIndex:indexPath.item];
        [self.selectedAssetArray removeObjectAtIndex:indexPath.item];
        [self.collectionView reloadData];
    }
}

#pragma mark - SYActivityVideoPlayViewDelegate

- (void)SYActivityVideoPlayViewPlayVideo:(NSString *)videoUrl {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    if ([NSString sy_isBlankString:videoUrl]) {
        [SYToastView showToast:@"播放异常，请稍后重试~"];
        return;
    }
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [avPlayerVC.player play];
    avPlayerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
    self.avPlayer = avPlayerVC;
}

- (void)SYActivityVideoPlayViewDeleteVideo {
    self.isVideoPost = NO;
    self.videoFilePath = @"";
    self.videoCover = nil;
    self.videoView.hidden = YES;
    self.collectionView.hidden = NO;
    [self.collectionView reloadData];
    [self updateLocationPosition];
}

#pragma mark - SYActivityLocationViewDelegate

- (void)activityLocationViewDidChooseChangeAddress {
    SYLocationSearchVC *vc = [[SYLocationSearchVC alloc] initWithLocation:self.currentLocation];
    vc.delegate = self;
    SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:vc];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi
                       animated:YES
                     completion:nil];
}

#pragma mark - SYLocationSearchVCDelegate

- (void)locationSearchVCDidChooseLocation:(SYLocationViewModel *)location {
    if (location) {
        self.locationView.address = [NSString stringWithFormat:@"%@·%@", location.city, location.name];
    }
}

#pragma mark - SYPersonHomepageLookPhotoViewDelegate

- (void)SYPersonHomepageLookPhotoViewDeletePhoto:(NSString *)photoUrl {
    if (self.detailIndex >= 0 && self.detailIndex < [self.selectedPhotoArray count]) {
        [self.selectedPhotoArray removeObjectAtIndex:self.detailIndex];
        [self.selectedAssetArray removeObjectAtIndex:self.detailIndex];
        [self.collectionView reloadData];
    }
}

#pragma mark - Lazyload

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor sam_colorWithHex:@"#909090"]
                            forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_cancelButton addTarget:self
                          action:@selector(cancel:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _postButton.frame = CGRectMake(0, 0, 70, 44);
        CAGradientLayer *_gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 8, 70, 28);
        _gradientLayer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#8C15FF"].CGColor,(__bridge id)[UIColor sy_colorWithHexString:@"#E763FA"].CGColor];
        _gradientLayer.cornerRadius = 14.f;
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        [_postButton.layer addSublayer:_gradientLayer];
        [_postButton setTitle:@"发动态" forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightSemibold];
        [_postButton addTarget:self
                        action:@selector(post:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, iPhoneX ? 88.f : 64.f, self.view.sy_width, 2)];
        _progressView.backgroundColor = RGBACOLOR(242,242,242,1);
        [_progressView.layer addSublayer:self.progressLayer];
    }
    return _progressView;
}

- (CAGradientLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAGradientLayer layer];
        _progressLayer.frame = CGRectMake(0, 0, 0, 2);
        _progressLayer.startPoint = CGPointMake(0, 0);
        _progressLayer.endPoint = CGPointMake(1, 0);
        _progressLayer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#B44BFF"].CGColor,(__bridge id)[UIColor sy_colorWithHexString:@"#D375FF"].CGColor];
    }
    return _progressLayer;
}

- (SYPlaceholderTextView *)textView {
    if (!_textView) {
        CGFloat y = (iPhoneX ? 88.f : 64.f) + 2;
        CGFloat x = 20.f;
        _textView = [[SYPlaceholderTextView alloc] initWithFrame:CGRectMake(x, y, self.view.sy_width - 2 * x, 100)
                                               limitedTextLength:150];
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor sam_colorWithHex:@"#C9C9C9"];
        _textView.textDelegate = self;
        [_textView setPlaceholderFont:[UIFont systemFontOfSize:14.f]
                            textColor:[UIColor sam_colorWithHex:@"#C9C9C9"]
                                 text:@"此时此地，想和大家分享什么"];
    }
    return _textView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(88.f, 88.f);
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 5.f;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.textView.sy_bottom + 2.f, self.view.sy_width, 88.f) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SYCreateActivityImageCell class]
            forCellWithReuseIdentifier:@"cell"];
        _collectionView.clipsToBounds = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}

- (SYActivityVideoPlayView *)videoView {
    if (!_videoView) {
        _videoView = [[SYActivityVideoPlayView alloc] initWithFrame:CGRectMake(20, self.textView.sy_bottom + 2.f, 119, 204) delegate:self];
        _videoView.hidden = YES;
    }
    return _videoView;
}

- (SYActivityLocationView *)locationView {
    if (!_locationView) {
        _locationView = [[SYActivityLocationView alloc] initWithFrame:CGRectMake(0, self.collectionView.sy_bottom + 10.f, self.view.sy_width, 54.f)];
        _locationView.delegate = self;
    }
    return _locationView;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (UIView *)forbidHitView {
    if (!_forbidHitView) {
        CGFloat y = iPhoneX ? 64 + 24 : 64;
        _forbidHitView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y)];
        _forbidHitView.hidden = YES;
    }
    return _forbidHitView;
}

@end
