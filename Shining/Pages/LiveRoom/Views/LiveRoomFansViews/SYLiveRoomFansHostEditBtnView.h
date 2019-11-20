//
//  SYLiveRoomFansHostEditBtnView.h
//  Shining
//
//  Created by leeco on 2019/11/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LiveRoomFansHostEditBtnDelegate <NSObject>

-(void)liveRoomFansHostEditBtn_clickBlankView;
-(void)liveRoomFansHostEditBtn_clickSureBtn;
@end
@interface SYLiveRoomFansHostEditBtnView : UIView
@property(nonatomic,weak)id<LiveRoomFansHostEditBtnDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
