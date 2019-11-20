//
//  SYVoiceRoomGiftNumCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGiftNumCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIView *line;

- (void)showWithNumer:(NSInteger)number name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
