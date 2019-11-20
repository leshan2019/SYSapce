//
//  SYVoiceRoomExpressionView.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomExpressionViewDelegate <NSObject>

- (void)voiceRoomExpressionViewDidSelectExpressionWithId:(NSInteger)expressionId;

@end

@interface SYVoiceRoomExpressionView : UIView

@property (nonatomic, weak) id <SYVoiceRoomExpressionViewDelegate> delegate;

- (void)loadExpressions;

@end

NS_ASSUME_NONNULL_END
