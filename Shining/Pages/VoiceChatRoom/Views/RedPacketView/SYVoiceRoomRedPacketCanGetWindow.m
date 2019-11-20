//
//  SYVoiceRoomRedPacketCanGetWindow.m
//  Shining
//
//  Created by yangxuan on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomRedPacketCanGetWindow.h"
#import "SYVoiceRoomRedpacketCell.h"
#import "SYRoomGroupRedpacketModel.h"

#define SYVoiceRoomRedpacketCellId @"SYVoiceRoomRedpacketCellId"

@interface SYVoiceRoomRedPacketCanGetWindow()<UICollectionViewDelegate,
UICollectionViewDataSource,
SYVoiceRoomRedpacketCellDelegate>

@property (nonatomic, strong) UIButton *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UICollectionView *listView;

@property (nonatomic, strong) NSArray *redPacketList;

@end

@implementation SYVoiceRoomRedPacketCanGetWindow

- (void)dealloc {
    // 此方法必须调用，否则cell不被释放，定时器一直运行，造成性能消耗
    [self deallocAllCell];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)updateRecpacketData:(NSArray *)data {
    self.redPacketList = data;
    if (data && data.count > 0) {
        [self.listView reloadData];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cancelRedPacketWindow];
}

#pragma mark - Private

- (void)initSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.listView];
    
    CGFloat ratio = 315.f/260.f;
    CGFloat width = self.sy_width - 2*30;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(width, width/ratio));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(84, 18));
        make.top.equalTo(self.contentView).with.offset(20);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.top.equalTo(self.contentView).with.offset(14);
        make.right.equalTo(self.contentView).with.offset(-14);
    }];

    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(58);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)cancelRedPacketWindow {
    [self removeFromSuperview];
}

- (void)deallocAllCell {
    NSInteger cellCount = self.redPacketList.count;
    SYVoiceRoomRedpacketCell *cell = nil;
    for (int i = 0; i < cellCount; i++) {
        cell = (SYVoiceRoomRedpacketCell *)[self.listView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (cell) {
            [cell releaseTimer];
        }
    }
}

#pragma mark - UICollectionDelegate & UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.redPacketList) {
        return self.redPacketList.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomRedpacketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYVoiceRoomRedpacketCellId forIndexPath:indexPath];
    cell.delegate = self;
    SYRoomGroupRedpacketModel *model = [self.redPacketList objectAtIndex:indexPath.item];
    [cell configueModel:model];
    return cell;
}

#pragma mark - SYVoiceRoomRedpacketCellDelegate

// 点击领取按钮，领取红包
- (void)SYVoiceRoomRedpackeCellClickGetBtn:(id)model {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYVoiceRoomRedPacketCanGetWindowClickGetBtn:)]) {
        [self.delegate SYVoiceRoomRedPacketCanGetWindowClickGetBtn:model];
    }
}

- (NSInteger)hasPassedTime {
    NSInteger time = 0;
    if (self.delegate && [self.delegate hasPassedTime]) {
        time = [self.delegate hasPassedTime];
    }
    return time;
}

#pragma mark - Lazyload

- (UIButton *)contentView {
    if (!_contentView) {
        _contentView = [UIButton new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(68,68,68,1);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"未领取的红包";
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:[UIImage imageNamed_sy:@"voiceroom_redpacket_cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelRedPacketWindow) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(self.sy_width - 2*30, 72);
        _listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.backgroundColor = [UIColor clearColor];
        _listView.delegate = self;
        _listView.dataSource = self;
        [_listView registerClass:[SYVoiceRoomRedpacketCell class] forCellWithReuseIdentifier:SYVoiceRoomRedpacketCellId];
    }
    return _listView;
}

@end
