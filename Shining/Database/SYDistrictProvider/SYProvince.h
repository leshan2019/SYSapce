//
//  SYProvince.h
//  Shining
//
//  Created by Zhang Qigang on 2019/3/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYProvince.h"
#import "SYDistrict.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYProvince : NSObject
@property (nonatomic, assign, readonly) NSInteger provinceId;
@property (nonatomic, copy, readonly) NSString* provinceName;
@end

NS_ASSUME_NONNULL_END
