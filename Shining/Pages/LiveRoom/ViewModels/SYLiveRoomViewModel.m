//
//  SYLiveRoomViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomViewModel.h"

@interface SYLiveRoomViewModel ()

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *password;

@end

@implementation SYLiveRoomViewModel

- (instancetype)initWithChannelID:(NSString *)channelID
                         password:(NSString *)password {
    self = [super init];
    if (self) {
        _channelID = channelID;
        _password = password;
    }
    return self;
}

- (void)startProcess {
    
}

@end
