//
//  SYMineLevelUserInfoView.h
//  Shining
//
//  Created by 杨玄 on 2019/6/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMineLevelUserInfoView : UIView

- (void)updateUserInfoWithName:(NSString *)name
                     avatarUrl:(NSString *)avatarUrl
                  currentLevel:(NSInteger)level
                     nextLevel:(NSInteger)nextLevel
                  consumeHoney:(NSInteger)consumeHoney
           currentLevelMinCoin:(NSInteger)minCoin
           currentLevelMaxCoin:(NSInteger)maxCoin;
@end

NS_ASSUME_NONNULL_END
