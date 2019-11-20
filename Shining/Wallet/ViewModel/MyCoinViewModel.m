//
//  MyCoinViewModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "MyCoinViewModel.h"
#import "SYWalletNetWorkManager.h"
#import "SYCoinPackageModel.h"
#import <StoreKit/StoreKit.h>
#import "SYMemoryHandler.h"

@interface MyCoinViewModel ()<SKProductsRequestDelegate>
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger pageSize;
@property(nonatomic, strong)SKProductsRequest *skRequest;

@end

@implementation MyCoinViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        self.pageSize = 20;
    }
    return self;
}

- (void)requestMyCoinWithSuccess:(void(^)(NSNumber *coin))success {
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    [newWork requestWallet:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSNumber class]]) {
            if (success) {
                success(response);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (success) {
            success(@(0));
        }
    }];
}


/**
 lebz 获取充值套餐list

 @param completion completion block
 */
- (void)getLebzCoinPackageList:(completionBlock)completion {
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [newWork requestLebzCoinPackageList:^(id  _Nullable response) {
        weakSelf.lebzListModel = (SYCoinPackageListModel *)response;
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (completion) {
            completion(NO);
        }
    }];
}

- (BOOL)isLebzCoinPackageNextPage {
    return NO;
}

- (void)getLebzCoinPackageNextPage:(completionBlock)completion {

}


- (BOOL)isLebzCoinPackageEmptyData {
    if (!self.lebzListModel || !self.lebzListModel.list || self.lebzListModel.list.count <= 0) {
        return YES;
    }
    return NO;
}





/**
 获取充值套餐list

 @param completion completion block
 */
- (void)getLepayCoinPackageList:(completionBlock)completion {
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [newWork requestLepayCoinPackageList:^(id  _Nullable response) {
        weakSelf.lepayListModel = (SYCoinPackageListModel *)response;
        for (SYCoinPackageModel *model in weakSelf.lepayListModel.list) {
            for (SYCoinPackageModel *item in [SYMemoryHandler shareSYMemoryHandler].syPackageProducts) {
                if ([item.cid isEqualToString:model.cid]) {
                    model.price = item.price;
                    model.validatePrice = item.validatePrice;
                    model.priceLocale = item.priceLocale;
                }
            }
        }
        [weakSelf varifyIapProductInfo:weakSelf.lepayListModel.list];
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.lepayListModel = [SYCoinPackageListModel new];
        weakSelf.lepayListModel.list = [NSMutableArray arrayWithArray:[SYMemoryHandler shareSYMemoryHandler].syPackageProducts];
        if (completion) {
            completion(NO);
        }
    }];
}

- (BOOL)isLepayCoinPackageNextPage {
    return NO;
}

- (void)getLepayCoinPackageNextPage:(completionBlock)completion {

}

- (BOOL)isLepayCoinPackageEmptyData {
    if (!self.lepayListModel || !self.lepayListModel.list || self.lepayListModel.list.count <= 0) {
        return YES;
    }
    return NO;
}




/**
 去itunes Store 验证套餐信息（价格及是否存在）。

 @param coinPackages 充值套餐列表
 */
- (void)varifyIapProductInfo:(NSArray *)coinPackages {
    if (!coinPackages || coinPackages.count <= 0) {
        return;
    }
//    [SYMemoryHandler shareSYMemoryHandler].syPackageProducts = [NSMutableArray arrayWithArray:coinPackages];
    NSMutableArray *productIds = [NSMutableArray new];
    for (SYCoinPackageModel *item in coinPackages) {
        if (item.apple_id && item.apple_id.length > 0) {
            [productIds addObject:item.apple_id];
        }
    }
    [self sendGetSKProductsRequest:productIds];
}



/**
 获取iAP验证后的SYCoinPackageModel 实例

 @param productId apple_id
 @return SYCoinPackageModel 实例
 */
- (SYCoinPackageModel *)getVarifyedIapProduct:(NSString *)productId {

    return nil;
}


/**
 *  发送套餐验证请求给APPStore
 */
- (void)sendGetSKProductsRequest:(NSArray *)productIDs {
    if ([SKPaymentQueue canMakePayments]) {
        NSSet *productIdSet =[NSSet setWithArray:productIDs];
        if (productIdSet && [productIdSet count] > 0) {
            self.skRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdSet];
            self.skRequest.delegate = self;
            [self.skRequest start];
        }
    }else {
        NSLog(@"请打开应用内支付功能");
    }

}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (request == self.skRequest) {
        [self handleSKResponseFromSKRequest:response.products];
    }
}


//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------%@",request);
}


/**
 *  处理Appstore返回的SKProduct数组
 */
- (void)handleSKResponseFromSKRequest:(NSArray *)skProducts {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.skRequest.delegate = nil;
    self.skRequest = nil;
    if (skProducts == nil || skProducts.count == 0) {
        return;
    }
    NSMutableArray *savedSKProducts = [NSMutableArray array];
    BOOL hasSavedSKProduct = NO;
    for (SKProduct *skProduct in skProducts) {
        hasSavedSKProduct = NO;
        for (SKProduct *tempSKProduct in savedSKProducts) {
            if ([skProduct.productIdentifier isEqualToString:tempSKProduct.productIdentifier])
            {
                hasSavedSKProduct = YES;
                break;
            }
        }
        if (!hasSavedSKProduct) {
            [savedSKProducts addObject:skProduct];
        }
    }
    //更新到公共区
    [SYMemoryHandler shareSYMemoryHandler].skProducts = [NSMutableArray arrayWithArray:savedSKProducts];
    [self updateCoinPackageInfoWith:savedSKProducts];
}


/**
 *  根据SKProduct更新套餐信息
 */
- (void)updateCoinPackageInfoWith:(NSArray *)skproducts {
    for (SKProduct *skproduct in skproducts) {
        NSString *price = @"";
        NSString *validatePrice = @"";
        NSString *priceLocale = @"";

        // 采用本地显示价格显示方式，如获取人民币则显示为¥ 20.88
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:skproduct.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:skproduct.price];

        price = formattedPrice;
        validatePrice = [NSString stringWithFormat:@"%0.2f",[skproduct.price floatValue]];
        priceLocale = [skproduct.priceLocale objectForKey:NSLocaleCurrencyCode];
        for (SYCoinPackageModel *coin in self.lepayListModel.list) {
            if ([coin.apple_id isEqualToString:skproduct.productIdentifier]) {
                coin.price = price;
                coin.validatePrice = validatePrice;
                coin.priceLocale = priceLocale;
            }
        }
    }
    self.varifyIapSuccess = skproducts.count > 0;
    //更新到公共区
    [SYMemoryHandler shareSYMemoryHandler].syPackageProducts = [NSMutableArray arrayWithArray:self.lepayListModel.list];

}


- (void)dealloc {
    if (self.skRequest) {
        [self.skRequest cancel];
        self.skRequest.delegate = nil;
        self.skRequest = nil;
    }
}


@end
