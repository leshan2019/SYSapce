//
//  SYLiveBigTextMessageListView.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveBigTextMessageListView.h"

#import "SYLiveBigTextMessageCell.h"
#import "SYLiveBigGiftMessageCell.h"
#import "SYLiveBigGameMessageCell.h"

@interface SYLiveBigTextMessageListView ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SYLiveBigTextMessageListView

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
        [_collectionView registerClass:[SYLiveBigTextMessageCell class]
            forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[SYLiveBigGiftMessageCell class]
            forCellWithReuseIdentifier:@"gift"];
        [_collectionView registerClass:[SYLiveBigGameMessageCell class]
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
        if (model.messageType == SYVoiceTextMessageTypeGift ||
            model.messageType == SYVoiceTextMessageTypeFollow) {
            SYLiveBigGiftMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gift"
                                                                                     forIndexPath:indexPath];
            cell.delegate = self;
            [cell showWithViewModel:model];
            return cell;
        } else if (model.messageType == SYVoiceTextMessageTypeGame ||
                   model.messageType == SYVoiceTextMessageTypeExpression) {
            SYLiveBigGameMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"game"
                                                                                     forIndexPath:indexPath];
            cell.delegate = self;
            [cell showWithViewModel:model];
            return cell;
        } else {
            SYLiveBigTextMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                     forIndexPath:indexPath];
            [cell showWithViewModel:model];
            cell.delegate = self;
            return cell;
        }
    }
    SYLiveBigTextMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                             forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceTextMessageListView:messageViewModelAtIndex:)]) {
        SYVoiceTextMessageViewModel *model = [self.dataSource voiceTextMessageListView:self
                                                               messageViewModelAtIndex:indexPath.item];
        return [SYLiveBigTextMessageCell cellSizeWithViewModel:model
                                                       width:self.bounds.size.width];
    }
    return CGSizeMake(self.bounds.size.width, 44.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(collectionView.sy_height - 20, 0, 0, 0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
