//
//  SYOverScreenStripView.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/8.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYOverScreenStripViewTypeAllRooms,
    SYOverScreenStripViewTypeInteral,
    SYOverScreenStripViewTypeGameWin, // 游戏获胜飘屏
    SYOverScreenStripViewTypeBeeGameWin, // 采蜜获胜飘屏
    SYOverScreenStripViewTypeSendGroupRedpacket
} SYOverScreenStripViewType;

NS_ASSUME_NONNULL_BEGIN

@protocol SYOverScreenStripViewDelegate <NSObject>

- (void)overScreenStripViewAnimationDidFinish;
- (void)overScreenStripViewOpenChatRoomWithRoomId:(NSString *)roomId;

@end

@interface SYOverScreenStripView : UIView

@property (nonatomic, weak) id <SYOverScreenStripViewDelegate> delegate;

- (void)showWithGiftImageURL:(NSString *)imageURL
                    giftName:(NSString *)giftName
                      sender:(NSString *)sender
                    receiver:(NSString *)receiver
                       price:(NSInteger)price
                      roomId:(NSString *)roomId
                    gameName:(NSString *)gameName
                        type:(SYOverScreenStripViewType)type;

@end

NS_ASSUME_NONNULL_END
