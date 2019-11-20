//
//  SYVoiceRoomExpressionViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomExpressionViewModel.h"
#import "SYVoiceChatNetManager.h"

@interface SYVoiceRoomExpressionViewModel ()

@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation SYVoiceRoomExpressionViewModel

- (void)requestExpressionListWithBlock:(void(^)(BOOL))block {
    SYVoiceChatNetManager *netManager = [[SYVoiceChatNetManager alloc] init];
    [netManager requestExpressionListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSArray class]]) {
            self.modelArray = (NSArray *)response;
            if (block) {
                block(YES);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}

- (SYVoiceRoomExpression *)expressionWithPage:(NSInteger)page index:(NSInteger)index {
    NSInteger objectIndex = page * VoiceRoomExpressionCountPerPage + index;
    if (objectIndex >= 0 && objectIndex < [self.modelArray count]) {
        return self.modelArray[objectIndex];
    }
    return nil;
}

- (NSInteger)expressionPageCount {
    NSInteger count = [self.modelArray count];
    NSInteger page = count / VoiceRoomExpressionCountPerPage;
    if (count % VoiceRoomExpressionCountPerPage > 0) {
        page ++;
    }
    return page;
}

- (NSInteger)expressionCountWithPage:(NSInteger)page {
    NSInteger count = [self.modelArray count];
    return MIN(count - page * VoiceRoomExpressionCountPerPage, VoiceRoomExpressionCountPerPage);
}

- (NSInteger)expressionIdWithPage:(NSInteger)page index:(NSInteger)index {
    return [self expressionWithPage:page index:index].id;
}

- (NSString *)expressionNameWithPage:(NSInteger)page index:(NSInteger)index {
    return [self expressionWithPage:page index:index].name;
}

- (NSString *)expressionIconWithPage:(NSInteger)page index:(NSInteger)index  {
    return [self expressionWithPage:page index:index].icon;
}

@end
