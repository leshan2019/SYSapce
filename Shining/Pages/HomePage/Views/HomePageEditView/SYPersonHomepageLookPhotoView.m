//
//  SYPersonHomepageLookPhotoView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/30.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#define MaxRatio 3
#define MinRatio 0.8

#import "SYPersonHomepageLookPhotoView.h"

@interface SYPersonHomepageLookPhotoView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UIButton *deletePhoto;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, assign) BOOL canDelete;
@property (nonatomic, assign) CGRect maxFrame;
@property (nonatomic, assign) CGRect minFrame;
@property (nonatomic, assign) CGRect originFrame;

@end

@implementation SYPersonHomepageLookPhotoView

- (instancetype)initWithFrame:(CGRect)frame withPhotoUrl:(NSString *)url canDelete:(BOOL)canDelete{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxFrame = CGRectMake(0, 0, MaxRatio*self.sy_width, MaxRatio*self.sy_width);
        self.minFrame = CGRectMake(0, 0, MinRatio*self.sy_width, MinRatio*self.sy_width);
        self.photoUrl = url;
        self.canDelete = canDelete;
        [self initSubViews];
    }
    return self;
}

- (void)tapGesture {
    [self removeFromSuperview];
}

#pragma mark - init

- (void)initSubViews {
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.photo];
    [self.baseView addSubview:self.deletePhoto];
    // imageView
    [self.photo sd_setImageWithURL:[NSURL URLWithString:[NSString sy_safeString:self.photoUrl]] placeholderImage:[UIImage imageNamed_sy:@"homepage_photo_default_big"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            CGFloat imageWidth = self.baseView.sy_width;
            CGFloat imageHeight = image.size.height * imageWidth / image.size.width;
            CGFloat imageX = 0;
            CGFloat imageY = (self.baseView.sy_height - imageHeight) / 2;
            self.originFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
            self.photo.frame = self.originFrame;
            self.maxFrame = CGRectMake(0, 0, MaxRatio*imageWidth, MaxRatio*imageHeight);
            self.minFrame = CGRectMake(0, 0, MinRatio*imageWidth, MinRatio*imageHeight);
        }
    }];
    // deleteBtn
    self.deletePhoto.hidden = !self.canDelete;
    // animation
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.baseView.frame;
        frame.origin.y = 0;
        self.baseView.frame = frame;
    }];
}

#pragma mark - BtnClickEvent

- (void)handleDeleteBtnClickEvent {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomepageLookPhotoViewDeletePhoto:)]) {
        [self.delegate SYPersonHomepageLookPhotoViewDeletePhoto:self.photoUrl];
    }
}

#pragma mark - Gesture

- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state==UIGestureRecognizerStateBegan || recognizer.state==UIGestureRecognizerStateChanged)
    {
        UIView *view = self.photo;
        view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
    } else {
        CGRect newFrame = self.photo.frame;
        newFrame = [self handleScaleFrame:newFrame];
        newFrame = [self handleBorderFrame:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.photo.frame = newFrame;
        }];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        UIView *view = self.photo;
        // 返回的是相对于最原始的手指的偏移量
        CGPoint transP = [recognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + transP.x, view.center.y + transP.y}];
        // 复位,表示相对上一次
        [recognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.photo.frame;
        newFrame = [self handleBorderFrame:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.photo.frame = newFrame;
        }];
    }
}

- (CGRect)handleScaleFrame:(CGRect)newFrame {
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (CGRectGetWidth(newFrame) < CGRectGetWidth(self.minFrame)) {
        newFrame = self.minFrame;
    }
    if (CGRectGetWidth(newFrame) > CGRectGetWidth(self.maxFrame)) {
        newFrame = self.maxFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderFrame:(CGRect)newFrame {
    if (CGRectGetWidth(newFrame) <= self.sy_width) {
        newFrame.origin.x = (self.sy_width - CGRectGetWidth(newFrame)) / 2.0f;
        newFrame.origin.y = (self.sy_height - CGRectGetHeight(newFrame)) / 2.0f;
    }else {
        // horizontally
        if (newFrame.origin.x > 0) {
            newFrame.origin.x = 0;
        }
        if (CGRectGetMaxX(newFrame) < self.sy_width) {
            newFrame.origin.x = self.sy_width - newFrame.size.width;
        }
        if (CGRectGetHeight(newFrame) > self.sy_height) {
            // vertically
            if (newFrame.origin.y > 0) {
                newFrame.origin.y = 0;
            }
            if (CGRectGetMaxY(newFrame) < self.sy_height) {
                newFrame.origin.y = self.sy_height - newFrame.size.height;
            }
        } else {
            newFrame.origin.y = (self.sy_height - CGRectGetHeight(newFrame)) / 2.0f;
        }
    }
    return newFrame;
}

#pragma mark - Lazyload

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView new];
        _baseView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [_baseView addGestureRecognizer:tapGesture];
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [_baseView addGestureRecognizer:pinchGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [_baseView addGestureRecognizer:panGesture];
        _baseView.frame = CGRectMake(0, self.sy_height, self.sy_width, self.sy_height);
    }
    return _baseView;
}

- (UIImageView *)photo {
    if (!_photo) {
        _photo = [UIImageView new];
        _photo.frame = CGRectMake(0, (self.baseView.sy_height - self.baseView.sy_width) / 2.f , self.baseView.sy_width, self.baseView.sy_width);
        _photo.clipsToBounds = YES;
        _photo.userInteractionEnabled = YES;
        _photo.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _photo;
}

- (UIButton *)deletePhoto {
    if (!_deletePhoto) {
        _deletePhoto = [UIButton new];
        _deletePhoto.frame = CGRectMake(self.baseView.sy_width - 20 - 26, self.baseView.sy_height - 26 - ((iPhoneX ? (34+16) : 16)) , 26, 26);
        [_deletePhoto setImage:[UIImage imageNamed_sy:@"homepage_photo_delete"] forState:UIControlStateNormal];
        [_deletePhoto addTarget:self action:@selector(handleDeleteBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletePhoto;
}

@end
