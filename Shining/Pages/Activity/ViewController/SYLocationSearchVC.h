//
//  SYLocationSearchVC.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYLocationViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYLocationSearchVCDelegate <NSObject>

- (void)locationSearchVCDidChooseLocation:(SYLocationViewModel *)location;

@end

@interface SYLocationSearchVC : UIViewController

@property (nonatomic, weak) id <SYLocationSearchVCDelegate> delegate;

- (instancetype)initWithLocation:(CGPoint)location;

@end

NS_ASSUME_NONNULL_END
