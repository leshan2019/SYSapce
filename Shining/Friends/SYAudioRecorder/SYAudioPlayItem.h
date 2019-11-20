//
//  SYAudioPlayItem.h
//  Shining
//
//  Created by letv_lzb on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger,SYAudioType) {
    SYAudioTypeUnknown = -1,
    SYAudioTypeFile = 0,
    SYAudioTypeOnline = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface SYAudioPlayItem : NSObject
@property (nonatomic ,copy, nonnull) NSString *url;
@property (nonatomic ,strong, nonnull) AVPlayerItem *item;
@property (nonatomic, assign) SYAudioType audioType;
@property (nonatomic, assign) NSInteger itemIndex;

- (id)initWithUrl:(NSString *)url audioType:(SYAudioType)type;

@end

NS_ASSUME_NONNULL_END
