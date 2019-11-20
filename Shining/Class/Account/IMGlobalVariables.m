//
//  IMGlobalVariables.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "IMGlobalVariables.h"

MainViewController *gMainController = nil;
BOOL gIsInitializedSDK = NO;
BOOL gIsCalling = NO;
static IMGlobalVariables *shared = nil;

@implementation IMGlobalVariables
+ (instancetype)shareGlobal
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[IMGlobalVariables alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

+ (void)setGlobalMainController:(nullable MainViewController *)aMainController
{
    gMainController = aMainController;
}
@end
