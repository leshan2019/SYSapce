//
//  SYCustomPostView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCustomPostView : UIView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)msg;

- (void)show;

@end

NS_ASSUME_NONNULL_END
