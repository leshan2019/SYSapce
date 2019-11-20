//
//  SYVoiceRoomWaitMicListView.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomApplyMicListView.h"
#import "SYVoiceRoomApplyMicCell.h"

@interface SYVoiceRoomApplyMicListView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SYVoiceRoomApplyMicCellDelegate>

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UIView *effectBackView;
@property (nonatomic, strong) UIView *backMask;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *applyMicButton;
@property (nonatomic, strong) UIView *buttonBack;

@end

@implementation SYVoiceRoomApplyMicListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backMask];
        [self addSubview:self.effectView];
        [self insertSubview:self.effectBackView
               belowSubview:self.effectView];
        [self.effectView.contentView addSubview:self.countLabel];
        [self.effectView.contentView addSubview:self.lineView];
        [self addSubview:self.collectionView];
        [self addSubview:self.buttonBack];
        [self.buttonBack addSubview:self.applyMicButton];
    }
    return self;
}

- (void)reloadData {
    [self.collectionView reloadData];
    [self reloadApplyButton];
    [self reloadCountLabel];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomApplyMicListViewMyselfIndex)]) {
        NSInteger index = [self.dataSource voiceRoomApplyMicListViewMyselfIndex];
        if (index != NSNotFound) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                             inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                                animated:YES];
        }
    }
}

- (void)reloadApplyButton {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomApplyMicListViewIsNeedApplyButton)]) {
        BOOL need = [self.dataSource voiceRoomApplyMicListViewIsNeedApplyButton];
        self.applyMicButton.hidden = !need;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomApplyMicListViewIsMyselfInApplyList)]) {
        BOOL contains = [self.dataSource voiceRoomApplyMicListViewIsMyselfInApplyList];
        [self setApplyMicSelected:contains];
    }
}

- (void)reloadCountLabel {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomApplyMicListViewItemCount)]) {
        NSInteger count = [self.dataSource voiceRoomApplyMicListViewItemCount];
        self.countLabel.text = [NSString stringWithFormat:@"排麦（%ld）",(long)count];
    }
}

- (void)changeUserRole:(SYChatRoomUserRole)role {
    [self reloadData];
}

- (UIView *)backMask {
    if (!_backMask) {
        _backMask = [[UIView alloc] initWithFrame:self.bounds];
        _backMask.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backMask addGestureRecognizer:tap];
    }
    return _backMask;
}

- (void)tap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomApplyMicListViewDidDisappeared)]) {
        [self.delegate voiceRoomApplyMicListViewDidDisappeared];
    }
    [self removeFromSuperview];
}

- (void)apply:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomApplyMicListViewDidSelectApplyButton)]) {
        [self.delegate voiceRoomApplyMicListViewDidSelectApplyButton];
    }
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        CGFloat width = self.bounds.size.width;
        CGFloat height = 319.f;
        CGFloat originY = self.bounds.size.height - height;
        if (iPhoneX) {
            originY -= 34.f;
            height += 34.f;
        }
        _effectView.frame = CGRectMake(0, originY, width, height);
//        _effectView.alpha = 0.8;
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_effectView.bounds
//                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(10, 10)];
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = _effectView.bounds;
//        maskLayer.path = path.CGPath;
//        _effectView.layer.mask = maskLayer;
    }
    return _effectView;
}

- (UIView *)effectBackView {
    if (!_effectBackView) {
        _effectBackView = [[UIView alloc] initWithFrame:self.effectView.frame];
        _effectBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _effectBackView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 15.f, _effectView.bounds.size.width - 20.f, 20.f)];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _countLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50.f, self.effectView.bounds.size.width, 0.5f)];
        _lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
    return _lineView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        CGFloat width = self.bounds.size.width;
        CGFloat height = 209.f;
        CGFloat originY = self.bounds.size.height - height - 60.f;
        if (iPhoneX) {
            originY -= 34.f;
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, originY, width, height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[SYVoiceRoomApplyMicCell class]
            forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UIView *)buttonBack {
    if (!_buttonBack) {
        CGFloat height = 60.f;
        CGFloat originY = self.bounds.size.height - height;
        if (iPhoneX) {
            originY -= 34.f;
            height += 34.f;
        }
        _buttonBack = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.bounds.size.width, height)];
        _buttonBack.backgroundColor = [UIColor clearColor];
    }
    return _buttonBack;
}

- (UIButton *)applyMicButton {
    if (!_applyMicButton) {
        CGFloat width = _buttonBack.bounds.size.width - 100.f;
        CGFloat height = 40.f;
        CGFloat originY = 10.f;
        _applyMicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyMicButton.frame = CGRectMake(50.f, originY, width, height);
        [_applyMicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyMicButton.layer.cornerRadius = 20.f;
        _applyMicButton.clipsToBounds = YES;
        [self setApplyMicSelected:NO];
        _applyMicButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_applyMicButton addTarget:self
                            action:@selector(apply:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyMicButton;
}

- (void)setApplyMicSelected:(BOOL)selected {
    if (selected) {
        UIColor *gray = [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1/1.0];
        [_applyMicButton setBackgroundImage:[SYUtil imageFromColor:gray]
                                   forState:UIControlStateNormal];
        [_applyMicButton setTitle:@"排麦中...(点击可取消)" forState:UIControlStateNormal];
    } else {
        UIColor *purple = [UIColor colorWithRed:123/255.0 green:64/255.0 blue:255/255.0 alpha:1/1.0];
        [_applyMicButton setBackgroundImage:[SYUtil imageFromColor:purple]
                                   forState:UIControlStateNormal];
        [_applyMicButton setTitle:@"申请排麦" forState:UIControlStateNormal];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomApplyMicListViewItemCount)]) {
        return [self.dataSource voiceRoomApplyMicListViewItemCount];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomApplyMicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    cell.delegate = self;
    SYVoiceChatUserViewModel *model = nil;
    BOOL needConfirmButton = NO;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomApplyMicListViewItemModelAtIndex:)]) {
        model = [self.dataSource voiceRoomApplyMicListViewItemModelAtIndex:indexPath.item];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomApplyMicListViewNeedConfirmButtonAtIndex:)]) {
        needConfirmButton = [self.dataSource voiceRoomApplyMicListViewNeedConfirmButtonAtIndex:indexPath.item];
    }
    [cell drawWithUserViewModel:model
                          index:indexPath.item + 1
              needConfirmButton:needConfirmButton];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width, 60.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomApplyMicListViewDidSelectRowAtIndex:)]) {
        [self.delegate voiceRoomApplyMicListViewDidSelectRowAtIndex:indexPath.item];
    }
}

#pragma mark - cell delegate method

- (void)voiceRoomApplyMicCellDidSelectConfirmButtonWithCell:(SYVoiceRoomApplyMicCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomApplyMicListViewDidSelectConfirmButtonAtIndex:)]) {
        NSInteger index = [self.collectionView indexPathForCell:cell].item;
        [self.delegate voiceRoomApplyMicListViewDidSelectConfirmButtonAtIndex:index];
    }
    [self tap:nil];
}

@end
