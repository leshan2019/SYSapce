//
//  SYVoiceRoomPropView.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomPropView.h"
#import "SYVoiceRoomPropViewModel.h"
#import "SYVoiceRoomPropCell.h"
#import "SYPickerView.h"
#import "SYOptionListView.h"
#import "SYCircleSegmentControl.h"
#import "SYChildProtectManager.h"

@interface SYVoiceRoomPropView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SYOptionListViewDelegate>

@property (nonatomic, strong) SYVoiceRoomPropViewModel *viewModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) SYCircleSegmentControl *actionButton;
@property (nonatomic, strong) UIButton *vipUseBtn;                  // 永久头像框或者坐骑专用
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectedPriceIndex;

@end

@implementation SYVoiceRoomPropView

- (instancetype)initWithFrame:(CGRect)frame
                     propType:(NSInteger)propType {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = -1;
        _selectedPriceIndex = -1;
        _viewModel = [[SYVoiceRoomPropViewModel alloc] initWithPropType:propType];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.toolBar];
        self.toolBar.hidden = YES;
        
        [self.toolBar addSubview:self.durationLabel];
        [self.toolBar addSubview:self.priceLabel];
        [self.toolBar addSubview:self.arrowView];
        [self.toolBar addSubview:self.actionButton];
        [self.toolBar addSubview:self.vipUseBtn];
        [self.toolBar addSubview:self.hintLabel];

    }
    return self;
}

- (void)requestData {
    [self.viewModel requestPropListWithSuccess:^(BOOL success) {
        if (success) {
            [self.collectionView reloadData];
            [self refreshToolbarDurationAndPriceWithPricelist:[self.viewModel propPriceListAtIndex:self.selectedIndex]
                                                   priceIndex:self.selectedPriceIndex];
            self.toolBar.hidden = YES;
            self.collectionView.contentInset = UIEdgeInsetsZero;
        }
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10.f;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SYVoiceRoomPropCell class]
            forCellWithReuseIdentifier:@"cell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        CGFloat height = 50.f;
        if (iPhoneX) {
            height += 34.f;
        }
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - height, self.sy_width, height)];
        _toolBar.backgroundColor = [UIColor sam_colorWithHex:@"#27262C"];
    }
    return _toolBar;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, 30, 17)];
        _durationLabel.font = [UIFont systemFontOfSize:12.f];
        _durationLabel.textAlignment = NSTextAlignmentRight;
        _durationLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_durationLabel addGestureRecognizer:tap];
    }
    return _durationLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.durationLabel.sy_right + 40.f, self.durationLabel.sy_top, 110, 17.f)];
        _priceLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _priceLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.durationLabel.sy_right + 6.f, 19.f, 14.f, 14.f)];
        _arrowView.image = [UIImage imageNamed_sy:@"voiceroom_prop_arrow"];
        _arrowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_arrowView addGestureRecognizer:tap];
    }
    return _arrowView;
}

- (SYCircleSegmentControl *)actionButton {
    if (!_actionButton) {
        __weak typeof(self) weakSelf = self;
        CGRect frame = CGRectMake(self.sy_width - 160 - 10, 6, 160, 38);
        _actionButton = [[SYCircleSegmentControl alloc] initSYCircleSegmentControl:frame withTitles:@[@"赠送",@"购买"] withClickBlock:^(NSInteger postion) {
//            if ([[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:nil]) {
//                return;
//            }
            if (postion == 0) {         // 赠送
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(propViewClickGiveGiftsBtn)]) {
                    [weakSelf.delegate propViewClickGiveGiftsBtn];
                }
            } else if (postion == 1) {  // 购买
                [weakSelf buttonAction];
            }
        }];
    }
    return _actionButton;
}

- (UIButton *)vipUseBtn {
    if (!_vipUseBtn) {
        CGRect frame = CGRectMake(self.sy_width - 80 - 10, 6, 80, 38);
        _vipUseBtn = [[UIButton alloc] initWithFrame:frame];
        [_vipUseBtn setTitle:@"使用" forState:UIControlStateNormal];
        _vipUseBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_vipUseBtn setTitleColor:RGBACOLOR(255,255,255,1) forState:UIControlStateNormal];
        _vipUseBtn.backgroundColor = RGBACOLOR(113,56,239,1);
        _vipUseBtn.clipsToBounds = YES;
        _vipUseBtn.layer.cornerRadius = 19;
        [_vipUseBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        _vipUseBtn.hidden = YES;
    }
    return _vipUseBtn;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 200, 17)];
        _hintLabel.font = [UIFont systemFontOfSize:12.f];
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.text = @"您尚未到达获取要求";
        _hintLabel.hidden = YES;
    }
    return _hintLabel;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel propCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomPropCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                          forIndexPath:indexPath];
    [cell showWithIcon:[self.viewModel propIconAtIndex:indexPath.item]];
    [self.viewModel checkIsMyPropsWithPropAtIndex:indexPath.item
                                            block:^(BOOL isMine, BOOL isUse, BOOL vip, NSString * _Nonnull expireTime) {
                                                if (isUse) {
                                                    [cell setIsInUseWithExpireTime:expireTime];
                                                } else if (isMine) {
                                                    [cell setIsMineWithExpireTime:expireTime];
                                                } else if (vip) {
                                                    NSInteger level = [self.viewModel propVipLevelAtIndex:indexPath.item];
                                                    [cell setVipLevel:level durationTime:expireTime];
                                                } else {
                                                    [cell setDefaultPrice:[self.viewModel propPriceAtIndex:indexPath.item]
                                                               durationTime:expireTime];
                                                }
                                            }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.sy_width - 40.f) / 3.f;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10.f, 0, 10.f);
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.item;
    self.toolBar.hidden = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, self.toolBar.sy_height, 0);
    if (self.viewModel.propType == 1) {
        if ([self.delegate respondsToSelector:@selector(propViewDidSelectAvatarBox:)]) {
            NSString *url = [self.viewModel propIconAtIndex:indexPath.item];
            [self.delegate propViewDidSelectAvatarBox:url];
        }
    }else if (self.viewModel.propType == 2) {
        if ([self.delegate respondsToSelector:@selector(propViewDidSlelectDriverBox:)]) {
            NSInteger propId = [self.viewModel propIdAtIndex:indexPath.item];
            [self.delegate propViewDidSlelectDriverBox:propId];
        }
    }
    [self drawToolBarWithIndex:indexPath.item];
}

#pragma mark -

- (void)drawToolBarWithIndex:(NSInteger)index {
    [self.viewModel checkIsMyPropsWithPropAtIndex:index
                                            block:^(BOOL isMine, BOOL isUse, BOOL vip, NSString * _Nonnull expireTime) {
                                                void (^hideShow)(BOOL showHint) = ^(BOOL showHint) {
                                                    self.hintLabel.hidden = !showHint;
                                                    self.actionButton.hidden = showHint;
                                                    self.priceLabel.hidden = showHint;
                                                    self.durationLabel.hidden = showHint;
                                                    self.vipUseBtn.hidden = YES;
                                                };
                                                if (isMine || isUse) {
                                                    hideShow(NO);
                                                    NSString *title = isUse ? @"取消" : @"使用";
                                                    [self.actionButton updateRightTitle:title];
                                                    if (vip) {
                                                        self.actionButton.hidden = YES;
                                                        self.vipUseBtn.hidden = NO;
                                                        [self.vipUseBtn setTitle:title forState:UIControlStateNormal];
                                                    }
                                                } else if (vip) {
                                                    hideShow(YES);
                                                } else {
                                                    hideShow(NO);
                                                    [self.actionButton updateRightTitle:@"购买"];
                                                }
                                                [self refreshToolbarDurationAndPriceWithPricelist:[self.viewModel propPriceListAtIndex:index]
                                                                                       priceIndex:0];
                                            }];
}

- (void)tap:(id)sender {
//    self.selectedPriceIndex ++;
//    if (self.selectedPriceIndex >= 3) {
//        self.selectedPriceIndex = 0;
//    }
//    [self refreshToolbarDurationAndPriceWithPricelist:[self.viewModel propPriceListAtIndex:self.selectedIndex]
//                                           priceIndex:self.selectedPriceIndex];
    
    NSArray *priceList = [self.viewModel propPriceListAtIndex:self.selectedIndex];
    NSMutableArray *options = [NSMutableArray new];
    for (SYPropPriceModel *price in priceList) {
        [options addObject:[NSString stringWithFormat:@"%ld天", price.duration]];
    }
    SYOptionListView *optionListView = [[SYOptionListView alloc] initWithOptions:options];
    optionListView.delegate = self;
    CGPoint point = CGPointMake(46.f, self.toolBar.sy_top);
    point = [self convertPoint:point toView:self.superview];
    [optionListView showInView:self.superview
                    arrowPoint:point];
}

- (void)refreshToolbarDurationAndPriceWithPricelist:(NSArray *)priceList
                                         priceIndex:(NSInteger)priceIndex {
    self.selectedPriceIndex = priceIndex;
    if (priceIndex >= 0 && priceIndex < [priceList count]) {
        self.priceLabel.hidden = NO;
        self.durationLabel.hidden = NO;
        self.arrowView.hidden = NO;
        SYPropPriceModel *price = [priceList objectAtIndex:priceIndex];
        self.durationLabel.text = [NSString stringWithFormat:@"%ld天", price.duration];
        self.priceLabel.text = [NSString stringWithFormat:@"总价：%ld蜜豆", price.price];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.durationLabel.text];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor whiteColor]
                       range:NSMakeRange(0, self.durationLabel.text.length)];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor sam_colorWithHex:@"#E42112"]
                       range:[self.durationLabel.text rangeOfString:[NSString stringWithFormat:@"%ld", price.duration]]];
        self.durationLabel.attributedText = string;
        
        string = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor whiteColor]
                       range:NSMakeRange(0, self.priceLabel.text.length)];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor sam_colorWithHex:@"#E42112"]
                       range:[self.priceLabel.text rangeOfString:[NSString stringWithFormat:@"%ld", price.price]]];
        self.priceLabel.attributedText = string;
    } else {
        self.priceLabel.hidden = YES;
        self.durationLabel.hidden = YES;
        self.arrowView.hidden = YES;
    }
}

- (void)buttonAction {
    if (self.selectedIndex < 0) {
        return;
    }
    [self.viewModel checkIsMyPropsWithPropAtIndex:self.selectedIndex
                                             block:^(BOOL isMine, BOOL isUse, BOOL vip, NSString * _Nonnull expireTime) {
                                                 if (isUse) {
                                                     // 取消使用，暂时没有
                                                     [self.viewModel requestCancelPropWithSuccess:^(BOOL success) {
                                                         if (success) {
                                                             [SYToastView showToast:@"取消成功"];
                                                             [self requestData];
                                                         } else {
                                                             [SYToastView showToast:@"取消失败"];
                                                         }
                                                     }];
                                                 } else if (isMine) {
                                                     // 使用
                                                     [self.viewModel requestUsePropAtIndex:self.selectedIndex
                                                                                   success:^(BOOL success) {
                                                                                       if (success) {
                                                                                           [SYToastView showToast:@"使用成功"];
                                                                                           [self requestData];
                                                                                       } else {
                                                                                           [SYToastView showToast:@"使用失败"];
                                                                                       }
                                                                                   }];
                                                 } else {
                                                     [self.viewModel requestPurchasePropAtIndex:self.selectedIndex
                                                                                     priceIndex:self.selectedPriceIndex
                                                                                        success:^(BOOL success, NSInteger errorCode) {
                                                                                            if (success) {
                                                                                                [SYToastView showToast:@"购买成功"];
                                                                                                [self requestData];
                                                                                            } else {
                                                                                                if (errorCode == 4003) {
                                                                                                    if ([self.delegate respondsToSelector:@selector(propViewDidLackOfBalance)]) {
                                                                                                        [self.delegate propViewDidLackOfBalance];
                                                                                                    }
                                                                                                } else {
                                                                                                    [SYToastView showToast:@"购买失败"];
                                                                                                }
                                                                                            }
                                                                                        }];
                                                 }
                                             }];
}

#pragma mark - 赠送礼物接口

- (void)buyGiftForFriend:(NSString *)userId success:(BuyGiftForFriendBlock)block {
    [self.viewModel requestPurchaseGiftToFriend:userId atIndex:self.selectedIndex priceIndex:self.selectedPriceIndex success:^(BOOL success, NSInteger errorCode) {
        if (success && [self.viewModel isUserSelf:userId]) {
            [self requestData];
        }
        if (block) {
            block(success, errorCode);
        }
    }];
}

#pragma mark -

- (void)optionListViewDidChooseOptionAtIndex:(NSInteger)index
                                      option:(NSString *)option {
    [self refreshToolbarDurationAndPriceWithPricelist:[self.viewModel propPriceListAtIndex:self.selectedIndex]
                                           priceIndex:index];
}

@end
