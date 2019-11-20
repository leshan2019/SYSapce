//
//  SYTransferPopView.h
//  Shining
//
//  Created by letv_lzb on 2019/7/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SYTransferEnsureBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SYTransferPopView : UIView

- (instancetype)initSYTransferPopViewWithHoneyCount:(NSInteger)honeyCount
                                        ensureBlock:(SYTransferEnsureBlock)ensureBlock;

@end

NS_ASSUME_NONNULL_END
