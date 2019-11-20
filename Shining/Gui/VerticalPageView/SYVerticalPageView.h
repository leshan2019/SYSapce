//
//  SYVerticalPageView.h
//  ShiningBed
//
//  Created by Zhang Qigang on 2019/11/11.
//  Copyright © 2019 Zhang Qigang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYVerticalPageView;

@protocol SYVerticalPageViewDelegate <NSObject>
// 有多少页
- (NSUInteger) numberOfPagesInPageView: (SYVerticalPageView*) view;

// 将要显示和隐藏
- (void) verticalPageView: (SYVerticalPageView*) view willDisplayPage: (UIView*) page atIndex: (NSInteger) index;
- (void) verticalPageView: (SYVerticalPageView*) view didDisplayPage: (UIView*) page atIndex: (NSInteger) index;
// 将要隐藏和隐藏
- (void) verticalPageView: (SYVerticalPageView*) view willEndDisplayPage: (UIView*) page atIndex: (NSInteger) index;
- (void) verticalPageView: (SYVerticalPageView*)view didEndDisplayPage: (UIView*) page atIndex:(NSInteger)index;
// 创建 Page
- (UIView*) verticalPageView: (SYVerticalPageView*) view pageAtIndex: (NSInteger) index;

// 开始拖动
- (void) verticalPageViewWillBeginDragging: (SYVerticalPageView*) view;
// 结束拖动
- (void) verticalPageViewDidEndDragging: (SYVerticalPageView*) view;
@end

@interface SYVerticalPageView : UIView
@property (nonatomic, weak) id<SYVerticalPageViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

- (void) registerClass: (Class) pageClass;
- (UIView*) dequeueReusablePage;

- (instancetype) initWithFrame: (CGRect) frame;
- (void) reloadData; // reloadData 的时候不能设置
// 设置当前页, 不知道好使不好使 :(
- (void) setCurrentPageIndex: (NSInteger) index animated: (BOOL) animated; // 拖动的时候不能设置??
@end

NS_ASSUME_NONNULL_END
