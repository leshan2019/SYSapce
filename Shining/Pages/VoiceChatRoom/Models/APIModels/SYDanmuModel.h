//
//  SYDanmuModel.h
//  Shining
//
//  Created by 杨玄 on 2019/4/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYDanmuModel : NSObject

@property (nonatomic, assign) NSInteger danmu_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger danmu_style;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger vip_level;
@end

NS_ASSUME_NONNULL_END
