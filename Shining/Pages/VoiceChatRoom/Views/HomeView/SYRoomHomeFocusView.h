//
//  SYVoiceRoomHomeFocusView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomHomeFocusViewDelegate <NSObject>

- (NSInteger)homeFocusImageCount;
- (NSString *)homeFocusImageURLAtIndex:(NSInteger)index;

- (void)homeFocusDidTapImageAtIndex:(NSInteger)index;
- (void)homeFocusDidShowImageAtIndex:(NSInteger)index;
- (void)homeFocusResetFrame;
@end

@interface SYRoomHomeFocusView : UIView

@property (nonatomic, weak) id <SYVoiceRoomHomeFocusViewDelegate> delegate;

- (void)reloadData;
- (void)resetSpec:(CGFloat)newSpec;
@end

NS_ASSUME_NONNULL_END
