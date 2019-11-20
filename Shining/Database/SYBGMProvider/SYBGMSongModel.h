//
//  SYBGMSongModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYBGMSongModel : NSObject

@property (nonatomic, assign) long long songID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *singer;
@property (nonatomic, assign) long long size;
@property (nonatomic, strong) NSString *path;

@end

NS_ASSUME_NONNULL_END
