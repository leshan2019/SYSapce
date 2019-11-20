//
//  SYVoiceRoomOnlineListView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomOnlineListView.h"
#import "SYVoiceRoomOnlineListCell.h"
#import "SYVoiceRoomOnlineListModel.h"
#import "SYVoiceChatNetManager.h"

#define SYVoiceRoomOnlineListCellId @"SYVoiceRoomOnlineListCellId"

@interface SYVoiceRoomOnlineListView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIButton  *backView;          // 透明度浮层
@property (nonatomic, strong) UILabel *titleLabel;          // “在线用户”
@property (nonatomic, strong) UILabel *totalLabel;          // “共122309人”
@property (nonatomic, strong) UIView  *horizonLine;         // 分割横线
@property (nonatomic, strong) UICollectionView *listView;   // 列表
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, strong) NSString *channelId;          // rid
@property (nonatomic, strong) SYVoiceRoomOnlineListModel *listModel;
@property (nonatomic, strong) NSMutableArray *listArr;      // 数据源
@property (nonatomic, assign) NSInteger currentPage;        // 当前展示的页码
@end

@implementation SYVoiceRoomOnlineListView

- (instancetype)initWithFrame:(CGRect)frame withChannelID:(NSString *)channelId {
    self = [super initWithFrame:frame];
    if (self) {
        self.channelId = channelId;
        self.currentPage = 1;
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.totalLabel];
        [self.backView addSubview:self.horizonLine];
        [self.backView addSubview:self.listView];
        [self makeConstraintsForSubviews];
        self.listArr = [NSMutableArray array];
        [self requestOnlineListDataWithPage:self.currentPage];
        __weak typeof(self) weakSelf = self;
        self.listView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.currentPage < weakSelf.listModel.pageCount && weakSelf.currentPage < 5) {
                [self requestOnlineListDataWithPage:self.currentPage + 1];
            }
        }];
        self.listView.mj_footer.hidden = YES;
    }
    return self;
}

- (void)makeConstraintsForSubviews {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(319);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(20);
        make.top.equalTo(self.backView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(63, 17));
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).with.offset(17);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.backView).with.offset(-20);
        make.height.mas_equalTo(17);
    }];
    [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView);
        make.top.equalTo(self.backView).with.offset(45.5);
        make.right.equalTo(self.backView);
        make.height.mas_equalTo(0.5);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView);
        make.right.equalTo(self.backView);
        make.bottom.equalTo(self.backView);
        make.top.equalTo(self.horizonLine.mas_bottom);
    }];
}

- (void)requestOnlineListDataWithPage:(NSInteger)page {
    __weak typeof(self) weakSelf = self;
    [self.netManager requestVoiceRoomOnlineListWithChannelId:self.channelId page:page success:^(id  _Nullable response) {
        [weakSelf.listView.mj_footer endRefreshing];
        SYVoiceRoomOnlineListModel *model = (SYVoiceRoomOnlineListModel *)response;
        weakSelf.listModel = model;
        BOOL hasMoreData = self.currentPage < self.listModel.pageCount && self.currentPage < 5;
        weakSelf.listView.mj_footer.hidden = !hasMoreData;
    } failure:^(NSError * _Nullable error) {
        [weakSelf.listView.mj_footer endRefreshing];
        BOOL hasMoreData = self.currentPage < self.listModel.pageCount && self.currentPage < 5;
        weakSelf.listView.mj_footer.hidden = !hasMoreData;
    }];
}

#pragma mark - Setter

- (void)setListModel:(SYVoiceRoomOnlineListModel *)listModel {
    _listModel = listModel;
    if (listModel && listModel.data.count > 0) {
        self.currentPage = listModel.page;
        NSMutableAttributedString *text = [self getTotalPeople:[NSString stringWithFormat:@"共%ld人",listModel.total]];
        self.totalLabel.attributedText = text;
        if ([self.delegate respondsToSelector:@selector(onlineListViewDidFetchOnlineNumber:)]) {
            [self.delegate onlineListViewDidFetchOnlineNumber:listModel.total];
        }
        [self.listArr addObjectsFromArray:listModel.data];
        [self.listView reloadData];
    }
}

- (NSMutableAttributedString *)getTotalPeople:(NSString *)string {
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:@"人"];
    NSRange pointRange = NSMakeRange(1, range.location-1);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = RGBACOLOR(255,64,232,1);
    [attribut addAttributes:dic range:pointRange];
    return attribut;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomOnlineListCell *cell = (SYVoiceRoomOnlineListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SYVoiceRoomOnlineListCellId forIndexPath:indexPath];

    SYVoiceRoomUserModel *model = [self.listArr objectAtIndex:indexPath.item];
    NSInteger age = [SYUtil ageWithBirthdayString:model.birthday];
    [cell updateCellWithHeaderImage:model.avatar withName:model.name withGender:model.gender withAge:age withId:model.id withLevel:model.level];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleOnlineListViewClickEventWithModel:)]) {
        SYVoiceRoomUserModel *model = [self.listArr objectAtIndex:indexPath.item];
        [self.delegate handleOnlineListViewClickEventWithModel:model];
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取点击点的坐标
    CGPoint touchPoint = [[touches  anyObject] locationInView:self];
    //空白处的范围
    CGRect rect = self.backView.frame;

    //判断 点（CGPoint）是否在某个范围（CGRect）内
    if (!CGRectContainsPoint(rect, touchPoint)) {
        [self removeFromSuperview];
    }
}

#pragma mark - LazyLoad

- (UIButton *)backView {
    if (!_backView) {
        _backView = [UIButton new];
        _backView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *_effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_backView addSubview:_effectView];
        
        UIView *view = _backView;
        [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.right.equalTo(view);
            make.bottom.equalTo(view);
            make.top.equalTo(view);
        }];
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"在线人数";
    }
    return _titleLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [UILabel new];
        _totalLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _totalLabel;
}

- (UIView *)horizonLine {
    if (!_horizonLine) {
        _horizonLine = [UIView new];
        _horizonLine.backgroundColor = RGBACOLOR(68, 69, 68, 1);
    }
    return _horizonLine;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(__MainScreen_Width, 60);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.alwaysBounceVertical = YES;
        [_listView registerClass:[SYVoiceRoomOnlineListCell class] forCellWithReuseIdentifier:SYVoiceRoomOnlineListCellId];
        _listView.backgroundColor = [UIColor clearColor];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
