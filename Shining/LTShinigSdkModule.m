//
//  LetvShinigSdkModule.m
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/4/24.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import "LTShinigSdkModule.h"
#import "ShiningSdkManager.h"

@implementation LTShinigSdkModule

- (void)setupService
{
    [self registerService];
    /*
    self.isSetupService = YES;
     */
}


- (void)registerService {

}


- (void)cleanService {
    //停基础服务
    /*
    [super cleanService];
     */
    //do something else
}

- (void)registerInterfaces {
    /*
    ShiningSdkManager *impl =  [ShiningSdkManager shareShiningSdkManager];
    LTMBaseInterface *iface = [[LTMBaseInterface alloc] init];
    [iface implementWith:impl];

    [self.interfaceDic setObject:iface forKey:NSStringFromProtocol(@protocol(ShiningSdkProtocol))];
    [self.interfaceArray addObject:iface];
     */
}

- (void)unRegisterInterfaces
{
    //注销
    /*
    [self.interfaceDic removeAllObjects];
    [self.interfaceArray  removeAllObjects];
    self.isRegisteredInterface = NO;
     */
    //do something else
}

@end
