//
//  SYPersonHomepageVoiceCardAllocView.h
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    SYVoiceCardAllocViewStatus_prepare,
    SYVoiceCardAllocViewStatus_success = 1,
    SYVoiceCardAllocViewStatus_failed = 2,
} SYVoiceCardAllocViewStatus;
NS_ASSUME_NONNULL_BEGIN
@protocol SYPersonHomepageVoiceCardAllocViewDelegate <NSObject>
- (void)allocView_refreshWord;
- (void)allocView_clickCategory:(NSString*)str;
- (void)allocView_clickFinish;
- (void)allocView_leadUserToOpenRecordPermission;
- (void)allocView_voiceViewDeleteLocalVoice:(NSString *)localVoiceUrl;
- (void)allocView_voiceViewSaveLocalVoice:(NSString *)localVoiceUrl voiceDuration:(NSInteger)duration;
@end
@interface SYPersonHomepageVoiceCardAllocView : UIView
-(void)resetAllocView_WordInfo:(NSString*)string;
-(void)resetAllocView_categoryInfo:(NSArray*)array;
-(void)resetAllocView_recodeControl;
-(void)resetAllocView_showLoadingView;
-(void)resetAllocView_hideLoadingView;
-(void)resetAllocView_showFailView;
-(void)resetAllocView_hideFailView;
-(void)resetAllocView_showSuccessView:(id)result;
-(void)resetViewState:(BOOL)hidden;
-(void)resetAllocViewWithStatus:(SYVoiceCardAllocViewStatus)status;
@property (nonatomic, weak) id <SYPersonHomepageVoiceCardAllocViewDelegate> delegate;
@end

@interface SYVoiceCardCategoryCell : UICollectionViewCell
+ (CGSize)cellSizeWithWordWidth:(CGFloat)width;
- (void)showWithTitle:(NSString *)title;
@end
@interface SYAnalyzeResultVeiw : UIView
-(void)setResultInfo:(NSDictionary*)dic;
@end
NS_ASSUME_NONNULL_END
