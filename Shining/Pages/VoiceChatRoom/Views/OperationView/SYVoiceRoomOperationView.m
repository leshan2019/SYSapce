//
//  SYVoiceRoomOperationView.m
//  Shining
//
//  Created by 杨玄 on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomOperationView.h"

@interface SYVoiceRoomOperationView ()

@property (nonatomic, copy) operationClick clickBlock;

@end

@implementation SYVoiceRoomOperationView

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(operationClick)clickBlock {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.clickBlock = clickBlock;
    return self;
}

#pragma mark - Public

- (void)updateOperationDatas:(NSArray *)datas {
    [self removeAllSubviews];
    if (!datas || datas.count == 0) {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    CGFloat spaceY = 20;
    NSArray *subArr;
    CGFloat operationItemViewHeight;
    CGRect itemFrame = CGRectZero;
    CGRect beforeFrame = CGRectZero;
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < datas.count; i++) {
        subArr = [datas objectAtIndex:i];
        if (subArr.count <= 1) {
            operationItemViewHeight = 46;
        } else {
            operationItemViewHeight = 46 + 4 + 5;
        }
        if (i == 0) {
            itemFrame = CGRectMake(self.sy_width - 46, self.sy_height - operationItemViewHeight, 46, operationItemViewHeight);
        } else {
            itemFrame = CGRectMake(self.sy_width - 46, CGRectGetMinY(beforeFrame) - spaceY - operationItemViewHeight, 46, operationItemViewHeight);
        }
        SYVoicRoomOperationItemView *itemView = [[SYVoicRoomOperationItemView alloc] initWithFrame:itemFrame withItems:subArr withClickBlock:^(SYVoiceRoomOperationViewModel * _Nullable model) {
            if (model && weakSelf.clickBlock) {
                weakSelf.clickBlock(model);
            }
        }];
        beforeFrame = itemFrame;
        [self addSubview:itemView];
    }
}

#pragma mark - Private

- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
