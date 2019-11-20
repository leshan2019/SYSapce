//
//  RobotManager.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kRobot_Message_Ext @"em_robot_message"
#define kRobot_Message_Type @"msgtype"
#define kRobot_Message_Choice @"choice"
#define kRobot_Message_List @"list"
#define kRobot_Message_Title @"title"

@interface RobotManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isRobotWithUsername:(NSString*)username;

- (NSString*)getRobotNickWithUsername:(NSString*)username;

- (void)addRobotsToMemory:(NSArray*)robots;

- (BOOL)isRobotMenuMessage:(EMMessage*)message;

- (NSString*)getRobotMenuMessageDigest:(EMMessage*)message;

- (NSString*)getRobotMenuMessageContent:(EMMessage*)message;

@end

NS_ASSUME_NONNULL_END
