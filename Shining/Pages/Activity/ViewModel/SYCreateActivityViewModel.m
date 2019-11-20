//
//  SYCreateActivityViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateActivityViewModel.h"
#import "SYAPPServiceAPI.h"
#import "SYUserServiceAPI.h"

@implementation SYCreateActivityViewModel

- (void)requestVerifyImageData:(NSData *)data
                         block:(void(^)(BOOL isValid, NSString *url))block {
    [[SYAPPServiceAPI sharedInstance] requestValidateImage:data success:^(id  _Nullable response) {
        NSString *url = nil;
        if ([response isKindOfClass:[NSDictionary class]]) {
            url = response[@"image"];
        }
        if (block) {
            block(YES, url);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO, nil);
        }
    }];
}

- (void)requestSendActivityWithText:(NSString *)text
                          imageURLs:(NSArray<NSData *> *)imageURLs
                              video:(NSData *)videoFile
                         videoCover:(NSData *)videoCover
                           location:(NSString *)location
                           progress:(nonnull void (^)(CGFloat))progress
                              block:(void (^)(BOOL success,BOOL isShowTip))block {
    [self requestValidText:text success:^(BOOL result) {
        if (result) {
            [[SYUserServiceAPI sharedInstance] requestSendActivityText:text imageURLs:imageURLs video:videoFile videoCover:videoCover location:location progress:progress success:^(id  _Nullable response) {
                if (block) {
                    block(YES,YES);
                }
            } failure:^(NSError * _Nullable error) {
                if (block) {
                    block(NO,YES);
                }
            }];
        }else {
            if (block) {
                block(NO,NO);
            }
            [SYToastView showToast:@"发送内容包含敏感词，请重新输入~"];
        }
    }];
}


- (void)requestValidText:(NSString *)text success:(void (^)(BOOL))success {
    [[SYUserServiceAPI sharedInstance] requestValidateText:text success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            if (success) {
                success([response[@"validate"] boolValue]);
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}


@end
