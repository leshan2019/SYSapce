//
//  SYSoundtoneModel.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYSoundtoneModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *sound_type;
@property (nonatomic, assign) NSInteger score;

@end

NS_ASSUME_NONNULL_END
