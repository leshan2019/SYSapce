//
//  NSArray+SYSafe.m
//  KVOTest
//
//  Created by StriEver on 16/7/29.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "NSArray+SYSafe.h"
#import <objc/runtime.h>
#import "NSObject+SYImpChangeTool.h"
@implementation NSArray (SYSafe)
+ (void)load{
    static dispatch_once_t onceDispatch;
    dispatch_once(&onceDispatch, ^{
        [self SwizzlingMethod:@"objectAtIndex:" systemClassString:@"__NSArrayI" toSafeMethodString:@"sy_objectAtIndex:" targetClassString:@"NSArray"];

        [self SwizzlingMethod:@"objectAtIndex:" systemClassString:@"__NSSingleObjectArrayI" toSafeMethodString:@"sy_object1AtIndex:" targetClassString:@"NSArray"];

        [self SwizzlingMethod:@"objectAtIndex:" systemClassString:@"__NSArray0" toSafeMethodString:@"sy_object2AtIndex:" targetClassString:@"NSArray"];

         [self SwizzlingMethod:@"initWithObjects:count:" systemClassString:@"__NSPlaceholderArray" toSafeMethodString:@"initWithObjects_sy:count:" targetClassString:@"NSArray"];

        [self SwizzlingMethod:@"arrayByAddingObject:" systemClassString:@"__NSArrayI" toSafeMethodString:@"arrayByAddingObject_sy:" targetClassString:@"NSArray"];
    });
}

- (id)sy_objectAtIndex:(NSUInteger)index{
    //判断数组是否越界
    if (index >= [self count]) {
        return nil;
    }
    return [self sy_objectAtIndex:index];
}

- (id)sy_object1AtIndex:(NSUInteger)index{
    //判断数组是否越界
    if (index >= [self count]) {
        return nil;
    }
    return [self sy_object1AtIndex:index];
}

- (id)sy_object2AtIndex:(NSUInteger)index{
    //判断数组是否越界
    if (index >= [self count]) {
        return nil;
    }
    return [self sy_object2AtIndex:index];
}

- (NSArray *)arrayByAddingObject_sy:(id)anObject {
    if (!anObject) {
        return self;
    }
    return [self arrayByAddingObject_sy:anObject];
}
- (instancetype)initWithObjects_sy:(id *)objects count:(NSUInteger)count {
    NSUInteger newCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!objects[i]) {
            break;
        }
        newCount++;
    }
    self = [self initWithObjects_sy:objects count:newCount];
    return self;
}


@end
