//
//  SYVideoRoomConfigView.h
//  Shining
//
//  Created by Zhang Qigang on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYVideoRoomConfigDelegate <NSObject>
@optional
- (void) closeButtonClicked;
- (void) beautifyButtonClicked;
- (void) startShowButtonClicked;
- (void) roomConfigButtonClicked;
- (void) roomTitleChanged: (NSString*) title;
@end


@interface SYVideoRoomConfigView : UIView
@property (nonatomic, weak) id<SYVideoRoomConfigDelegate> delegate;
@property (nonatomic, copy) NSString* title;
@end

NS_ASSUME_NONNULL_END
