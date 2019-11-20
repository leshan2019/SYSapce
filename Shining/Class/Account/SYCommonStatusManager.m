//
//  SYCommonStatusManager.m
//  Shining
//
//  Created by jiuqi on 2019/10/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCommonStatusManager.h"
#import "SYGiftNetManager.h"
#import "SYDayTaskItemModel.h"

static SYCommonStatusManager *statusManager_sharedInstance = nil;

@interface SYCommonStatusManager()
@property (nonatomic, strong) SYGiftNetManager *networkManager;
@end

@implementation SYCommonStatusManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusManager_sharedInstance = [[self alloc] init];
    });
    return statusManager_sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkManager = [SYGiftNetManager new];
    }
    return self;
}

- (void)checkDayTaskUnReceived :(void(^)(BOOL))finishBlock{
    [self.networkManager requestDayTaskListWithSuccess:^(id  _Nullable response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSArray *listArray = [dict objectForKey:@"list"];
        BOOL isUnReceived = NO;
        for (int i=0; i<listArray.count; i++) {
            NSDictionary *modelDict = listArray[i];
            SYDayTaskItemModel *model = [SYDayTaskItemModel yy_modelWithDictionary:modelDict];
            if (![NSObject sy_empty:model] && (model.status == SYDayTaskItemStatus_Done_unReceived)) {
                isUnReceived = YES;
                break;
            }
        }
        
        if (finishBlock) {
            finishBlock(isUnReceived);
        }
        
        
    } failure:^(NSError * _Nullable error) {
        if (finishBlock) {
            finishBlock(NO);
        }
    }];
}
@end
