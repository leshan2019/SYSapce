//
//  NSObject+SYObjectEmpty.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/11.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYWeakProxy : NSProxy

+ (instancetype)weakProxyForObject:(id)targetObject;

@end

@interface NSObject (SYObjectEmpty)
+ (BOOL)sy_empty:(NSObject *)o;
@end
