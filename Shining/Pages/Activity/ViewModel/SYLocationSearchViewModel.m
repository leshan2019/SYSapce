//
//  SYLocationSearchViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLocationSearchViewModel.h"
#import "SYLocationManager.h"

@interface SYLocationSearchViewModel () <SYLocationManagerDelegate>

@property (nonatomic, strong) SYLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isFetchAround;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, copy) void(^successBlock)(BOOL success);

@end

@implementation SYLocationSearchViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [SYLocationManager new];
        _locationManager.delegate = self;
        _locationArray = [NSMutableArray new];
        _isLoading = NO;
        _isFetchAround = NO;
    }
    return self;
}

- (void)requestCurrentLocationWithSuccessBlock:(void(^)(BOOL success, CGPoint location))successBlock {
    [self.locationManager requestLocationWithCompletion:^(NSString * _Nonnull locationName, CGPoint location) {
        if (successBlock) {
            successBlock(YES, location);
        }
    }];
}

- (void)requestPlacesWithLocation:(CGPoint)location
                             page:(NSInteger)page
                     successBlock:(void(^)(BOOL success))successBlock {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    if (!self.isFetchAround) {
        [self.locationArray removeAllObjects];
    }
    self.isFetchAround = YES;
    self.successBlock = successBlock;
    [self.locationManager requestAroundPlacesWithPage:page
                                             location:location];
}

- (void)requestAroundPlacesWithKeyword:(NSString *)keyword
                                  page:(NSInteger)page
                          successBlock:(void(^)(BOOL success))successBlock {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    if (self.isFetchAround || ![self.keyword isEqualToString:keyword]) {
        [self.locationArray removeAllObjects];
    }
    self.keyword = keyword;
    self.isFetchAround = NO;
    self.successBlock = successBlock;
    [self.locationManager requestAroundPlacesWithKeyword:keyword
                                                    page:page];
}

- (NSInteger)locationCount {
    return [self.locationArray count];
}

- (SYLocationViewModel *)locationViewModelAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.locationArray count]) {
        return self.locationArray[index];
    }
    return nil;
}

- (void)locationManagerFetchLocationFailed {
    self.isLoading = NO;
    if (self.successBlock) {
        self.successBlock(NO);
    }
}

- (void)locationManagerFetchLocationSuccessWithLocations:(NSArray <SYLocationViewModel *>*)locations {
    self.isLoading = NO;
    [self.locationArray addObjectsFromArray:locations];
    if (self.successBlock) {
        self.successBlock(YES);
    }
}


- (void)locationManagerDoRequireLocationAuth {
    if (self.doRequireLocationAuth) {
        self.doRequireLocationAuth(YES);
    }
}

@end
