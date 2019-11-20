//
//  SYDistrict.h
//  Shining
//
//  Created by Zhang Qigang on 2019/3/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYDistrict : NSObject
@property (nonatomic, assign, readonly) NSInteger districtId;
@property (nonatomic, copy, readonly) NSString* districtName;
@property (nonatomic, assign, readonly) NSInteger provinceId;
@property (nonatomic, copy, readonly) NSString* provinceName;
@end

NS_ASSUME_NONNULL_END
