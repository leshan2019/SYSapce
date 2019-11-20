//
//  SYDistrict-Private.h
//  Shining
//
//  Created by Zhang Qigang on 2019/3/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDistrict.h"

@interface SYDistrict ()
@property (nonatomic, assign, readwrite) NSInteger districtId;
@property (nonatomic, copy, readwrite) NSString* districtName;
@property (nonatomic, assign, readwrite) NSInteger provinceId;
@property (nonatomic, copy, readwrite) NSString* provinceName;
@end
