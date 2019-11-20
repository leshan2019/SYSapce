//
//  SYLocationManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//
/*
#import "SYLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface SYLocationManager () <AMapSearchDelegate,AMapLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) NSString *cityCode;

@end

@implementation SYLocationManager

- (void)requestLocationWithCompletion:(void(^)(NSString *locationName, CGPoint location))completion {
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(locationManagerDoRequireLocationAuth)]) {
                    [self.delegate locationManagerDoRequireLocationAuth];
                }
            }else if (error.code == AMapLocationErrorLocateFailed)
            {
                if (completion) {
                    completion(nil, CGPointZero);
                }
                return;
            }
        }
        
        NSLog(@"location:%@", location);
        NSString *address = nil;
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            if (completion) {
                address = [NSString stringWithFormat:@"%@·%@", regeocode.city, regeocode.AOIName];
                
            }
        }
        completion(address, CGPointMake(location.coordinate.latitude, location.coordinate.longitude));
    }];
}

//            住宅区：120300
//            学校：141200
//            楼宇：120200
//            商场：060111
  //           银行:160100
            // 餐饮:050000

- (void)requestAroundPlacesWithPage:(NSInteger)page
                           location:(CGPoint)location{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:location.x longitude:location.y];
    // 按照距离排序. 
    request.sortrule            = 0;
    request.requireExtension    = YES;
    request.page = page;
    request.types = @"120300|141200|120200|160100|050000";
    [self.searchAPI AMapPOIAroundSearch:request];
}

- (void)requestAroundPlacesWithKeyword:(NSString *)keyword
                                  page:(NSInteger)page {
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
    request.keywords            = keyword;
    request.city                = self.cityCode?:@"";
    request.requireExtension    = YES;
    request.page = page;
    request.types = @"120300|141200|120200|160100|050000";
        
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.searchAPI AMapPOIKeywordsSearch:request];
}

#pragma mark -

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (AMapSearchAPI *)searchAPI {
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

#pragma mark -

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(locationManagerFetchLocationFailed)]) {
        [self.delegate locationManagerFetchLocationFailed];
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request
               response:(AMapPOISearchResponse *)response {
    if ([self.delegate respondsToSelector:@selector(locationManagerFetchLocationSuccessWithLocations:)]) {
        NSMutableArray *array = [NSMutableArray new];
        for (AMapPOI *po in response.pois) {
            [array addObject:[[SYLocationViewModel alloc] initWithName:po.name
                                                               address:po.address
                                                                  city:po.city]];
            if (!self.cityCode) {
                self.cityCode = po.citycode;
            }
        }
        [self.delegate locationManagerFetchLocationSuccessWithLocations:array];
    }
}


- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(locationManagerDoRequireLocationAuth)]) {
            [self.delegate locationManagerDoRequireLocationAuth];
        }
    }else {
         [locationManager requestAlwaysAuthorization];
    }
}

@end
*/
