//
//  SYBGMProvider.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYBGMSongModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYBGMProvider : NSObject

+ (instancetype)shared;
- (void)install;

- (NSArray <SYBGMSongModel *>*)bgmSongs;

- (BOOL)insertSongWithSongID:(long long)songID
                        name:(NSString *)name
                      singer:(NSString *)singer
                        size:(long long)size
                    filePath:(NSString *)filePath;

//// 0 导入中，1 正常可用，2 不可用
//- (BOOL)setFilePath:(NSString *)filePath
//             songID:(NSInteger)songID;

- (BOOL)removeSongBySongID:(long long)songID;

@end

NS_ASSUME_NONNULL_END
