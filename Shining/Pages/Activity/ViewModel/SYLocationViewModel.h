//
//  SYLocationViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLocationViewModel : NSObject

- (instancetype)initWithName:(NSString *)name
                     address:(NSString *)address
                        city:(NSString *)city;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) NSString *city;

@end

NS_ASSUME_NONNULL_END
