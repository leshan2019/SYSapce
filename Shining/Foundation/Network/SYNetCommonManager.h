//
//  SYNetCommonManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking/AFNetworking.h>

@protocol AFMultipartFormData;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(id _Nullable response);
typedef void(^FailureBlock)(NSError * _Nullable error);

@interface SYNetCommonManager : NSObject

- (void)GET:(NSString *)url
 parameters:(NSDictionary *)parameters
    success:(SuccessBlock)success
    failure:(FailureBlock)failure;

- (void)POST:(NSString *)url
  parameters:(NSDictionary *)parameters
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;

- (void)POST:(NSString *)url
  parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;

// 进度条
- (void)POST:(NSString *)url
  parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
     success:(SuccessBlock)success
     failure:(FailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
