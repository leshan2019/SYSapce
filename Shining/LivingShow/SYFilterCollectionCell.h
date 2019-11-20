//
//  SYFilterCollectionCell.h
//  Shining
//
//  Created by Zhang Qigang on 2019/10/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYFilterCollectionCell : UICollectionViewCell
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* image;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) BOOL mark;
@property (nonatomic, assign) BOOL showValue;
@end

NS_ASSUME_NONNULL_END
