//
//  SYNetCommonManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYNetCommonManager.h"
#import "SYUserModel.h"
#import "SYSettingManager.h"

@interface SYNetCommonManager ()

//@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation SYNetCommonManager

- (instancetype)init {
    self = [super init];
    if (self) {
//        _sessionManager = [SYNetCommonManager sessionManager];
    }
    return self;
}

- (void)GET:(NSString *)url
 parameters:(NSDictionary *)parameters
    success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    AFHTTPSessionManager *manager = [[self class] sessionManager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:SHANYIN_PCODE forKey:@"pcode"];
    [dict setObject:SHANYIN_VERSION forKey:@"version"];
    [dict setObject:[SYSettingManager smAntiDeviceId] forKey:@"did"];
    [manager GET:url parameters:dict progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *response = responseObject;
             NSNumber *code = response[@"code"];
             BOOL isValid = YES;
             if ([code integerValue] == 2007
                 || [code integerValue] == 2008
                 || [code integerValue] == 2009) {
                 isValid = NO;
             }
             if (isValid) {
                 if (success) {
                     success(responseObject);
                 }
             }else {
                 if (failure) {
                     NSError *error = [NSError errorWithDomain:@"" code:2007 userInfo:response];
                     failure(error);
                 }
                 if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
                     [[UserProfileManager sharedInstance] logOut];
                 }
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if (failure) {
                 failure(error);
             }
         }];
}

- (void)POST:(NSString *)url
  parameters:(NSDictionary *)parameters
     success:(SuccessBlock)success
     failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:SHANYIN_PCODE forKey:@"pcode"];
    [dict setObject:SHANYIN_VERSION forKey:@"version"];
    [dict setObject:[SYSettingManager smAntiDeviceId] forKey:@"did"];
    AFHTTPSessionManager *manager = [[self class] sessionManager];
    [manager POST:url parameters:dict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *response = responseObject;
              NSNumber *code = response[@"code"];
              BOOL isValid = YES;
              if ([code integerValue] == 2007
                  || [code integerValue] == 2008
                  || [code integerValue] == 2009) {
                  isValid = NO;
              }
              if (isValid) {
                  if (success) {
                      success(responseObject);
                  }
              }else {
                  if (failure) {
                      NSError *error = [NSError errorWithDomain:@"" code:2007 userInfo:response];
                      failure(error);
                  }
                  if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
                      [[UserProfileManager sharedInstance] logOut];
                  }
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (failure) {
                  failure(error);
              }
          }];
}

- (void)POST:(NSString *)url
  parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> _Nonnull))block
     success:(SuccessBlock)success
     failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:SHANYIN_PCODE forKey:@"pcode"];
    [dict setObject:SHANYIN_VERSION forKey:@"version"];
    [dict setObject:[SYSettingManager smAntiDeviceId] forKey:@"did"];
    AFHTTPSessionManager *manager = [[self class] sessionManager];
    [manager POST:url parameters:dict
        constructingBodyWithBlock:block
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *response = responseObject;
              NSNumber *code = response[@"code"];
              BOOL isValid = YES;
              if ([code integerValue] == 2007
                  || [code integerValue] == 2008
                  || [code integerValue] == 2009) {
                  isValid = NO;
              }
              if (isValid) {
                  if (success) {
                      success(responseObject);
                  }
              }else {
                  if (failure) {
                      NSError *error = [NSError errorWithDomain:@"" code:2007 userInfo:response];
                      failure(error);
                  }
                  if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
                      [[UserProfileManager sharedInstance] logOut];
                  }
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (failure) {
                  failure(error);
              }
          }];
}

- (void)POST:(NSString *)url parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:SHANYIN_PCODE forKey:@"pcode"];
    [dict setObject:SHANYIN_VERSION forKey:@"version"];
    [dict setObject:[SYSettingManager smAntiDeviceId] forKey:@"did"];
    AFHTTPSessionManager *manager = [[self class] sessionManager];
    [manager POST:url parameters:dict
        constructingBodyWithBlock:block
         progress:uploadProgress
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *response = responseObject;
              NSNumber *code = response[@"code"];
              BOOL isValid = YES;
              if ([code integerValue] == 2007
                  || [code integerValue] == 2008
                  || [code integerValue] == 2009) {
                  isValid = NO;
              }
              if (isValid) {
                  if (success) {
                      success(responseObject);
                  }
              }else {
                  if (failure) {
                      NSError *error = [NSError errorWithDomain:@"" code:2007 userInfo:response];
                      failure(error);
                  }
                  if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
                      [[UserProfileManager sharedInstance] logOut];
                  }
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (failure) {
                  failure(error);
              }
          }];
}

#pragma mark - private method

+ (AFHTTPSessionManager *)sessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet* acceptableContentTypes =
    [NSMutableSet setWithSet: manager.responseSerializer.acceptableContentTypes];
    [acceptableContentTypes addObject: @"text/html"];
    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 15;
    manager.requestSerializer = requestSerializer;
//    [manager.requestSerializer setValue:[self user].accessToken ?: @"" forHTTPHeaderField:@"tk"];
    [manager.requestSerializer setValue:[SYSettingManager accessToken]
                     forHTTPHeaderField:@"ssotk"];
    return manager;
}

@end
