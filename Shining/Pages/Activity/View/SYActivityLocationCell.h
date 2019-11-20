//
//  SYActivityLocationCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYActivityLocationCell : UICollectionViewCell

- (void)showWithName:(NSString *)name
             address:(NSString *)address;

@end

NS_ASSUME_NONNULL_END
