//
//  SYVideoRoomHomeView.h
//  Shining
//
//  Created by leeco on 2019/9/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCategoryProtocol.h"
@class SYRoomCategoryViewModel;
NS_ASSUME_NONNULL_BEGIN
@protocol SYRoomHomeViewDelegate <NSObject>
-(void)roomHomeView_clickFocusView:(UIViewController*)vc;
@end
@interface SYRoomHomeView : UIView
@property (nonatomic,weak)id<SYRoomHomeViewDelegate> delegate;
@property (nonatomic,assign)BOOL hasRequestedData;
@property (nonatomic,strong) SYRoomCategoryViewModel *categoryViewModel;
-(instancetype)initWithFrame:(CGRect)frame andCategoryType:(FirstCategoryType)type;
-(void)resetSubViewsFrame;
-(void)requestVideoHomeData;
-(void)willAppear;
-(void)setMainTableViewScrollEnable:(BOOL)canScroll;
@end

NS_ASSUME_NONNULL_END
