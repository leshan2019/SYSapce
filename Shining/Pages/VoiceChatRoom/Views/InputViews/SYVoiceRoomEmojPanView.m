//
//  SYVoiceRoomEmojPanView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomEmojPanView.h"
#import "SYVoiceRoomEmojCell.h"

#define EmojExpressionSource @"😀,😁,😂,😃,😄,😅,😆,😇,😈,👿,😉,😊,☺️,😋,😌,😍,😎,😏,😐,😑,😒,😓,😔,😕,😖,😗,😘,😙,😚,😛,😜,😝,😞,😟,😠,😡,😢,😣,😤,😥,😦,😧,😨,😩,😪,😫,😬,😭,😮,😯,😰,😱,😲,😳,😴,😵,😶,😷,❤️,💔,💌,💕,💞,💓,💗,💖,💘,💝"

@interface SYVoiceRoomEmojPanView () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *emojArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation SYVoiceRoomEmojPanView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _emojArray = [EmojExpressionSource componentsSeparatedByString:@","];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.sy_width / 8.f, 50);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, 150)
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[SYVoiceRoomEmojCell class]
            forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.collectionView.sy_bottom + 6.f, self.sy_width, 30)];
        NSInteger pages = [self.emojArray count] / 24;
        NSInteger remain = [self.emojArray count] % 24;
        if (remain) {
            pages ++;
        }
        _pageControl.numberOfPages = pages;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.emojArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomEmojCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    [cell showEmoj:self.emojArray[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *emoj = self.emojArray[indexPath.item];
    if (self.emojBlock) {
        self.emojBlock(emoj);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.sy_width;
    if (scrollView.contentOffset.x > page * scrollView.sy_width * page) {
        page ++;
    }
    self.pageControl.currentPage = page;
}

@end
