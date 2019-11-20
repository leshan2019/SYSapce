//
//  SYinGamebeeViewController.h
//  DemobeeOC
//
//  Created by leeco on 2019/8/14.
//  Copyright © 2019 JiangYue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYGameBeeDelegate <NSObject>
/**
 * 完成游戏
 */
- (void)completeGameBee;
/**
 * 弹出登录
 */
- (void)popGameBeeLogin;

- (void)gameBeeDidGetGiftWithName:(NSString *)giftName
                            price:(NSInteger)price
                           giftId:(NSInteger)giftId
                         giftIcon:(NSString *)giftIcon
                         gameName:(NSString *)gameName;

@end

@interface SYGameBeeViewController: UIViewController

@property (nonatomic, strong, readwrite) NSString *channelID;

@property (nonatomic, weak, readwrite) UIViewController *vc;
@property (nonatomic, weak) id <SYGameBeeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
