//
//  SYDistrictProvider.m
//  Shining
//
//  Created by Zhang Qigang on 2019/3/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <sqlite3.h>
#import <FMDB/FMDB.h>
#import "SYDistrict.h"
#import "SYDistrict-Private.h"
#import "SYDistrictProvider.h"

@interface SYDistrictProvider ()
@property (nonatomic, strong) FMDatabase* db;
@end

@implementation SYDistrictProvider
+ (instancetype) shared {
    static SYDistrictProvider* _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[SYDistrictProvider alloc] init];
    });
    
    return _shared;
}

- (instancetype) init {
    if (self = [super init]) {
    }
    return self;
}

- (void) open {
    static FMDatabase* db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [FMDatabase databaseWithPath: self.dbPath];
    });
    _db = db;
    
    if (_db) {
        [_db openWithFlags: SQLITE_OPEN_READONLY];
    }
}

- (void) install {
    NSFileManager* fm = NSFileManager.defaultManager;
    NSLog(@"Detect db path: %@", self.dbPath);
    if (![fm fileExistsAtPath: self.dbPath]) {
        NSError* error = nil;
        if (![fm createDirectoryAtPath: self.dbDirname withIntermediateDirectories: YES attributes: nil error: &error]) {
            NSLog(@"create db error: %@", error);
            return;
        }
        
        NSString* dbSrc = [[NSBundle mainBundle] pathForResource: @"districts" ofType: @"db"];
        if (dbSrc.length == 0) {
            NSLog(@"Can't find db in bundle");
            return;
        }
        
        // COPY db
        if (![fm copyItemAtPath: dbSrc toPath: self.dbPath error: &error]) {
            NSLog(@"copy db error: %@", error);
        }
    }
}

- (SYDistrict* _Nullable)  districtOfId: (NSInteger) districtId {
    if (!_db) {
        [self open];
    }
    
    if (!_db) {
        NSLog(@"open db failed");
        return nil;
    }
    
    NSString* sql = @"SELECT district_id, district_name, province_id, province_name FROM district WHERE district_id = ?";
    
    FMResultSet* rs = [_db executeQuery: sql, @(districtId)];
    if (![rs next]) {
        return nil;
    }
    
    SYDistrict* district = [[SYDistrict alloc] init];
    district.districtId = [rs intForColumn: @"district_id"];
    district.districtName = [rs stringForColumn: @"district_name"];
    district.provinceId = [rs intForColumn: @"province_id"];
    district.provinceName = [rs stringForColumn: @"province_name"];
    return district;
}

- (NSArray *)getAllProvinces {
    NSMutableArray *tempArrs = [NSMutableArray array];
    if (!_db) {
        [self open];
    }
    if (!_db) {
        NSLog(@"open db failed");
        return @[];
    }
    NSString* sql = @"SELECT province_name FROM district";

    FMResultSet* rs = [_db executeQuery: sql];
    while ([rs next]) {
        NSString *provinceName = [rs stringForColumn: @"province_name"];
        if (![tempArrs containsObject:provinceName]) {
            [tempArrs addObject:provinceName];
        }
    }
    NSArray *provincesArr = [NSArray arrayWithArray:tempArrs];
    return provincesArr;
}

- (NSArray *)getAllDistrictsByProvinceName:(NSString *)provinceName {
    NSMutableArray *tempArrs = [NSMutableArray array];
    if (!_db) {
        [self open];
    }
    if (!_db) {
        NSLog(@"open db failed");
        return @[];
    }
    NSString* sql = @"SELECT district_name FROM district WHERE province_name = ?";

    FMResultSet* rs = [_db executeQuery: sql, provinceName];
    while ([rs next]) {
        NSString *districtName = [rs stringForColumn: @"district_name"];
        [tempArrs addObject:[NSString sy_safeString:districtName]];
    }
    NSArray *districtsArr = [NSArray arrayWithArray:tempArrs];
    return districtsArr;
}

- (NSInteger)getDistrictIdByProvinceName:(NSString *)provinceName withDistrictName:(NSString *)districtName {
    NSInteger districtId = 0;
    if (!_db) {
        [self open];
    }
    if (!_db) {
        NSLog(@"open db failed");
        return districtId;
    }
    NSString* sql = @"SELECT district_id FROM district WHERE province_name = ? and district_name = ?";

    FMResultSet* rs = [_db executeQuery: sql, provinceName, districtName];
    while ([rs next]) {
        districtId = [rs intForColumn: @"district_id"];
        return districtId;
    }
    return districtId;
}

#pragma mark - getter
- (NSString*) dbBasename {
    return @"districts.db";
}

- (NSString*) dbDirname {
    NSFileManager* fm = NSFileManager.defaultManager;
    NSError* error = nil;
    NSURL* url = [fm URLForDirectory: NSLibraryDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &error];
    url = [url URLByAppendingPathComponent: @"Application Support" isDirectory: YES];
    return url.path;
}

- (NSString*) dbPath {
    return [self.dbDirname stringByAppendingPathComponent: self.dbBasename];
}
@end
