//
//  SYVoiceCardWordModel.h
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYVoiceCardWordModel;
NS_ASSUME_NONNULL_BEGIN
@interface SYVoiceCardWordsListModel : NSObject
@property(nonatomic,strong)NSArray<SYVoiceCardWordModel*>*word_list;


@end
@interface SYVoiceCardWordModel : NSObject<YYModel>

@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)NSString*category;
@property(nonatomic,strong)NSString*word;
@end

NS_ASSUME_NONNULL_END
