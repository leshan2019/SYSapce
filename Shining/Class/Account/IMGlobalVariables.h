//
//  IMGlobalVariables.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN
extern MainViewController *gMainController;

extern BOOL gIsInitializedSDK;

extern BOOL gIsCalling;

@interface IMGlobalVariables : NSObject
+ (void)setGlobalMainController:(nullable MainViewController *)aMainController;
@end

NS_ASSUME_NONNULL_END
