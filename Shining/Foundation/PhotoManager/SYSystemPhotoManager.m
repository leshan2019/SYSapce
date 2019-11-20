//
//  SYSystemPhotoManager.m
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYSystemPhotoManager.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "SYImageCutterViewController.h"
#import "SYImageCutter.h"

@interface SYSystemPhotoManager ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, SYImageCutterViewControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, weak) UIViewController *originViewController;
@property (nonatomic, copy) completeBlock completeBlock;
@property (nonatomic, assign) SYSystemPhotoSizeRatioType ratioType;     // 默认1:1

@end

@implementation SYSystemPhotoManager

- (instancetype)initWithViewController:(UIViewController *)vc withBlock:(nonnull completeBlock)complete{
    self = [super init];
    if (self) {
        self.originViewController = vc;
        self.completeBlock = complete;
        self.ratioType = SYSystemPhotoRatio_OneToOne;
    }
    return self;
}

- (void)updateSYSystemPhotoRatioType:(SYSystemPhotoSizeRatioType)type {
    self.ratioType = type;
}

- (void)openPhotoGraph {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"没有权限打开摄像头");
        return ;
    }
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.originViewController presentViewController: self.imagePicker animated:YES completion:^{
        NSLog(@"打开相机");
    }];
}

- (void)openPhotoAlbum {
    //打开相册
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSLog(@"没有权限打开相册");
        return ;
    }
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.originViewController presentViewController: self.imagePicker animated:YES completion:^{
        NSLog(@"打开相册");
    }];
}

+ (BOOL)checkCameraPermission {
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    BOOL isDeny = (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied);
   
    return !isDeny;
}

+ (BOOL)checkPhotoAlbumPermission {
     PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    BOOL isDeny = (status == PHAuthorizationStatusRestricted ||
                   status == PHAuthorizationStatusDenied);
    return !isDeny;
}


+ (void)openJurisdiction{
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

+ (void)handleForPermissionDeny:(UIViewController *)controller isCameraOrPhoto:(BOOL)isCamera
{
    NSString *title = isCamera?@"去开启访问相机权限?":@"去开启访问相册权限?";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            //===无权限 引导去开启===
            [SYSystemPhotoManager openJurisdiction];
            
        }];
    
        [alertController addAction:cancel];
        
        [alertController addAction:ok];
        
        // present显示
        
        [controller presentViewController:alertController animated:YES completion:nil];
}

+ (void)showPermissionDenyAlert:(UIViewController *)controller isCameraOrPhoto:(BOOL)isCamera{
    NSString *alertString = [NSString stringWithFormat:@"请在iPhone的“设置”-“隐私”-“%@”选项中，允许访问您的%@",isCamera?@"相机":@"相册",isCamera?@"相机":@"相册"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancel];
    [controller presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
//    UIImagePickerControllerSourceType sourceType = picker.sourceType;
//    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    UIImage *theImage =nil;
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
//        if ([picker allowsEditing]) {
//            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        } else {
//            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        }
//    } else if ([mediaType isEqualToString:(NSString *)kUTTypeImage] && sourceType == UIImagePickerControllerSourceTypeCamera) {
//        if ([picker allowsEditing]) {
//            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        }else {
//            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        }
//        // 保存图片到相册中
//        UIImageWriteToSavedPhotosAlbum(theImage,self,nil,nil);
//    }
//    if (theImage && self.completeBlock) {
//        self.completeBlock(theImage);
//    }
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGFloat width = __MainScreen_Width;
        CGFloat height = 0;
        switch (self.ratioType) {
            case SYSystemPhotoRatio_OneToOne:
            {
                height = __MainScreen_Width;
            }
                break;
            case SYSystemPhotoRatio_SixteenToNine:
            {
                height = width * 9 / 16.f;
            }
                break;
            case SYSystemPhotoRatio_IDCard:
            {
                height = __MainScreen_Width*1.4;
            }
                break;
            default:
                break;
        }
        CGRect cropFrame = CGRectMake(0, (__MainScreen_Height - height ) / 2, width, height);
        SYImageCutterViewController *vc = [[SYImageCutterViewController alloc] initSYImageCutterVCWithImage:originImage cropFrame:cropFrame limitScaleRatio:3];
        vc.delegate = self;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.originViewController presentViewController:vc animated:YES completion:^{
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SYImageCutterViewControllerDelegate

- (void)SYImageCutterVCClickCancelBtn:(SYImageCutterViewController *)VC {
    [VC dismissViewControllerAnimated:YES completion:^{}];
}

- (void)SYImageCutterVC:(SYImageCutterViewController *)VC clickEnterBtnWithEditedImage:(UIImage *)image {
    [VC dismissViewControllerAnimated:YES completion:^{
        if (image && self.completeBlock) {
            CGSize maxSize;
            switch (self.ratioType) {
                case SYSystemPhotoRatio_OneToOne:
                {
                    maxSize = CGSizeMake(512, 512);
                }
                    break;
                case SYSystemPhotoRatio_SixteenToNine:
                {
                    maxSize = CGSizeMake(512, 512 * 9 / 16.f);
                }
                    break;
                case SYSystemPhotoRatio_IDCard:
                {
                    maxSize = CGSizeMake(512, 512*1.4);
                }
                    break;
                default:
                    break;
            }
            UIImage *scaleImage = [SYImageCutter cutOriginImageToMaxSize:image maxSize:maxSize];
            self.completeBlock(self.ratioType, scaleImage);
        }
    }];
}

#pragma mark - LazyLoad

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES; //允许编辑
        _imagePicker.videoMaximumDuration = 15 ; //视频时长默认15s
        _imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }
    return _imagePicker;
}

@end
