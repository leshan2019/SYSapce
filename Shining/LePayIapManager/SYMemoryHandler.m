//
//  SYLepayIpaMemoryInstance.m
//  Shining
//
//  Created by letv_lzb on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMemoryHandler.h"

@interface SYMemoryHandler ()
    
@end

@implementation SYMemoryHandler

SYSingleCaseM(SYMemoryHandler)


- (NSMutableArray *)syPackageProducts {
    if (!_syPackageProducts) {
        _syPackageProducts = [NSMutableArray new];
    }
    return _syPackageProducts;
}


- (NSMutableArray *)skProducts {
    if (!_skProducts) {
        _skProducts = [NSMutableArray new];
    }
    return _skProducts;
}

@end
