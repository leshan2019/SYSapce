//
//  SYLivingAPI.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLivingModel.h"
#import "SYLivingAPI.h"

@interface SYLivingAPI ()
@property (nonatomic, strong) SYNetCommonManager* http;
@property (nonatomic, strong) NSString *baseURL;
@end

@implementation SYLivingAPI
+ (instancetype) shared {
    static SYLivingAPI* _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (instancetype) init {
    if (self = [super init]) {
#ifdef UseSettingTestDevEnv
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/";
        }else {
            _baseURL = @"http://api.svoice.le.com/";
        }
#else
        _baseURL = @"https://api-svoice.le.com/";
#endif
        self.http = [[SYNetCommonManager alloc] init];
    }
    
    return self;
}

- (void) getStreamPushUrlWithRoomId: (NSString*) roomId
                       successBlock: (SuccessBlock) success
                       failureBlock: (FailureBlock) failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/live/stream"];
    [self.http GET: url
        parameters: @{@"rid": roomId, @"type": @(1)}
           success:^(id  _Nullable response) {
               NSDictionary* data = RESPONSE_DATA(response, failure);
               SYLivingStreamModel* model = [SYLivingStreamModel yy_modelWithJSON: data];
               if (success) {
                   success(model);
               }
           }
           failure:^(NSError * _Nullable error) {
               if (failure) failure(error);
           }];
}

- (void) getStreamPullUrlWithRoomId: (NSString*) roomId
                       successBlock: (SuccessBlock) success
                       failureBlock: (FailureBlock) failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/live/stream"];
    [self.http GET: url
        parameters: @{@"rid": roomId, @"type": @(2)}
           success:^(id  _Nullable response) {
               NSDictionary* data = RESPONSE_DATA(response, failure);
               SYLivingStreamModel* model = [SYLivingStreamModel yy_modelWithJSON: data];
               if (success) {
                   success(model);
               }
           }
           failure:^(NSError * _Nullable error) {
               if (failure) failure(error);
           }];
}

- (void) getRoomTitleWithRoomId: (NSString*) roomId
                   successBlock: (SuccessBlock) success
                   failureBlock: (FailureBlock) failure {
    // TODO: 获取房间名称
    
}

- (void) setRoomTitleWithRoomId: (NSString*) roomId
                   successBlock: (SuccessBlock) success
                   failureBlock: (FailureBlock) failure {
    // TODO: 设置房间名称
    
}

- (void) openRoomWithRoomId: (NSString*) roomId
               successBlock: (SuccessBlock) success
               failureBlock: (FailureBlock) failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/live/start"];
    [self.http GET: url
        parameters: @{@"rid": roomId}
           success:^(id  _Nullable response) {
               if (success) {
                   success(nil);
               }
           }
           failure:^(NSError * _Nullable error) {
               if (failure) failure(error);
           }];
}

- (void) closeRoomWithRoomId: (NSString*) roomId
                successBlock: (SuccessBlock) success
                failureBlock: (FailureBlock) failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/live/stop"];
    [self.http GET: url
        parameters: @{@"rid": roomId}
           success:^(id  _Nullable response) {
               if (success) {
                   success(nil);
               }
           }
           failure:^(NSError * _Nullable error) {
               if (failure) failure(error);
           }];
}
@end

