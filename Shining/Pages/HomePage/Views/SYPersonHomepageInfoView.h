//
//  SYPersonHomepageInfoView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 个人主页 - 资料view
*/
@interface SYPersonHomepageInfoView : UIView

- (void)updateHomepageInfoViewWithId:(NSString *)idStr
                          coordinate:(NSString *)coordinate
                       constellation:(NSString *)constellation;

@end

NS_ASSUME_NONNULL_END
