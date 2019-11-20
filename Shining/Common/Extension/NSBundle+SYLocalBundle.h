//
//  NSBundle+SYLocalBundle.h
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/5/20.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (SYLocalBundle)

+ (instancetype)sy_localBundle;
+ (NSString *)sy_localizedStringForKey:(NSString *)key;
+ (NSString *)sy_localizedStringForKey:(NSString *)key value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
