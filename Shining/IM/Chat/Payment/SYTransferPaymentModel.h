//
//  SYTransferPaymentModel.h
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/7/11.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYTransferPaymentModel : NSObject
@property (nonatomic, copy)NSString *acount;
@property (nonatomic, copy)NSString *transferStyle;
@property (nonatomic, strong)UserProfileEntity *userInfo;
@end

NS_ASSUME_NONNULL_END
