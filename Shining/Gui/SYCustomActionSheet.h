//
//  SYCustomActionSheet.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCustomActionSheet : UIView

- (instancetype)initWithActions:(NSArray <NSString *>*)actions
                    cancelTitle:(NSString *)cancelTitle
                    selectBlock:(void(^)(NSInteger index))selectBlock
                    cancelBlock:(void(^)(void))cancelBlock;


- (void)show;

@end

NS_ASSUME_NONNULL_END
