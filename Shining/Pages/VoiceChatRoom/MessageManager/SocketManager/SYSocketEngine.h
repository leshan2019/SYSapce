//
//  SYSocketEngine.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYSocketEngineDelegate <NSObject>

@end

@interface SYSocketEngine : NSObject

- (void)openWithRoomId:(NSString *)roomId
              delegate:(id <SYSocketEngineDelegate>) delegate;

- (void)close;

@end

NS_ASSUME_NONNULL_END
