//
//  SYCommentView.m
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCommentView.h"
#import "SYCommentViewModel.h"
#import "SYCommentCell.h"
#import "SYSendCommentToolView.h"
#import "SYDynamicDeleteView.h"


#define SYCommentCellId @"SYCommentCellId"

@interface SYCommentView ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UITextFieldDelegate>

@property (nonatomic, strong) UIButton *bgView;                 // 白色背景
@property (nonatomic, strong) UILabel *titleLabel;              // “全部评论”
@property (nonatomic, strong) UIView *horizonLine;              // 分割线
@property (nonatomic, strong) UICollectionView *listView;       // 评论列表
@property (nonatomic, strong) UILabel *emptyLabel;              // "暂无评论"
@property (nonatomic, strong) SYDynamicDeleteView *deleteWindow;    // 删除确认弹窗

// 输入框相关
@property (nonatomic, strong) UIButton *inputViewBg;            // 键盘输入背景
@property (nonatomic, strong) SYSendCommentToolView *inputBar; // 输入view

@property (nonatomic, strong) NSString *momentId;           // 动态id
@property (nonatomic, strong) NSString *myselfId;           // 谁要发送评论
@property (nonatomic, strong) SYCommentViewModel *viewModel;
@property (nonatomic, copy) UpdateCommentBlock updateBlock;

@end

@implementation SYCommentView

- (void)dealloc {
    [self removeKeyboardNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame momentId:(NSString *)momentId mySelfid:(NSString *)mySelfId block:(nonnull UpdateCommentBlock)updateBlock{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self addKeyboardNotifcations];
        self.momentId = momentId;
        self.myselfId = mySelfId;
        self.updateBlock = updateBlock;
        [self showLoadingView];
        [self requestCommentListData:momentId page:1];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - Request

// 请求评论列表
- (void)requestCommentListData:(NSString *)momentId page:(NSInteger)page {
    [self.viewModel requestDynamicCommentListData:momentId page:page success:^(BOOL success) {
        [self hideLoadingView];
        [self.listView.mj_footer endRefreshing];
        self.emptyLabel.hidden = YES;
        if (success) {
            self.listView.mj_footer.hidden = NO;
            [self.listView reloadData];
            if (page == 1) {
                [self.listView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
        } else {
            if (page == 1) {
                self.emptyLabel.hidden = NO;
                self.listView.mj_footer.hidden = YES;
            } else {
                [SYToastView showToast:@"暂无更多数据"];
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (self.updateBlock) {
            self.updateBlock([self.viewModel getTotalComments]);
        }
    } failure:^{
        [self hideLoadingView];
        [self.listView.mj_footer endRefreshing];
        if (page == 1) {
            self.emptyLabel.hidden = NO;
        }
        [SYToastView showToast:@"网络异常，请重试~"];
    }];
}

#pragma mark - Private

- (void)initSubViews {
    self.backgroundColor = RGBACOLOR(0,0,0,0.6);
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.horizonLine];
    [self.bgView addSubview:self.listView];
    [self.bgView addSubview:self.emptyLabel];
    // 键盘
    [self addSubview:self.inputViewBg];
    [self addSubview:self.inputBar];
    
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(420 + (iPhoneX ? 34 : 0));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(15);
        make.top.equalTo(self.bgView).with.offset(13);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(22);
    }];
    [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(20);
        make.top.equalTo(self.bgView).with.offset(48);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.center.equalTo(self.bgView);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).with.offset(iPhoneX ? -(64 + 34) : -64);
        make.top.equalTo(self.horizonLine.mas_bottom);
    }];
    [self.inputViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(iPhoneX ? -34 : 0);
        make.height.mas_equalTo(64);
    }];
}

// 收起键盘
- (void)hideKeyBoard {
    [self.inputBar packUpKeyboard];
}

// 发送评论
- (void)sendComment:(NSString *)commentStr {
    [self.inputBar packUpKeyboard];
    [self.viewModel requestValidText:commentStr success:^(BOOL result) {
        if (result) {
            [self.viewModel requestSendComment:self.momentId content:commentStr success:^(BOOL sendSuccess) {
                if (sendSuccess) {
                    [self requestCommentListData:self.momentId page:1];
                    [SYToastView showToast:@"发送成功"];
                } else {
                    [SYToastView showToast:@"发送失败"];
                }
            }];
        } else {
            [SYToastView showToast:@"发送内容包含敏感词，请重新输入~"];
        }
    }];
}

// 删除自己的评论
- (void)deleteMyselfComment:(NSString *)commentId {
    if (self.deleteWindow) {
        [self.deleteWindow removeFromSuperview];
        self.deleteWindow = nil;
    }
    __weak typeof(self) weakSelf = self;
    self.deleteWindow = [[SYDynamicDeleteView alloc] initWithFrame:self.bounds deleteBlock:^{
        [weakSelf.viewModel requestDeleteComment:commentId momentid:self.momentId success:^(BOOL deleteSuccess) {
            if (deleteSuccess) {
                [weakSelf.listView reloadData];
                [SYToastView showToast:@"删除成功"];
                if (weakSelf.updateBlock) {
                    weakSelf.updateBlock([weakSelf.viewModel getTotalComments]);
                }
                if ([weakSelf.viewModel getTotalComments] <= 0) {
                    weakSelf.emptyLabel.hidden = NO;
                    weakSelf.listView.mj_footer.hidden = YES;
                }
            } else {
                [SYToastView showToast:@"删除失败"];
            }
        }];
    } cancelBlock:^{
    }];
    [self addSubview:self.deleteWindow];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYCommentCellId forIndexPath:indexPath];
    NSString *avatar = [self.viewModel avatar:indexPath];;
    NSString *name = [self.viewModel name:indexPath];
    NSString *gender = [self.viewModel gender:indexPath];;
    NSInteger age = [self.viewModel age:indexPath];
    NSString *title = [self.viewModel title:indexPath];
    NSString *time = [self.viewModel time:indexPath];
    [cell configueSYCommentCell:avatar name:name gender:gender age:age content:title time:time];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *clickUserId = [self.viewModel userId:indexPath];
    if ([clickUserId isEqualToString:self.myselfId]) {
        [self deleteMyselfComment:[self.viewModel commentId:indexPath]];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [self.viewModel title:indexPath];
    CGFloat height = [SYCommentCell calculateSYCommentCellHeightWithTitleWidth:(self.sy_width - 51 - 20) content:content];
    return CGSizeMake(self.sy_width, height);
}

#pragma mark - UIKeyboardNotification

- (void)addKeyboardNotifcations {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.inputViewBg.hidden = NO;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-keyboardHeight);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.inputViewBg.hidden = YES;
    [self.inputBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(iPhoneX ? -34 : 0);
    }];
}

#pragma mark - Loading

- (void)showLoadingView {
    [MBProgressHUD showHUDAddedTo:self.bgView animated:NO];
}

- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self.bgView animated:NO];
}

#pragma mark - Lazyload

- (UIButton *)bgView {
    if (!_bgView) {
        _bgView = [UIButton new];
        _bgView.backgroundColor = RGBACOLOR(255,255,255,1);
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(48,48,48,1);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"全部评论";
    }
    return _titleLabel;
}

- (UIView *)horizonLine {
    if (!_horizonLine) {
        _horizonLine = [UIView new];
        _horizonLine.backgroundColor = RGBACOLOR(242,242,242,1);
    }
    return _horizonLine;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        [_listView registerClass:[SYCommentCell class] forCellWithReuseIdentifier:SYCommentCellId];
        _listView.backgroundColor = RGBACOLOR(255,255,255,1);
        
        __weak typeof(self) weakSelf = self;
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            NSInteger currentPage = [weakSelf.viewModel getCurrentPages];
            [weakSelf requestCommentListData:weakSelf.momentId page:(currentPage + 1)];
        }];
        [footer setTitle:@"上拉加载更多数据~" forState:MJRefreshStateIdle];
        [footer setTitle:@"松开手试试~" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"已经到底啦~" forState:MJRefreshStateNoMoreData];
        _listView.mj_footer = footer;
    }
    return _listView;
}

- (UILabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [UILabel new];
        _emptyLabel.textColor = RGBACOLOR(144,144,144,1);
        _emptyLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.text = @"暂无评论";
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}

- (SYCommentViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYCommentViewModel new];
    }
    return _viewModel;
}

- (UIButton *)inputViewBg {
    if (!_inputViewBg) {
        _inputViewBg = [UIButton new];
        _inputViewBg.backgroundColor = RGBACOLOR(0,0,0,0.6);
        _inputViewBg.hidden = YES;
        [_inputViewBg addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputViewBg;
}

- (SYSendCommentToolView *)inputBar {
    if (!_inputBar) {
        __weak typeof(self) weakSelf = self;
        _inputBar = [[SYSendCommentToolView alloc] initWithFrame:CGRectZero maxInputNum:150 sendBlock:^(NSString *text) {
            [weakSelf sendComment:text];
        }];
    }
    return _inputBar;
}

@end
