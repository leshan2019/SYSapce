//
//  SYPersonHomepageVoiceCardShowView.h
//  Shining
//
//  Created by leeco on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYMyVoiceCardSoundModel;
NS_ASSUME_NONNULL_BEGIN
@protocol SYPersonHomepageVoiceCardShowViewDelegate <NSObject>
- (void)showView_retryRecode;

@end
@interface SYPersonHomepageVoiceCardShowView : UIView
@property (nonatomic, weak) id <SYPersonHomepageVoiceCardShowViewDelegate> delegate;
-(void)resetViewState:(BOOL)hidden andHideRecodeBtn:(BOOL)buttonHidden;
-(void)resetViewInfos:(SYMyVoiceCardSoundModel*)info;
@end

@interface SYVoiceCardUserHeaderView : UIView
-(void)setHeader:(NSString*)headerUrl andName:(NSString*)name;
@end
NS_ASSUME_NONNULL_END
