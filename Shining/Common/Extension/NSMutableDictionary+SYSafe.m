//
//  NSMutableDictionary+SYSafe.m
//  KVOTest
//
//  Created by StriEver on 16/8/5.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "NSMutableDictionary+SYSafe.h"
#import <objc/runtime.h>
#import "NSObject+SYImpChangeTool.h"
@implementation NSMutableDictionary (SYSafe)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self SwizzlingMethod:@"sy_removeObjectForKey:" systemClassString:@"NSMutableDictionary" toSafeMethodString:@"removeObjectForKey:" targetClassString:@"__NSDictionaryM"];
        [self SwizzlingMethod:@"sy_setObject:forKey:" systemClassString:@"NSMutableDictionary" toSafeMethodString:@"setObject:forKey:" targetClassString:@"__NSDictionaryM"];
    });
}
- (void)sy_removeObjectForKey:(id)key {
    if (!key) {
        return;
    }
    [self sy_removeObjectForKey:key];
}
- (void)sy_setObject:(id)obj forKey:(id <NSCopying>)key {
    if (!obj) {
        return;
    }
    if (!key) {
        return;
    }
    [self sy_setObject:obj forKey:key];
}
@end
