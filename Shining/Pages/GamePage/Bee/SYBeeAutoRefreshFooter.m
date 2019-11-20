//
//  SYBeeAutoRefreshFooter.m
//  Shining
//
//  Created by leeco on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYBeeAutoRefreshFooter.h"

@interface SYBeeAutoRefreshFooter()
@property (weak, nonatomic) UILabel *label;
@end

@implementation SYBeeAutoRefreshFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 40;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:194.0f/255.0f green:167.0f/255.0f blue:255.0f/255.0f alpha:1];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载更多";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载数据中";
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"没有更多";
            break;
        default:
            break;
    }
}

@end
