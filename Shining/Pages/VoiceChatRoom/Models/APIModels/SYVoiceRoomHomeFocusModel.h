//
//  SYVoiceRoomHomeFocusModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomHomeFocusModel : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *jump;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *image;

@end

NS_ASSUME_NONNULL_END
