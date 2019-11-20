//
//  SYCreateActivityViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCreateActivityViewModel : NSObject

- (void)requestVerifyImageData:(NSData *)data
                         block:(void(^)(BOOL isValid, NSString *url))block;

- (void)requestSendActivityWithText:(NSString *)text
                          imageURLs:(NSArray <NSData *>*)imageURLs
                              video:(NSData *)videoFile
                         videoCover:(NSData *)videoCover
                           location:(NSString *)location
                           progress:(void(^)(CGFloat))progress
                              block:(void(^)(BOOL success,BOOL isShowTip))block;


@end

NS_ASSUME_NONNULL_END
