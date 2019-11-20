//
//  SYVoiceRoomGiftGroupView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiftGroupView.h"
#import "SYVoiceChatRoomGiftViewModel.h"
#import "SYVoiceRoomGiftItemCell.h"

#define GiftCountPerPage 10

@interface SYVoiceRoomGiftGroupView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, assign) NSInteger groupIndex;
@property (nonatomic, strong) SYVoiceChatRoomGiftViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *collectionViewArray;

@property (nonatomic, assign) NSInteger selectedGiftIndex;
@property (nonatomic, assign) NSInteger selectedGiftId;

@end

@implementation SYVoiceRoomGiftGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedGiftIndex = -1;
        _collectionViewArray = [NSMutableArray new];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.hintLabel];
    }
    return self;
}

- (void)showGiftListWithGroup:(NSInteger)group
                    viewModel:(SYVoiceChatRoomGiftViewModel *)viewModel {
    self.viewModel = viewModel;
    self.groupIndex = group;
    NSInteger pageCount = [self giftTotalPage];
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    
    for (int i = 0; i < pageCount; i ++) {
        if (i >= [self.collectionViewArray count]) {
            UICollectionView *collectionView = [self collectionViewWithPageIndex:i];
            [self.collectionViewArray addObject:collectionView];
            [self.scrollView addSubview:collectionView];
        }
        UICollectionView *collectionView = [self.collectionViewArray objectAtIndex:i];
        [collectionView reloadData];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.sy_width * pageCount, self.scrollView.sy_height);
    self.hintLabel.hidden = (pageCount > 0);
}

- (void)reloadData {
    
    NSInteger giftId = [self.viewModel giftIDAtIndexPath:[NSIndexPath indexPathForItem:self.selectedGiftIndex inSection:self.groupIndex]];
    if (giftId != self.selectedGiftId) {
        self.selectedGiftId = 0;
        self.selectedGiftIndex = -1;
    }
    
    NSInteger pageCount = [self.collectionViewArray count];
    
    for (int i = 0; i < pageCount; i ++) {
        if (i < [self.collectionViewArray count]) {
            UICollectionView *collectionView = [self.collectionViewArray objectAtIndex:i];
            [collectionView reloadData];
        }
    }
    self.hintLabel.hidden = ([self giftTotalPage] > 0);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat width = CGRectGetWidth(self.bounds);
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, self.sy_height - GiftPageControlHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.sy_bottom, self.sy_width, GiftPageControlHeight)];
        _pageControl.currentPage = 0;
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _hintLabel.center = CGPointMake(self.sy_width / 2.f, self.sy_height / 2.f);
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.font = [UIFont systemFontOfSize:14.f];
        _hintLabel.text = @"您的背包里尚没有礼物~";
        _hintLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLabel;
}

- (UICollectionView *)collectionViewWithPageIndex:(NSInteger)pageIndex {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 6;
    layout.minimumInteritemSpacing = 0;
    CGFloat width = self.scrollView.sy_width;
    layout.itemSize = CGSizeMake(width/(float)(GiftCountPerPage/2), self.scrollView.sy_height / 2.f - 6.f);
    layout.sectionInset = UIEdgeInsetsMake(6.f, 0, 0, 0);
    UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(pageIndex * width, 0, width, self.scrollView.sy_height)
                                                           collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[SYVoiceRoomGiftItemCell class]
        forCellWithReuseIdentifier:@"cell"];
    return _collectionView;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger page = scrollView.contentOffset.x / scrollView.sy_width;
        if (scrollView.contentOffset.x > page * scrollView.sy_width * page) {
            page ++;
        }
        self.pageControl.currentPage = page;
    }
}

#pragma mark -

- (NSInteger)giftTotalPage {
    NSInteger pageCount = [self.viewModel giftCountAtGroupIndex:self.groupIndex] / GiftCountPerPage;
    if ([self.viewModel giftCountAtGroupIndex:self.groupIndex] % GiftCountPerPage > 0) {
        pageCount ++;
    }
    return pageCount;
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSInteger totalGiftCount = [self.viewModel giftCountAtGroupIndex:self.groupIndex];
    if (totalGiftCount == 0) {
        return 0;
    }
    NSInteger pageIndex = [self.collectionViewArray indexOfObject:collectionView];
    NSInteger pageCount = [self giftTotalPage];
    NSInteger count = GiftCountPerPage;
    if (pageCount == (pageIndex + 1)) {
        count = (totalGiftCount % GiftCountPerPage == 0) ? GiftCountPerPage : (totalGiftCount % GiftCountPerPage);
    } else if (pageCount < (pageIndex + 1)) {
        return 0;
    }
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pageIndex = [self.collectionViewArray indexOfObject:collectionView];
    NSInteger index = pageIndex * GiftCountPerPage + indexPath.item;
    SYVoiceRoomGiftItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                              forIndexPath:indexPath];
    [cell showWithGiftImageURL:[self.viewModel giftIconAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.groupIndex]]
                         title:[self.viewModel giftNameAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.groupIndex]]
                         price:[self.viewModel giftPriceStringAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.groupIndex]]
                      vipLevel:[self.viewModel giftLevelStringAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.groupIndex]]
                   needShowNum:self.isGiftBag
                           num:[self.viewModel giftBagGiftNumAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.groupIndex]]
                      minusNum:[self.viewModel giftMinusNumAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.groupIndex]]];
    
    if (self.isGiftBag) {
        NSInteger pageIndex = [self.collectionViewArray indexOfObject:collectionView];
        NSInteger index = pageIndex * GiftCountPerPage + indexPath.item;
        cell.selected = (index == self.selectedGiftIndex);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedGiftIndex >= 0) {
        NSInteger oldSelectPage = self.selectedGiftIndex / GiftCountPerPage;
        if (oldSelectPage >= 0 && oldSelectPage < [self.collectionViewArray count]) {
            UICollectionView *collectionView = [self.collectionViewArray objectAtIndex:oldSelectPage];
            NSInteger index = self.selectedGiftIndex % GiftCountPerPage;
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                                                    inSection:0]];
            if (cell) {
                cell.selected = NO;
            }
        }
    }
    NSInteger pageIndex = [self.collectionViewArray indexOfObject:collectionView];
    NSInteger index = pageIndex * GiftCountPerPage + indexPath.item;
    self.selectedGiftIndex = index;
    self.selectedGiftId = [self.viewModel giftIDAtIndexPath:[NSIndexPath indexPathForItem:index inSection:self.groupIndex]];
//    [self reloadSendButtonState];
    if ([self.delegate respondsToSelector:@selector(voiceRoomGiftGroupViewDidChangeGiftSelectIndexWithGroupView:)]) {
        [self.delegate voiceRoomGiftGroupViewDidChangeGiftSelectIndexWithGroupView:self];
    }
}

@end
