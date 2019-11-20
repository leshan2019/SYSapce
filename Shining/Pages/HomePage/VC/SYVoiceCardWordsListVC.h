//
//  SYVoiceCardWordsListVC.h
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYVoiceCardWordModel;
NS_ASSUME_NONNULL_BEGIN
@protocol SYVoiceCardWordsListVCDelegate <NSObject>
-(void)wordsListVC_selectNewWord:(SYVoiceCardWordModel*)model;


@end
@interface SYVoiceCardWordsListVC : UIViewController
@property(nonatomic,weak)id<SYVoiceCardWordsListVCDelegate>delegate;
- (instancetype)initWithState:(NSDictionary* )dic;
@end
@interface SYVoiceCardWordsListCell : UITableViewCell
-(void)setTitle:(NSString*)title;
@end
NS_ASSUME_NONNULL_END
