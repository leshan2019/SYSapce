//
//  ShiningAppDelegate.h
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/4/20.
//  Copyright © 2019 LeEco. All rights reserved.
//

//#import <Flutter/Flutter.h>
#import "ShiningSdkManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShiningAppDelegate : NSObject <UIApplicationDelegate,UNUserNotificationCenterDelegate>

- (instancetype)initWithDelegate:(id<ShiningSdkManager>)delegate;

@end

NS_ASSUME_NONNULL_END
