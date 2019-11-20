//
//  SYUserModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYUserModel : NSObject <YYModel>

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *agoraToken;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
