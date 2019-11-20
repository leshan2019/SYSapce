//
//  SYLocationSearchVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLocationSearchVC.h"
#import "SYLocationSearchViewModel.h"
#import "SYActivityLocationCell.h"
#import "SYLocationSearchHeaderView.h"

@interface SYLocationSearchVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SYLocationSearchHeaderViewDelegate>

@property (nonatomic, strong) SYLocationSearchViewModel *viewModel;
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *keyword;

@end

@implementation SYLocationSearchVC

- (instancetype)initWithLocation:(CGPoint)location {
    self = [super init];
    if (self) {
        _location = location;
        _viewModel = [SYLocationSearchViewModel new];
        _currentPage = 1;
        __weak typeof(self) weakSelf = self;
        _viewModel.doRequireLocationAuth = ^(BOOL success) {
            //  1.实例化UIAlertController对象
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开定位开关"
                                                                           message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务"
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            //  2.1实例化UIAlertAction按钮:取消按钮
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     // 点击取消按钮，调用此block
                                                                     NSLog(@"取消按钮被按下！");
                                                                 }];
            [alert addAction:cancelAction];

            //  2.2实例化UIAlertAction按钮:确定按钮
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"立即开启"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                  }];
            [alert addAction:defaultAction];

            //  3.显示alertController
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地点";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.leftBarButtonItem = left;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    void (^block)(void) = ^{
        [weakSelf.viewModel requestPlacesWithLocation:weakSelf.location
                                             page:weakSelf.currentPage
                                     successBlock:^(BOOL success) {
            if (success) {
                [weakSelf.collectionView reloadData];
            }
        }];
    };
    if (CGPointEqualToPoint(CGPointZero, self.location)) {
        [MBProgressHUD showHUDAddedTo:self.view
        animated:NO];
        [self.viewModel requestCurrentLocationWithSuccessBlock:^(BOOL success, CGPoint location) {
            weakSelf.location = location;
            if (CGPointEqualToPoint(CGPointZero, location)) {
                [SYToastView showToast:@"定位错误"];
            } else {
                block();
            }
            [MBProgressHUD hideHUDForView:self.view
            animated:NO];
        }];
    } else {
        block();
    }
}

#pragma mark -

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.view.sy_width, 48.f);
        layout.minimumInteritemSpacing = 0.f;
        layout.minimumLineSpacing = 0.f;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SYActivityLocationCell class]
            forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[SYLocationSearchHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"header"];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor sam_colorWithHex:@"#909090"]
                            forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_cancelButton addTarget:self
                          action:@selector(cancel:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel locationCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYActivityLocationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                             forIndexPath:indexPath];
    SYLocationViewModel *model = [self.viewModel locationViewModelAtIndex:indexPath.item];
    [cell showWithName:model.name
               address:model.address];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYLocationViewModel *model = [self.viewModel locationViewModelAtIndex:indexPath.item];
    if ([self.delegate respondsToSelector:@selector(locationSearchVCDidChooseLocation:)]) {
        [self.delegate locationSearchVCDidChooseLocation:model];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SYLocationSearchHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"header" forIndexPath:indexPath];
    header.delegate = self;
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.sy_width, 90);
}

- (void)locationSearchHeaderViewDidSearchKeyword:(NSString *)keyword {
    if (![keyword isEqualToString:self.keyword]) {
        self.currentPage = 1;
        self.keyword = keyword;
        __weak typeof(self) weakSelf = self;
        [self.viewModel requestAroundPlacesWithKeyword:keyword
                                                  page:self.currentPage
                                          successBlock:^(BOOL success) {
            if (success) {
                [weakSelf.collectionView reloadData];
            }
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + scrollView.sy_height >= scrollView.contentSize.height) {
        if (![SYNetworkReachability isNetworkReachable]) {
            return;
        }
        if (!self.viewModel.isLoading) {
            [MBProgressHUD showHUDAddedTo:self.view
                                 animated:NO];
            self.currentPage ++;
            __weak typeof(self) weakSelf = self;
            if (self.keyword) {
                [self.viewModel requestAroundPlacesWithKeyword:self.keyword
                                                          page:self.currentPage
                                                  successBlock:^(BOOL success) {
                    if (success) {
                        [weakSelf.collectionView reloadData];
                    }
                    [MBProgressHUD hideHUDForView:self.view
                                         animated:NO];
                }];
            } else {
                [self.viewModel requestPlacesWithLocation:self.location
                                                     page:self.currentPage
                                             successBlock:^(BOOL success) {
                    if (success) {
                        [weakSelf.collectionView reloadData];
                    }
                    [MBProgressHUD hideHUDForView:self.view
                                         animated:NO];
                }];
            }
        }
    }
}


@end
