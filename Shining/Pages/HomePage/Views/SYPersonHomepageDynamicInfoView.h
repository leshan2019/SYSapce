//
//  SYPersonHomepageDynamicInfoView.h
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYDynamicViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYPersonHomepageDynamicInfoViewDelegate <NSObject>

- (void)changeDynamicInfoViewScrollViewContentOffset:(CGFloat)x;

@end

/**
 * 个人主页 - 动态+资料
*/
@interface SYPersonHomepageDynamicInfoView : UIView

- (instancetype)initWithFrame:(CGRect)frame userId:(NSString *)userId;

@property (nonatomic, weak) id <SYDynamicViewProtocol> delegate;

@property (nonatomic, weak) id <SYPersonHomepageDynamicInfoViewDelegate> scrollDelegate;

// 请求动态列表数据
- (void)requestDynamicListData;

// 更新资料
- (void)updateInfoView:(NSString *)userId
            coordinate:(NSString *)coordinate
         constellation:(NSString *)constellation;

- (UIScrollView*)getDynammicScrollView;
- (void)setDynamicViewScrollDelegate:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
