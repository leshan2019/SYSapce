//
//  SYLiveRoomFinishView.h
//  Shining
//
//  Created by leeco on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SYSexType) {
    SYSexType_Unknown,
    SYSexType_male,
    SYSexType_female                       
};
@protocol SYLiveRoomFinishViewDelegate <NSObject>
- (void)liveRoomFinishView_clickInfoBtn;
- (void)liveRoomFinishView_clickAddAttentionBtn;
- (void)liveRoomFinishView_clickBackBtn;
@end
@interface SYLiveRoomFinishView : UIView
@property (nonatomic, weak) id <SYLiveRoomFinishViewDelegate> _Nullable delegate;
@property (nonatomic,assign,readonly)BOOL isFollowing;

-(void)setUserInfoAvatar:(NSString*_Nullable)avatarUrl
                userName:(NSString*_Nullable)userName
               userLevel:(NSInteger)userLevel
               hostLevel:(NSInteger)hostLevel
                 userAge:(NSInteger)userAge
                 userSex:(SYSexType)sex
              isFollowed:(BOOL)isFollowed;

- (void)setFollowState:(BOOL)isFollowing;



@end

