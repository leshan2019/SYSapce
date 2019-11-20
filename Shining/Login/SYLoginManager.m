//
//  SYLoginManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLoginManager.h"
#import "SYLoginNetManager.h"
#import "SYSettingManager.h"
#import "SYUserModel.h"

@interface SYLoginManager ()

@property (nonatomic, strong) SYLoginNetManager *netManager;

@end

@implementation SYLoginManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _netManager = [[SYLoginNetManager alloc] init];
    }
    return self;
}

- (void)loginWithPhone:(NSString *)phone {
    [self.netManager loginWithPhone:phone
                            success:^(id  _Nullable response) {
                                if ([response isKindOfClass:[NSDictionary class]]) {
                                    NSDictionary *data = response[@"data"];
                                    SYUserModel *user = [SYUserModel yy_modelWithDictionary:data];
                                    [SYSettingManager setUserInfo:[user yy_modelToJSONString]];
                                }
                            } failure:^(NSError * _Nullable error) {
                                
                            }];
}

@end
