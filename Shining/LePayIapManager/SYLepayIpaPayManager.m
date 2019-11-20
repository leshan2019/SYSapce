//
//  SYLepayIpaPayManager.h
//  shining
//
//  Created by lzb_letv on 2019/03/27.
//  Copyright © 2018年 LeEco. All rights reserved.
//

#import "SYLepayIpaPayManager.h"
#import <StoreKit/StoreKit.h>
#import "LepaySDK.h"
#import "SYLepayIpaNetWorkManager.h"
#import "SYCoinPackageModel.h"
//#import <MBProgressHUD/MBProgressHUD.h>
#import "SYWalletNetWorkManager.h"
#import "SYCoinPackageListModel.h"
#import "SYMemoryHandler.h"

@interface SYLepayIpaPayManager ()<SKProductsRequestDelegate,LPSLepayIAPManagerDelegate>

@property (nonatomic, strong) SKProductsRequest *skRequest;
@property (nonatomic, strong) NSMutableArray *savedSKProducts;  //保存所有的skproducts

/**
 *  H5传给客户端的购买的套餐信息
 *  协议字段：productId，packageId，groupId，name，autoRenew，vipDesc，validatePrice，priceLocale
 *  Note:validatePrice和priceLocal字段需要根据SKProduct更新一下格式
 */
@property (nonatomic, strong) NSMutableDictionary *orderInfos;
@property (nonatomic, copy) SYIapBuyBlock resultBlock;          //购买结果回调

@property (nonatomic, strong) NSString *buyProductId;           //保存下单的产品apple_id
@property (nonatomic, strong) NSString *buyProductcid;          //保存下单的产品cid
@property (nonatomic, strong) NSDictionary *savedOrderDic;      //保存下单的ResultDic
@property (nonatomic, strong) MBProgressHUD *payHud;            //支付toast
@property (nonatomic, weak) UIViewController *parentVC;          //toast vc
@property (nonatomic, strong) NSString *roomId;                 // 充值返点roomId

@end

@implementation SYLepayIpaPayManager

#pragma mark - PublicMethod


/**
 初始化方法

 @param ParentVC ParentVC
 @return return self
 */
- (instancetype)initWithToastParentVC:(UIViewController *)ParentVC {
    self = [self init];
    if (self) {
        self.parentVC = ParentVC;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.savedSKProducts = nil;
        self.savedOrderDic = nil;
        _orderInfos = nil;
        self.resultBlock = nil;
        self.buyProductId = @"";
        self.buyProductcid = @"";
        self.isPaying = NO;
    }
    return self;
}

- (void)buyVipProduct:(NSMutableDictionary *)orderInfo andFinishBlock:(SYIapBuyBlock)resultBlock {
    if (self.isPaying) {
        return;
    }

    [self showToast:@"套餐信息苹果验证中..."];

    SYCoinPackageModel *model = [orderInfo objectForKey:@"product"];
    [orderInfo setObject:model.apple_id forKey:@"productId"];
    [orderInfo setObject:model.cid forKey:@"productCid"];
    self.roomId = orderInfo[@"roomId"];
    self.isPaying = YES;
    self.resultBlock = resultBlock;
    self.orderInfos = orderInfo;
}

#pragma mark - Setter

- (void)setOrderInfos:(NSMutableDictionary *)orderInfos {
    _orderInfos = orderInfos;
    self.buyProductId = [orderInfos objectForKey:@"productId"];
    self.buyProductcid = [orderInfos objectForKey:@"productCid"];
    [self varifyIapProductIDs:self.buyProductId];
}

#pragma mark - iap套餐验证

- (void)varifyIapProductIDs:(NSString *)productId {

    if (![SYNetworkReachability isNetworkReachable]) {
        [self showToast:@"网络连接中断，请检查网络..."];
        [self hiddenToast:.2f];
        [self postLepayResultCode:SY_PayResult_Failed_other andResult:nil];
        return;
    }
    NSLog(@"SY套餐验证id:%@",productId);
    /*
    if ((!self.savedSKProducts || self.savedSKProducts.count <= 0)
        && [SYMemoryHandler shareSYMemoryHandler].skProducts.count > 0) {
        self.savedSKProducts = [SYMemoryHandler shareSYMemoryHandler].skProducts;
    }
     */
    SKProduct *skProductPurchased = nil;
    for (SKProduct *item in self.savedSKProducts) {
        if ([item.productIdentifier isEqualToString:productId]) {
            skProductPurchased = item;
            break;
        }
    }
    if (skProductPurchased) {
        //已经拿到SKProduct直接下单
        [self updateSavedOrderInfoWith:skProductPurchased];
        [self orderLepayProductWithProductInfo:self.orderInfos];
    }else {
        //没有拿到sk,先请求sk,在下单
        [self sendGetSKProductsRequest:[NSArray arrayWithObject:productId]];
    }
}

#pragma mark - Lepay套餐下单

- (void)orderLepayProductWithProductInfo:(NSDictionary *)info {
    NSLog(@"SY调起客户端下单-%@",info);
    [self showToast:@"生成商品订单中..."];
    [self setOrderCountryCode];
    SYLepayIpaNetWorkManager* netManager = [[SYLepayIpaNetWorkManager alloc] init];
    [netManager sendRechargeOrder:self.buyProductcid
                           roomId:self.roomId
                          success:^(id  _Nullable response) {
        NSDictionary *resultDic = response;
        NSString *orderId = [resultDic objectForKey:@"merchant_no"];
        NSString *productId = [resultDic objectForKey:@"product_id"];
        if ([NSObject sy_empty:resultDic] || [NSString sy_isBlankString:orderId] || [NSString sy_isBlankString:productId]) {
            NSLog(@"SY生成商品订单失败-%@",resultDic);
            [self postLepayResultCode:SY_PayResult_Failed_NoOrderId andResult:nil];
            [self showToast:@"生成商品订单失败"];
            [self hiddenToast:2.f];
            self.savedOrderDic = nil;
            return ;
        }
        NSLog(@"SY生成订单成功-%@",resultDic);
        self.savedOrderDic = resultDic;
        [self startIAPForLepay];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"SY生成商品订单失败-%@",error);
        [self showToast:@"生成商品订单失败"];
        [self hiddenToast:2.f];
        [self postLepayResultCode:SY_PayResult_Failed_NoOrderId andResult:nil];
        self.savedOrderDic = nil;
    }];
}

#pragma mark - Lepay套餐支付

- (void)startIAPForLepay {
    NSLog(@"SY开始iap支付");
    [self showToast:@"支付中..."];
    NSString *product_id = [self.savedOrderDic objectForKey:@"product_id"];
    SKProduct *skProductPurchased = nil;
    for (SKProduct *item in self.savedSKProducts) {
        if ([item.productIdentifier isEqualToString:product_id]) {
            skProductPurchased = item;
            break;
        }
    }
    if (skProductPurchased) {
        if ([SYSettingManager syIsTestApi]) {//test
            [LepaySDK registerPlatform:LepayPlatformType_Test];
        }else{
            [LepaySDK registerPlatform:LepayPlatformType_Online];
        }
        [LepaySDK buyProductV2:self.savedOrderDic withSKProduct:skProductPurchased];
        [self resetOrderInfos];
    }else {
        [self showToast:@"支付失败：从苹果获取套餐信息失败~"];
        [self hiddenToast:2.f];
        [self postLepayResultCode:SY_PayResult_Failed_Auth andResult:nil];
    }
    
}

- (void)resetOrderInfos {
    //发起支付后，清空保存的变量
    _orderInfos = nil;
    self.buyProductId = nil;
    self.buyProductcid = nil;
}

/**
 *  传给SY支付结果code
 */
- (void)postLepayResultCode:(SY_PayResultType)code andResult:(NSDictionary *)resultDic {
    if (self.resultBlock) {
        self.resultBlock(code,resultDic);
    }
    self.isPaying = NO;
}

/**
 *  发送套餐验证请求给APPStore
 */
- (void)sendGetSKProductsRequest:(NSArray *)productIDs {
    NSSet *productIdSet =[NSSet setWithArray:productIDs];
    if (productIdSet && [productIdSet count] > 0) {
        self.skRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdSet];
        self.skRequest.delegate = self;
        [self.skRequest start];
    }
}

/**
 *  根据SKProduct更新套餐信息
 */
- (void)updateSavedOrderInfoWith:(SKProduct *)skproduct {
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
    for (SYCoinPackageModel *item in [SYMemoryHandler shareSYMemoryHandler].syPackageProducts) {
        if ([item.apple_id isEqualToString:skproduct.productIdentifier]) {
            item.price = price;
            item.validatePrice = validatePrice;
            item.priceLocale = priceLocale;
        }
    }
    [self.orderInfos setValue:price forKey:@"price"];
    [self.orderInfos setObject:validatePrice forKey:@"validatePrice"];
    [self.orderInfos setObject:priceLocale forKey:@"priceLocale"];
    
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

        for (SYCoinPackageModel *coin in [SYMemoryHandler shareSYMemoryHandler].syPackageProducts) {
            if ([coin.apple_id isEqualToString:skproduct.productIdentifier]) {
                coin.price = price;
                coin.validatePrice = validatePrice;
                coin.priceLocale = priceLocale;
            }
        }
    }
}


/**
 *  设置支付SDK需要的信息
 */
- (void)setOrderCountryCode {
    if ([SYSettingManager syIsTestApi]) {
        [LepaySDK registerPlatform:LepayPlatformType_Test];
    }else{
        [LepaySDK registerPlatform:LepayPlatformType_Online];
    }
    NSString *shareSecret = APP_IAP_SHARESECRET;
    [LepaySDK configV2ShareSecrect:shareSecret CountryCode:@"86" Delegate:self];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (request == self.skRequest) {
        [self handleSKResponseFromSKRequest:response.products];
    }
}


//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showToast:@"支付失败：从苹果获取套餐信息失败~"];
        [self hiddenToast:2.f];
        [self postLepayResultCode:SY_PayResult_Failed_Auth andResult:nil];
        NSLog(@"------------------错误-----------------:%@", error);
    });
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------%@",request);
}

/**
 *  处理Appstore返回的SKProduct数组
 */
- (void)handleSKResponseFromSKRequest:(NSArray *)skProducts {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
           self.skRequest.delegate = nil;
           self.skRequest = nil;

           if (skProducts == nil || skProducts.count == 0) {
               [self showToast:@"支付失败：从苹果获取套餐信息失败~"];
               [self hiddenToast:2.f];
               [self postLepayResultCode:SY_PayResult_Failed_Auth andResult:nil];
               return;
           }

           if (!self.savedSKProducts) {
               self.savedSKProducts = [NSMutableArray array];
           }

           BOOL hasSavedSKProduct = NO;
           for (SKProduct *skProduct in skProducts) {
               hasSavedSKProduct = NO;
               for (SKProduct *tempSKProduct in self.savedSKProducts) {
                   if ([skProduct.productIdentifier isEqualToString:tempSKProduct.productIdentifier])
                   {
                       hasSavedSKProduct = YES;
                       break;
                   }
               }
               if (!hasSavedSKProduct) {
                   [self.savedSKProducts addObject:skProduct];
               }
           }

           SKProduct *skProductPurchased = nil;
           for (SKProduct *item in self.savedSKProducts) {
               if ([item.productIdentifier isEqualToString:self.buyProductId]) {
                   skProductPurchased = item;
                   break;
               }
           }
           if (skProductPurchased) {
               //直接下单
                          [self updateSavedOrderInfoWith:skProductPurchased];
                          [self orderLepayProductWithProductInfo:self.orderInfos];
           }else {
               //鉴权失败
               [self showToast:@"支付失败：从苹果获取套餐信息失败~"];
               [self hiddenToast:2.f];
               [self postLepayResultCode:SY_PayResult_Failed_Auth andResult:nil];
           }
    });
}

#pragma mark - LPSLepayIAPManagerDelegate

- (void)lePayIapProcessResult:(BOOL)bSucc Status:(LePayIapProcessStatus)status MsgInfo:(NSDictionary *)msgDic {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"HKIAP: 成功回调 是否成功：%d  当前状态 :%ld msg: %@",bSucc, (long)status,msgDic);
        if(bSucc){
            if (Lepay_Iap_ProcessStatus_PaymentVerifyProcessing == status) {
                NSString *orderId = [self.savedOrderDic objectForKey:@"merchant_no"];
                NSString *productId = [self.savedOrderDic objectForKey:@"product_id"];
                NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:productId,@"productId",orderId,@"orderId", nil];
                [self showToast:@"支付成功"];
                [self hiddenToast:2.f];
                [self postLepayResultCode:SY_PayResult_Success andResult:resultDic];
            }
        } else {
            NSString *errorMsg = nil;
            if (msgDic && msgDic.count > 0) {
                NSString *temp = [msgDic objectForKey:@"msg"];
                if (temp && [temp isKindOfClass:[NSString class]]
                    && temp.length > 0) {
                    errorMsg = temp;
                }
            }
            if (status == Lepay_Iap_ProcessStatus_AppPurchaseProcessing) {
//                if (errorMsg) {
//                    [self showToast:[NSString stringWithFormat:@"支付失败:%@",errorMsg]];
//                }else{
                    [self showToast:@"支付失败"];
//                }
                [self hiddenToast:2.f];
                [self postLepayResultCode:SY_PayResult_Failed_Cancel andResult:nil];
            }else {
//                if (errorMsg) {
//                    [self showToast:[NSString stringWithFormat:@"支付失败:%@",errorMsg]];
//                }else{
                    [self showToast:@"支付失败"];
//                }
                [self hiddenToast:2.f];
                [self postLepayResultCode:SY_PayResult_Failed_other andResult:nil];
            }
        }
    });
}


/**
 支付过程提示

 @param toast des
 */
- (void)showToast:(NSString *)toast {
    if (!self.parentVC) {
        return;
    }
    if (self.payHud) {
        [self.payHud hide:NO];
        self.payHud = nil;
    }
    if (!_payHud) {
        _payHud = [MBProgressHUD showHUDAddedTo:self.parentVC.view
                                       animated:NO];
        _payHud.mode = MBProgressHUDModeText;
    }
    self.payHud.labelText = toast;
    [self.payHud show:NO];
}


/**
 隐藏toast 提示

 @param delay delay time
 */
- (void)hiddenToast:(NSTimeInterval)delay {
    [self.payHud hide:YES afterDelay:delay];
}

- (void)dealloc {
    if (self.skRequest) {
        [self.skRequest cancel];
        self.skRequest.delegate = nil;
        self.skRequest = nil;
    }
    [self hiddenToast:0];
    self.payHud = nil;

}

@end
