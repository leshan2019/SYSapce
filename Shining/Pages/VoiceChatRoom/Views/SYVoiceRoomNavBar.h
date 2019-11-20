//
//  SYVoiceRoomNavBar.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomNavBarDelegate <NSObject>

@optional
- (void)voiceRoomBarDidTapBack;
- (void)voiceRoomBarDidTapMore;

@end

@interface SYVoiceRoomNavBar : UIView

@property (nonatomic, weak) id <SYVoiceRoomNavBarDelegate> delegate;

- (void)setTitleView:(UIView *)titleView;
- (void)setTitle:(NSString *)title;
- (void)setMoreButtonHidden:(BOOL)hidden;
- (void)setRightBarButton:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
