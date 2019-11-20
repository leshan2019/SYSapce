//
//  SYLoginNetManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLoginNetManager.h"

@implementation SYLoginNetManager

- (void)loginWithPhone:(NSString *)phone
               success:(SuccessBlock)success
               failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"http://123.59.123.121:1323/login?phone=%@&captcha=1",phone];
    [self GET:url
   parameters:@{}
      success:success
      failure:failure];
}

@end
