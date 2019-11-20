//
//  SYShareView.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SYShareViewTypeWeixinSession,
    SYShareViewTypeWeixinTimeline,
} SYShareViewType;

@protocol SYShareViewDelegate <NSObject>

- (void)shareViewDidSelectShareType:(SYShareViewType)type;

@end

@interface SYShareView : UIView

@property (nonatomic, weak) id <SYShareViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
