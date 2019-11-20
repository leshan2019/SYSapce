//
//  SYVoiceRoomOperationModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomOperationModel : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *jumplink;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSInteger position;

@end

NS_ASSUME_NONNULL_END
