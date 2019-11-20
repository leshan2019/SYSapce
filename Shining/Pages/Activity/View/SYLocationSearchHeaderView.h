//
//  SYLocationSearchHeaderView.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYLocationSearchHeaderViewDelegate <NSObject>

- (void)locationSearchHeaderViewDidSearchKeyword:(NSString *)keyword;

@end

@interface SYLocationSearchHeaderView : UICollectionReusableView

@property (nonatomic, weak) id <SYLocationSearchHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
