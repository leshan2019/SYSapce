//
//  SYDynamicPhotoView.m
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDynamicPhotoView.h"
#import <HUPhotoBrowser.h>

// 多张图片尺寸
#define ImageWidth  (__MainScreen_Width - 2*20 - 2*ImageSpace)/3.0
#define ImageHeight (__MainScreen_Width - 2*20 - 2*ImageSpace)/3.0
#define ImageSpace 2

// 单张图片尺寸
#define SignleImageWidth  183
#define SingleImageHeight 180

@interface SYDynamicPhotoView ()

@property (nonatomic, copy) ClickPhoto clickBlock;
@property (nonatomic, strong) NSArray *photoArr;

@end

@implementation SYDynamicPhotoView

- (instancetype)initWithFrame:(CGRect)frame clickPhoto:(ClickPhoto)clickBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.clickBlock = clickBlock;
    }
    return self;
}

- (void)configuePhotoView:(NSArray *)photoArr {
    self.photoArr = photoArr;
}

+ (CGFloat)calculatePhotoViewHeight:(NSInteger)photoCount {
    // 最多展示9张图片
    if (photoCount < 0 || photoCount > 10) {
        return 0;
    }
    if (photoCount == 1) {
        return SingleImageHeight;
    }
    if (photoCount <= 3) {
        return ImageHeight;
    }
    if (photoCount <= 6) {
        return ImageHeight * 2 + ImageSpace;
    }
    if (photoCount <= 9) {
        return ImageHeight * 3 + ImageSpace * 2;
    }
    return 0;
}

#pragma mark - Setter

- (void)setPhotoArr:(NSArray *)photoArr {
    _photoArr = photoArr;
    [self removeAllSubViews];
    if (photoArr && photoArr.count > 0) {
        NSInteger imageCount = photoArr.count;
        UIImageView *imageView;
        NSString *imageUrl;
        CGRect imageFrame;
        CGFloat x;
        CGFloat y;
        if (imageCount == 1) {
            imageUrl = [photoArr objectAtIndex:0];
            x = 0;
            y = 0;
            imageFrame = CGRectMake(x, y, SignleImageWidth, SingleImageHeight);
            imageView = [self createImageWithFrame:imageFrame imageUrl:imageUrl tag:(100 + 0)];
            [self addSubview:imageView];
        } else {
            for (int i = 0; i < imageCount; i++) {
                imageUrl = [photoArr objectAtIndex:i];
                x = 0 + (i % 3) * (ImageWidth + ImageSpace);
                y = (i / 3) * (ImageHeight + ImageSpace);
                imageFrame = CGRectMake(x, y, ImageWidth, ImageHeight);
                imageView = [self createImageWithFrame:imageFrame imageUrl:imageUrl tag:(100 + i)];
                [self addSubview:imageView];
            }
        }
    }
}

#pragma mark - Private

- (UIImageView *)createImageWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl tag:(NSInteger)tag {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = 4;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[SYUtil imageFromColor:[UIColor sy_colorWithHexString:@"#ECECEC"]]];
    imageView.tag = tag;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [imageView addGestureRecognizer:gesture];
    return imageView;
}

- (void)removeAllSubViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - ClickGesture

- (void)clickImage:(UITapGestureRecognizer *)gesture {
    UIImageView *view = (UIImageView *)gesture.view;
    NSInteger index = view.tag - 100;
    [HUPhotoBrowser showFromImageView:view withURLStrings:self.photoArr atIndex:index];
}

@end
