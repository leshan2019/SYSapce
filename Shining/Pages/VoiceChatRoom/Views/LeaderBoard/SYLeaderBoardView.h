//
//  SYLeaderBoardView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYLeaderBoardViewTypeIncome,
    SYLeaderBoardViewTypeOutcome,
} SYLeaderBoardViewType;

@protocol SYLeaderBoardViewDelegate <NSObject>

- (void)leaderBoardViewDidSelectUserWithUid:(NSString *_Nonnull)uid;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYLeaderBoardView : UIView

@property (nonatomic, weak) id <SYLeaderBoardViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                    channelID:(NSString *)channelID
                         type:(SYLeaderBoardViewType)type;

@end

NS_ASSUME_NONNULL_END
