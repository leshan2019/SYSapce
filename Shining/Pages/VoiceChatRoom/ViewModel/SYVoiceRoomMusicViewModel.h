//
//  SYVoiceRoomMusicViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomMusicViewModel : NSObject

- (void)requestMusicList;

- (NSInteger)songsCount;
- (NSString *)songTitleAtIndex:(NSInteger)index;
- (long long)songSizeAtIndex:(NSInteger)index;
- (long long)songIdAtIndex:(NSInteger)index;
- (NSString *)songFilePathAtIndex:(NSInteger)index;

- (void)addSongsWithCollection:(MPMediaItemCollection *)collection
                    completion:(void(^)(void))completion;
- (void)deleteSongAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
