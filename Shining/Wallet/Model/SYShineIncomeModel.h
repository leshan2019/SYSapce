//
//  SYShineIncomeModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYShineIncomeModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger daily_shine;
@property (nonatomic, assign) NSInteger weekly_shine;
@property (nonatomic, assign) NSInteger total_shine;
@end

NS_ASSUME_NONNULL_END
