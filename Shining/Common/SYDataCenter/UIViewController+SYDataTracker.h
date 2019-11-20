//
//  UIViewController+SYDataTracker.h
//  Shining
//
//  Created by letv_lzb on 2019/5/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SYDataTracker)

@property (nonatomic ,strong) NSDictionary *syDataInfoDictionary;


/**
 页面统计 (必须在 viewWillAppear 调用周期之前配置 pageName ： 建议 viewDidLoad 或者 init)

 @param pageType 统计的页面Type （SYDataCenterDefine.h）
 */
- (void)sy_configDataInfoPageName:(SYPageNameType)pageType;

@end

NS_ASSUME_NONNULL_END
