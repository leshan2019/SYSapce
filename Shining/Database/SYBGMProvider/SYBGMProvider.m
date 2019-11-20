//
//  SYBGMProvider.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYBGMProvider.h"
#import <FMDB/FMDB.h>

@interface SYBGMProvider ()

@property (nonatomic, strong) FMDatabase* db;

@end

@implementation SYBGMProvider

+ (instancetype)shared {
    static SYBGMProvider *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [SYBGMProvider new];
    });
    return shared;
}

- (void)open {
    static FMDatabase *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [FMDatabase databaseWithPath:self.dbPath];
    });
    self.db = db;
    [self.db open];
}

- (void)install {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.dbPath]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:self.dbDirname
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil]) {
            return;
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bgm" ofType:@"sqlite"];
        if (path.length == 0) {
            return;
        }
        
        if (![[NSFileManager defaultManager] copyItemAtPath:path
                                                     toPath:self.dbPath
                                                      error:nil]) {
            return;
        }
    }
}

- (NSArray <SYBGMSongModel *>*)bgmSongs {
    if (!self.db) {
        [self open];
    }
    if (!self.db) {
        NSLog(@"db opens failed!");
        return nil;
    }
    NSMutableArray *songs = [NSMutableArray new];
    NSString* sql = @"SELECT * FROM Songs";
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        SYBGMSongModel *model = [SYBGMSongModel new];
        model.songID = [rs longLongIntForColumn:@"id"];
        model.name = [rs stringForColumn:@"name"];
        model.singer = [rs stringForColumn:@"singer"];
        model.size = [rs longLongIntForColumn:@"size"];
        model.path = [rs stringForColumn:@"path"];
        [songs addObject:model];
    }
    return songs;
}

- (BOOL)insertSongWithSongID:(long long)songID
                        name:(NSString *)name
                      singer:(NSString *)singer
                        size:(long long)size
                    filePath:(NSString *)filePath {
    if (!self.db) {
        [self open];
    }
    if (!self.db) {
        NSLog(@"db opens failed!");
        return NO;
    }
    NSString *sql = @"INSERT INTO Songs VALUES (?,?,?,?,?)";
    return [self.db executeUpdate:sql, @(songID), name, singer, @(size), filePath];
}

//- (BOOL)setFilePath:(NSString *)filePath
//             songID:(NSInteger)songID {
//    if (!self.db) {
//        [self open];
//    }
//    if (!self.db) {
//        NSLog(@"db opens failed!");
//        return NO;
//    }
//    NSString *sql = @"UPDATE Songs SET path = ? WHERE id = ?";
//    return [self.db executeQuery:sql, filePath, songID];
//}

- (BOOL)removeSongBySongID:(long long)songID {
    if (!self.db) {
        [self open];
    }
    if (!self.db) {
        NSLog(@"db opens failed!");
        return NO;
    }
    NSString *sql = @"DELETE FROM Songs WHERE id = ?";
    return [self.db executeUpdate:sql, @(songID)];
}

#pragma mark - getter
- (NSString*) dbBasename {
    return @"bgm.sqlite";
}

- (NSString*) dbDirname {
    NSFileManager* fm = NSFileManager.defaultManager;
    NSError* error = nil;
    NSURL* url = [fm URLForDirectory: NSLibraryDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &error];
    url = [url URLByAppendingPathComponent: @"Application Support" isDirectory: YES];
    return url.path;
}

- (NSString*) dbPath {
    return [self.dbDirname stringByAppendingPathComponent: self.dbBasename];
}

@end
