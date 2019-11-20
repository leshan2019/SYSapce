//
//  SYTransferPaymentVC.h
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/7/11.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYTransferPaymentVCProtocol <NSObject>

- (void)didSendRedpackage:(UserProfileEntity *)user beeCount:(NSString *)count;

@end

@interface SYTransferPaymentVC : UIViewController

- (instancetype)initWithUserInfo:(UserProfileEntity *)recervedInfo delegate:(id<SYTransferPaymentVCProtocol>)delegate;

@end

NS_ASSUME_NONNULL_END
