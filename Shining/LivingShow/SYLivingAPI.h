//
//  SYLivingAPI.h
//  Shining
//
//  Created by Zhang Qigang on 2019/9/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define RESPONSE_DATA(response,failure) \
({ \
    NSDictionary* data = nil; \
    if ([(response) isKindOfClass: [NSDictionary class]] && (response)[@"code"]) { \
        NSNumber *code = response[@"code"]; \
        if ([code integerValue] == 0) { \
            data = ((response)[@"data"])?: (response); \
            if (data == nil) { \
                (failure)(nil); \
                return; \
            } \
        } else { \
            NSError *error = [NSError errorWithDomain: NSCocoaErrorDomain \
                                                code: [code integerValue] \
                                            userInfo: nil]; \
            if ((failure)) { \
                (failure)(error); \
                return; \
            } \
        } \
    } else { \
        if ((failure)) { \
            (failure)(nil); \
            return; \
        } \
    } \
    data;\
})

@interface SYLivingAPI : NSObject
+ (instancetype) shared;

- (void) getStreamPushUrlWithRoomId: (NSString*) roomId successBlock: (SuccessBlock) success failureBlock: (FailureBlock) failure;
- (void) getStreamPullUrlWithRoomId: (NSString*) roomId successBlock: (SuccessBlock) success failureBlock: (FailureBlock) failure;
- (void) getRoomTitleWithRoomId: (NSString*) roomId successBlock: (SuccessBlock) success failureBlock: (FailureBlock) failure;
- (void) setRoomTitleWithRoomId: (NSString*) roomId successBlock: (SuccessBlock) success failureBlock: (FailureBlock) failure;
- (void) openRoomWithRoomId: (NSString*) roomId successBlock: (SuccessBlock) success failureBlock: (FailureBlock) failure;
- (void) closeRoomWithRoomId: (NSString*) roomId successBlock: (SuccessBlock) success failureBlock: (FailureBlock) failure;
@end

NS_ASSUME_NONNULL_END
