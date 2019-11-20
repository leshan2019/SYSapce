//
//  SYOptionListView.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYOptionListViewDelegate <NSObject>

- (void)optionListViewDidChooseOptionAtIndex:(NSInteger)index
                                      option:(NSString *)option;

@end

@interface SYOptionListView : UIView

@property (nonatomic, weak) id <SYOptionListViewDelegate> delegate;

- (instancetype)initWithOptions:(NSArray <NSString *>*)options;

- (void)showInView:(UIView *)view
        arrowPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
