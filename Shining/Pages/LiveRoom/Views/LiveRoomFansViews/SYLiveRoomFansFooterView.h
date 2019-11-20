//
//  SYLiveRoomFansFooterView.h
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LiveRoomFansFooterViewDelegate <NSObject>

-(void)liveRoomFansFooterView_openFansRights:(NSString*)priceType;
@end
@interface SYLiveRoomFansFooterView : UIView
@property(nonatomic,weak)id<LiveRoomFansFooterViewDelegate> delegate;
-(void)resetFooterInfo:(NSArray*)titles;
@end
@interface SYLiveRoomFansComboCell : UICollectionViewCell
- (void)showWithTitle:(NSString *)title;

@end
NS_ASSUME_NONNULL_END
