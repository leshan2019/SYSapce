//
//  PopBeeGiftListview.m
//  Shining
//
//  Created by leeco on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "PopBeeGiftListview.h"
#import "PopBeeGiftListviewModel.h"
#import "PopBeeGiftListviewCell.h"
#import "SYBeeAutoRefreshFooter.h"
#import "SYDataEmptyView.h"

@interface PopBeeGiftListview()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PopBeeGiftListDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) PopBeeGiftListviewModel *viewModel;
@property (nonatomic, strong) SYDataEmptyView *noDataView;
@end

@implementation PopBeeGiftListview

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(24, 5.0, 62, 1);
        [self buildUI];
        _viewModel = [[PopBeeGiftListviewModel alloc ]init];
        _viewModel.delegate = self;
        [self requestListData];
    }
    return self;
}

- (void)buildUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]init];
    [tap addTarget:self action:@selector(closebee)];
    [self addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(0,0, self.sy_width, 40)];
    label.text = @"中奖记录";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = RGBACOLOR(194, 167, 255, 1);;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    UIView *line = [[UIView alloc ] initWithFrame:CGRectMake(20, 39, self.sy_width - 40, 1)];
    line.backgroundColor = RGBACOLOR(255, 255, 255, 0.1f);
    [self addSubview:line];
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _layout.itemSize = CGSizeMake(self.sy_width, 37);
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, self.sy_width, self.sy_height - 40) collectionViewLayout:self.layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[PopBeeGiftListviewCell class] forCellWithReuseIdentifier:@"PopBeeGiftListviewCell"];
    self.collectionView.mj_footer.hidden = YES;
    self.collectionView.mj_footer = [SYBeeAutoRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestListData)];
    self.collectionView.mj_footer.hidden = YES;
}

- (void)closebee{}

- (SYDataEmptyView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[SYDataEmptyView alloc] initWithFrame:CGRectMake(0, 40, self.sy_width, self.sy_height - 40)
                                                withTipImage:@""
                                                  withTipStr:@"没有礼物，去采蜜吧！"];
        _noDataView.hidden = YES;
        _noDataView.backgroundColor = RGBACOLOR(24, 5, 62, 1);
        _noDataView.tipLabel.textColor = [UIColor whiteColor];
    }
    return _noDataView;
}

- (void)setChannelID:(NSString *)channelID
{
    _channelID = channelID;
    self.viewModel.channelID  = channelID;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PopBeeGiftListviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PopBeeGiftListviewCell" forIndexPath:indexPath];
    if (indexPath.row < self.viewModel.dataSource.count) {
        SYGiftModel *giftModel = [self.viewModel.dataSource objectAtIndex:indexPath.row];
        cell.giftModel = giftModel;
    }
    return cell;
}

/**
 * 礼物更新
 */
- (void)gameBeeGiftListUpdate{
    [self.collectionView.mj_footer endRefreshing];
    
    if (self.viewModel.dataSource.count % PagesSize) {
        // 没有更多
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    
    [self.collectionView reloadData];
    
    if (self.viewModel.dataSource.count > 0) {
        self.noDataView.hidden = YES;
        [self.noDataView removeFromSuperview];
    }
    if (self.viewModel.dataSource.count < PagesSize) {
        self.collectionView.mj_footer.hidden = YES;
    }else
    {
        self.collectionView.mj_footer.hidden = NO;
    }
    
}

/**
 * 礼物为空
 */
- (void)gameBeeGiftListEmpty{
    self.collectionView.hidden = YES;
    self.noDataView.hidden = NO;
    if (![self.noDataView superview]) {
        [self addSubview:self.noDataView];
    }
}

/**
 * 遇到错误
 */
- (void)gameBeeGiftListError:(NSString *)error{
    [SYToastView showToast:@"礼物获取失败，请稍后再试!"];
    self.noDataView.hidden = NO;
    if (![self.noDataView superview]) {
        [self addSubview:self.noDataView];
    }
}

- (void)requestListData{
    [self.viewModel requestListData];
}

@end
