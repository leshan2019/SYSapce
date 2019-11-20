//
//  NSObject+SYObjectEmpty.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/11.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "NSObject+SYObjectEmpty.h"
#import "NSString+SYHTTPExtensions.h"


@interface SYWeakProxy ()

@property (nonatomic, weak) id target;

@end

@implementation SYWeakProxy

#pragma mark Life Cycle
+ (instancetype)weakProxyForObject:(id)targetObject
{
    SYWeakProxy *weakProxy = [SYWeakProxy alloc];
    weakProxy.target = targetObject;
    return weakProxy;
}


#pragma mark Forwarding Messages

- (id)forwardingTargetForSelector:(SEL)selector
{
    return _target;
}


#pragma mark - NSWeakProxy Method Overrides
#pragma mark Handling Unimplemented Methods

- (void)forwardInvocation:(NSInvocation *)invocation
{
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

@end

@implementation NSObject (SYObjectEmpty)
+ (BOOL)sy_empty:(NSObject *)o{
    if (o==nil) {
        return YES;
    }
    if (o==NULL) {
        return YES;
    }
    if (o==[NSNull new]) {
        return YES;
    }
    if ([o isKindOfClass:[NSString class]]) {
        return [NSString sy_isBlankString:(NSString *)o];
    }
    if ([o isKindOfClass:[NSData class]]) {
        return [((NSData *)o) length]<=0;
    }
    if ([o isKindOfClass:[NSDictionary class]]) {
        return [((NSDictionary *)o) count]<=0;
    }
    if ([o isKindOfClass:[NSArray class]]) {
        return [((NSArray *)o) count]<=0;
    }
    if ([o isKindOfClass:[NSSet class]]) {
        return [((NSSet *)o) count]<=0;
    }
    return NO;
}

@end
