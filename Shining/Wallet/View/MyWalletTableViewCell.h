//
//  MyWalletTableViewCell.h
//  Shining
//
//  Created by letv_lzb on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWalletTableViewCell : UITableViewCell


/**
 绑定数据

 @param item 数据model
 */
- (void)bindData:(id)item;

@end

NS_ASSUME_NONNULL_END
