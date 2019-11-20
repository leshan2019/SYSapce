//
//  SYLocationSearchViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYLocationViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLocationSearchViewModel : NSObject

@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, copy) void(^doRequireLocationAuth)(BOOL success);

- (void)requestCurrentLocationWithSuccessBlock:(void(^)(BOOL success, CGPoint location))successBlock;

- (void)requestPlacesWithLocation:(CGPoint)location
                             page:(NSInteger)page
                     successBlock:(void(^)(BOOL success))successBlock;

- (void)requestAroundPlacesWithKeyword:(NSString *)keyword
                                  page:(NSInteger)page
                          successBlock:(void(^)(BOOL success))successBlock;

// =================== datasource ==========================

- (NSInteger)locationCount;
- (SYLocationViewModel *)locationViewModelAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
