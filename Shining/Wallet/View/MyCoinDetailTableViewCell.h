//
//  MyCoinDetailTableViewCell.h
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCoinDetailTableViewCell : UITableViewCell

/**
 绑定数据

 @param item 数据model
 */
- (void)bindData:(id)item;

@end

NS_ASSUME_NONNULL_END
