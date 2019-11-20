//
//  SYSignProvider.h
//  Shining
//
//  Created by Zhang Qigang on 2019/3/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYSignProvider : NSObject
+ (instancetype) shared;

- (NSString* _Nullable) signOfDateString: (NSString*) string;
@end

NS_ASSUME_NONNULL_END
