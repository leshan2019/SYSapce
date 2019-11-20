//
//  SYLocationViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLocationViewModel.h"

@implementation SYLocationViewModel

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                        city:(nonnull NSString *)city {
    self = [super init];
    if (self) {
        _name = name;
        _address = address;
        _city = city;
    }
    return self;
}

@end
