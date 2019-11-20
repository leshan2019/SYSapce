//
//  SYSearchModel.h
//  Shining
//
//  Created by 杨玄 on 2019/9/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYSearchModel : NSObject<YYModel>

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *data;

@end

NS_ASSUME_NONNULL_END
