//
//  SYGiftResourceLoader.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiftResourceLoader.h"
#import <SSZipArchive/ZipArchive.h>

static NSMutableArray *kDownloadingGiftArray;
static NSMutableArray *kDownloadingPropArray;
static NSMutableArray *kDownloadingExpressionArray;
static NSString *kGiftDir;
static NSString *kPropDir;
static NSString *kExpressionDir;
static NSString *kUserDefaultsKey;
static NSString *kPropUserDefaultsKey;
static NSString *kExpressionUserDefaultsKey;

@interface SYGiftResourceLoader ()

@property (nonatomic, strong) NSMutableArray *downloadingGiftArray;

@end

@implementation SYGiftResourceLoader

+ (void)initialize {
    if (self == [SYGiftResourceLoader class]) {
        kDownloadingGiftArray = [NSMutableArray new];
        kDownloadingPropArray = [NSMutableArray new];
        kDownloadingExpressionArray = [NSMutableArray new];
        kGiftDir = @"ShiningGift";
        kPropDir = @"ShiningProp";
        kExpressionDir = @"ShiningExpression";
        kUserDefaultsKey = @"Shining_Gift";
        kPropUserDefaultsKey = @"Shining_Prop";
        kExpressionUserDefaultsKey = @"Shining_Expression";
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{kUserDefaultsKey: @{}}];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{kPropUserDefaultsKey: @{}}];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{kExpressionUserDefaultsKey: @{}}];
    }
}

+ (void)setLastAnimationPackageURL:(NSString *)url
                            giftID:(NSInteger)giftID {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserDefaultsKey];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [newDict setObject:url forKey:[NSString stringWithFormat:@"%ld",(long)giftID]];
    [[NSUserDefaults standardUserDefaults] setObject:[newDict copy] forKey:kUserDefaultsKey];
}

+ (NSString *)lastAnimationPackageURLWithGiftID:(NSInteger)giftID {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserDefaultsKey];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)giftID];
    return dict[key];
}

+ (void)setLastAnimationPackageURL:(NSString *)url
                            propID:(NSInteger)propID {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPropUserDefaultsKey];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [newDict setObject:url forKey:[NSString stringWithFormat:@"%ld",(long)propID]];
    [[NSUserDefaults standardUserDefaults] setObject:[newDict copy] forKey:kPropUserDefaultsKey];
}

+ (NSString *)lastAnimationPackageURLWithPropID:(NSInteger)propID {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPropUserDefaultsKey];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)propID];
    return dict[key];
}

+ (void)setLastAnimationPackageURL:(NSString *)url
                      expressionID:(NSInteger)expressionID {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kExpressionUserDefaultsKey];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [newDict setObject:url forKey:[NSString stringWithFormat:@"%ld",(long)expressionID]];
    [[NSUserDefaults standardUserDefaults] setObject:[newDict copy] forKey:kPropUserDefaultsKey];
}

+ (NSString *)lastAnimationPackageURLWithExpressionID:(NSInteger)expressionID {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kExpressionUserDefaultsKey];
    NSString *key = [NSString stringWithFormat:@"%ld",(long)expressionID];
    return dict[key];
}

+ (NSString *)giftDirPath {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [document stringByAppendingPathComponent:kGiftDir];
}

+ (NSString *)propDirPath {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [document stringByAppendingPathComponent:kPropDir];
}

+ (NSString *)expressionDirPath {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [document stringByAppendingPathComponent:kExpressionDir];
}

+ (NSString *)giftAnimationFramesDirPathWithGiftID:(NSInteger)giftID {
    return [[self giftDirPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", (long)giftID]];
}

+ (NSString *)propAnimationFramesDirPathWithPropID:(NSInteger)propID {
    return [[self propDirPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", (long)propID]];
}

+ (NSString *)expressionAnimationFramesDirPathWithExpressionID:(NSInteger)expressionID {
    return [[self expressionDirPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", (long)expressionID]];
}

+ (void)downloadAnimationResourceWithGiftID:(NSInteger)giftID
                                     zipURL:(NSString *)zipURL {
    if (giftID <= 0 || [NSString sy_isBlankString:zipURL]) {
        return;
    }
    if ([[kDownloadingGiftArray copy] containsObject:zipURL]) {
        // 正在下载，则不再继续添加下载任务
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self giftDirPath]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self giftDirPath]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    
    if ([[self lastAnimationPackageURLWithGiftID:giftID] isEqualToString:zipURL]) {
        // 本地存在zip，则默认资源已存在，不再下载
        return;
    }
    
    NSLog(@"gift dir: %@",[self giftDirPath]);
    
    NSString *zipFileName = [NSString stringWithFormat:@"%@_temp.zip", @(giftID)];
    NSString *zipFilePath = [[self giftDirPath] stringByAppendingPathComponent:zipFileName];
    
    [kDownloadingGiftArray addObject:zipURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:zipURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:zipFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [kDownloadingGiftArray removeObject:zipURL];
        if (!error) {
            NSString *giftDir = [self giftAnimationFramesDirPathWithGiftID:giftID];
            if ([[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
                [[NSFileManager defaultManager] removeItemAtPath:giftDir
                                                           error:nil];
            }
            NSError *error = nil;
            if (![[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:giftDir
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&error];
            }
            if (!error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error = nil;
                    [SSZipArchive unzipFileAtPath:zipFilePath
                                    toDestination:giftDir
                                        overwrite:YES
                                         password:nil
                                            error:&error];
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setLastAnimationPackageURL:zipURL
                                                      giftID:giftID];
                        });
                    }
                    [[NSFileManager defaultManager] removeItemAtPath:zipFilePath
                                                               error:nil];
                });
            }
        } else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:zipFilePath
                                                           error:nil];
            }
        }
    }];
    [downloadTask resume];
}

+ (void)downloadAnimationResourceWithPropID:(NSInteger)propID
                                     zipURL:(NSString *)zipURL
{
    if (propID <= 0 || [NSString sy_isBlankString:zipURL]) {
        return;
    }
    if ([[kDownloadingPropArray copy] containsObject:zipURL]) {
        // 正在下载，则不再继续添加下载任务
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self propDirPath]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self propDirPath]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    
    if ([[self lastAnimationPackageURLWithPropID:propID] isEqualToString:zipURL]) {
        // 本地存在zip，则默认资源已存在，不再下载
        return;
    }
    
    NSLog(@"prop dir: %@",[self propDirPath]);
    
    NSString *zipFileName = [NSString stringWithFormat:@"%@_temp.zip", @(propID)];
    NSString *zipFilePath = [[self propDirPath] stringByAppendingPathComponent:zipFileName];
    
    [kDownloadingPropArray addObject:zipURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:zipURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:zipFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [kDownloadingPropArray removeObject:zipURL];
        if (!error) {
            NSString *propDir = [self propAnimationFramesDirPathWithPropID:propID];
            if ([[NSFileManager defaultManager] fileExistsAtPath:propDir]) {
                [[NSFileManager defaultManager] removeItemAtPath:propDir
                                                           error:nil];
            }
            NSError *error = nil;
            if (![[NSFileManager defaultManager] fileExistsAtPath:propDir]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:propDir
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&error];
            }
            if (!error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error = nil;
                    [SSZipArchive unzipFileAtPath:zipFilePath
                                    toDestination:propDir
                                        overwrite:YES
                                         password:nil
                                            error:&error];
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setLastAnimationPackageURL:zipURL
                                                      propID:propID];
                        });
                    }
                    [[NSFileManager defaultManager] removeItemAtPath:zipFilePath
                                                               error:nil];
                });
            }
        } else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:zipFilePath
                                                           error:nil];
            }
        }
    }];
    [downloadTask resume];
}

+ (void)downloadAnimationResourceWithExpressionID:(NSInteger)expressionID
                                           zipURL:(NSString *)zipURL {
    if (expressionID <= 0 || [NSString sy_isBlankString:zipURL]) {
        return;
    }
    if ([[kDownloadingExpressionArray copy] containsObject:zipURL]) {
        // 正在下载，则不再继续添加下载任务
        return;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self expressionDirPath]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[self expressionDirPath]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    
    if ([[self lastAnimationPackageURLWithExpressionID:expressionID] isEqualToString:zipURL]) {
        // 本地存在zip，则默认资源已存在，不再下载
        return;
    }
    
    NSLog(@"Expression dir: %@",[self expressionDirPath]);
    
    NSString *zipFileName = [NSString stringWithFormat:@"%@_temp.zip", @(expressionID)];
    NSString *zipFilePath = [[self expressionDirPath] stringByAppendingPathComponent:zipFileName];
    
    [kDownloadingExpressionArray addObject:zipURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:zipURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:zipFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [kDownloadingExpressionArray removeObject:zipURL];
        if (!error) {
            NSString *giftDir = [self expressionAnimationFramesDirPathWithExpressionID:expressionID];
            if ([[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
                [[NSFileManager defaultManager] removeItemAtPath:giftDir
                                                           error:nil];
            }
            NSError *error = nil;
            if (![[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:giftDir
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&error];
            }
            if (!error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error = nil;
                    [SSZipArchive unzipFileAtPath:zipFilePath
                                    toDestination:giftDir
                                        overwrite:YES
                                         password:nil
                                            error:&error];
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setLastAnimationPackageURL:zipURL
                                                expressionID:expressionID];
                        });
                    }
                    [[NSFileManager defaultManager] removeItemAtPath:zipFilePath
                                                               error:nil];
                });
            }
        } else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:zipFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:zipFilePath
                                                           error:nil];
            }
        }
    }];
    [downloadTask resume];
}

+ (NSArray <UIImage *>*)giftAnimationImagesWithGiftID:(NSInteger)giftID {
    NSString *giftDir = [self giftAnimationFramesDirPathWithGiftID:giftID];
    if ([[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
        return [self imagesWithDirPath:giftDir];
    }
    return nil;
}

+ (NSArray <UIImage *>*)expressionAnimationImagesWithExpressionID:(NSInteger)expressionID {
    NSString *dir = [self expressionAnimationFramesDirPathWithExpressionID:expressionID];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        return [self imagesWithDirPath:dir];
    }
    return nil;
}

+ (NSString *)giftAnimationAudioEffectWithGiftID:(NSInteger)giftID{
    NSString *giftDir = [self giftAnimationFramesDirPathWithGiftID:giftID];
    if ([[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
        return [self audioEffectWithDirPath:giftDir];

    }
    return nil;
}

+ (NSArray *)randomGiftSVGAsWithGiftID:(NSInteger)giftID
{
    NSString *giftDir = [self giftAnimationFramesDirPathWithGiftID:giftID];
    if ([[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
        NSError *error = nil;
        NSArray *filenames = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:giftDir
                                                                                 error:&error];
        filenames = [filenames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *str in filenames) {
            BOOL isSVGA = NO;
            if (![NSString sy_isBlankString:str] && [str hasSuffix:@".svga"]) {
                isSVGA = YES;
            }
            if(isSVGA){
                [array addObject:[giftDir stringByAppendingPathComponent:str]];
            }
        }
        return array;
    }
    return nil;
}

+ (NSString *)giftSVGAWithGiftID:(NSInteger)giftID {
    NSString *giftDir = [self giftAnimationFramesDirPathWithGiftID:giftID];
    if ([[NSFileManager defaultManager] fileExistsAtPath:giftDir]) {
        if ([self isSVGAResource:giftDir]) {
            return [self svgaWithDirPath:giftDir];
        }
    }
    return nil;
}

+ (NSString *)propSVGAWithPropID:(NSInteger)propID {
    NSString *propDir = [self propAnimationFramesDirPathWithPropID:propID];
    if ([[NSFileManager defaultManager] fileExistsAtPath:propDir]) {
        if ([self isSVGAResource:propDir]) {
            return [self svgaWithDirPath:propDir];
        }
    }
    return nil;
}

+ (NSArray<UIImage *> *)imagesWithDirPath:(NSString *)dirPath {
    NSError *error = nil;
    NSArray *filenames = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath
                                                                        error:&error];
    filenames = [filenames sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *name in filenames) {
        NSString *imagePath = [dirPath stringByAppendingPathComponent:name];
        UIImage *image = [self imageWithPath:imagePath];
        if (!image) {
            continue;
        }
        [images addObject:image];
    }
    return [images copy];
}

+ (UIImage *)imageWithPath:(NSString *)path {
    return [UIImage imageWithContentsOfFile:path];
}

+ (NSString *)audioEffectWithDirPath:(NSString *)dirPath
{
    NSString *audioPath = @"";
    NSError *error = nil;
    NSArray *filenames = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath
                          
                                                                             error:&error];
    
    for (NSString *str in filenames) {
        BOOL isAudioEffect = NO;
        if (![NSString sy_isBlankString:str] && ([str hasSuffix:@".mp3"] || [str hasSuffix:@".wav"])) {
            isAudioEffect = YES;
        }
        if(isAudioEffect){
            audioPath = [dirPath stringByAppendingPathComponent:str];
        }
    }
    return audioPath;

}

+ (BOOL)isSVGAResource:(NSString *)dirPath{
    BOOL isSVGA = NO;
    NSError *error = nil;
    NSArray *filenames = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath
                                                                             error:&error];
    if (filenames && filenames.count > 0) {
        NSString *fileName = filenames[0];
        if (![NSString sy_isBlankString:fileName] && [fileName hasSuffix:@".svga"]) {
            isSVGA = YES;
        }
    }
    for (NSString *str in filenames) {
        if (![NSString sy_isBlankString:str] && [str hasSuffix:@".svga"]) {
            isSVGA = YES;
        }
    }
    
    return isSVGA;
}

+ (NSString *)svgaWithDirPath:(NSString *)dirPath{
    NSString *svgaPath = @"";
    NSError *error = nil;
    NSArray *filenames = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath
    
                                                                             error:&error];
  
    for (NSString *str in filenames) {
        BOOL isSVGA = NO;
        if (![NSString sy_isBlankString:str] && [str hasSuffix:@".svga"]) {
            isSVGA = YES;
        }
        if(isSVGA){
            svgaPath = [dirPath stringByAppendingPathComponent:str];
        }
    }
    return svgaPath;
}

@end
