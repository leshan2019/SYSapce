//
//  SYCreateVoiceRoomTypeView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCreateVoiceRoomTypeView : UIView

@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)showWithCategoryNames:(NSArray *)names;

@end

NS_ASSUME_NONNULL_END
