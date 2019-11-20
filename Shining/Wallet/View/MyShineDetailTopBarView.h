//
//  MyShineDetailTopBarView.h
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyShineDetailTopBarViewDelegate <NSObject>

@required
- (void)handleConversationControlLeftClickEvent;
- (void)handleConversationControlRightClickEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MyShineDetailTopBarView : UIView

@property (nonatomic, weak) id<MyShineDetailTopBarViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedControl;

@end

NS_ASSUME_NONNULL_END
