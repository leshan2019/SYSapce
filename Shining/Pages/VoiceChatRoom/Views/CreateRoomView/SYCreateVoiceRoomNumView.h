//
//  SYCreateVoiceRoomNumView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYCreateVoiceRoomNumViewDelegate <NSObject>

- (void)createVoiceRoomNumViewDidSelectNumButton;

@end

@interface SYCreateVoiceRoomNumView : UIView

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) id <SYCreateVoiceRoomNumViewDelegate> delegate;

@property (nonatomic, assign) NSInteger micConfigIndex;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
