//
//  SYPersonHomepageDynamicView.m
//  Shining
//
//  Created by yangxuan on 2019/10/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageDynamicView.h"
#import "SYPersonHomepageDynamicViewModel.h"
#import "SYDynamicViewCell.h"
#import "SYDynamicDeleteView.h"
#import "SYCommentView.h"
#import "SYPersonHomepageLookPhotoView.h"
#import "SYCommentOnlyKeyboardView.h"

#define SYDynamicViewCellID @"SYDynamicViewCellID"

@interface SYPersonHomepageDynamicView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
SYDynamicViewProtocol>

// 删除动态确认弹窗
@property (nonatomic, strong) SYDynamicDeleteView *deleteWindow;

// 评论view
@property (nonatomic, strong) SYCommentView *commentView;                   // 评论view
@property (nonatomic, strong) SYCommentOnlyKeyboardView *keyboardView;      // 只有键盘view

// listView
@property (nonatomic, strong) UICollectionView *dynamicListView;
@property (nonatomic, strong) NSArray *dataSources;
@property (nonatomic, strong) SYPersonHomepageDynamicViewModel *viewModel;

// userid
@property (nonatomic, strong) NSString *userId;         // 用户id

// emptyView - 个人主页使用
@property (nonatomic, strong) UIView *homePageEmptyView;
@property (nonatomic, strong) UIImageView *homePageTipImageView;
@property (nonatomic, strong) UILabel *homePageTipLabel;        // 快去发布你的第一个动态吧

// emptyView - 广场使用
@property (nonatomic, strong) UIView *squareEmptyView;
@property (nonatomic, strong) UIImageView *squareTipImageView;
@property (nonatomic, strong) UILabel *squareTipLabel;          // "暂无内容"

// emptyView - 关注使用
@property (nonatomic, strong) UIView *concernEmptyView;
@property (nonatomic, strong) UIImageView *concernTipImageView;
@property (nonatomic, strong) UILabel *concernTipLabel;        // 暂无内容，快去认识一些新朋友吧
@property (nonatomic, strong) UIButton *concernJumpBtn;        // 为您推荐优质用户
@property (nonatomic, copy) ScrollToSquareBlock scrollBlock;

// 动态类型
@property (nonatomic, assign) SYDynamicType dynamicType;

@end

@implementation SYPersonHomepageDynamicView

- (instancetype)initWithFrame:(CGRect)frame type:(SYDynamicType)dynamicType {
    self = [super initWithFrame:frame];
    if (self) {
        self.dynamicType = dynamicType;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.backgroundColor = RGBACOLOR(247,247,247,1);
    [self addSubview:self.dynamicListView];
    switch (self.dynamicType) {
        case SYDynamicType_Homepage:{
            [self addSubview:self.homePageEmptyView];
        }
            break;
        case SYDynamicType_Square:{
            [self addSubview:self.squareEmptyView];
        }
            break;
        case SYDynamicType_Concern:{
            [self addSubview:self.concernEmptyView];
            [self addSubview:self.concernJumpBtn];
        }
            break;
        default:
            break;
    }
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.dynamicListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    switch (self.dynamicType) {
        case SYDynamicType_Homepage:{
            [self.homePageEmptyView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            [self.homePageTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.homePageEmptyView).with.offset(30);
                make.centerX.equalTo(self.homePageEmptyView);
                make.size.mas_equalTo(CGSizeMake(110, 110));
            }];
            [self.homePageTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.homePageTipImageView.mas_bottom).with.offset(15);
                make.centerX.equalTo(self.homePageEmptyView);
                make.size.mas_equalTo(CGSizeMake(144, 17));
            }];
        }
            break;
        case SYDynamicType_Square:{
            [self.squareEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            [self.squareTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.squareEmptyView);
                make.size.mas_equalTo(CGSizeMake(110, 110));
            }];
            [self.squareTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.squareTipImageView.mas_bottom).with.offset(12);
                make.centerX.equalTo(self.squareEmptyView);
                make.size.mas_equalTo(CGSizeMake(210, 16));
            }];
        }
            break;
        case SYDynamicType_Concern:{
            [self.concernEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            [self.concernTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.concernEmptyView);
                make.size.mas_equalTo(CGSizeMake(210, 16));
            }];
            [self.concernTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.concernTipLabel.mas_top).with.offset(-12);
                make.centerX.equalTo(self.concernEmptyView);
                make.size.mas_equalTo(CGSizeMake(110, 110));
            }];
            [self.concernJumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(160, 40));
                make.centerX.equalTo(self.concernEmptyView);
                make.top.equalTo(self.concernTipLabel.mas_bottom).with.offset(30);
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Public

- (void)configeUserId:(NSString *)userId {
    self.userId = userId;
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    [self.viewModel updateLoginUserId:userInfo.userid];
}

- (void)requestFirstPageListData {
    switch (self.dynamicType) {
        case SYDynamicType_Homepage: {
            [self requestUserDynamicListData:self.userId page:1];
        }
            break;
        case SYDynamicType_Square: {
            [self requestSquareListData:self.userId page:1];
        }
            break;
        case SYDynamicType_Concern: {
            [self requestConcernListData:self.userId page:1];
        }
            break;
        default:
            break;
    }
}

- (UIScrollView *)getDynamicScrollView {
    return self.dynamicListView;
}

- (void)configeJumpToSquareBlock:(ScrollToSquareBlock)block {
    self.scrollBlock = block;
}

#pragma mark - Private

- (void)requestUserDynamicListData:(NSString *)userId page:(NSInteger)page {
    [self.viewModel requestHomepageUserDynamicListData:userId page:page success:^(BOOL success) {
        [self.dynamicListView.mj_footer endRefreshing];
        self.homePageEmptyView.hidden = YES;
        if (success) {
            self.dynamicListView.mj_footer.hidden = NO;
            [self.dynamicListView reloadData];
            if (page == 1) {
                [self.dynamicListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        } else {
            if (page == 1) {
                // 没有数据
                self.dynamicListView.mj_footer.hidden = YES;
                self.homePageEmptyView.hidden = NO;
                [self.dynamicListView reloadData];  // 防止显示上次的第一页的数据，所以重新刷一遍
            } else {
//                [SYToastView showToast:@"暂无更多动态"];
                [self.dynamicListView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^{
        [self.dynamicListView.mj_footer endRefreshing];
        if (page == 1) {
            self.homePageEmptyView.hidden = NO;
            self.dynamicListView.mj_footer.hidden = YES;
            [self.dynamicListView reloadData];      // 防止显示上次的第一页的数据，所以重新刷一遍
        } else {
            [SYToastView showToast:@"网络异常，请重试~"];
        }
    }];
}

- (void)requestSquareListData:(NSString *)userId page:(NSInteger)page {
    if (page == 1) {
        [self showLoadingView];
    }
    self.squareEmptyView.hidden = YES;
    [self.viewModel requestHomepageSquareListWithPage:page
                                               success:^(BOOL success) {
        [self hideLoadingView];
        [self.dynamicListView.mj_header endRefreshing];
        [self.dynamicListView.mj_footer endRefreshing];
        if (success) {
            self.dynamicListView.mj_footer.hidden = NO;
            [self.dynamicListView reloadData];
            if (page == 1) {
                [self.dynamicListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        } else {
            if (page == 1) {
                // 没有数据
                self.squareEmptyView.hidden = NO;
                self.dynamicListView.mj_footer.hidden = YES;
                [self.dynamicListView reloadData];
            } else {
                [SYToastView showToast:@"暂无更多动态"];
                [self.dynamicListView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^{
        [self hideLoadingView];
        [self.dynamicListView.mj_header endRefreshing];
        [self.dynamicListView.mj_footer endRefreshing];
        if (page == 1) {
            self.squareEmptyView.hidden = NO;
            self.dynamicListView.mj_footer.hidden = YES;
            [self.dynamicListView reloadData];
        } else {
            [SYToastView showToast:@"网络异常，请重试~"];
        }
    }];
}

- (void)requestConcernListData:(NSString *)userId page:(NSInteger)page {
    if (page == 1) {
        [self showLoadingView];
    }
    self.concernEmptyView.hidden = YES;
    self.concernJumpBtn.hidden = YES;
    [self.viewModel requestConcernListWithPage:page success:^(BOOL success) {
        [self hideLoadingView];
        [self.dynamicListView.mj_header endRefreshing];
        [self.dynamicListView.mj_footer endRefreshing];
        if (success) {
            self.dynamicListView.mj_footer.hidden = NO;
            [self.dynamicListView reloadData];
            if (page == 1) {
                [self.dynamicListView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        } else {
            if (page == 1) {
                // 没有数据
                self.concernEmptyView.hidden = NO;
                self.concernJumpBtn.hidden = NO;
                self.dynamicListView.mj_footer.hidden = YES;
                [self.dynamicListView reloadData];
            } else {
                [SYToastView showToast:@"暂无更多动态"];
                [self.dynamicListView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^{
        [self hideLoadingView];
        [self.dynamicListView.mj_header endRefreshing];
        [self.dynamicListView.mj_footer endRefreshing];
        if (page == 1) {
            self.concernEmptyView.hidden = NO;
            self.concernJumpBtn.hidden = NO;
            self.dynamicListView.mj_footer.hidden = YES;
            [self.dynamicListView reloadData];
        } else {
            [SYToastView showToast:@"网络异常，请重试~"];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYDynamicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYDynamicViewCellID forIndexPath:indexPath];
    NSString *momentId = [self.viewModel momentId:indexPath];
    NSString *userId = [self.viewModel userId:indexPath];
    NSString *avatar = [self.viewModel avatar:indexPath];;
    NSString *name = [self.viewModel name:indexPath];
    NSString *gender = [self.viewModel gender:indexPath];;
    NSInteger age = [self.viewModel age:indexPath];
    BOOL showDelete = [self.viewModel canDeleteDynamic:indexPath];
    NSString *title = [self.viewModel title:indexPath];
    NSArray *photoArr = [self.viewModel photoArr:indexPath];
    NSDictionary *videoDic = [self.viewModel videoDic:indexPath];
    NSString *location = [self.viewModel location:indexPath];
    NSString *time = [self.viewModel time:indexPath];
    BOOL hasClickLike = [self.viewModel hasClickLike:indexPath];;
    NSInteger likeNum = [self.viewModel likeNum:indexPath];
    NSInteger commentNum = [self.viewModel commentNum:indexPath];
    BOOL isConcern = [self.viewModel hasConcern:indexPath];
    NSInteger roomid = [self.viewModel streamerRoomId:indexPath];
    UserProfileEntity *userModel = [self.viewModel userModel:indexPath];
    BOOL showGreetBtn = [self.viewModel showGreetBtn:indexPath];
    BOOL isUserSelf = [self.viewModel isUserSelf:indexPath];
    if (self.dynamicType == SYDynamicType_Square || self.dynamicType == SYDynamicType_Concern) {
        [cell configueSquareDynamicCell:momentId userId:userId avatar:avatar name:name gender:gender age:age roomId:[NSString stringWithFormat:@"%ld", (long)roomid] hasAttention:isConcern title:title photoArr:photoArr videoDic:videoDic location:location time:time hasClickLike:hasClickLike likeNum:likeNum commentNum:commentNum userModel:userModel showGreetBtn:showGreetBtn isUserSelf:isUserSelf];
    } else {
        [cell configueHomepageDynamicCell:momentId userId:userId avatar:avatar name:name gender:gender age:age showDeleteBtn:showDelete title:title photoArr:photoArr videoDic:videoDic location:location time:time hasClickLike:hasClickLike likeNum:likeNum commentNum:commentNum];
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self.viewModel title:indexPath];
    NSArray *photoArr = [self.viewModel photoArr:indexPath];
    NSDictionary *videoDic = [self.viewModel videoDic:indexPath];
    NSString *location = [self.viewModel location:indexPath];
    CGFloat height = [SYDynamicViewCell calculateDynamicViewCellHeightByCellWidth:self.sy_width - 2*20 title:title photoArr:photoArr videoDic:videoDic location:location];
    return CGSizeMake(self.sy_width, height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.dynamicListView) {
        CGFloat y = scrollView.contentOffset.y;
        if (self.offSetDelegate && [self.offSetDelegate respondsToSelector:@selector(changeOffSet:)]) {
            [self.offSetDelegate changeOffSet:y];
        }
    }
}

#pragma mark - SYDynamicViewProtocol

// 调起登录
- (void)SYDynamicViewClickLogin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickLogin)]) {
        [self.delegate SYDynamicViewClickLogin];
    }
}

// 点击头像
- (void)SYDynamicViewClickAvatar:(NSString *)userId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickAvatar:)]) {
        [self.delegate SYDynamicViewClickAvatar:userId];
    }
}

// 删除动态
- (void)SYDynamicViewClickDelete:(NSString *)momentId {
    if (self.deleteWindow) {
        [self.deleteWindow removeFromSuperview];
        self.deleteWindow = nil;
    }
    UIWindow *keyWindown = [UIApplication sharedApplication].keyWindow;
    
    __weak typeof(self) weakSelf = self;
    self.deleteWindow = [[SYDynamicDeleteView alloc] initWithFrame:keyWindown.bounds deleteBlock:^{
        [weakSelf.viewModel requestHomepageDeleteDynamic:momentId success:^(BOOL success) {
            if (success) {
                [weakSelf.dynamicListView reloadData];
                [SYToastView showToast:@"删除成功"];
                if (weakSelf.dynamicType == SYDynamicType_Homepage) {
                    NSInteger leftCount = [weakSelf.viewModel getTotalDataCount];
                    if (leftCount == 0) {
                        weakSelf.homePageEmptyView.hidden = NO;
                        weakSelf.dynamicListView.mj_footer.hidden = YES;
                    }
                }
            } else {
                [SYToastView showToast:@"删除失败"];
            }
        }];
    } cancelBlock:^{
    }];
    [keyWindown addSubview:self.deleteWindow];
}

// 播放视频
- (void)SYDynamicViewClickPlayVideo:(NSString *)videoUrl {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickPlayVideo:)]) {
        [self.delegate SYDynamicViewClickPlayVideo:videoUrl];
    }
}

// 点赞+取消
- (void)SYDynamicViewClickLike:(BOOL)like momentId:(nonnull NSString *)momentId userId:(nonnull NSString *)userId {
    [self.viewModel requestDynamicClickLikeWithLike:like momentId:momentId userId:userId success:^(BOOL success) {
        if (success) {
            [SYToastView showToast:(like ? @"点赞成功" : @"取消点赞成功")];
            [self.dynamicListView reloadData];
        } else {
            [SYToastView showToast:(like ? @"点赞失败" : @"取消点赞失败")];
        }
    }];
}

// 点击评论
- (void)SYDynamicViewClickComment:(NSString *)momentId userId:(nonnull NSString *)userId onlyShowKeyboard:(BOOL)show{
    __weak typeof(self) weakSelf = self;
    UpdateCommentBlock block = ^(NSInteger totalNum){
        [weakSelf.viewModel updateDynamicCommentNum:totalNum momentId:momentId userId:userId];
        [weakSelf.dynamicListView reloadData];
    };
    if (show) {
        // 展示键盘
        if (self.keyboardView) {
            [self.keyboardView removeFromSuperview];
            self.keyboardView = nil;
        }
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.keyboardView = [[SYCommentOnlyKeyboardView alloc] initWithFrame:keyWindow.bounds momentId:momentId block:block];
        [keyWindow addSubview:self.keyboardView];
        
    } else {
        // 展示评论列表
        if (self.commentView) {
            [self.commentView removeFromSuperview];
            self.commentView = nil;
        }
        UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.commentView = [[SYCommentView alloc] initWithFrame:keyWindow.bounds
                                                       momentId:momentId
                                                       mySelfid:userInfo.userid
                                                          block:block];
        [keyWindow addSubview:self.commentView];
    }
}

// 关注用户
- (void)SYDynamicViewClickAttentionUser:(NSString *)userId momentId:(nonnull NSString *)momentId block:(nonnull AttentionBlock)attentionBlock{
    if (self.dynamicType == SYDynamicType_Square) {
        [self.viewModel requestAttentionUserWithUserid:userId momentId:momentId success:^(BOOL success) {
            if (success) {
                [SYToastView showToast:@"关注成功"];
                if (attentionBlock) {
                    attentionBlock(YES);
                }
            } else {
                [SYToastView showToast:@"关注失败"];
                if (attentionBlock) {
                    attentionBlock(NO);
                }
            }
        }];
    }
}

// 进入直播间
- (void)SYDynamicViewClickEnterLivingRoom:(NSString *)roomId {
    if (self.dynamicType == SYDynamicType_Square || self.dynamicType == SYDynamicType_Concern) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickEnterLivingRoom:)]) {
            [self.delegate SYDynamicViewClickEnterLivingRoom:roomId];
        }
    }
}

// 打招呼
- (void)SYDynamicViewClickGreet:(UserProfileEntity *)userModel{
    if (self.dynamicType == SYDynamicType_Square || self.dynamicType == SYDynamicType_Concern) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickGreet:)]) {
            [self.delegate SYDynamicViewClickGreet:userModel];
        }
    }
}

#pragma mark - Loading

- (void)showLoadingView {
    [MBProgressHUD showHUDAddedTo:self animated:NO];
}

- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self animated:NO];
}

#pragma mark - BtnClick

- (void)handleConcernJumpBtn {
    if (self.scrollBlock) {
        self.scrollBlock();
    }
}

#pragma mark - Lazyload

- (UICollectionView *)dynamicListView {
    if (!_dynamicListView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _dynamicListView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _dynamicListView.delegate = self;
        _dynamicListView.dataSource = self;
        _dynamicListView.backgroundColor = RGBACOLOR(247,247,247,1);
        if (self.dynamicType == SYDynamicType_Homepage) {
            _dynamicListView.showsVerticalScrollIndicator = NO;
        }
        _dynamicListView.alwaysBounceVertical = YES;
        _dynamicListView.showsHorizontalScrollIndicator = NO;
        [_dynamicListView registerClass:[SYDynamicViewCell class] forCellWithReuseIdentifier:SYDynamicViewCellID];
        // footer
        __weak typeof(self) weakSelf = self;
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            NSInteger currentPage = [weakSelf.viewModel getCurrentPages];
            switch (weakSelf.dynamicType) {
                case SYDynamicType_Homepage: {
                    [weakSelf requestUserDynamicListData:self.userId page:(currentPage + 1)];
                }
                    break;
                case SYDynamicType_Square: {
                    [weakSelf requestSquareListData:weakSelf.userId page:(currentPage + 1)];
                }
                    break;
                case SYDynamicType_Concern: {
                    [weakSelf requestConcernListData:weakSelf.userId page:(currentPage + 1)];
                }
                    break;
                default:
                    break;
            }
        }];
        [footer setTitle:@"上拉加载更多数据~" forState:MJRefreshStateIdle];
        [footer setTitle:@"松开手试试~" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"已加载全部内容" forState:MJRefreshStateNoMoreData];
        _dynamicListView.mj_footer = footer;
        
        // header
        if (self.dynamicType == SYDynamicType_Square || self.dynamicType == SYDynamicType_Concern) {
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf requestFirstPageListData];
            }];
            _dynamicListView.mj_header = header;
        }
    }
    return _dynamicListView;
}

- (UIView *)homePageEmptyView {
    if (!_homePageEmptyView) {
        _homePageEmptyView = [UIView new];
        [_homePageEmptyView addSubview:self.homePageTipImageView];
        [_homePageEmptyView addSubview:self.homePageTipLabel];
        _homePageEmptyView.hidden = YES;
        _homePageEmptyView.userInteractionEnabled = NO;
    }
    return _homePageEmptyView;
}

- (UIImageView *)homePageTipImageView {
    if (!_homePageTipImageView) {
        _homePageTipImageView = [UIImageView new];
        _homePageTipImageView.image = [UIImage imageNamed_sy:@"homepage_dynamic_empty"];
        _homePageTipLabel.contentMode = UIViewContentModeScaleAspectFit;
        _homePageTipImageView.userInteractionEnabled = NO;
    }
    return _homePageTipImageView;
}

- (UILabel *)homePageTipLabel {
    if (!_homePageTipLabel) {
        _homePageTipLabel = [UILabel new];
        _homePageTipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _homePageTipLabel.textColor = RGBACOLOR(96,96,96,1);
        _homePageTipLabel.textAlignment = NSTextAlignmentLeft;
        _homePageTipLabel.text = @"快去发布你的第一个动态吧";
        _homePageTipLabel.userInteractionEnabled = NO;
    }
    return _homePageTipLabel;
}

- (UIView *)squareEmptyView {
    if (!_squareEmptyView) {
        _squareEmptyView = [UIView new];
        _squareEmptyView.hidden = YES;
        [_squareEmptyView addSubview:self.squareTipImageView];
        [_squareEmptyView addSubview:self.squareTipLabel];
        _squareEmptyView.userInteractionEnabled = NO;
    }
    return _squareEmptyView;
}

- (UIImageView *)squareTipImageView {
    if (!_squareTipImageView) {
        _squareTipImageView = [UIImageView new];
        _squareTipImageView.image = [UIImage imageNamed_sy:@"homepage_dynamic_empty"];
        _squareTipImageView.userInteractionEnabled = NO;
    }
    return _squareTipImageView;
}

- (UILabel *)squareTipLabel {
    if (!_squareTipLabel) {
        _squareTipLabel = [UILabel new];
        _squareTipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _squareTipLabel.textColor = RGBACOLOR(153,153,153,1);
        _squareTipLabel.textAlignment = NSTextAlignmentCenter;
        _squareTipLabel.text = @"暂无内容";
        _squareTipLabel.userInteractionEnabled = NO;
    }
    return _squareTipLabel;
}

- (UIView *)concernEmptyView {
    if (!_concernEmptyView) {
        _concernEmptyView = [UIView new];
        _concernEmptyView.hidden = YES;
        [_concernEmptyView addSubview:self.concernTipImageView];
        [_concernEmptyView addSubview:self.concernTipLabel];
        _concernEmptyView.userInteractionEnabled = NO;
    }
    return _concernEmptyView;
}

- (UIImageView *)concernTipImageView {
    if (!_concernTipImageView) {
        _concernTipImageView = [UIImageView new];
        _concernTipImageView.image = [UIImage imageNamed_sy:@"homepage_dynamic_attention_no_default"];
        _concernTipImageView.userInteractionEnabled = NO;
        _concernTipImageView.layer.cornerRadius = 55;
        _concernTipImageView.clipsToBounds = YES;
    }
    return _concernTipImageView;
}

- (UILabel *)concernTipLabel {
    if (!_concernTipLabel) {
        _concernTipLabel = [UILabel new];
        _concernTipLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _concernTipLabel.textColor = RGBACOLOR(153,153,153,1);
        _concernTipLabel.textAlignment = NSTextAlignmentCenter;
        _concernTipLabel.text = @"暂无内容，快去认识一些新朋友吧";
        _concernTipLabel.userInteractionEnabled = NO;
    }
    return _concernTipLabel;
}

- (UIButton *)concernJumpBtn {
    if (!_concernJumpBtn) {
        _concernJumpBtn = [UIButton new];
        _concernJumpBtn.layer.cornerRadius = 20;
        _concernJumpBtn.backgroundColor = RGBACOLOR(97,42,224,1);
        [_concernJumpBtn setTitle:@"为您推荐优质用户" forState:UIControlStateNormal];
        [_concernJumpBtn setTitleColor:RGBACOLOR(245,245,245,1) forState:UIControlStateNormal];
        _concernJumpBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_concernJumpBtn addTarget:self action:@selector(handleConcernJumpBtn) forControlEvents:UIControlEventTouchUpInside];
        _concernEmptyView.hidden = YES;
    }
    return _concernJumpBtn;
}

- (SYPersonHomepageDynamicViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYPersonHomepageDynamicViewModel new];
    }
    return _viewModel;
}

@end
