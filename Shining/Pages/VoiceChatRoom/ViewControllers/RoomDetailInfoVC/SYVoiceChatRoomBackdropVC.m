//
//  SYVoiceChatRoomBackdropVC.m
//  Shining
//
//  Created by 杨玄 on 2019/4/16.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomBackdropVC.h"
#import "SYCommonTopNavigationBar.h"
#import "SYVoiceChatNetManager.h"
#import "SYVoiceChatRoomBackdropCell.h"

#define SYBackdropSize CGSizeMake(86, 114+38)   // 每个cell的大小
#define SYBackdropCountOneLine 4                // 一行显示多少张图片
#define SYVoiceChatRoomBackdropCellId  @"SYVoiceChatRoomBackdropCellId"

@interface SYVoiceChatRoomBackdropVC ()<SYCommonTopNavigationBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) NSArray *imageDataSources;            // 背景图数据源
@property (nonatomic, assign) NSUInteger selectIndex;               // 当前选中的背景图索引
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;

@end

@implementation SYVoiceChatRoomBackdropVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);

    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.listView];

    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -34 : 0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
}

- (void)setSelectBackdrop:(NSInteger)selectBackdrop {
    _selectBackdrop = selectBackdrop;
    for (NSInteger i = 0; i < self.imageDataSources.count; i++) {
        NSArray *subArr = [self.imageDataSources objectAtIndex:i];
        if ([subArr[0] integerValue] == selectBackdrop) {
            self.selectIndex = i;
            break;
        }
    }
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSaveBtnClick {
    if (self.usedByCreateRoomVC) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SYVoiceChatRoomBackDropVCSelectedRoomBackGroundImageNum:)]) {
            [self.delegate SYVoiceChatRoomBackDropVCSelectedRoomBackGroundImageNum:self.selectIndex];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSInteger selectImageNum = self.selectIndex;
        if (selectImageNum == self.selectBackdrop) {
            [SYToastView showToast:@"修改成功~"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        __weak typeof(self) weakSelf = self;
        [self.netManager requestUpdateChannelInfoWithChannelID:self.channelId name:@"" greeting:@"" desc:@"" icon:@"" iconFile:[NSData data] iconFile_16_9:[NSData data] backgroundImage:@(selectImageNum) success:^(id  _Nullable response) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SYVoiceChatRoomBackDropVCSelectedRoomBackGroundImageNum:)]) {
                [weakSelf.delegate SYVoiceChatRoomBackDropVCSelectedRoomBackGroundImageNum:selectImageNum];
            }
            [SYToastView showToast:@"房间背景修改成功~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError * _Nullable error) {
            [SYToastView showToast:@"房间背景更新失败~"];
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageDataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceChatRoomBackdropCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYVoiceChatRoomBackdropCellId forIndexPath:indexPath];
    NSNumber *imageNum = [[self.imageDataSources objectAtIndex:indexPath.item] objectAtIndex:0];
    NSString *name = [[self.imageDataSources objectAtIndex:indexPath.item] objectAtIndex:1];
    BOOL select = indexPath.item == self.selectIndex;
    NSString *imageUrl = [NSString stringWithFormat:@"voiceroom_bg_%ld",[imageNum integerValue]];
    [cell updateBackdropCellWithImage:imageUrl withSelect:select withName:name];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger clickIndex = indexPath.item;
    if (clickIndex == self.selectIndex) {
        return;
    }
    SYVoiceChatRoomBackdropCell *selectCell = (SYVoiceChatRoomBackdropCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [selectCell updateSelectedImageWithSelect:YES];

    if (self.selectIndex != -1) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:self.selectIndex inSection:0];
        SYVoiceChatRoomBackdropCell *lastSelectCell = (SYVoiceChatRoomBackdropCell *)[collectionView cellForItemAtIndexPath:lastIndexPath];
        [lastSelectCell updateSelectedImageWithSelect:NO];
    }

    self.selectIndex = clickIndex;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return SYBackdropSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(14, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat space = (__MainScreen_Width - SYBackdropCountOneLine*SYBackdropSize.width - 20) / (SYBackdropCountOneLine - 1);
    return space;
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"背景选择" rightTitle:@"保存" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_listView registerClass:[SYVoiceChatRoomBackdropCell class] forCellWithReuseIdentifier:SYVoiceChatRoomBackdropCellId];
        _listView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}

- (NSArray *)imageDataSources {
    if (!_imageDataSources) {
        _imageDataSources = @[@[@(0),@"默认"],
                              @[@(1),@"魅惑紫"],
                              @[@(2),@"魅惑蓝"],
                              @[@(3),@"魅惑红"]];
    }
    return _imageDataSources;
}

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
