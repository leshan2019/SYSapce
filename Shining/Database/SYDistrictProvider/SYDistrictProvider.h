//
//  SYDistrictProvider.h
//  Shining
//
//  Created by Zhang Qigang on 2019/3/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYDistrict.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYDistrictProvider : NSObject
@property (nonatomic, copy, readonly) NSString* dbPath;
@property (nonatomic, copy, readonly) NSString* dbBasename;
@property (nonatomic, copy, readonly) NSString* dbDirname;

+ (instancetype) shared;
- (void) install;
- (SYDistrict* _Nullable) districtOfId: (NSInteger) districtId;

// 获取所有的省份
- (NSArray *)getAllProvinces;

// 获取某个省对应的所有的行政区
- (NSArray *)getAllDistrictsByProvinceName:(NSString *)provinceName;

// 获取某个省某个行政区对应的districtId
- (NSInteger)getDistrictIdByProvinceName:(NSString *)provinceName withDistrictName:(NSString *)districtName;

@end

NS_ASSUME_NONNULL_END
