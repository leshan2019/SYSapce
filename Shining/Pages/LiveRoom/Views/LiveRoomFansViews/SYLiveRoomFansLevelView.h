//
//  SYLiveRoomFansLevelView.h
//  Shining
//
//  Created by leeco on 2019/11/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomFansLevelView : UIView
- (instancetype)initWithFrame:(CGRect)frame andFontSize:(CGFloat)size;
-(void)setViewInfoIconName:(NSString*)name andLevel:(NSString*)level;

@end

NS_ASSUME_NONNULL_END
