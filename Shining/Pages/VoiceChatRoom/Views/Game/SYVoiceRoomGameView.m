//
//  SYVoiceRoomGameView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGameView.h"
#import "SYVoiceRoomGameCell.h"
#import "SYVoiceRoomGameViewModel.h"

@interface SYVoiceRoomGameView () <UICollectionViewDelegate, UICollectionViewDataSource>

//@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SYVoiceRoomGameViewModel *viewModel;

@property (nonatomic, strong) UIView *disableView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SYVoiceRoomGameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewModel = [[SYVoiceRoomGameViewModel alloc] init];
//        [self addSubview:self.maskView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.collectionView];
        [self.containerView addSubview:self.disableView];
    }
    return self;
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([self.timer isKindOfClass:[NSTimer class]] &&
        [self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)timerAction:(id)sender {
    self.disableView.hidden = YES;
    [self stopTimer];
}

- (UIView *)disableView {
    if (!_disableView) {
        _disableView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _disableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _disableView.hidden = YES;
    }
    return _disableView;
}

//- (UIView *)maskView {
//    if (!_maskView) {
//        _maskView = [[UIView alloc] initWithFrame:self.bounds];
//        _maskView.backgroundColor = [UIColor clearColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                              action:@selector(tap:)];
//        [_maskView addGestureRecognizer:tap];
//    }
//    return _maskView;
//}

- (UIView *)containerView {
    if (!_containerView) {
//        CGFloat height = 90.f;
//        if (iPhoneX) {
//            height += 34.f;
//        }
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height)];
//        _containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    }
    return _containerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(75.f, 75.f);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.sy_width, 90)
                                             collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SYVoiceRoomGameCell class]
            forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel gameCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                          forIndexPath:indexPath];
    NSString *title = [self.viewModel titleAtIndex:indexPath.item];
    NSString *imageName = [self.viewModel imageNameAtIndex:indexPath.item];
    [cell showWithImage:[UIImage imageNamed_sy:imageName]
                  title:title];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(voiceRoomGameViewDidSelectGame:)]) {
        SYVoiceRoomGameType type = [self.viewModel gameTypeAtIndex:indexPath.item];
        if (type != SYVoiceRoomGameUnknown) {
            [self.delegate voiceRoomGameViewDidSelectGame:type];
            [self startTimer];
            self.disableView.hidden = NO;
        }
    }
//    [self tap:nil];
}

//- (void)tap:(id)sender {
//    [self removeFromSuperview];
//}

@end
