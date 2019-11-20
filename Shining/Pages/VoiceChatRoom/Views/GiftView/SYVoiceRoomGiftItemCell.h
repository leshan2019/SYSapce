//
//  SYVoiceRoomGiftItemCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGiftItemCell : UICollectionViewCell

- (void)showWithGiftImageURL:(NSString *)url
                       title:(NSString *)title
                       price:(NSString *)price
                    vipLevel:(NSString *)vipLevel
                 needShowNum:(BOOL)needShowNum
                         num:(NSInteger)num
                    minusNum:(NSInteger)minusNum;

@end

NS_ASSUME_NONNULL_END
