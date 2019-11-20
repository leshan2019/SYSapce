//
//  SYActivityLocationView.h
//  Shining
//
//  Created by mengxiangjian on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYActivityLocationViewDelegate <NSObject>

- (void)activityLocationViewDidChooseChangeAddress;

@end

@interface SYActivityLocationView : UIView

@property (nonatomic, strong) NSString *address;
@property (nonatomic, weak) id <SYActivityLocationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
