//
//  SYUserDynamicModel.h
//  Shining
//
//  Created by yangxuan on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYDynamicVideoUrl @"SYDynamicVideoUrl"
#define SYDynamicVideoCover @"SYDynamicVideoCover"

NS_ASSUME_NONNULL_BEGIN

// 动态model
@interface SYUserDynamicModel : NSObject

@property (nonatomic, strong) NSString *momentsid;      // 动态id
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *pic_1;
@property (nonatomic, strong) NSString *pic_2;
@property (nonatomic, strong) NSString *pic_3;
@property (nonatomic, strong) NSString *pic_4;
@property (nonatomic, strong) NSString *pic_5;
@property (nonatomic, strong) NSString *pic_6;
@property (nonatomic, strong) NSString *pic_7;
@property (nonatomic, strong) NSString *pic_8;
@property (nonatomic, strong) NSString *pic_9;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *video_cover;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, assign) NSInteger like_quantity;
@property (nonatomic, assign) NSInteger comment_quantity;
@property (nonatomic, assign) BOOL like;           // 是否已经赞过
@property (nonatomic, assign) BOOL is_concern;
@property (nonatomic, assign) NSInteger streamer_roomid;
@property (nonatomic, strong) UserProfileEntity *userinfo;

@end

@interface SYUserDynamicListModel : NSObject

@property (nonatomic, strong) NSArray<SYUserDynamicModel *> *list;

@end

// 评论model
@interface SYUserCommentModel : NSObject

@property (nonatomic, strong) NSString *commentid;  // 评论id
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *momentid;   // 动态id
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *avatar_imgurl;

@end

// 评论列表listModel
@interface SYUserCommentListModel : NSObject

@property (nonatomic, strong) NSArray<SYUserCommentModel *> *list;
@property (nonatomic, assign) NSInteger count;

@end


NS_ASSUME_NONNULL_END
