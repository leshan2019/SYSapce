//
//  SYVoiceRoomMusicViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomMusicViewModel.h"
#import "SYBGMProvider.h"

@interface SYVoiceRoomMusicViewModel ()

@property (nonatomic, strong) NSArray *songsArray;

@end

@implementation SYVoiceRoomMusicViewModel

- (void)requestMusicList {
    self.songsArray = [[SYBGMProvider shared] bgmSongs];
}

- (NSInteger)songsCount {
    return [self.songsArray count];
}

- (NSString *)songTitleAtIndex:(NSInteger)index {
    NSString *name = [self songAtIndex:index].name;
    if (name) {
        NSString *singer = [self songAtIndex:index].singer;
        if (![NSString sy_isBlankString:singer]) {
            name = [name stringByAppendingFormat:@"-%@",singer];
        }
    }
    return name;
}

- (long long)songSizeAtIndex:(NSInteger)index {
    return [self songAtIndex:index].size;
}

- (long long)songIdAtIndex:(NSInteger)index {
    return [self songAtIndex:index].songID;
}

- (NSString *)songFilePathAtIndex:(NSInteger)index {
    NSString *path = [self songAtIndex:index].path;
    return [self musicDiscPathWithPath:path];
}

- (void)addSongsWithCollection:(MPMediaItemCollection *)mediaItemCollection
                    completion:(void(^)(void))completion {
    if (mediaItemCollection) {
        NSArray<MPMediaItem *> *items = [mediaItemCollection items];
        if ([items count] == 0) {
            NSLog(@"未选择BGM");
            return;
        }
        NSString *musicDir = self.musicDir;
        if (![[NSFileManager defaultManager] fileExistsAtPath:musicDir]) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:musicDir
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:nil]) {
                NSLog(@"could not create music dir");
                return;
            }
        }
        NSInteger totalCount = [items count];
        __block NSInteger handledCount = 0;
        __weak typeof(self) weakSelf = self;
        void (^checkBlock)(void) = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                handledCount ++;
                if (handledCount >= totalCount) {
                    weakSelf.songsArray = [[SYBGMProvider shared] bgmSongs];
                    if (completion) {
                        completion();
                    }
                }
            });
        };
        for (MPMediaItem *song in items) {
            NSInteger songID = [[song valueForProperty:MPMediaItemPropertyPersistentID] integerValue];
            NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
            NSString *singer = [song valueForKey:MPMediaItemPropertyArtist] ?: @"";
            
            NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
            AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
            NSLog (@"compatible presets for songAsset: %@",
                   [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
            
            /* approach 1: export just the song itself
             */
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                              initWithAsset: songAsset
                                              presetName: AVAssetExportPresetAppleM4A];
            NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
            [exporter determineCompatibleFileTypesWithCompletionHandler:^(NSArray<AVFileType> * _Nonnull compatibleFileTypes) {
                AVFileType fileType = @"";
                if ([compatibleFileTypes containsObject:AVFileTypeMPEGLayer3]) {
                    fileType = AVFileTypeMPEGLayer3;
                } else if ([compatibleFileTypes containsObject:AVFileTypeAppleM4A]) {
                    fileType = AVFileTypeAppleM4A;
                } else if ([compatibleFileTypes containsObject:AVFileTypeWAVE]) {
                    fileType = AVFileTypeWAVE;
                } else if ([compatibleFileTypes containsObject:AVFileType3GPP]) {
                    fileType = AVFileType3GPP;
                } else {
                    checkBlock();
                    return;
                }
                exporter.outputFileType = fileType;
                NSString *name = [NSString stringWithFormat:@"%@", @(songID)];
                NSString *path = [weakSelf musicDiscPathWithPath:name];
                exporter.outputURL = [NSURL fileURLWithPath:path];
                [exporter exportAsynchronouslyWithCompletionHandler:^{
                    switch (exporter.status) {
                        case AVAssetExportSessionStatusFailed:
                        case AVAssetExportSessionStatusCancelled:
                        {
                            // log error to text view
                            NSError *exportError = exporter.error;
                            NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                            checkBlock();
                        }
                            break;
                        case AVAssetExportSessionStatusCompleted:
                        {
                            NSLog (@"AVAssetExportSessionStatusCompleted");
                            NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                                  error:nil];
                            NSNumber *size = [dict objectForKey:NSFileSize];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[SYBGMProvider shared] insertSongWithSongID:songID
                                                                        name:title
                                                                      singer:singer
                                                                        size:[size longLongValue]
                                                                    filePath:name];
                            });
                            checkBlock();
                        }
                            break;
                        default: { NSLog (@"didn't get export status"); break;}
                    }
                }];
            }];
        }
    }
}

- (void)deleteSongAtIndex:(NSInteger)index {
    SYBGMSongModel *song = [self songAtIndex:index];
    if (song) {
        NSString *filePath = [self musicDiscPathWithPath:song.path];
        [[SYBGMProvider shared] removeSongBySongID:song.songID];
        [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                   error:nil];
        self.songsArray = [[SYBGMProvider shared] bgmSongs];
    }
}

#pragma mark - private

- (SYBGMSongModel *)songAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.songsArray count]) {
        return [self.songsArray objectAtIndex:index];
    }
    return nil;
}

- (NSString *)musicDir {
    NSString *musicDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Shining_Music"];
    return musicDir;
}

- (NSString *)musicDiscPathWithPath:(NSString *)path {
    return [self.musicDir stringByAppendingPathComponent:path];
}

@end
