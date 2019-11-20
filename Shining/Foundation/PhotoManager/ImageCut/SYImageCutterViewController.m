//
//  SYImageCutterViewController.m
//  Shining
//
//  Created by 杨玄 on 2019/5/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYImageCutterViewController.h"

@interface SYImageCutterViewController ()

@property (nonatomic, strong) UIImage *originImage;

@property (nonatomic, assign) CGRect cropFrame;   // 裁剪区frame
@property (nonatomic, assign) CGFloat limitRatio; // 放大倍率

@property (nonatomic, assign) CGRect originFrame; // 保留图片初始化frame
@property (nonatomic, assign) CGRect latestFrame;
@property (nonatomic, assign) CGRect largeFrame;  // 最大frame

// View
@property (nonatomic, strong) UIImageView *showImageView;   // 图片view
@property (nonatomic, strong) UIView *overlayView;          // 蒙版
@property (nonatomic, strong) UIView *cropperView;          // 截图框
@property (nonatomic, strong) UIButton *cancelBtn;          // 取消按钮
@property (nonatomic, strong) UIButton *ensureBtn;          // 确定按钮

@end

@implementation SYImageCutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initSubViews];
    [self addGestureRecognizers];
}

#pragma mark - PublicMethod

- (instancetype)initSYImageCutterVCWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio {
    self = [super init];
    if (self) {
        self.originImage = [self fixOrientation:originalImage];
        self.cropFrame = cropFrame;
        self.limitRatio = limitRatio;
        self.showImageView.image = self.originImage;
    }
    return self;
}

#pragma mark - PrivateMethod

- (void)initSubViews {

    // 添加图片view
    CGFloat imageWidth = CGRectGetWidth(self.cropFrame);
    CGFloat imageHeight = self.originImage.size.height*imageWidth/self.originImage.size.width;
    CGFloat imageX = CGRectGetMinX(self.cropFrame)+(CGRectGetWidth(self.cropFrame) - imageWidth)/2;
    CGFloat imageY = CGRectGetMinY(self.cropFrame)+(CGRectGetHeight(self.cropFrame) - imageHeight)/2;
    self.originFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    self.showImageView.frame = self.originFrame;
    self.latestFrame = self.originFrame;
    self.largeFrame = CGRectMake(0, 0, self.limitRatio*imageWidth, self.limitRatio*imageHeight);
    [self.view addSubview:self.showImageView];

    // 蒙版
    [self.view addSubview:self.overlayView];

    // 截图框
    [self.view addSubview:self.cropperView];

    [self overlayClipping];

    // 取消按钮
    [self.view addSubview:self.cancelBtn];

    // 确定按钮
    [self.view addSubview:self.ensureBtn];
}

// 修正图片方向
- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }

    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }

    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.cropperView.frame.origin.x,
                                        self.overlayView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.cropperView.frame.origin.x + self.cropperView.frame.size.width,
                                        0,
                                        self.overlayView.frame.size.width - self.cropperView.frame.origin.x - self.cropperView.frame.size.width,
                                        self.overlayView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.overlayView.frame.size.width,
                                        self.cropperView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.cropperView.frame.origin.y + self.cropperView.frame.size.height,
                                        self.overlayView.frame.size.width,
                                        self.overlayView.frame.size.height - self.cropperView.frame.origin.y + self.cropperView.frame.size.height));
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.originFrame.size.width) {
        newFrame = self.originFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if ( newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.originImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.originImage.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newW; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

#pragma mark - Gesture

- (void) addGestureRecognizers
{
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImageView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.showImageView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImageView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImageView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.showImageView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

#pragma mark - Lazyload

- (UIImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [UIImageView new];
    }
    return _showImageView;
}

- (UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
        _overlayView.alpha = 0.5;
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.userInteractionEnabled = NO;
    }
    return _overlayView;
}

- (UIView *)cropperView {
    if (!_cropperView) {
        _cropperView = [[UIView alloc] initWithFrame:self.cropFrame];
        _cropperView.clipsToBounds = YES;
        _cropperView.layer.borderColor = [UIColor yellowColor].CGColor;
        _cropperView.layer.borderWidth = 1.0f;
    }
    return _cropperView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        CGFloat y = iPhoneX ? CGRectGetHeight(self.view.bounds) - 50 - 34 : CGRectGetHeight(self.view.bounds) - 50;
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 100, 50)];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        _cancelBtn.titleLabel.textColor = [UIColor whiteColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [_cancelBtn addTarget:self action:@selector(handleClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        CGFloat y = iPhoneX ? CGRectGetHeight(self.view.bounds) - 50 - 34 : CGRectGetHeight(self.view.bounds) - 50;
        CGFloat x = CGRectGetWidth(self.view.bounds) - 100;
        _ensureBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 100, 50)];
        _ensureBtn.backgroundColor = [UIColor clearColor];
        _ensureBtn.titleLabel.textColor = [UIColor whiteColor];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [_ensureBtn addTarget:self action:@selector(handleClickEnsureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

- (void)handleClickCancelBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYImageCutterVCClickCancelBtn:)]) {
        [self.delegate SYImageCutterVCClickCancelBtn:self];
    }
}

- (void)handleClickEnsureBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYImageCutterVC:clickEnterBtnWithEditedImage:)]) {
        [self.delegate SYImageCutterVC:self clickEnterBtnWithEditedImage:[self getSubImage]];
    }
}


@end
