//
//  SYVoiceTextMessageView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceTextMessageListView.h"
#import "SYVoiceGiftMessageCell.h"
#import "SYVoiceGameMessageCell.h"
#import "SYVoiceRoomGiftStripView.h"
//#import ""

@interface SYVoiceTextMessageListView ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SYVoiceRoomGiftStripView *giftStripView;

@end

@implementation SYVoiceTextMessageListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
//        [self addSubview:self.giftStripView];
    }
    return self;
}

- (void)addGiftInfo:(SYVoiceTextMessageViewModel *)giftViewModel {
    if (!giftViewModel) {
        return;
    }
//    [self.giftStripView addGiftInfo:giftViewModel];
}

- (void)reloadData {
    [self.collectionView reloadData];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsOfVoiceTextMessageListView:)]) {
        NSInteger count = [self.dataSource numberOfItemsOfVoiceTextMessageListView:self];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MAX((count - 1), 0)
                                                                         inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                            animated:YES];
    }
}

- (SYVoiceRoomGiftStripView *)giftStripView {
    if (!_giftStripView) {
        _giftStripView = [[SYVoiceRoomGiftStripView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, 26.f)];
    }
    return _giftStripView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SYVoiceTextMessageCell class]
            forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[SYVoiceGiftMessageCell class]
            forCellWithReuseIdentifier:@"gift"];
        [_collectionView registerClass:[SYVoiceGameMessageCell class]
            forCellWithReuseIdentifier:@"game"];
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceTextMessageListView:messageViewModelAtIndex:)]) {
        SYVoiceTextMessageViewModel *model = [self.dataSource voiceTextMessageListView:self
                                                               messageViewModelAtIndex:indexPath.item];
        if (model.messageType == SYVoiceTextMessageTypeGift) {
            SYVoiceGiftMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gift"
                                                                                     forIndexPath:indexPath];
            cell.delegate = self;
            [cell showWithViewModel:model];
            return cell;
        } else if (model.messageType == SYVoiceTextMessageTypeGame ||
                   model.messageType == SYVoiceTextMessageTypeExpression) {
            SYVoiceGameMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"game"
                                                                                     forIndexPath:indexPath];
            cell.delegate = self;
            [cell showWithViewModel:model];
            return cell;
        } else {
            SYVoiceTextMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                     forIndexPath:indexPath];
            [cell showWithViewModel:model];
            cell.delegate = self;
            return cell;
        }
    }
    SYVoiceTextMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                             forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsOfVoiceTextMessageListView:)]) {
        return [self.dataSource numberOfItemsOfVoiceTextMessageListView:self];
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceTextMessageListView:messageViewModelAtIndex:)]) {
        SYVoiceTextMessageViewModel *model = [self.dataSource voiceTextMessageListView:self
                                                               messageViewModelAtIndex:indexPath.item];
        return [SYVoiceTextMessageCell cellSizeWithViewModel:model
                                                       width:self.bounds.size.width];
    }
    return CGSizeMake(self.bounds.size.width, 44.f);
}

- (void)voiceTextMessageCellDidTapUsernameWithCell:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceTextMessageListViewDidSelectUserAtIndex:)]) {
        [self.delegate voiceTextMessageListViewDidSelectUserAtIndex:indexPath.item];
    }
}

- (void)voiceTextMessageCellDidTapReceiverNameWithCell:(UICollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceTextMessageListViewDidSelectReceiverAtIndex:)]) {
        [self.delegate voiceTextMessageListViewDidSelectReceiverAtIndex:indexPath.item];
    }
}

@end
