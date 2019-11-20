//
//  SYLiveBigMessageListPopView.h
//  Shining
//
//  Created by mengxiangjian on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYLiveBigTextMessageListView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYLiveBigMessageListPopViewDelegate <NSObject>

- (void)messageListPopViewDidClose;

@end

@interface SYLiveBigMessageListPopView : UIView

@property (nonatomic, weak) id <SYVoiceTextMessageListViewDelegate> actionDelegate;
@property (nonatomic, weak) id <SYLiveBigMessageListPopViewDelegate> delegate;
@property (nonatomic, weak) id <SYVoiceTextMessageListViewDataSource> dataSource;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
