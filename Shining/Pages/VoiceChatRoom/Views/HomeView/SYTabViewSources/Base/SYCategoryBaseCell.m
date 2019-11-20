//
//  SYCategoryBaseCell.m
//  UI系列测试
//
//  Created by jiaxin on 2018/3/15.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "SYCategoryBaseCell.h"

@interface SYCategoryBaseCell ()
@property (nonatomic, strong) SYCategoryBaseCellModel *cellModel;
@property (nonatomic, strong) SYCategoryViewAnimator *animator;
@property (nonatomic, strong) NSMutableArray <SYCategoryCellSelectedAnimationBlock> *animationBlockArray;
@end

@implementation SYCategoryBaseCell

- (void)dealloc
{
    [self.animator stop];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    [self.animator stop];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    _animationBlockArray = [NSMutableArray array];
}

- (void)reloadData:(SYCategoryBaseCellModel *)cellModel {
    self.cellModel = cellModel;

    if (cellModel.isSelectedAnimationEnabled) {
        [self.animationBlockArray removeLastObject];
        if ([self checkCanStartSelectedAnimation:cellModel]) {
            _animator = [[SYCategoryViewAnimator alloc] init];
            self.animator.duration = cellModel.selectedAnimationDuration;
        }else {
            [self.animator stop];
        }
    }
}

- (BOOL)checkCanStartSelectedAnimation:(SYCategoryBaseCellModel *)cellModel {
    if (cellModel.selectedType == SYCategoryCellSelectedTypeCode || cellModel.selectedType == SYCategoryCellSelectedTypeClick) {
        return YES;
    }
    return NO;
}

- (void)addSelectedAnimationBlock:(SYCategoryCellSelectedAnimationBlock)block {
    [self.animationBlockArray addObject:block];
}

- (void)startSelectedAnimationIfNeeded:(SYCategoryBaseCellModel *)cellModel {
    if (cellModel.isSelectedAnimationEnabled && [self checkCanStartSelectedAnimation:cellModel]) {
        //需要更新isTransitionAnimating，用于处理在过滤时，禁止响应点击，避免界面异常。
        cellModel.transitionAnimating = YES;
        __weak typeof(self)weakSelf = self;
        self.animator.progressCallback = ^(CGFloat percent) {
            for (SYCategoryCellSelectedAnimationBlock block in weakSelf.animationBlockArray) {
                block(percent);
            }
        };
        self.animator.completeCallback = ^{
            cellModel.transitionAnimating = NO;
            [weakSelf.animationBlockArray removeAllObjects];
        };
        [self.animator start];
    }
}

@end
