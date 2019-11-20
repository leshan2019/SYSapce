//
//  NSDictionary+SYSafe.m
//  KVOTest
//
//  Created by StriEver on 16/8/1.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "NSDictionary+SYSafe.h"
#import <objc/runtime.h>
#import "NSObject+SYImpChangeTool.h"

@implementation NSDictionary (SYSafe)
+ (void)load{
    [self SwizzlingMethod:@"initWithObjects:forKeys:count:" systemClassString:@"__NSPlaceholderDictionary" toSafeMethodString:@"initWithObjects_sy:forKeys:count:" targetClassString:@"NSDictionary"];
}
-(instancetype)initWithObjects_sy:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count {
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }else{
            rightCount++;
        }
    }
    self = [self initWithObjects_sy:objects forKeys:keys count:rightCount];
    return self;
}
@end
