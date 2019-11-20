//
//  NSMutableArray+SYSafe.m
//  KVOTest
//
//  Created by StriEver on 16/8/1.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "NSMutableArray+SYSafe.h"
#import <objc/runtime.h>
#import "NSObject+SYImpChangeTool.h"
@implementation NSMutableArray (SYSafe)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self SwizzlingMethod:@"addObject:" systemClassString:@"__NSArrayM" toSafeMethodString:@"sy_addObject:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"insertObject:atIndex:" systemClassString:@"__NSArrayM" toSafeMethodString:@"sy_insertObject:atIndex:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"removeObjectAtIndex:" systemClassString:@"__NSArrayM" toSafeMethodString:@"sy_removeObjectAtIndex:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"replaceObjectAtIndex:withObject:" systemClassString:@"__NSArrayM" toSafeMethodString:@"sy_safe_replaceObjectAtIndex:withObject:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"removeObjectsAtIndexes:" systemClassString:@"NSMutableArray" toSafeMethodString:@"sy_removeObjectsAtIndexes:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"removeObjectsInRange:" systemClassString:@"NSMutableArray" toSafeMethodString:@"sy_removeObjectsInRange:" targetClassString:@"NSMutableArray"];
        
        [self SwizzlingMethod:@"objectAtIndex:" systemClassString:@"__NSArrayM" toSafeMethodString:@"sy_objectAtIndex:" targetClassString:@"NSMutableArray"];
        
        
    });
}
- (void)sy_addObject:(id)anObject{
    if (!anObject) {
        return;
    }
    [self sy_addObject:anObject];
}
- (void)sy_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count]) {
        return;
    }
    if (!anObject) {
        return;
    }
    [self sy_insertObject:anObject atIndex:index];
}
- (void)sy_removeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return;
    }
    
    return [self sy_removeObjectAtIndex:index];
}
- (void)sy_safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count]) {
        return;
    }
    if (!anObject) {
        return;
    }
    [self sy_safe_replaceObjectAtIndex:index withObject:anObject];
}
- (void)sy_removeObjectsAtIndexes:(NSIndexSet *)indexes{
    NSMutableIndexSet * mutableSet = [NSMutableIndexSet indexSet];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < [self count ]) {
            [mutableSet addIndex:idx];
        }
    }];
    [self sy_removeObjectsAtIndexes:mutableSet];
}
- (void)sy_removeObjectsInRange:(NSRange)range{
    //获取最大索引
    if (range.location + range.length - 1 < [self count]) {
        [self sy_removeObjectsInRange:range];
        return;
    }
    if (range.location >= [self count]) {
        return;
    }
    NSInteger tempInteger = range.location + range.length - 1;
    while (tempInteger >= [self count]) {
        tempInteger -= 1;
    }
    NSRange tempRange = NSMakeRange(range.location, tempInteger + 1 -range.location);
    [self sy_removeObjectsInRange:tempRange];
}
- (id)sy_objectAtIndex:(NSUInteger)index{
    //判断数组是否越界
    if (index >= [self count]) {
        return nil;
    }
    return [self sy_objectAtIndex:index];
}
@end
