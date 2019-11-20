//
//  SYMineIDCardNameVC.h
//  Shining
//
//  Created by 杨玄 on 2019/3/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYMineIDCardNameVCDelegate <NSObject>

- (void)saveIDCardName:(NSString *)name;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYMineIDCardNameVC : UIViewController

@property (nonatomic, weak) id<SYMineIDCardNameVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
