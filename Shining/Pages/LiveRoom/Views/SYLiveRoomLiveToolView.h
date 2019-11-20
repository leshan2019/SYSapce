//
//  SYLiveRoomLiveToolView.h
//  Shining
//
//  Created by leeco on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SYLiveRoomLiveToolViewActionType) {
    SYLiveRoomLiveToolViewActionType_rollback,
    SYLiveRoomLiveToolViewActionType_clear,
    SYLiveRoomLiveToolViewActionType_mirror,
    SYLiveRoomLiveToolViewActionType_biggerFont,
    SYLiveRoomLiveToolViewActionType_beauty,
    SYLiveRoomLiveToolViewActionType_roomInfo,
    SYLiveRoomLiveToolViewActionType_privateMsg,
    SYLiveRoomLiveToolViewActionType_closeAnimation,
    SYLiveRoomLiveToolViewActionType_redpackage,
    SYLiveRoomLiveToolViewActionType_hide
};
NS_ASSUME_NONNULL_BEGIN
@protocol SYLiveRoomLiveToolViewDelegate <NSObject>
- (void)liveRoomToolView_clickBtn:(SYLiveRoomLiveToolViewActionType)type other:(id)object;
- (void)liveRoomToolView_userCancel;
@end
@interface SYLiveRoomLiveToolView : UIView
- (instancetype)initWithFrame:(CGRect)frame mirroOpen:(BOOL)isOpen;
- (instancetype)initWithFrame:(CGRect)frame isHost:(BOOL)isHost;
@property (nonatomic, weak) id <SYLiveRoomLiveToolViewDelegate> _Nullable delegate;
@property (nonatomic, assign)BOOL mirrorOpen;
@property (nonatomic, assign)BOOL animationClose;
@property (nonatomic, assign)BOOL chartHide;

/// 更新主播状态
/// @param isHost 是否为主播
- (void)updateHostState:(BOOL)isHost;
- (void)showToast:(NSString *)toast;
@end

NS_ASSUME_NONNULL_END
NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomLiveToolHeader : UICollectionReusableView
@property (nonatomic,strong)UILabel *headerTitleLabel;
@end

NS_ASSUME_NONNULL_END
